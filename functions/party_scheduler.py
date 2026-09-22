"""One-minute social quest scheduling and shared Party content expiry.

P21 owns Firebase decorators and exports. The public functions here accept an
ignored scheduler event so they can be exported directly later.
"""

from collections.abc import Callable, Iterable, Mapping, Sequence
from datetime import datetime, timedelta, timezone
from random import Random
from typing import Any
from urllib.parse import quote

from firebase_admin import firestore
from firebase_functions import https_fn, logger
from google.cloud.firestore_v1.base_query import FieldFilter
from party_common import (
    callable_error,
    load_party_context,
    require_auth,
    require_command_id,
    require_object,
    require_string,
    run_idempotent_command,
)
from party_notifications import party_notification_data, send_notification_to_users
from party_quest_catalog import (
    EARLY_AVAILABILITY,
    FINAL_AVAILABILITY,
    QUEST_AVAILABILITIES,
    REGULAR_AVAILABILITY,
    TARGET_CLASS_PREFIX,
    validate_template_eligibility_rule,
)
from party_quest_eligibility import (
    QuestMember,
    build_eligibility_context,
    candidate_members,
    canonical_pair_key,
    is_eligible_pair,
)
from party_quests import (
    MAX_QUEST_DURATION_MINUTES,
    MAX_QUEST_INTERVAL_MINUTES,
    MAX_QUEST_POINTS_UNITS,
    MIN_QUEST_DURATION_MINUTES,
    MIN_QUEST_INTERVAL_MINUTES,
    MIN_QUEST_POINTS_UNITS,
)

MAX_SCHEDULER_BATCH_SIZE = 100
QUEST_CYCLE_STARTS = 18

TransactionRunnerFactory = Callable[
    [Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]
]
DocumentProvider = Callable[[Any, datetime], Iterable[Any]]
NotificationDispatcher = Callable[..., Any]


def party_quest_scheduler(_event: Any) -> Mapping[str, int]:
    return run_party_scheduler(firestore.client())


def start_next_party_quest(request: Any) -> Mapping[str, Any]:
    return start_next_party_quest_command(request, firestore.client())


def start_next_party_quest_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    random_source: Random | None = None,
    notification_dispatcher: NotificationDispatcher = send_notification_to_users,
    transaction_runner: Callable[
        [Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]
    ]
    | None = None,
    log: Any = logger,
) -> Mapping[str, Any]:
    actor_id = require_auth(request)
    data = require_object(getattr(request, "data", None))
    party_id = require_string(data, "sessionId", max_length=1_500)
    command_id = require_command_id(data)
    rng = random_source or Random()
    did_start = False

    def operation(transaction: Any) -> Mapping[str, Any]:
        nonlocal did_start
        did_start = False
        context = load_party_context(
            transaction, db, party_id, actor_id, require_admin=True
        )
        settings = context.party.get("moduleSettings")
        if (
            not isinstance(settings, Mapping)
            or settings.get("socialQuestsEnabled") is not True
        ):
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Social quests are disabled.",
            )
        if context.party.get("activeQuestId") is not None:
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "A social quest is already active.",
            )
        now = _now(now_provider)
        result = _attempt_quest_start(
            transaction,
            db,
            party_id,
            context.party,
            context.session,
            now,
            rng,
            quest_id=_manual_quest_id(command_id),
            advance_on_failure=False,
        )
        did_start = result.get("outcome") == "created"
        response = {
            "sessionId": party_id,
            "started": did_start,
            **{key: value for key, value in result.items() if key != "outcome"},
        }
        return response

    result = run_idempotent_command(
        db,
        party_id=party_id,
        command_id=command_id,
        command_name="start_next_party_quest",
        actor_user_id=actor_id,
        operation=operation,
        transaction_runner=transaction_runner,
    )
    log.info(
        "Manual Party quest start processed.",
        actorUserId=actor_id,
        **_outcome_log_fields(
            party_id, {**result, "outcome": "created" if did_start else "advanced"}
        ),
    )
    if did_start:
        notification_dispatcher(
            db,
            result["eligibleMemberIds"],
            actor_user_id=None,
            title=result["title"],
            body=result["instructions"],
            data=party_notification_data(
                "party_quest_started", party_id, source_id=result["questId"]
            ),
        )
    return result


