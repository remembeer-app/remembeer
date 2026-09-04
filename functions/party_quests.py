"""Transactional social quest settings, templates, and partner selections.

Handlers are intentionally undecorated for P21 to export. All notification
hooks run after their authoritative transaction has committed.
"""

from collections.abc import Callable, Mapping, Sequence
from datetime import datetime, timedelta, timezone
from typing import Any

from firebase_admin import firestore
from firebase_functions import https_fn
from party_common import (
    callable_error,
    load_party_context,
    require_auth,
    require_bool,
    require_command_id,
    require_int,
    require_object,
    require_string,
    run_idempotent_command,
)
from party_notifications import party_notification_data, send_notification_to_users
from party_quest_catalog import ALL_ELIGIBLE_MEMBERS, CATALOG_VERSION
from party_scoring import (
    SCORE_UNITS_PER_POINT,
    AwardInput,
    canonical_pair_key,
    create_awards,
    deterministic_event_id,
)

MIN_QUEST_INTERVAL_MINUTES = 5
MAX_QUEST_INTERVAL_MINUTES = 180
MIN_QUEST_DURATION_MINUTES = 1
MAX_QUEST_DURATION_MINUTES = 60
MIN_QUEST_POINTS_UNITS = SCORE_UNITS_PER_POINT
MAX_QUEST_POINTS_UNITS = 500 * SCORE_UNITS_PER_POINT
MAX_QUEST_TITLE_LENGTH = 120
MAX_QUEST_INSTRUCTIONS_LENGTH = 1_000

TransactionRunner = Callable[[Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]]
NotificationDispatcher = Callable[..., Any]


def set_party_quest_schedule(request: Any) -> Mapping[str, Any]:
    return set_party_quest_schedule_command(request, firestore.client())


def create_custom_quest_template(request: Any) -> Mapping[str, Any]:
    return create_custom_quest_template_command(request, firestore.client())


def update_custom_quest_template(request: Any) -> Mapping[str, Any]:
    return update_custom_quest_template_command(request, firestore.client())


def delete_custom_quest_template(request: Any) -> Mapping[str, Any]:
    return delete_custom_quest_template_command(request, firestore.client())


def set_quest_template_enabled(request: Any) -> Mapping[str, Any]:
    return set_quest_template_enabled_command(request, firestore.client())


def select_quest_partner(request: Any) -> Mapping[str, Any]:
    return select_quest_partner_command(request, firestore.client())


def set_party_quest_schedule_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    raw_schedule = require_object(data.get("questSchedule"), "questSchedule")
    minimum = require_int(
        raw_schedule,
        "minIntervalMinutes",
        minimum=MIN_QUEST_INTERVAL_MINUTES,
        maximum=MAX_QUEST_INTERVAL_MINUTES,
    )
    maximum = require_int(
        raw_schedule,
        "maxIntervalMinutes",
        minimum=MIN_QUEST_INTERVAL_MINUTES,
        maximum=MAX_QUEST_INTERVAL_MINUTES,
    )
    duration = require_int(
        raw_schedule,
        "defaultDurationMinutes",
        minimum=MIN_QUEST_DURATION_MINUTES,
        maximum=MAX_QUEST_DURATION_MINUTES,
    )
    if minimum > maximum:
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "minIntervalMinutes must not exceed maxIntervalMinutes.",
        )

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(
            transaction, db, session_id, actor_id, require_admin=True
        )
        now = _now(now_provider)
        old_schedule = context.party.get("questSchedule")
        next_quest_at = (
            old_schedule.get("nextQuestAt")
            if isinstance(old_schedule, Mapping)
            else None
        )
        if _quests_enabled(context.party) and next_quest_at is None:
            next_quest_at = now + timedelta(minutes=minimum)
        schedule = {
            "minIntervalMinutes": minimum,
            "maxIntervalMinutes": maximum,
            "defaultDurationMinutes": duration,
            "nextQuestAt": next_quest_at,
        }
        transaction.update(
            _party_ref(db, session_id),
            {"questSchedule": schedule, "updatedAt": firestore.SERVER_TIMESTAMP},
        )
        return {"sessionId": session_id, "questSchedule": schedule}

    return _run_command(
        db,
        session_id,
        command_id,
        "set_party_quest_schedule",
        actor_id,
        operation,
        transaction_runner,
    )


