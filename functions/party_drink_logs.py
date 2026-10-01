"""Server-authoritative create, update, and delete commands for Party drink logs."""

from collections.abc import Callable, Mapping, Sequence
from datetime import datetime, timezone, tzinfo
from typing import Any

from firebase_admin import firestore
from firebase_functions import https_fn
from party_badges import evaluate_badges, newly_unlocked_badge_ids
from party_common import (
    callable_error,
    load_party_context,
    require_auth,
    require_command_id,
    require_int,
    require_object,
    require_string,
    run_idempotent_command,
)
from party_scoring import (
    calculate_drink_score,
    deterministic_event_id,
    reversal_event_id,
)
from party_user_stats import apply_drink_log_stats

DRINK_CATEGORIES = {"beer", "cider", "cocktail", "spirit", "wine"}
GLOBAL_USER_ID = "global"
MAX_SESSION_DRINK_LOGS = 1_000


def create_party_drink_log(request: Any) -> Mapping[str, Any]:
    return create_party_drink_log_command(request, firestore.client())


def update_party_drink_log(request: Any) -> Mapping[str, Any]:
    return update_party_drink_log_command(request, firestore.client())


def delete_party_drink_log(request: Any) -> Mapping[str, Any]:
    return delete_party_drink_log_command(request, firestore.client())