def run_party_scheduler(
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    random_source: Random | None = None,
    due_party_provider: DocumentProvider | None = None,
    expired_quest_provider: DocumentProvider | None = None,
    expired_challenge_provider: DocumentProvider | None = None,
    notification_dispatcher: NotificationDispatcher = send_notification_to_users,
    transaction_runner_factory: Callable[
        [Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]
    ]
    | None = None,
    log: Any = logger,
) -> Mapping[str, int]:
    """Expire terminal content, then transactionally claim every due Party."""

    now = _now(now_provider)
    expired_quests = _expire_documents(
        db,
        now,
        "quests",
        "activeQuestId",
        expired_quest_provider or _expired_quest_documents,
        transaction_runner_factory,
        log,
    )
    expired_challenges = _expire_documents(
        db,
        now,
        "challenges",
        "activeChallengeId",
        expired_challenge_provider or _expired_challenge_documents,
        transaction_runner_factory,
        log,
    )
    due_documents = list((due_party_provider or _due_party_documents)(db, now))[
        :MAX_SCHEDULER_BATCH_SIZE
    ]
    created = 0
    advanced = 0
    skipped = 0
    failed = 0
    rng = random_source or Random()
    for party_snapshot in due_documents:
        party_id = _snapshot_id(party_snapshot)

        def claim(
            transaction: Any, claimed_party_id: str = party_id
        ) -> Mapping[str, Any]:
            return _claim_due_party(transaction, db, claimed_party_id, now, rng)

        try:
            result = _run_transaction(db, claim, transaction_runner_factory)
        except Exception as error:  # noqa: BLE001 - one bad Party must not stop the rest
            failed += 1
            log.error(
                "Party quest scheduler failed to process a due Party.",
                partyId=party_id,
                error=repr(error),
            )
            continue
        outcome = result.get("outcome")
        log.info(
            "Party quest scheduler processed a due Party.",
            **_outcome_log_fields(party_id, result),
        )
        if outcome == "created":
            created += 1
            notification_dispatcher(
                db,
                result["eligibleMemberIds"],
                actor_user_id=None,
                title=result["title"],
                body=result["instructions"],
                data=party_notification_data(
                    "party_quest_started", party_id, source_id=result["questId"]
                ),
            )
        elif outcome == "advanced":
            advanced += 1
        else:
            skipped += 1
    summary = {
        "createdQuests": created,
        "advancedParties": advanced,
        "skippedParties": skipped,
        "failedParties": failed,
        "expiredQuests": expired_quests,
        "expiredChallenges": expired_challenges,
    }
    log.info(
        "Party quest scheduler run completed.",
        dueParties=len(due_documents),
        **summary,
    )
    return summary


def _outcome_log_fields(party_id: str, result: Mapping[str, Any]) -> dict[str, Any]:
    """Pick the stable, non-sensitive parts of a quest start result for logs."""

    fields: dict[str, Any] = {"partyId": party_id, "outcome": result.get("outcome")}
    for key in ("reason", "templateId", "questId"):
        if result.get(key) is not None:
            fields[key] = result[key]
    eligible = result.get("eligibleMemberIds")
    if isinstance(eligible, Sequence) and not isinstance(eligible, (str, bytes)):
        fields["eligibleMemberCount"] = len(eligible)
    return fields


