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
from google.cloud.firestore_v1.base_query import FieldFilter
from party_notifications import party_notification_data, send_notification_to_users
from party_quest_catalog import validate_template_eligibility_rule
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

TransactionRunnerFactory = Callable[
    [Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]
]
DocumentProvider = Callable[[Any, datetime], Iterable[Any]]
NotificationDispatcher = Callable[..., Any]


def party_quest_scheduler(_event: Any) -> Mapping[str, int]:
    return run_party_scheduler(firestore.client())


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
    )
    expired_challenges = _expire_documents(
        db,
        now,
        "challenges",
        "activeChallengeId",
        expired_challenge_provider or _expired_challenge_documents,
        transaction_runner_factory,
    )
    due_documents = list((due_party_provider or _due_party_documents)(db, now))[
        :MAX_SCHEDULER_BATCH_SIZE
    ]
    created = 0
    advanced = 0
    skipped = 0
    rng = random_source or Random()
    for party_snapshot in due_documents:
        party_id = _snapshot_id(party_snapshot)

        def claim(
            transaction: Any, claimed_party_id: str = party_id
        ) -> Mapping[str, Any]:
            return _claim_due_party(transaction, db, claimed_party_id, now, rng)

        result = _run_transaction(db, claim, transaction_runner_factory)
        outcome = result.get("outcome")
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
    return {
        "createdQuests": created,
        "advancedParties": advanced,
        "skippedParties": skipped,
        "expiredQuests": expired_quests,
        "expiredChallenges": expired_challenges,
    }


def _claim_due_party(
    transaction: Any,
    db: Any,
    party_id: str,
    now: datetime,
    random_source: Random,
) -> Mapping[str, Any]:
    party_ref = db.collection("parties").document(party_id)
    session_ref = db.collection("sessions").document(party_id)
    party_snapshot = transaction.get(party_ref)
    session_snapshot = transaction.get(session_ref)
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

    templates = [
        (snapshot.id, snapshot.to_dict() or {})
        for snapshot in _transaction_collection(
            transaction, party_ref.collection("questTemplates")
        )
        if (snapshot.to_dict() or {}).get("enabled") is True
    ]
    interval = random_source.randint(
        schedule["minIntervalMinutes"], schedule["maxIntervalMinutes"]
    )
    next_quest_at = now + timedelta(minutes=interval)
    updated_schedule = {**schedule, "nextQuestAt": next_quest_at}
    if not templates:
        transaction.update(
            party_ref,
            {
                "questSchedule": updated_schedule,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        return {"outcome": "advanced", "reason": "noEnabledTemplates"}

    template_id, template = random_source.choice(templates)
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
    if len(eligible_ids) < 2:
        transaction.update(
            party_ref,
            {
                "questSchedule": updated_schedule,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        return {"outcome": "advanced", "reason": "insufficientEligibility"}

    duration = template.get("durationMinutes", schedule["defaultDurationMinutes"])
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
    quest_id = _quest_id(due_at)
    quest_ref = party_ref.collection("quests").document(quest_id)
    if transaction.get(quest_ref).exists:
        return {"outcome": "skipped"}
    ends_at = now + timedelta(minutes=duration)
    transaction.create(
        quest_ref,
        {
            "templateId": template_id,
            "titleSnapshot": title,
            "instructionsSnapshot": instructions,
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
            "questSchedule": updated_schedule,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        },
    )
    return {
        "outcome": "created",
        "questId": quest_id,
        "eligibleMemberIds": eligible_ids,
        "title": title,
        "instructions": instructions,
    }


def _expire_documents(
    db: Any,
    now: datetime,
    collection_name: str,
    active_field: str,
    provider: DocumentProvider,
    runner: Callable[[Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]] | None,
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
            content_snapshot = transaction.get(content_ref)
            party_snapshot = transaction.get(root_ref)
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

        result = _run_transaction(db, expire, runner)
        if result.get("expired") is True:
            expired += 1
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
        member_snapshot = transaction.get(
            party_ref.collection("members").document(user_id)
        )
        user_snapshot = transaction.get(db.collection("users").document(user_id))
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
    value = document.get(field, [])
    if (
        not isinstance(value, Sequence)
        or isinstance(value, (str, bytes))
        or any(not isinstance(item, str) or not item for item in value)
    ):
        raise ValueError(f"Stored {field} is invalid")
    return list(dict.fromkeys(value))


def _stored_optional_strings(document: Mapping[str, Any], field: str) -> set[str]:
    if field not in document:
        return set()
    return set(_stored_strings(document, field))


def _transaction_collection(transaction: Any, collection: Any) -> list[Any]:
    return list(transaction.get(collection))


def _quest_id(due_at: datetime) -> str:
    timestamp = due_at.astimezone(timezone.utc).isoformat(timespec="microseconds")
    return f"scheduled-{quote(timestamp, safe='-_.~')}"


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
