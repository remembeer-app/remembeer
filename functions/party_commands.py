"""Transactional Party activation, membership, and archive commands.

The handlers in this module are intentionally undecorated. ``main.py`` remains
the deployment entry point and can export them as Firebase callables in P21.
"""

from collections.abc import Callable, Mapping, Sequence
from datetime import datetime
from typing import Any

from firebase_admin import firestore
from firebase_functions import https_fn
from party_common import (
    callable_error,
    load_party_context,
    require_auth,
    require_command_id,
    require_object,
    require_session_admin,
    require_session_member,
    require_string,
    run_idempotent_command,
)
from party_notifications import party_notification_data, send_notification_to_users
from party_scoring import calculate_drink_score, deterministic_event_id

PARTY_SCHEMA_VERSION = 1
DEFAULT_QUEST_MIN_INTERVAL_MINUTES = 15
DEFAULT_QUEST_MAX_INTERVAL_MINUTES = 45
DEFAULT_QUEST_DURATION_MINUTES = 15

TemplateSeed = tuple[str, Mapping[str, Any]]
TemplateSeedProvider = Callable[[str], Sequence[TemplateSeed]]


def built_in_template_seeds(actor_user_id: str) -> Sequence[TemplateSeed]:
    """P15 extension point for the versioned built-in quest catalog."""

    del actor_user_id
    return ()


def activate_party(request: Any) -> Mapping[str, Any]:
    """Callable handler that activates an eligible Session exactly once."""

    return activate_party_command(request, firestore.client())


def archive_party(request: Any) -> Mapping[str, Any]:
    """Callable handler that ends the Session and archives its Party."""

    return archive_party_command(request, firestore.client())


def sync_party_membership(request: Any) -> Mapping[str, Any]:
    """Callable handler for Party-aware Session member additions/departures."""

    return sync_party_membership_command(request, firestore.client())