def _claim_due_party(
    transaction: Any,
    db: Any,
    party_id: str,
    now: datetime,
    random_source: Random,
) -> Mapping[str, Any]:
    party_ref = db.collection("parties").document(party_id)
    session_ref = db.collection("sessions").document(party_id)
    party_snapshot = party_ref.get(transaction=transaction)
    session_snapshot = session_ref.get(transaction=transaction)
    if not party_snapshot.exists or not session_snapshot.exists:
        return {"outcome": "skipped"}
    party = party_snapshot.to_dict() or {}
    session = session_snapshot.to_dict() or {}
    schedule = _stored_schedule(party)
    due_at = schedule["nextQuestAt"]
    settings = party.get("moduleSettings")
    if (
        party.get("status") != "active"
        or not isinstance(settings, Mapping)
        or settings.get("socialQuestsEnabled") is not True
        or not isinstance(due_at, datetime)
        or due_at > now
        or party.get("activeQuestId") is not None
    ):
        return {"outcome": "skipped"}

    return _attempt_quest_start(
        transaction,
        db,
        party_id,
        party,
        session,
        now,
        random_source,
        quest_id=_quest_id(due_at),
        advance_on_failure=True,
    )


def _attempt_quest_start(
    transaction: Any,
    db: Any,
    party_id: str,
    party: Mapping[str, Any],
    session: Mapping[str, Any],
    now: datetime,
    random_source: Random,
    *,
    quest_id: str,
    advance_on_failure: bool,
) -> Mapping[str, Any]:
    party_ref = db.collection("parties").document(party_id)
    schedule = _stored_schedule(party)
    enabled_templates = [
        (snapshot.id, snapshot.to_dict() or {})
        for snapshot in _transaction_collection(
            transaction, party_ref.collection("questTemplates")
        )
        if (snapshot.to_dict() or {}).get("enabled") is True
        and (snapshot.to_dict() or {}).get("source") == "builtIn"
    ]
    history = _stored_string_list(party, "questCycleHistory")
    if len(history) >= QUEST_CYCLE_STARTS:
        raise ValueError("Stored Party questCycleHistory is invalid")
    unlocked_availabilities = _unlocked_availabilities(len(history) + 1)
    templates = [
        (template_id, template)
        for template_id, template in enabled_templates
        if _stored_availability(template) in unlocked_availabilities
    ]
    if not templates:
        if advance_on_failure:
            _advance_schedule(transaction, party_ref, schedule, now, random_source)
        return {"outcome": "advanced", "reason": "noEnabledTemplates"}

    unused_templates = [item for item in templates if item[0] not in history]
    template_id, template = random_source.choice(unused_templates or templates)
    source = _stored_text(template, "source")
    rule = _stored_text(template, "eligibilityRule")
    try:
        validate_template_eligibility_rule(source, rule)
    except ValueError as error:
        raise ValueError("Stored quest template eligibility is invalid") from error
    members = _load_members(transaction, db, party_ref, session)
    completed_history = _completed_history(transaction, party_ref)
    finalist_team_ids = _stored_optional_strings(party, "finalistTeamIds")
    candidates = candidate_members(members)
    context = build_eligibility_context(
        candidates,
        completed_pair_keys=completed_history,
        finalist_team_ids=finalist_team_ids,
    )
    pair_keys = sorted(
        canonical_pair_key(first.user_id, second.user_id)
        for index, first in enumerate(candidates)
        for second in candidates[index + 1 :]
        if is_eligible_pair(rule, first, second, context)
    )
    eligible_ids = sorted(
        {
            member.user_id
            for member in candidates
            if any(
                canonical_pair_key(member.user_id, other.user_id) in pair_keys
                for other in candidates
                if other.user_id != member.user_id
            )
        }
    )
    target_class = (
        rule.removeprefix(TARGET_CLASS_PREFIX)
        if rule.startswith(TARGET_CLASS_PREFIX)
        else None
    )
    target_class_member_ids = (
        sorted(
            member.user_id
            for member in candidates
            if member.selected_class == target_class
        )
        if target_class is not None
        else []
    )
    if len(eligible_ids) < 2:
        if advance_on_failure:
            _advance_schedule(
                transaction,
                party_ref,
                schedule,
                now,
                random_source,
                quest_cycle_history=_next_cycle_history(history, template_id),
            )
        return {
            "outcome": "advanced",
            "reason": "insufficientEligibility",
            "templateId": template_id,
        }

    duration = template.get("durationMinutes")
    if duration is None:
        duration = schedule["defaultDurationMinutes"]
    if (
        isinstance(duration, bool)
        or not isinstance(duration, int)
        or not MIN_QUEST_DURATION_MINUTES <= duration <= MAX_QUEST_DURATION_MINUTES
    ):
        raise ValueError("Stored quest template duration is invalid")
    points = template.get("pointsUnits")
    if (
        isinstance(points, bool)
        or not isinstance(points, int)
        or not MIN_QUEST_POINTS_UNITS <= points <= MAX_QUEST_POINTS_UNITS
    ):
        raise ValueError("Stored quest template points are invalid")
    title = _stored_text(template, "title")
    instructions = _stored_text(template, "instructions")
    quest_ref = party_ref.collection("quests").document(quest_id)
    if quest_ref.get(transaction=transaction).exists:
        return {"outcome": "skipped"}
    ends_at = now + timedelta(minutes=duration)
    transaction.create(
        quest_ref,
        {
            "templateId": template_id,
            "titleSnapshot": title,
            "instructionsSnapshot": instructions,
            "eligibilityRuleSnapshot": rule,
            "targetClassMemberIds": target_class_member_ids,
            "pointsUnits": points,
            "startsAt": now,
            "endsAt": ends_at,
            "status": "active",
            "eligibleMemberIds": eligible_ids,
            "eligiblePairKeys": pair_keys,
            "completedPairKeys": [],
            "createdAt": firestore.SERVER_TIMESTAMP,
        },
    )
    transaction.update(
        party_ref,
        {
            "activeQuestId": quest_id,
            "questCycleHistory": _next_cycle_history(history, template_id),
            "questSchedule": _next_schedule(schedule, now, random_source),
            "updatedAt": firestore.SERVER_TIMESTAMP,
        },
    )
    return {
        "outcome": "created",
        "questId": quest_id,
        "templateId": template_id,
        "eligibleMemberIds": eligible_ids,
        "title": title,
        "instructions": instructions,
    }