def create_custom_quest_template_command(
    request: Any,
    db: Any,
    *,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    template_id = _document_id(data, "templateId")
    values = _template_input(data)

    def operation(transaction: Any) -> Mapping[str, Any]:
        load_party_context(transaction, db, session_id, actor_id, require_admin=True)
        template_ref = _template_ref(db, session_id, template_id)
        if transaction.get(template_ref).exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "Quest template ID already exists.",
            )
        template = {
            "source": "custom",
            "builtInKey": None,
            **values,
            "eligibilityRule": ALL_ELIGIBLE_MEMBERS,
            "enabled": True,
            "catalogVersion": CATALOG_VERSION,
            "createdByUserId": actor_id,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
        transaction.create(template_ref, template)
        return {"sessionId": session_id, "templateId": template_id, **template}

    return _run_command(
        db,
        session_id,
        command_id,
        "create_custom_quest_template",
        actor_id,
        operation,
        transaction_runner,
    )


def update_custom_quest_template_command(
    request: Any,
    db: Any,
    *,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    template_id = _document_id(data, "templateId")
    values = _template_input(data)

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(
            transaction, db, session_id, actor_id, require_admin=True
        )
        template_ref, template = _load_template(
            transaction, db, session_id, template_id
        )
        _require_custom_template(template)
        if context.party.get("activeQuestId") is not None:
            quest_ref = _quest_ref(db, session_id, context.party["activeQuestId"])
            quest_snapshot = transaction.get(quest_ref)
            if (
                quest_snapshot.exists
                and (quest_snapshot.to_dict() or {}).get("templateId") == template_id
            ):
                raise callable_error(
                    https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                    "A template used by the active quest cannot be changed.",
                )
        transaction.update(
            template_ref, {**values, "updatedAt": firestore.SERVER_TIMESTAMP}
        )
        return {"sessionId": session_id, "templateId": template_id, **values}

    return _run_command(
        db,
        session_id,
        command_id,
        "update_custom_quest_template",
        actor_id,
        operation,
        transaction_runner,
    )


def delete_custom_quest_template_command(
    request: Any,
    db: Any,
    *,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    template_id = _document_id(data, "templateId")

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(
            transaction, db, session_id, actor_id, require_admin=True
        )
        template_ref, template = _load_template(
            transaction, db, session_id, template_id
        )
        _require_custom_template(template)
        if context.party.get("activeQuestId") is not None:
            quest_snapshot = transaction.get(
                _quest_ref(db, session_id, context.party["activeQuestId"])
            )
            if (
                quest_snapshot.exists
                and (quest_snapshot.to_dict() or {}).get("templateId") == template_id
            ):
                raise callable_error(
                    https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                    "A template used by the active quest cannot be deleted.",
                )
        transaction.delete(template_ref)
        return {"sessionId": session_id, "templateId": template_id, "deleted": True}

    return _run_command(
        db,
        session_id,
        command_id,
        "delete_custom_quest_template",
        actor_id,
        operation,
        transaction_runner,
    )


def set_quest_template_enabled_command(
    request: Any,
    db: Any,
    *,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    template_id = _document_id(data, "templateId")
    enabled = require_bool(data, "enabled")

    def operation(transaction: Any) -> Mapping[str, Any]:
        load_party_context(transaction, db, session_id, actor_id, require_admin=True)
        template_ref, _ = _load_template(transaction, db, session_id, template_id)
        transaction.update(
            template_ref,
            {"enabled": enabled, "updatedAt": firestore.SERVER_TIMESTAMP},
        )
        return {
            "sessionId": session_id,
            "templateId": template_id,
            "enabled": enabled,
        }

    return _run_command(
        db,
        session_id,
        command_id,
        "set_quest_template_enabled",
        actor_id,
        operation,
        transaction_runner,
    )


def select_quest_partner_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    notification_dispatcher: NotificationDispatcher = send_notification_to_users,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    quest_id = _document_id(data, "questId")
    selected_id = require_string(data, "selectedUserId", max_length=1_500)
    if actor_id == selected_id:
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "A member cannot select themselves.",
        )
    did_match = False

    def operation(transaction: Any) -> Mapping[str, Any]:
        nonlocal did_match
        did_match = False
        context = load_party_context(transaction, db, session_id, actor_id)
        if not _quests_enabled(context.party):
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Social quests are disabled.",
            )
        quest_ref = _quest_ref(db, session_id, quest_id)
        quest_snapshot = transaction.get(quest_ref)
        if not quest_snapshot.exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.NOT_FOUND, "Quest was not found."
            )
        quest = quest_snapshot.to_dict() or {}
        now = _now(now_provider)
        if (
            context.party.get("activeQuestId") != quest_id
            or quest.get("status") != "active"
            or _stored_datetime(quest, "endsAt") <= now
        ):
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Quest is not active.",
            )
        eligible_ids = _stored_unique_strings(quest, "eligibleMemberIds")
        if actor_id not in eligible_ids or selected_id not in eligible_ids:
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Both members must be eligible for this quest.",
            )
        pair_key = canonical_pair_key(actor_id, selected_id)
        eligible_pairs = _stored_unique_strings(quest, "eligiblePairKeys")
        if pair_key not in eligible_pairs:
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "The selected pair does not satisfy this quest.",
            )
        completed_pairs = _stored_unique_strings(quest, "completedPairKeys")
        selection_ref = quest_ref.collection("selections").document(actor_id)
        reverse_ref = quest_ref.collection("selections").document(selected_id)
        selection_snapshot = transaction.get(selection_ref)
        reverse_snapshot = transaction.get(reverse_ref)
        existing = selection_snapshot.to_dict() or {}
        reverse = reverse_snapshot.to_dict() or {}
        if (
            selection_snapshot.exists
            and canonical_pair_key(actor_id, _stored_selection_target(existing))
            in completed_pairs
        ):
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "A completed quest selection cannot be changed.",
            )
        if (
            reverse_snapshot.exists
            and canonical_pair_key(selected_id, _stored_selection_target(reverse))
            in completed_pairs
        ):
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "The selected member already completed a pair.",
            )
        matched = reverse.get("selectedUserId") == actor_id
        if matched and pair_key in completed_pairs:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "This pair already completed the quest.",
            )

        if matched:
            points = _stored_points(quest)
            participant_ids = sorted((actor_id, selected_id))
            awards = create_awards(
                transaction,
                _party_ref(db, session_id),
                [
                    AwardInput(
                        event_id=_quest_award_id(quest_id, pair_key, recipient),
                        kind="socialQuest",
                        recipient_user_id=recipient,
                        participant_ids=participant_ids,
                        points_units=points,
                        source_collection="quests",
                        source_id=quest_id,
                        occurred_at=now,
                        actor_user_id=actor_id,
                        payload={
                            "questId": quest_id,
                            "pairKey": pair_key,
                            "title": quest.get("titleSnapshot"),
                        },
                    )
                    for recipient in participant_ids
                ],
            )
            if not all(award.created for award in awards):
                raise callable_error(
                    https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                    "This pair already has quest awards.",
                )
            completed_pairs.append(pair_key)
            transaction.update(quest_ref, {"completedPairKeys": completed_pairs})
            did_match = True

        selection = {
            "selectorUserId": actor_id,
            "selectedUserId": selected_id,
            "selectedAt": now,
        }
        if selection_snapshot.exists:
            transaction.update(selection_ref, selection)
        else:
            transaction.create(selection_ref, selection)
        return {
            "sessionId": session_id,
            "questId": quest_id,
            "selectedUserId": selected_id,
            "matched": matched,
            "pairKey": pair_key if matched else None,
            "awardEventIds": (
                [
                    _quest_award_id(quest_id, pair_key, recipient)
                    for recipient in sorted((actor_id, selected_id))
                ]
                if matched
                else []
            ),
        }

    result = _run_command(
        db,
        session_id,
        command_id,
        "select_quest_partner",
        actor_id,
        operation,
        transaction_runner,
    )
    if did_match:
        notification_dispatcher(
            db,
            [actor_id, selected_id],
            actor_user_id=actor_id,
            title="Social quest completed",
            body="Your mutual selection earned points.",
            data=party_notification_data(
                "party_quest_completed", session_id, source_id=quest_id
            ),
        )
    return result


