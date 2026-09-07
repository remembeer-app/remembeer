"""Integer Party scoring and immutable transactional score-event primitives."""

from collections.abc import Mapping, Sequence
from dataclasses import dataclass
from decimal import ROUND_HALF_UP, Decimal, InvalidOperation
from typing import Any
from urllib.parse import quote

from firebase_admin import firestore
from firebase_functions import https_fn
from party_common import callable_error

SCORE_UNITS_PER_POINT = 1_000
CLASS_BONUS_PERCENT = 10
_AWARD_KINDS = {
    "drink",
    "socialQuest",
    "adminChallenge",
    "beerpongPlacement",
}


@dataclass(frozen=True)
class DrinkScore:
    alcohol_ml: Decimal
    base_units: int
    class_bonus_units: int
    awarded_units: int
    applied_multiplier: Decimal


@dataclass(frozen=True)
class EventWriteResult:
    event_id: str
    event: Mapping[str, Any]
    created: bool


@dataclass(frozen=True)
class AwardInput:
    """One award to apply through :func:`create_awards`."""

    event_id: str
    kind: str
    recipient_user_id: str
    participant_ids: Sequence[str]
    points_units: int
    source_collection: str
    source_id: str
    occurred_at: Any
    actor_user_id: str | None = None
    payload: Mapping[str, Any] | None = None
    drink_count_delta: int | None = None


@dataclass(frozen=True)
class ReversalInput:
    award_event_id: str
    occurred_at: Any
    actor_user_id: str | None = None
    reason: str | None = None


def calculate_drink_score(
    volume_ml: float | Decimal,
    alcohol_percentage: float | Decimal,
    *,
    drink_category: str,
    selected_class: str | None,
) -> DrinkScore:
    """Calculate score units with decimal half-up rounding at each plan step."""

    volume = _positive_decimal(volume_ml, "volume_ml")
    percentage = _positive_decimal(alcohol_percentage, "alcohol_percentage")
    if percentage > 100:
        raise ValueError("alcohol_percentage must not exceed 100")
    if not drink_category:
        raise ValueError("drink_category must not be empty")

    alcohol_ml = volume * percentage / Decimal(100)
    base_units = _round_units(alcohol_ml * SCORE_UNITS_PER_POINT)
    is_matching_class = selected_class == drink_category
    class_bonus_units = (
        _round_units(Decimal(base_units) * CLASS_BONUS_PERCENT / 100)
        if is_matching_class
        else 0
    )
    return DrinkScore(
        alcohol_ml=alcohol_ml,
        base_units=base_units,
        class_bonus_units=class_bonus_units,
        awarded_units=base_units + class_bonus_units,
        applied_multiplier=Decimal("1.1") if is_matching_class else Decimal(1),
    )


def canonical_pair_key(first_user_id: str, second_user_id: str) -> str:
    """Return a collision-safe, order-independent key for a mutual pair."""

    if not first_user_id or not second_user_id:
        raise ValueError("Pair user IDs must not be empty")
    if first_user_id == second_user_id:
        raise ValueError("A mutual pair requires two different users")
    first, second = sorted((first_user_id, second_user_id))
    return f"pair:{_id_part(first)}:{_id_part(second)}"


def deterministic_event_id(*parts: str) -> str:
    """Build a stable Firestore-safe ID from semantic source components.

    Example: ``deterministic_event_id('challenge', challenge_id, 'winner', uid)``.
    """

    if not parts or any(not part for part in parts):
        raise ValueError("Event ID parts must not be empty")
    return ":".join(_id_part(part) for part in parts)


def reversal_event_id(award_event_id: str) -> str:
    return deterministic_event_id("reversal", award_event_id)


def create_award(
    transaction: Any,
    party_ref: Any,
    *,
    event_id: str,
    kind: str,
    recipient_user_id: str,
    participant_ids: Sequence[str],
    points_units: int,
    source_collection: str,
    source_id: str,
    occurred_at: Any,
    actor_user_id: str | None = None,
    payload: Mapping[str, Any] | None = None,
    drink_count_delta: int | None = None,
) -> EventWriteResult:
    """Create one immutable award and update its member in ``transaction``.

    A semantically identical deterministic event is a no-op. Reusing an event ID
    for different content fails, preventing an unnoticed idempotency collision.
    """

    return create_awards(
        transaction,
        party_ref,
        [
            AwardInput(
                event_id=event_id,
                kind=kind,
                recipient_user_id=recipient_user_id,
                participant_ids=participant_ids,
                points_units=points_units,
                source_collection=source_collection,
                source_id=source_id,
                occurred_at=occurred_at,
                actor_user_id=actor_user_id,
                payload=payload,
                drink_count_delta=drink_count_delta,
            )
        ],
    )[0]