def _advance_schedule(
    transaction: Any,
    party_ref: Any,
    schedule: Mapping[str, Any],
    now: datetime,
    random_source: Random,
    *,
    quest_cycle_history: Sequence[str] | None = None,
) -> None:
    updates: dict[str, Any] = {
        "questSchedule": _next_schedule(schedule, now, random_source),
        "updatedAt": firestore.SERVER_TIMESTAMP,
    }
    if quest_cycle_history is not None:
        updates["questCycleHistory"] = list(quest_cycle_history)
    transaction.update(
        party_ref,
        updates,
    )


def _next_schedule(
    schedule: Mapping[str, Any], now: datetime, random_source: Random
) -> dict[str, Any]:
    interval = random_source.randint(
        schedule["minIntervalMinutes"], schedule["maxIntervalMinutes"]
    )
    return {**schedule, "nextQuestAt": now + timedelta(minutes=interval)}


def _expire_documents(
    db: Any,
    now: datetime,
    collection_name: str,
    active_field: str,
    provider: DocumentProvider,
    runner: Callable[[Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]] | None,
    log: Any = logger,
) -> int:
    expired = 0
    documents = list(provider(db, now))[:MAX_SCHEDULER_BATCH_SIZE]
    for snapshot in documents:
        reference = snapshot.reference
        party_ref = reference.parent.parent
        if party_ref is None:
            continue

        content_id = snapshot.id

        def expire(
            transaction: Any,
            content_ref: Any = reference,
            root_ref: Any = party_ref,
            claimed_content_id: str = content_id,
        ) -> Mapping[str, Any]:
            content_snapshot = content_ref.get(transaction=transaction)
            party_snapshot = root_ref.get(transaction=transaction)
            if not content_snapshot.exists or not party_snapshot.exists:
                return {"expired": False}
            content = content_snapshot.to_dict() or {}
            party = party_snapshot.to_dict() or {}
            ends_at = content.get("endsAt")
            if (
                content.get("status") != "active"
                or not isinstance(ends_at, datetime)
                or ends_at > now
            ):
                return {"expired": False}
            transaction.update(
                content_ref,
                {"status": "expired", "updatedAt": firestore.SERVER_TIMESTAMP},
            )
            party_update: dict[str, Any] = {"updatedAt": firestore.SERVER_TIMESTAMP}
            if party.get(active_field) == claimed_content_id:
                party_update[active_field] = None
            transaction.update(root_ref, party_update)
            return {"expired": True}

        try:
            result = _run_transaction(db, expire, runner)
        except Exception as error:  # noqa: BLE001 - keep expiring the rest
            log.error(
                "Party content expiry failed.",
                partyId=party_ref.path.rsplit("/", 1)[-1],
                collection=collection_name,
                contentId=content_id,
                error=repr(error),
            )
            continue
        if result.get("expired") is True:
            expired += 1
            log.info(
                "Party content expired.",
                partyId=party_ref.path.rsplit("/", 1)[-1],
                collection=collection_name,
                contentId=content_id,
            )
    return expired