def _template_input(data: Mapping[str, Any]) -> Mapping[str, Any]:
    return {
        "title": require_string(data, "title", max_length=MAX_QUEST_TITLE_LENGTH),
        "instructions": require_string(
            data, "instructions", max_length=MAX_QUEST_INSTRUCTIONS_LENGTH
        ),
        "pointsUnits": require_int(
            data,
            "pointsUnits",
            minimum=MIN_QUEST_POINTS_UNITS,
            maximum=MAX_QUEST_POINTS_UNITS,
        ),
        "durationMinutes": require_int(
            data,
            "durationMinutes",
            minimum=MIN_QUEST_DURATION_MINUTES,
            maximum=MAX_QUEST_DURATION_MINUTES,
        ),
    }


def _command_input(request: Any) -> tuple[str, Mapping[str, Any], str, str]:
    actor_id = require_auth(request)
    data = require_object(getattr(request, "data", None))
    session_id = require_string(data, "sessionId", max_length=1_500)
    return actor_id, data, session_id, require_command_id(data)


def _run_command(
    db: Any,
    session_id: str,
    command_id: str,
    command_name: str,
    actor_id: str,
    operation: Callable[[Any], Mapping[str, Any]],
    runner: TransactionRunner | None,
) -> Mapping[str, Any]:
    return run_idempotent_command(
        db,
        party_id=session_id,
        command_id=command_id,
        command_name=command_name,
        actor_user_id=actor_id,
        operation=operation,
        transaction_runner=runner,
    )