def activate_party_command(
    request: Any,
    db: Any,
    *,
    template_seed_provider: TemplateSeedProvider | None = None,
    notification_dispatcher: Callable[..., Any] = send_notification_to_users,
    transaction_runner: Callable[[Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]]
    | None = None,
) -> Mapping[str, Any]:
    actor_user_id = require_auth(request)
    data = require_object(getattr(request, "data", None))
    session_id = require_string(data, "sessionId", max_length=1_500)
    command_id = require_command_id(data)
    did_activate = False
    recipients: Sequence[str] = ()
    session_name = "Party"

    def operation(transaction: Any) -> Mapping[str, Any]:
        nonlocal did_activate, recipients, session_name
        session_ref = db.collection("sessions").document(session_id)
        party_ref = db.collection("parties").document(session_id)
        session_snapshot = transaction.get(session_ref)
        party_snapshot = transaction.get(party_ref)
        if not session_snapshot.exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.NOT_FOUND,
                "Session was not found.",
            )
        session = session_snapshot.to_dict() or {}
        require_session_admin(session, actor_user_id)
        if session.get("isSoloSession", True):
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Solo Sessions cannot become Parties.",
            )
        if session.get("endedAt") is not None:
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Ended Sessions cannot become Parties.",
            )
        if session.get("isParty") is True or party_snapshot.exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "Session is already a Party.",
            )

        member_ids = _stored_string_list(session, "memberIds")
        if len(member_ids) < 2:
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Party activation requires at least two Session members.",
            )
        seed_provider = template_seed_provider or built_in_template_seeds
        template_seeds = list(seed_provider(actor_user_id))
        _validate_template_seeds(template_seeds)
        awards, member_totals = _initial_drink_awards(session, member_ids)
        stored_name = session.get("name")
        if isinstance(stored_name, str) and stored_name:
            session_name = stored_name

        transaction.update(
            session_ref,
            {"isParty": True, "updatedAt": firestore.SERVER_TIMESTAMP},
        )
        transaction.create(
            party_ref,
            {
                "sessionId": session_id,
                "status": "active",
                "activatedAt": firestore.SERVER_TIMESTAMP,
                "activatedByUserId": actor_user_id,
                "archivedAt": None,
                "moduleSettings": {
                    "socialQuestsEnabled": False,
                    "adminChallengesEnabled": False,
                    "beerpongEnabled": False,
                },
                "questSchedule": {
                    "minIntervalMinutes": DEFAULT_QUEST_MIN_INTERVAL_MINUTES,
                    "maxIntervalMinutes": DEFAULT_QUEST_MAX_INTERVAL_MINUTES,
                    "defaultDurationMinutes": DEFAULT_QUEST_DURATION_MINUTES,
                    "nextQuestAt": None,
                },
                "activeQuestId": None,
                "activeChallengeId": None,
                "activeTournamentId": None,
                "schemaVersion": PARTY_SCHEMA_VERSION,
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        for member_id in member_ids:
            score_units, drink_count = member_totals.get(member_id, (0, 0))
            transaction.create(
                party_ref.collection("members").document(member_id),
                _new_member(member_id, score_units, drink_count),
            )
        for template_id, template in template_seeds:
            transaction.create(
                party_ref.collection("questTemplates").document(template_id),
                dict(template),
            )
        for event_id, event in awards:
            transaction.create(
                party_ref.collection("events").document(event_id),
                event,
            )
        recipients = member_ids
        did_activate = True
        return {
            "sessionId": session_id,
            "memberCount": len(member_ids),
            "templateCount": len(template_seeds),
            "initialAwardCount": len(awards),
        }

    result = run_idempotent_command(
        db,
        party_id=session_id,
        command_id=command_id,
        command_name="activate_party",
        actor_user_id=actor_user_id,
        operation=operation,
        transaction_runner=transaction_runner,
    )
    if did_activate:
        notification_dispatcher(
            db,
            recipients,
            actor_user_id=actor_user_id,
            title="Party started",
            body=f"{session_name} is now in Party Mode.",
            data=party_notification_data("party_activated", session_id),
        )
    return result


def sync_party_membership_command(
    request: Any,
    db: Any,
    *,
    transaction_runner: Callable[[Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]]
    | None = None,
) -> Mapping[str, Any]:
    actor_user_id = require_auth(request)
    data = require_object(getattr(request, "data", None))
    session_id = require_string(data, "sessionId", max_length=1_500)
    command_id = require_command_id(data)
    action = require_string(data, "action", max_length=16)
    member_id = require_string(data, "memberId", max_length=1_500)
    if action not in {"add", "leave"}:
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "action must be either 'add' or 'leave'.",
        )

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(transaction, db, session_id, actor_user_id)
        session_ref = db.collection("sessions").document(session_id)
        party_ref = db.collection("parties").document(session_id)
        member_ref = party_ref.collection("members").document(member_id)
        member_snapshot = transaction.get(member_ref)
        member_ids = _stored_string_list(context.session, "memberIds")
        admin_ids = _stored_string_list(context.session, "adminIds")

        if action == "add":
            require_session_member(context.session, actor_user_id)
            if member_id in context.session.get("bannedMemberIds", []):
                raise callable_error(
                    https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                    "Banned users cannot join the Session.",
                )
            if member_id not in member_ids:
                member_ids.append(member_id)
            if member_snapshot.exists:
                transaction.update(
                    member_ref,
                    {"isActive": True, "updatedAt": firestore.SERVER_TIMESTAMP},
                )
            else:
                transaction.create(member_ref, _new_member(member_id, 0, 0))
        else:
            if member_id != actor_user_id:
                raise callable_error(
                    https_fn.FunctionsErrorCode.PERMISSION_DENIED,
                    "Members can only remove themselves.",
                )
            if member_id == context.session.get("userId"):
                raise callable_error(
                    https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                    "The Session owner cannot leave.",
                )
            member_ids = [value for value in member_ids if value != member_id]
            admin_ids = [value for value in admin_ids if value != member_id]
            if member_snapshot.exists:
                transaction.update(
                    member_ref,
                    {"isActive": False, "updatedAt": firestore.SERVER_TIMESTAMP},
                )

        transaction.update(
            session_ref,
            {
                "memberIds": member_ids,
                "adminIds": admin_ids,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        return {"sessionId": session_id, "memberId": member_id, "action": action}

    return run_idempotent_command(
        db,
        party_id=session_id,
        command_id=command_id,
        command_name="sync_party_membership",
        actor_user_id=actor_user_id,
        operation=operation,
        transaction_runner=transaction_runner,
    )


def archive_party_command(
    request: Any,
    db: Any,
    *,
    notification_dispatcher: Callable[..., Any] = send_notification_to_users,
    transaction_runner: Callable[[Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]]
    | None = None,
) -> Mapping[str, Any]:
    actor_user_id = require_auth(request)
    data = require_object(getattr(request, "data", None))
    session_id = require_string(data, "sessionId", max_length=1_500)
    command_id = require_command_id(data)
    requested_ended_at = data.get("endedAt")
    if requested_ended_at is not None and not isinstance(requested_ended_at, str):
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "endedAt must be an ISO-8601 string.",
        )
    did_archive = False
    recipients: Sequence[str] = ()

    def operation(transaction: Any) -> Mapping[str, Any]:
        nonlocal did_archive, recipients
        context = load_party_context(
            transaction,
            db,
            session_id,
            actor_user_id,
            require_admin=True,
        )
        ended_at = requested_ended_at or context.session.get("endedAt")
        if not isinstance(ended_at, str) or not ended_at:
            raise callable_error(
                https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
                "endedAt is required when the Session is ongoing.",
            )
        _validate_end_time(ended_at, context.session.get("startedAt"))
        schedule = context.party.get("questSchedule", {})
        if not isinstance(schedule, Mapping):
            schedule = {}

        session_ref = db.collection("sessions").document(session_id)
        party_ref = db.collection("parties").document(session_id)
        transaction.update(
            session_ref,
            {"endedAt": ended_at, "updatedAt": firestore.SERVER_TIMESTAMP},
        )
        transaction.update(
            party_ref,
            {
                "status": "archived",
                "archivedAt": firestore.SERVER_TIMESTAMP,
                "questSchedule": {**schedule, "nextQuestAt": None},
                "activeQuestId": None,
                "activeChallengeId": None,
                "activeTournamentId": None,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        recipients = _stored_string_list(context.session, "memberIds")
        did_archive = True
        return {"sessionId": session_id, "status": "archived", "endedAt": ended_at}

    result = run_idempotent_command(
        db,
        party_id=session_id,
        command_id=command_id,
        command_name="archive_party",
        actor_user_id=actor_user_id,
        operation=operation,
        transaction_runner=transaction_runner,
    )
    if did_archive:
        notification_dispatcher(
            db,
            recipients,
            actor_user_id=actor_user_id,
            title="Party archived",
            body="The final Party results are ready.",
            data=party_notification_data("party_archived", session_id),
        )
    return result


def _initial_drink_awards(
    session: Mapping[str, Any],
    member_ids: Sequence[str],
) -> tuple[list[tuple[str, Mapping[str, Any]]], dict[str, tuple[int, int]]]:
    drinks = session.get("drinks", [])
    if not isinstance(drinks, Sequence) or isinstance(drinks, (str, bytes)):
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Stored Session drinks are invalid.",
        )
    member_set = set(member_ids)
    awards: list[tuple[str, Mapping[str, Any]]] = []
    totals: dict[str, tuple[int, int]] = {}
    seen_drink_ids: set[str] = set()
    for raw_drink in drinks:
        if not isinstance(raw_drink, Mapping):
            raise _invalid_stored_drink()
        drink_id = _stored_string(raw_drink, "id")
        recipient_id = _stored_string(raw_drink, "consumedByUserId")
        if drink_id in seen_drink_ids or recipient_id not in member_set:
            raise _invalid_stored_drink()
        seen_drink_ids.add(drink_id)
        drink_type = raw_drink.get("drinkType")
        if not isinstance(drink_type, Mapping):
            raise _invalid_stored_drink()
        category = _stored_string(drink_type, "category")
        alcohol_percentage = drink_type.get("alcoholPercentage")
        volume_ml = raw_drink.get("volumeInMilliliters")
        if (
            isinstance(alcohol_percentage, bool)
            or not isinstance(alcohol_percentage, (int, float))
            or isinstance(volume_ml, bool)
            or not isinstance(volume_ml, (int, float))
        ):
            raise _invalid_stored_drink()
        try:
            score = calculate_drink_score(
                volume_ml,
                alcohol_percentage,
                drink_category=category,
                selected_class=None,
            )
        except ValueError as error:
            raise _invalid_stored_drink() from error
        occurred_at = raw_drink.get("consumedAt")
        if occurred_at is None:
            raise _invalid_stored_drink()
        event_id = deterministic_event_id("drink", drink_id, "v", "1")
        event = {
            "kind": "drink",
            "recipientUserId": recipient_id,
            "participantIds": [recipient_id],
            "pointsUnits": score.base_units,
            "sourceCollection": "drinks",
            "sourceId": drink_id,
            "reversesEventId": None,
            "actorUserId": None,
            "occurredAt": occurred_at,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "payload": {
                "drinkId": drink_id,
                "drinkName": drink_type.get("name"),
                "category": category,
                "alcoholPercentage": alcohol_percentage,
                "volumeInMilliliters": volume_ml,
                "alcoholMilliliters": float(score.alcohol_ml),
                "selectedClass": None,
                "classVersion": 0,
                "appliedMultiplier": 1,
                "revision": 1,
            },
        }
        awards.append((event_id, event))
        prior_score, prior_count = totals.get(recipient_id, (0, 0))
        totals[recipient_id] = (prior_score + score.base_units, prior_count + 1)
    return awards, totals


def _new_member(user_id: str, score_units: int, drink_count: int) -> Mapping[str, Any]:
    return {
        "userId": user_id,
        "selectedClass": None,
        "classVersion": 0,
        "classChangedAt": None,
        "beerpongOptIn": False,
        "scoreUnits": score_units,
        "drinkCount": drink_count,
        "isActive": True,
        "joinedAt": firestore.SERVER_TIMESTAMP,
        "updatedAt": firestore.SERVER_TIMESTAMP,
    }


def _validate_template_seeds(seeds: Sequence[TemplateSeed]) -> None:
    ids: set[str] = set()
    for template_id, template in seeds:
        if not template_id or "/" in template_id or template_id in ids:
            raise ValueError("Template seed IDs must be unique Firestore document IDs")
        if not isinstance(template, Mapping):
            raise TypeError("Template seeds must contain mappings")
        ids.add(template_id)


def _stored_string_list(document: Mapping[str, Any], field_name: str) -> list[str]:
    value = document.get(field_name, [])
    if (
        not isinstance(value, Sequence)
        or isinstance(value, (str, bytes))
        or any(not isinstance(item, str) or not item for item in value)
    ):
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            f"Stored {field_name} is invalid.",
        )
    return list(dict.fromkeys(value))


def _stored_string(document: Mapping[str, Any], field_name: str) -> str:
    value = document.get(field_name)
    if not isinstance(value, str) or not value:
        raise _invalid_stored_drink()
    return value


def _validate_end_time(ended_at: str, started_at: Any) -> None:
    try:
        parsed_end = datetime.fromisoformat(ended_at.replace("Z", "+00:00"))
        parsed_start = (
            datetime.fromisoformat(started_at.replace("Z", "+00:00"))
            if isinstance(started_at, str)
            else started_at
        )
        if isinstance(parsed_start, datetime) and parsed_end <= parsed_start:
            raise ValueError
    except (TypeError, ValueError) as error:
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "endedAt must be after the Session start time.",
        ) from error


def _invalid_stored_drink() -> https_fn.HttpsError:
    return callable_error(
        https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        "A stored Session drink is invalid for Party activation.",
    )