def _load_members(
    transaction: Any,
    db: Any,
    party_ref: Any,
    session: Mapping[str, Any],
) -> list[QuestMember]:
    member_ids = _stored_strings(session, "memberIds")
    members: list[QuestMember] = []
    for user_id in member_ids:
        member_snapshot = (
            party_ref.collection("members")
            .document(user_id)
            .get(transaction=transaction)
        )
        user_snapshot = db.collection("users").document(user_id).get(
            transaction=transaction
        )
        if not member_snapshot.exists:
            continue
        member = member_snapshot.to_dict() or {}
        user = user_snapshot.to_dict() or {} if user_snapshot.exists else {}
        username = user.get("username", user_id)
        if not isinstance(username, str) or not username:
            username = user_id
        score = member.get("scoreUnits", 0)
        if isinstance(score, bool) or not isinstance(score, int):
            raise TypeError("Stored Party member scoreUnits is invalid")
        selected_class = member.get("selectedClass")
        accent = user.get("accentColorKey")
        team_id = member.get("beerpongTeamId")
        members.append(
            QuestMember(
                user_id=user_id,
                username=username,
                score_units=score,
                is_active=member.get("isActive") is True,
                selected_class=(
                    selected_class if isinstance(selected_class, str) else None
                ),
                accent_color_key=accent if isinstance(accent, str) else None,
                beerpong_team_id=team_id if isinstance(team_id, str) else None,
            )
        )
    return members


def _completed_history(transaction: Any, party_ref: Any) -> set[str]:
    completed: set[str] = set()
    for snapshot in _transaction_collection(
        transaction, party_ref.collection("events")
    ):
        event = snapshot.to_dict() or {}
        participants = event.get("participantIds")
        if (
            event.get("kind") == "socialQuest"
            and isinstance(participants, Sequence)
            and not isinstance(participants, (str, bytes))
            and len(participants) == 2
            and all(isinstance(item, str) and item for item in participants)
        ):
            completed.add(canonical_pair_key(participants[0], participants[1]))
    return completed


def _stored_schedule(party: Mapping[str, Any]) -> dict[str, Any]:
    schedule = party.get("questSchedule")
    if not isinstance(schedule, Mapping):
        raise TypeError("Stored Party questSchedule is invalid")
    minimum = schedule.get("minIntervalMinutes")
    maximum = schedule.get("maxIntervalMinutes")
    duration = schedule.get("defaultDurationMinutes")
    if (
        isinstance(minimum, bool)
        or not isinstance(minimum, int)
        or not MIN_QUEST_INTERVAL_MINUTES <= minimum <= MAX_QUEST_INTERVAL_MINUTES
        or isinstance(maximum, bool)
        or not isinstance(maximum, int)
        or not MIN_QUEST_INTERVAL_MINUTES <= maximum <= MAX_QUEST_INTERVAL_MINUTES
        or minimum > maximum
        or isinstance(duration, bool)
        or not isinstance(duration, int)
        or not MIN_QUEST_DURATION_MINUTES <= duration <= MAX_QUEST_DURATION_MINUTES
    ):
        raise ValueError("Stored Party questSchedule bounds are invalid")
    return {
        "minIntervalMinutes": minimum,
        "maxIntervalMinutes": maximum,
        "defaultDurationMinutes": duration,
        "nextQuestAt": schedule.get("nextQuestAt"),
    }