def _document_id(data: Mapping[str, Any], field_name: str) -> str:
    value = require_string(data, field_name, max_length=1_500)
    if "/" in value:
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            f"{field_name} must not contain '/'.",
        )
    return value


def _party_ref(db: Any, session_id: str) -> Any:
    return db.collection("parties").document(session_id)


def _template_ref(db: Any, session_id: str, template_id: str) -> Any:
    return _party_ref(db, session_id).collection("questTemplates").document(template_id)


def _quest_ref(db: Any, session_id: str, quest_id: str) -> Any:
    return _party_ref(db, session_id).collection("quests").document(quest_id)


def _load_template(
    transaction: Any, db: Any, session_id: str, template_id: str
) -> tuple[Any, Mapping[str, Any]]:
    reference = _template_ref(db, session_id, template_id)
    snapshot = transaction.get(reference)
    if not snapshot.exists:
        raise callable_error(
            https_fn.FunctionsErrorCode.NOT_FOUND, "Quest template was not found."
        )
    return reference, snapshot.to_dict() or {}


def _require_custom_template(template: Mapping[str, Any]) -> None:
    if template.get("source") != "custom":
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Built-in quest templates cannot be changed or deleted.",
        )


def _quests_enabled(party: Mapping[str, Any]) -> bool:
    settings = party.get("moduleSettings")
    return isinstance(settings, Mapping) and settings.get("socialQuestsEnabled") is True


def _stored_unique_strings(document: Mapping[str, Any], field: str) -> list[str]:
    value = document.get(field, [])
    if (
        not isinstance(value, Sequence)
        or isinstance(value, (str, bytes))
        or any(not isinstance(item, str) or not item for item in value)
        or len(set(value)) != len(value)
    ):
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            f"Stored quest {field} is invalid.",
        )
    return list(value)


def _stored_selection_target(selection: Mapping[str, Any]) -> str:
    value = selection.get("selectedUserId")
    if not isinstance(value, str) or not value:
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Stored quest selection is invalid.",
        )
    return value


def _stored_datetime(document: Mapping[str, Any], field: str) -> datetime:
    value = document.get(field)
    if not isinstance(value, datetime):
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            f"Stored quest {field} is invalid.",
        )
    return value


def _stored_points(quest: Mapping[str, Any]) -> int:
    value = quest.get("pointsUnits")
    if (
        isinstance(value, bool)
        or not isinstance(value, int)
        or not MIN_QUEST_POINTS_UNITS <= value <= MAX_QUEST_POINTS_UNITS
    ):
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Stored quest points are invalid.",
        )
    return value


def _quest_award_id(quest_id: str, pair_key: str, recipient: str) -> str:
    return deterministic_event_id(
        "quest", quest_id, "pair", pair_key, "member", recipient
    )


def _now(provider: Callable[[], datetime] | None) -> datetime:
    value = provider() if provider is not None else datetime.now(timezone.utc)
    if not isinstance(value, datetime):
        raise TypeError("now_provider must return datetime")
    return value