def create_party_drink_log_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    transaction_runner: Callable[
        [Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]
    ]
    | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    drink_log_id = _document_id(data, "drinkLogId")

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(transaction, db, session_id, actor_id)
        drink_logs = _stored_drink_logs(context.session)
        if len(drink_logs) >= MAX_SESSION_DRINK_LOGS:
            raise _failed_precondition("The Party Session is full.")
        if any(drink_log.get("id") == drink_log_id for drink_log in drink_logs):
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "Drink log already exists.",
            )

        drink_id, drink = _load_drink(transaction, db, data, actor_id)
        drink_log, consumed_at = _new_drink_log(
            data, drink_log_id, actor_id, drink_id, drink
        )
        _require_session_time(context.session, consumed_at)
        party_ref = db.collection("parties").document(session_id)
        member_ref = party_ref.collection("members").document(actor_id)
        user_ref = db.collection("users").document(actor_id)
        member_snapshot = member_ref.get(transaction=transaction)
        user_snapshot = user_ref.get(transaction=transaction)
        member = _active_member(member_snapshot)
        user = _existing_user(user_snapshot)
        now = _now(now_provider, consumed_at)
        revision = 1
        drink_log["partyRevision"] = revision
        score = calculate_drink_score(
            drink_log["volumeInMilliliters"],
            drink["alcoholPercentage"],
            drink_category=drink["category"],
            selected_class=_optional_class(member),
        )
        event_id = deterministic_event_id("drinkLog", drink_log_id, "v", str(revision))
        event_ref = party_ref.collection("events").document(event_id)
        if event_ref.get(transaction=transaction).exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "Drink log award already exists.",
            )

        updated_user = apply_drink_log_stats(user, new_drink_log=drink_log)
        updated_user = evaluate_badges(
            updated_user, consumed_at=consumed_at, now=now, drink_log=drink_log
        )
        unlocked_badge_ids = newly_unlocked_badge_ids(user, updated_user)
        transaction.update(
            db.collection("sessions").document(session_id),
            {
                "drinkLogs": [*drink_logs, drink_log],
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        transaction.update(user_ref, _user_updates(updated_user))
        transaction.create(
            event_ref,
            _award_event(
                drink_log,
                score=score,
                selected_class=_optional_class(member),
                class_version=_stored_int(member, "classVersion"),
                actor_id=actor_id,
                revision=revision,
            ),
        )
        transaction.update(
            member_ref,
            {
                "scoreUnits": _stored_int(member, "scoreUnits") + score.awarded_units,
                "drinkCount": _stored_int(member, "drinkCount") + 1,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        return _result(session_id, drink_log, event_id, score, unlocked_badge_ids)

    return run_idempotent_command(
        db,
        party_id=session_id,
        command_id=command_id,
        command_name="create_party_drink_log",
        actor_user_id=actor_id,
        operation=operation,
        transaction_runner=transaction_runner,
    )


def update_party_drink_log_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    transaction_runner: Callable[
        [Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]
    ]
    | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    drink_log_id = _document_id(data, "drinkLogId")

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(transaction, db, session_id, actor_id)
        drink_logs = _stored_drink_logs(context.session)
        index, old_drink_log = _owned_drink_log(drink_logs, drink_log_id, actor_id)
        drink_id, drink = _load_drink(transaction, db, data, actor_id)
        new_drink_log, consumed_at = _new_drink_log(
            data, drink_log_id, actor_id, drink_id, drink
        )
        _require_session_time(context.session, consumed_at)
        old_revision = _stored_revision(old_drink_log)
        revision = old_revision + 1
        new_drink_log["partyRevision"] = revision

        party_ref = db.collection("parties").document(session_id)
        member_ref = party_ref.collection("members").document(actor_id)
        user_ref = db.collection("users").document(actor_id)
        old_event_id = deterministic_event_id(
            "drinkLog", drink_log_id, "v", str(old_revision)
        )
        old_event_ref = party_ref.collection("events").document(old_event_id)
        reverse_id = reversal_event_id(old_event_id)
        reversal_ref = party_ref.collection("events").document(reverse_id)
        new_event_id = deterministic_event_id(
            "drinkLog", drink_log_id, "v", str(revision)
        )
        new_event_ref = party_ref.collection("events").document(new_event_id)
        member_snapshot = member_ref.get(transaction=transaction)
        user_snapshot = user_ref.get(transaction=transaction)
        old_event_snapshot = old_event_ref.get(transaction=transaction)
        reversal_snapshot = reversal_ref.get(transaction=transaction)
        new_event_snapshot = new_event_ref.get(transaction=transaction)
        member = _active_member(member_snapshot)
        user = _existing_user(user_snapshot)
        old_event = _active_award(old_event_snapshot, old_event_id)
        if reversal_snapshot.exists or new_event_snapshot.exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "Drink log revision was already replaced.",
            )

        selected_class = _optional_class(member)
        score = calculate_drink_score(
            new_drink_log["volumeInMilliliters"],
            drink["alcoholPercentage"],
            drink_category=drink["category"],
            selected_class=selected_class,
        )
        now = _now(now_provider, consumed_at)
        updated_user = apply_drink_log_stats(
            user, old_drink_log=old_drink_log, new_drink_log=new_drink_log
        )
        updated_user = evaluate_badges(
            updated_user, consumed_at=consumed_at, now=now, drink_log=new_drink_log
        )
        unlocked_badge_ids = newly_unlocked_badge_ids(user, updated_user)
        updated_drink_logs = list(drink_logs)
        updated_drink_logs[index] = new_drink_log
        transaction.update(
            db.collection("sessions").document(session_id),
            {
                "drinkLogs": updated_drink_logs,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        transaction.update(user_ref, _user_updates(updated_user))
        transaction.create(
            reversal_ref,
            _reversal_event(
                old_event, old_event_id, actor_id, now, "drink_log_updated"
            ),
        )
        transaction.create(
            new_event_ref,
            _award_event(
                new_drink_log,
                score=score,
                selected_class=selected_class,
                class_version=_stored_int(member, "classVersion"),
                actor_id=actor_id,
                revision=revision,
            ),
        )
        transaction.update(
            member_ref,
            {
                "scoreUnits": _stored_int(member, "scoreUnits")
                - _stored_int(old_event, "pointsUnits")
                + score.awarded_units,
                "drinkCount": _stored_int(member, "drinkCount"),
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        return _result(
            session_id,
            new_drink_log,
            new_event_id,
            score,
            unlocked_badge_ids,
            reversal_id=reverse_id,
        )

    return run_idempotent_command(
        db,
        party_id=session_id,
        command_id=command_id,
        command_name="update_party_drink_log",
        actor_user_id=actor_id,
        operation=operation,
        transaction_runner=transaction_runner,
    )


def delete_party_drink_log_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    transaction_runner: Callable[
        [Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]
    ]
    | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    drink_log_id = _document_id(data, "drinkLogId")

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(transaction, db, session_id, actor_id)
        drink_logs = _stored_drink_logs(context.session)
        index, drink_log = _owned_drink_log(drink_logs, drink_log_id, actor_id)
        consumed_at = _parse_datetime(
            drink_log.get("consumedAt"), "stored consumedAt"
        )
        revision = _stored_revision(drink_log)
        party_ref = db.collection("parties").document(session_id)
        member_ref = party_ref.collection("members").document(actor_id)
        user_ref = db.collection("users").document(actor_id)
        event_id = deterministic_event_id("drinkLog", drink_log_id, "v", str(revision))
        event_ref = party_ref.collection("events").document(event_id)
        reverse_id = reversal_event_id(event_id)
        reversal_ref = party_ref.collection("events").document(reverse_id)
        member_snapshot = member_ref.get(transaction=transaction)
        user_snapshot = user_ref.get(transaction=transaction)
        event_snapshot = event_ref.get(transaction=transaction)
        reversal_snapshot = reversal_ref.get(transaction=transaction)
        member = _active_member(member_snapshot)
        user = _existing_user(user_snapshot)
        event = _active_award(event_snapshot, event_id)
        if reversal_snapshot.exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "Drink log award was already reversed.",
            )
        drink_count = _stored_int(member, "drinkCount")
        if drink_count <= 0:
            raise _failed_precondition("Stored Party drink count is invalid.")

        now = _now(now_provider, consumed_at)
        updated_user = apply_drink_log_stats(user, old_drink_log=drink_log)
        updated_user = evaluate_badges(updated_user, consumed_at=consumed_at, now=now)
        unlocked_badge_ids = newly_unlocked_badge_ids(user, updated_user)
        transaction.update(
            db.collection("sessions").document(session_id),
            {
                "drinkLogs": [*drink_logs[:index], *drink_logs[index + 1 :]],
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        transaction.update(user_ref, _user_updates(updated_user))
        transaction.create(
            reversal_ref,
            _reversal_event(event, event_id, actor_id, now, "drink_log_deleted"),
        )
        transaction.update(
            member_ref,
            {
                "scoreUnits": _stored_int(member, "scoreUnits")
                - _stored_int(event, "pointsUnits"),
                "drinkCount": drink_count - 1,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        return {
            "sessionId": session_id,
            "drinkLogId": drink_log_id,
            "reversalEventId": reverse_id,
            "unlockedBadgeIds": unlocked_badge_ids,
        }

    return run_idempotent_command(
        db,
        party_id=session_id,
        command_id=command_id,
        command_name="delete_party_drink_log",
        actor_user_id=actor_id,
        operation=operation,
        transaction_runner=transaction_runner,
    )


def _command_input(request: Any) -> tuple[str, Mapping[str, Any], str, str]:
    actor_id = require_auth(request)
    data = require_object(getattr(request, "data", None))
    session_id = _document_id(data, "sessionId")
    return actor_id, data, session_id, require_command_id(data)


def _new_drink_log(
    data: Mapping[str, Any],
    drink_log_id: str,
    actor_id: str,
    drink_id: str,
    drink: Mapping[str, Any],
) -> tuple[dict[str, Any], datetime]:
    consumed_at = _parse_datetime(data.get("consumedAt"), "consumedAt")
    volume = require_int(data, "volumeInMilliliters", minimum=1, maximum=100_000)
    location = _location(data.get("location"))
    drink_log = {
        "id": drink_log_id,
        "consumedByUserId": actor_id,
        "consumedAt": consumed_at.isoformat(),
        "drink": dict(drink),
        "drinkId": drink_id,
        "volumeInMilliliters": volume,
        "location": location,
    }
    return drink_log, consumed_at


def _load_drink(
    transaction: Any,
    db: Any,
    data: Mapping[str, Any],
    actor_id: str,
) -> tuple[str, Mapping[str, Any]]:
    drink_id = _document_id(data, "drinkId")
    snapshot = db.collection("drinks").document(drink_id).get(
        transaction=transaction
    )
    if not snapshot.exists:
        raise callable_error(
            https_fn.FunctionsErrorCode.NOT_FOUND,
            "Drink was not found.",
        )
    stored = snapshot.to_dict() or {}
    if stored.get("deletedAt") is not None or stored.get("userId") not in {
        actor_id,
        GLOBAL_USER_ID,
    }:
        raise callable_error(
            https_fn.FunctionsErrorCode.PERMISSION_DENIED,
            "Drink is not available to this user.",
        )
    name = stored.get("name")
    category = stored.get("category")
    percentage = stored.get("alcoholPercentage")
    if (
        not isinstance(name, str)
        or not name.strip()
        or category not in DRINK_CATEGORIES
        or isinstance(percentage, bool)
        or not isinstance(percentage, (int, float))
        or not 0 < percentage <= 100
    ):
        raise _failed_precondition("Stored drink is invalid.")
    return (
        drink_id,
        {
            "name": name,
            "category": category,
            "alcoholPercentage": float(percentage),
        },
    )


def _stored_drink_logs(session: Mapping[str, Any]) -> list[Mapping[str, Any]]:
    drink_logs = session.get("drinkLogs", [])
    if (
        isinstance(drink_logs, (str, bytes))
        or not isinstance(drink_logs, Sequence)
        or any(not isinstance(drink_log, Mapping) for drink_log in drink_logs)
    ):
        raise _failed_precondition("Stored Session drink logs are invalid.")
    return list(drink_logs)


def _owned_drink_log(
    drink_logs: Sequence[Mapping[str, Any]], drink_log_id: str, actor_id: str
) -> tuple[int, Mapping[str, Any]]:
    matches = [
        (index, drink_log)
        for index, drink_log in enumerate(drink_logs)
        if drink_log.get("id") == drink_log_id
    ]
    if len(matches) != 1:
        raise callable_error(
            https_fn.FunctionsErrorCode.NOT_FOUND,
            "Drink log was not found.",
        )
    index, drink_log = matches[0]
    if drink_log.get("consumedByUserId") != actor_id:
        raise callable_error(
            https_fn.FunctionsErrorCode.PERMISSION_DENIED,
            "Users can only change their own drink logs.",
        )
    return index, drink_log


def _require_session_time(session: Mapping[str, Any], consumed_at: datetime) -> None:
    session_timezone = consumed_at.tzinfo or timezone.utc
    started_at = _parse_datetime(
        session.get("startedAt"),
        "stored startedAt",
        default_timezone=session_timezone,
    )
    ended_value = session.get("endedAt")
    ended_at = (
        _parse_datetime(
            ended_value,
            "stored endedAt",
            default_timezone=session_timezone,
        )
        if ended_value is not None
        else None
    )
    try:
        valid = started_at < consumed_at and (
            ended_at is None or consumed_at < ended_at
        )
    except TypeError as error:
        raise _failed_precondition(
            "Session and drink time zones do not match."
        ) from error
    if not valid:
        raise _failed_precondition("Drink time must be within the Party Session.")


def _active_member(snapshot: Any) -> Mapping[str, Any]:
    if not snapshot.exists:
        raise callable_error(
            https_fn.FunctionsErrorCode.NOT_FOUND,
            "Party member was not found.",
        )
    member = snapshot.to_dict() or {}
    if member.get("isActive") is not True:
        raise _failed_precondition("Party member is inactive.")
    return member


def _existing_user(snapshot: Any) -> Mapping[str, Any]:
    if not snapshot.exists:
        raise callable_error(
            https_fn.FunctionsErrorCode.NOT_FOUND,
            "User profile was not found.",
        )
    return snapshot.to_dict() or {}


def _active_award(snapshot: Any, event_id: str) -> Mapping[str, Any]:
    if not snapshot.exists:
        raise _failed_precondition(
            f"Active drink log award {event_id} was not found."
        )
    event = snapshot.to_dict() or {}
    if event.get("kind") != "drinkLog" or event.get("reversesEventId") is not None:
        raise _failed_precondition("Stored drink log award is invalid.")
    return event


def _award_event(
    drink_log: Mapping[str, Any],
    *,
    score: Any,
    selected_class: str | None,
    class_version: int,
    actor_id: str,
    revision: int,
) -> Mapping[str, Any]:
    drink = drink_log["drink"]
    return {
        "kind": "drinkLog",
        "recipientUserId": actor_id,
        "participantIds": [actor_id],
        "pointsUnits": score.awarded_units,
        "sourceCollection": "drinkLogs",
        "sourceId": drink_log["id"],
        "reversesEventId": None,
        "actorUserId": actor_id,
        "occurredAt": _parse_datetime(drink_log["consumedAt"], "stored consumedAt"),
        "createdAt": firestore.SERVER_TIMESTAMP,
        "payload": {
            "drinkLogId": drink_log["id"],
            "drinkName": drink["name"],
            "category": drink["category"],
            "alcoholPercentage": drink["alcoholPercentage"],
            "volumeInMilliliters": drink_log["volumeInMilliliters"],
            "alcoholMilliliters": float(score.alcohol_ml),
            "selectedClass": selected_class,
            "classVersion": class_version,
            "appliedMultiplier": float(score.applied_multiplier),
            "revision": revision,
        },
    }


def _reversal_event(
    award: Mapping[str, Any],
    award_id: str,
    actor_id: str,
    now: datetime,
    reason: str,
) -> Mapping[str, Any]:
    return {
        "kind": "reversal",
        "recipientUserId": award.get("recipientUserId"),
        "participantIds": list(award.get("participantIds", [])),
        "pointsUnits": -_stored_int(award, "pointsUnits"),
        "sourceCollection": award.get("sourceCollection"),
        "sourceId": award.get("sourceId"),
        "reversesEventId": award_id,
        "actorUserId": actor_id,
        "occurredAt": now,
        "createdAt": firestore.SERVER_TIMESTAMP,
        "payload": {"reversedKind": "drinkLog", "reason": reason},
    }


def _result(
    session_id: str,
    drink_log: Mapping[str, Any],
    event_id: str,
    score: Any,
    unlocked_badge_ids: Sequence[str],
    *,
    reversal_id: str | None = None,
) -> Mapping[str, Any]:
    callable_drink_log = dict(drink_log)
    location = callable_drink_log.get("location")
    if location is not None:
        callable_drink_log["location"] = {
            "latitude": location.latitude,
            "longitude": location.longitude,
        }
    result: dict[str, Any] = {
        "sessionId": session_id,
        "drinkLog": callable_drink_log,
        "awardEventId": event_id,
        "baseScoreUnits": score.base_units,
        "classBonusUnits": score.class_bonus_units,
        "awardedScoreUnits": score.awarded_units,
        "unlockedBadgeIds": list(unlocked_badge_ids),
    }
    if reversal_id is not None:
        result["reversalEventId"] = reversal_id
    return result


def _user_updates(user: Mapping[str, Any]) -> Mapping[str, Any]:
    return {
        "monthlyStats": user.get("monthlyStats", {}),
        "unlockedBadges": user.get("unlockedBadges", {}),
    }


def _optional_class(member: Mapping[str, Any]) -> str | None:
    selected = member.get("selectedClass")
    if selected is not None and selected not in DRINK_CATEGORIES:
        raise _failed_precondition("Stored Party class is invalid.")
    return selected


def _stored_revision(drink_log: Mapping[str, Any]) -> int:
    revision = drink_log.get("partyRevision", 1)
    if isinstance(revision, bool) or not isinstance(revision, int) or revision < 1:
        raise _failed_precondition("Stored Party drink log revision is invalid.")
    return revision


def _stored_int(document: Mapping[str, Any], field: str) -> int:
    value = document.get(field, 0)
    if isinstance(value, bool) or not isinstance(value, int):
        raise _failed_precondition(f"Stored {field} is invalid.")
    return value


def _document_id(data: Mapping[str, Any], field: str) -> str:
    value = require_string(data, field, max_length=1_500)
    if "/" in value:
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            f"{field} must not contain '/'.",
        )
    return value


def _parse_datetime(
    value: Any,
    field: str,
    *,
    default_timezone: tzinfo = timezone.utc,
) -> datetime:
    if isinstance(value, datetime):
        parsed = value
    elif isinstance(value, str):
        try:
            parsed = datetime.fromisoformat(value.replace("Z", "+00:00"))
        except ValueError as error:
            raise callable_error(
                https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
                f"{field} must be an ISO-8601 date-time.",
            ) from error
    else:
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            f"{field} must be an ISO-8601 date-time.",
        )
    return (
        parsed
        if parsed.tzinfo is not None
        else parsed.replace(tzinfo=default_timezone)
    )


def _location(value: Any) -> Any:
    if value is None:
        return None
    if isinstance(value, Mapping):
        latitude = value.get("latitude")
        longitude = value.get("longitude")
        if (
            isinstance(latitude, bool)
            or not isinstance(latitude, (int, float))
            or isinstance(longitude, bool)
            or not isinstance(longitude, (int, float))
            or not -90 <= latitude <= 90
            or not -180 <= longitude <= 180
        ):
            raise callable_error(
                https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
                "location latitude or longitude is invalid.",
            )
        return firestore.GeoPoint(float(latitude), float(longitude))
    latitude = getattr(value, "latitude", None)
    longitude = getattr(value, "longitude", None)
    if (
        isinstance(latitude, (int, float))
        and isinstance(longitude, (int, float))
        and -90 <= latitude <= 90
        and -180 <= longitude <= 180
    ):
        return value
    raise callable_error(
        https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
        "location must contain latitude and longitude.",
    )


def _now(provider: Callable[[], datetime] | None, consumed_at: datetime) -> datetime:
    now = provider() if provider is not None else datetime.now(timezone.utc)
    if consumed_at.tzinfo is None:
        return now.replace(tzinfo=None)
    return now.astimezone(consumed_at.tzinfo)


def _failed_precondition(message: str) -> https_fn.HttpsError:
    return callable_error(https_fn.FunctionsErrorCode.FAILED_PRECONDITION, message)