def _stored_text(document: Mapping[str, Any], field: str) -> str:
    value = document.get(field)
    if not isinstance(value, str) or not value:
        raise ValueError(f"Stored {field} is invalid")
    return value


def _stored_strings(document: Mapping[str, Any], field: str) -> list[str]:
    return list(dict.fromkeys(_stored_string_list(document, field)))


def _stored_string_list(document: Mapping[str, Any], field: str) -> list[str]:
    value = document.get(field, [])
    if (
        not isinstance(value, Sequence)
        or isinstance(value, (str, bytes))
        or any(not isinstance(item, str) or not item for item in value)
    ):
        raise ValueError(f"Stored {field} is invalid")
    return list(value)


def _stored_optional_strings(document: Mapping[str, Any], field: str) -> set[str]:
    if field not in document:
        return set()
    return set(_stored_strings(document, field))


def _stored_availability(template: Mapping[str, Any]) -> str:
    availability = _stored_text(template, "availability")
    if availability not in QUEST_AVAILABILITIES:
        raise ValueError("Stored quest template availability is invalid")
    return availability


def _unlocked_availabilities(start_number: int) -> frozenset[str]:
    if start_number <= 5:
        return frozenset({EARLY_AVAILABILITY})
    if start_number <= 10:
        return frozenset({EARLY_AVAILABILITY, REGULAR_AVAILABILITY})
    return frozenset({EARLY_AVAILABILITY, REGULAR_AVAILABILITY, FINAL_AVAILABILITY})


def _next_cycle_history(history: Sequence[str], template_id: str) -> list[str]:
    next_history = [*history, template_id]
    return [] if len(next_history) == QUEST_CYCLE_STARTS else next_history


def _transaction_collection(transaction: Any, collection: Any) -> list[Any]:
    return list(collection.stream(transaction=transaction))


def _quest_id(due_at: datetime) -> str:
    timestamp = due_at.astimezone(timezone.utc).isoformat(timespec="microseconds")
    return f"scheduled-{quote(timestamp, safe='-_.~')}"


def _manual_quest_id(command_id: str) -> str:
    return f"manual-{quote(command_id, safe='-_.~')}"


def _snapshot_id(snapshot: Any) -> str:
    value = getattr(snapshot, "id", None)
    if not isinstance(value, str) or not value:
        raise ValueError("Scheduler document snapshot has no ID")
    return value


def _run_transaction(
    db: Any,
    operation: Callable[[Any], Mapping[str, Any]],
    runner: Callable[[Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]] | None,
) -> Mapping[str, Any]:
    if runner is not None:
        return runner(operation)
    return firestore.transactional(operation)(db.transaction())


def _due_party_documents(db: Any, now: datetime) -> Iterable[Any]:
    return (
        db.collection("parties")
        .where(filter=FieldFilter("status", "==", "active"))
        .where(filter=FieldFilter("moduleSettings.socialQuestsEnabled", "==", True))
        .where(filter=FieldFilter("questSchedule.nextQuestAt", "<=", now))
        .limit(MAX_SCHEDULER_BATCH_SIZE)
        .stream()
    )


def _expired_quest_documents(db: Any, now: datetime) -> Iterable[Any]:
    return _expired_documents(db, "quests", now)


def _expired_challenge_documents(db: Any, now: datetime) -> Iterable[Any]:
    return _expired_documents(db, "challenges", now)


def _expired_documents(db: Any, collection: str, now: datetime) -> Iterable[Any]:
    return (
        db.collection_group(collection)
        .where(filter=FieldFilter("status", "==", "active"))
        .where(filter=FieldFilter("endsAt", "<=", now))
        .limit(MAX_SCHEDULER_BATCH_SIZE)
        .stream()
    )


def _now(provider: Callable[[], datetime] | None) -> datetime:
    value = provider() if provider is not None else datetime.now(timezone.utc)
    if not isinstance(value, datetime):
        raise TypeError("now_provider must return datetime")
    return value