def create_awards(
    transaction: Any,
    party_ref: Any,
    awards: Sequence[AwardInput],
) -> list[EventWriteResult]:
    """Create multiple awards after performing every Firestore read first.

    Use this for activation and multi-recipient outcomes. Firestore transactions
    reject reads after writes, so callers must not combine this with another
    primitive that has already queued writes.
    """

    if len({award.event_id for award in awards}) != len(awards):
        raise ValueError("Award event IDs must be unique within a batch")

    prepared: list[tuple[AwardInput, Any, Any, Mapping[str, Any], int]] = []
    member_refs: dict[str, Any] = {}
    member_snapshots: dict[str, Any] = {}
    for award in awards:
        count_delta = _validate_award(award)
        event_ref = party_ref.collection("events").document(award.event_id)
        event_snapshot = transaction.get(event_ref)
        event = _award_event(award)
        prepared.append((award, event_ref, event_snapshot, event, count_delta))
        if award.recipient_user_id not in member_refs:
            member_ref = party_ref.collection("members").document(
                award.recipient_user_id
            )
            member_refs[award.recipient_user_id] = member_ref
            member_snapshots[award.recipient_user_id] = transaction.get(member_ref)

    results: list[EventWriteResult] = []
    score_deltas: dict[str, int] = {}
    drink_deltas: dict[str, int] = {}
    for award, event_ref, event_snapshot, event, count_delta in prepared:
        if event_snapshot.exists:
            existing = event_snapshot.to_dict() or {}
            if not _same_event(existing, event):
                raise callable_error(
                    https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                    "Score event ID already exists with different content.",
                )
            results.append(EventWriteResult(award.event_id, existing, False))
            continue
        if not member_snapshots[award.recipient_user_id].exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.NOT_FOUND,
                "Party member was not found.",
            )
        transaction.create(event_ref, event)
        score_deltas[award.recipient_user_id] = (
            score_deltas.get(award.recipient_user_id, 0) + award.points_units
        )
        drink_deltas[award.recipient_user_id] = (
            drink_deltas.get(award.recipient_user_id, 0) + count_delta
        )
        results.append(EventWriteResult(award.event_id, event, True))

    for recipient_user_id, score_delta in score_deltas.items():
        member = member_snapshots[recipient_user_id].to_dict() or {}
        transaction.update(
            member_refs[recipient_user_id],
            {
                "scoreUnits": _stored_int(member, "scoreUnits") + score_delta,
                "drinkCount": _stored_int(member, "drinkCount")
                + drink_deltas[recipient_user_id],
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
    return results


def _validate_award(award: AwardInput) -> int:
    if award.kind not in _AWARD_KINDS:
        raise ValueError(f"Unsupported award kind: {award.kind}")
    if isinstance(award.points_units, bool) or not isinstance(award.points_units, int):
        raise TypeError("points_units must be an integer")
    if award.points_units <= 0:
        raise ValueError("Award points_units must be positive")
    count_delta = (
        (1 if award.kind == "drink" else 0)
        if award.drink_count_delta is None
        else award.drink_count_delta
    )
    if count_delta < 0:
        raise ValueError("Award drink_count_delta must not be negative")
    return count_delta


def _award_event(award: AwardInput) -> Mapping[str, Any]:
    return {
        "kind": award.kind,
        "recipientUserId": award.recipient_user_id,
        "participantIds": list(dict.fromkeys(award.participant_ids)),
        "pointsUnits": award.points_units,
        "sourceCollection": award.source_collection,
        "sourceId": award.source_id,
        "reversesEventId": None,
        "actorUserId": award.actor_user_id,
        "occurredAt": award.occurred_at,
        "createdAt": firestore.SERVER_TIMESTAMP,
        "payload": dict(award.payload or {}),
    }


def create_reversal(
    transaction: Any,
    party_ref: Any,
    *,
    award_event_id: str,
    occurred_at: Any,
    actor_user_id: str | None = None,
    reason: str | None = None,
) -> EventWriteResult:
    """Create the sole immutable exact negation of an existing award."""

    return create_reversals(
        transaction,
        party_ref,
        [
            ReversalInput(
                award_event_id=award_event_id,
                occurred_at=occurred_at,
                actor_user_id=actor_user_id,
                reason=reason,
            )
        ],
    )[0]


def create_reversals(
    transaction: Any,
    party_ref: Any,
    reversals: Sequence[ReversalInput],
) -> list[EventWriteResult]:
    """Reverse multiple awards after performing every Firestore read first."""

    award_ids = [item.award_event_id for item in reversals]
    if len(set(award_ids)) != len(award_ids):
        raise ValueError("Reversal award event IDs must be unique within a batch")

    prepared: list[tuple[ReversalInput, Any, Any, Mapping[str, Any], str, int]] = []
    member_refs: dict[str, Any] = {}
    member_snapshots: dict[str, Any] = {}
    for item in reversals:
        award_ref = party_ref.collection("events").document(item.award_event_id)
        reverse_id = reversal_event_id(item.award_event_id)
        reversal_ref = party_ref.collection("events").document(reverse_id)
        award_snapshot = transaction.get(award_ref)
        reversal_snapshot = transaction.get(reversal_ref)
        if not award_snapshot.exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.NOT_FOUND,
                "Award event was not found.",
            )
        award = award_snapshot.to_dict() or {}
        if award.get("kind") == "reversal" or award.get("reversesEventId") is not None:
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Only award events can be reversed.",
            )
        points_units = _stored_int(award, "pointsUnits")
        if points_units <= 0:
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Only positive award events can be reversed.",
            )
        recipient_user_id = award.get("recipientUserId")
        if not isinstance(recipient_user_id, str) or not recipient_user_id:
            raise ValueError("Stored award recipientUserId is invalid")
        if recipient_user_id not in member_refs:
            member_ref = party_ref.collection("members").document(recipient_user_id)
            member_refs[recipient_user_id] = member_ref
            member_snapshots[recipient_user_id] = transaction.get(member_ref)
        payload = {"reversedKind": award.get("kind")}
        if item.reason is not None:
            payload["reason"] = item.reason
        reversal = {
            "kind": "reversal",
            "recipientUserId": recipient_user_id,
            "participantIds": list(award.get("participantIds", [])),
            "pointsUnits": -points_units,
            "sourceCollection": award.get("sourceCollection"),
            "sourceId": award.get("sourceId"),
            "reversesEventId": item.award_event_id,
            "actorUserId": item.actor_user_id,
            "occurredAt": item.occurred_at,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "payload": payload,
        }
        prepared.append(
            (
                item,
                reversal_ref,
                reversal_snapshot,
                reversal,
                recipient_user_id,
                points_units,
            )
        )

    results: list[EventWriteResult] = []
    score_deltas: dict[str, int] = {}
    drink_deltas: dict[str, int] = {}
    pending_creates: list[tuple[Any, Mapping[str, Any]]] = []
    immutable_fields = (
        "kind",
        "recipientUserId",
        "participantIds",
        "pointsUnits",
        "sourceCollection",
        "sourceId",
        "reversesEventId",
    )
    for item, reversal_ref, snapshot, reversal, recipient_id, points_units in prepared:
        if snapshot.exists:
            existing = snapshot.to_dict() or {}
            if any(
                existing.get(field) != reversal.get(field) for field in immutable_fields
            ):
                raise callable_error(
                    https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                    "Reversal event ID already exists with different content.",
                )
            results.append(
                EventWriteResult(reversal_ref.path.rsplit("/", 1)[-1], existing, False)
            )
            continue
        pending_creates.append((reversal_ref, reversal))
        score_deltas[recipient_id] = score_deltas.get(recipient_id, 0) - points_units
        drink_deltas[recipient_id] = drink_deltas.get(recipient_id, 0) - (
            1 if reversal["payload"]["reversedKind"] == "drink" else 0
        )
        results.append(
            EventWriteResult(reversal_ref.path.rsplit("/", 1)[-1], reversal, True)
        )

    member_updates: list[tuple[str, int, int]] = []
    for recipient_id, score_delta in score_deltas.items():
        if not member_snapshots[recipient_id].exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.NOT_FOUND,
                "Party member was not found.",
            )
        member = member_snapshots[recipient_id].to_dict() or {}
        drink_count = _stored_int(member, "drinkCount") + drink_deltas[recipient_id]
        if drink_count < 0:
            raise ValueError("Stored Party member drinkCount would become negative")
        member_updates.append((recipient_id, score_delta, drink_count))

    for reversal_ref, reversal in pending_creates:
        transaction.create(reversal_ref, reversal)
    for recipient_id, score_delta, drink_count in member_updates:
        member = member_snapshots[recipient_id].to_dict() or {}
        transaction.update(
            member_refs[recipient_id],
            {
                "scoreUnits": _stored_int(member, "scoreUnits") + score_delta,
                "drinkCount": drink_count,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
    return results


def _positive_decimal(value: float | Decimal, name: str) -> Decimal:
    try:
        result = Decimal(str(value))
    except (InvalidOperation, ValueError) as error:
        raise ValueError(f"{name} must be numeric") from error
    if not result.is_finite() or result <= 0:
        raise ValueError(f"{name} must be finite and positive")
    return result


def _round_units(value: Decimal) -> int:
    return int(value.quantize(Decimal(1), rounding=ROUND_HALF_UP))


def _id_part(value: str) -> str:
    return quote(value, safe="-_.~")


def _stored_int(document: Mapping[str, Any], field_name: str) -> int:
    value = document.get(field_name, 0)
    if isinstance(value, bool) or not isinstance(value, int):
        raise TypeError(f"Stored {field_name} must be an integer")
    return value


def _same_event(existing: Mapping[str, Any], expected: Mapping[str, Any]) -> bool:
    immutable_fields = (
        "kind",
        "recipientUserId",
        "participantIds",
        "pointsUnits",
        "sourceCollection",
        "sourceId",
        "reversesEventId",
        "actorUserId",
        "occurredAt",
        "payload",
    )
    return all(existing.get(field) == expected.get(field) for field in immutable_fields)
