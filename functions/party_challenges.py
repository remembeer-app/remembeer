"""Transactional admin challenge commands and scheduler-facing expiry.

Handlers are intentionally undecorated for P21 to export. Notifications are
dispatched only after authoritative state commits and are therefore best-effort.
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
from party_notifications import send_notification_to_users
from party_scoring import (
    SCORE_UNITS_PER_POINT,
    create_award,
    create_reversal,
    deterministic_event_id,
)

MIN_CHALLENGE_DURATION_MINUTES = 1
MAX_CHALLENGE_DURATION_MINUTES = 60
MIN_CHALLENGE_POINTS_UNITS = SCORE_UNITS_PER_POINT
MAX_CHALLENGE_POINTS_UNITS = 500 * SCORE_UNITS_PER_POINT
MAX_CHALLENGE_TITLE_LENGTH = 120
MAX_CHALLENGE_INSTRUCTIONS_LENGTH = 1_000

TransactionRunner = Callable[[Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]]
NotificationDispatcher = Callable[..., Any]


def set_party_module_settings(request: Any) -> Mapping[str, Any]:
    return set_party_module_settings_command(request, firestore.client())


def create_admin_challenge(request: Any) -> Mapping[str, Any]:
    return create_admin_challenge_command(request, firestore.client())


def award_admin_challenge_winner(request: Any) -> Mapping[str, Any]:
    return award_admin_challenge_winner_command(request, firestore.client())


def complete_admin_challenge(request: Any) -> Mapping[str, Any]:
    return complete_admin_challenge_command(request, firestore.client())


def cancel_admin_challenge(request: Any) -> Mapping[str, Any]:
    return cancel_admin_challenge_command(request, firestore.client())


def reverse_admin_challenge_winner(request: Any) -> Mapping[str, Any]:
    return reverse_admin_challenge_winner_command(request, firestore.client())


def set_party_module_settings_command(
    request: Any,
    db: Any,
    *,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_user_id, data, session_id, command_id = _command_input(request)
    settings_data = require_object(data.get("moduleSettings"), "moduleSettings")
    settings = {
        "socialQuestsEnabled": require_bool(settings_data, "socialQuestsEnabled"),
        "adminChallengesEnabled": require_bool(settings_data, "adminChallengesEnabled"),
        "beerpongEnabled": require_bool(settings_data, "beerpongEnabled"),
    }

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(
            transaction, db, session_id, actor_user_id, require_admin=True
        )
        if (
            not settings["adminChallengesEnabled"]
            and context.party.get("activeChallengeId") is not None
        ):
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "The active challenge must be completed or cancelled first.",
            )
        transaction.update(
            db.collection("parties").document(session_id),
            {"moduleSettings": settings, "updatedAt": firestore.SERVER_TIMESTAMP},
        )
        return {"sessionId": session_id, "moduleSettings": settings}

    return _run_command(
        db,
        session_id,
        command_id,
        "set_party_module_settings",
        actor_user_id,
        operation,
        transaction_runner,
    )


def create_admin_challenge_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    notification_dispatcher: NotificationDispatcher = send_notification_to_users,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_user_id, data, session_id, command_id = _command_input(request)
    challenge_id = _document_id(data, "challengeId")
    title = require_string(data, "title", max_length=MAX_CHALLENGE_TITLE_LENGTH)
    instructions = require_string(
        data, "instructions", max_length=MAX_CHALLENGE_INSTRUCTIONS_LENGTH
    )
    points_units = require_int(
        data,
        "pointsUnits",
        minimum=MIN_CHALLENGE_POINTS_UNITS,
        maximum=MAX_CHALLENGE_POINTS_UNITS,
    )
    duration_minutes = require_int(
        data,
        "durationMinutes",
        minimum=MIN_CHALLENGE_DURATION_MINUTES,
        maximum=MAX_CHALLENGE_DURATION_MINUTES,
    )
    did_create = False
    recipients: Sequence[str] = ()

    def operation(transaction: Any) -> Mapping[str, Any]:
        nonlocal did_create, recipients
        context = load_party_context(
            transaction, db, session_id, actor_user_id, require_admin=True
        )
        _require_challenges_enabled(context.party)
        if context.party.get("activeChallengeId") is not None:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "A challenge is already active.",
            )
        challenge_ref = _challenge_ref(db, session_id, challenge_id)
        if transaction.get(challenge_ref).exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "Challenge ID already exists.",
            )
        now = _now(now_provider)
        ends_at = now + timedelta(minutes=duration_minutes)
        transaction.create(
            challenge_ref,
            {
                "title": title,
                "instructions": instructions,
                "pointsUnits": points_units,
                "startsAt": now,
                "endsAt": ends_at,
                "status": "active",
                "winnerIds": [],
                "createdByUserId": actor_user_id,
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        transaction.update(
            db.collection("parties").document(session_id),
            {
                "activeChallengeId": challenge_id,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        recipients = _active_member_ids(context.session)
        did_create = True
        return {
            "sessionId": session_id,
            "challengeId": challenge_id,
            "status": "active",
            "startsAt": now,
            "endsAt": ends_at,
        }

    result = _run_command(
        db,
        session_id,
        command_id,
        "create_admin_challenge",
        actor_user_id,
        operation,
        transaction_runner,
    )
    if did_create:
        notification_dispatcher(
            db,
            recipients,
            actor_user_id=actor_user_id,
            title=title,
            body=instructions,
            data={
                "type": "party_challenge_started",
                "sessionId": session_id,
                "challengeId": challenge_id,
            },
        )
    return result


def award_admin_challenge_winner_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    notification_dispatcher: NotificationDispatcher = send_notification_to_users,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_user_id, data, session_id, command_id = _command_input(request)
    challenge_id = _document_id(data, "challengeId")
    winner_user_id = require_string(data, "winnerUserId", max_length=1_500)
    did_award = False
    challenge_title = ""

    def operation(transaction: Any) -> Mapping[str, Any]:
        nonlocal did_award, challenge_title
        context = load_party_context(
            transaction, db, session_id, actor_user_id, require_admin=True
        )
        _require_challenges_enabled(context.party)
        challenge_ref, challenge = _load_challenge(
            transaction, db, session_id, challenge_id
        )
        _require_current_active_challenge(context.party, challenge_id, challenge)
        now = _now(now_provider)
        _require_before_deadline(challenge, now)
        if winner_user_id not in _active_member_ids(context.session):
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Challenge winners must be active Session members.",
            )
        member_snapshot = transaction.get(
            db.collection("parties")
            .document(session_id)
            .collection("members")
            .document(winner_user_id)
        )
        if (
            not member_snapshot.exists
            or (member_snapshot.to_dict() or {}).get("isActive") is not True
        ):
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Challenge winners must be active Party members.",
            )
        winner_ids = _winner_ids(challenge)
        if winner_user_id in winner_ids:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "This member has already won the challenge.",
            )
        points_units = _stored_points(challenge)
        challenge_title = _stored_text(challenge, "title")
        event_id = deterministic_event_id(
            "challenge", challenge_id, "winner", winner_user_id
        )
        award = create_award(
            transaction,
            db.collection("parties").document(session_id),
            event_id=event_id,
            kind="adminChallenge",
            recipient_user_id=winner_user_id,
            participant_ids=[winner_user_id],
            points_units=points_units,
            source_collection="challenges",
            source_id=challenge_id,
            occurred_at=now,
            actor_user_id=actor_user_id,
            payload={"challengeId": challenge_id, "title": challenge_title},
        )
        if not award.created:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "This member already has a challenge award.",
            )
        winner_ids.append(winner_user_id)
        transaction.update(
            challenge_ref,
            {"winnerIds": winner_ids, "updatedAt": firestore.SERVER_TIMESTAMP},
        )
        did_award = True
        return {
            "sessionId": session_id,
            "challengeId": challenge_id,
            "winnerUserId": winner_user_id,
            "awardEventId": event_id,
            "pointsUnits": points_units,
        }

    result = _run_command(
        db,
        session_id,
        command_id,
        "award_admin_challenge_winner",
        actor_user_id,
        operation,
        transaction_runner,
    )
    if did_award:
        notification_dispatcher(
            db,
            [winner_user_id],
            actor_user_id=actor_user_id,
            title="Challenge won",
            body=challenge_title,
            data={
                "type": "party_challenge_winner",
                "sessionId": session_id,
                "challengeId": challenge_id,
            },
        )
    return result


def complete_admin_challenge_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    return _close_challenge_command(
        request,
        db,
        status="completed",
        command_name="complete_admin_challenge",
        now_provider=now_provider,
        transaction_runner=transaction_runner,
    )


def cancel_admin_challenge_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    return _close_challenge_command(
        request,
        db,
        status="cancelled",
        command_name="cancel_admin_challenge",
        now_provider=now_provider,
        transaction_runner=transaction_runner,
    )


def reverse_admin_challenge_winner_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_user_id, data, session_id, command_id = _command_input(request)
    challenge_id = _document_id(data, "challengeId")
    winner_user_id = require_string(data, "winnerUserId", max_length=1_500)

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(
            transaction, db, session_id, actor_user_id, require_admin=True
        )
        _require_challenges_enabled(context.party)
        _, challenge = _load_challenge(transaction, db, session_id, challenge_id)
        challenge_status = challenge.get("status")
        if challenge_status not in {"active", "completed"}:
            raise callable_error(
                https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
                "Cancelled or expired challenges cannot be changed.",
            )
        now = _now(now_provider)
        if challenge_status == "active":
            _require_before_deadline(challenge, now)
        if winner_user_id not in _winner_ids(challenge):
            raise callable_error(
                https_fn.FunctionsErrorCode.NOT_FOUND,
                "Challenge winner was not found.",
            )
        award_event_id = deterministic_event_id(
            "challenge", challenge_id, "winner", winner_user_id
        )
        reversal = create_reversal(
            transaction,
            db.collection("parties").document(session_id),
            award_event_id=award_event_id,
            occurred_at=now,
            actor_user_id=actor_user_id,
            reason="adminChallengeWinnerCorrection",
        )
        if not reversal.created:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "This challenge award has already been reversed.",
            )
        return {
            "sessionId": session_id,
            "challengeId": challenge_id,
            "winnerUserId": winner_user_id,
            "awardEventId": award_event_id,
            "reversalEventId": reversal.event_id,
        }

    return _run_command(
        db,
        session_id,
        command_id,
        "reverse_admin_challenge_winner",
        actor_user_id,
        operation,
        transaction_runner,
    )


def _close_challenge_command(
    request: Any,
    db: Any,
    *,
    status: str,
    command_name: str,
    now_provider: Callable[[], datetime] | None,
    transaction_runner: TransactionRunner | None,
) -> Mapping[str, Any]:
    actor_user_id, data, session_id, command_id = _command_input(request)
    challenge_id = _document_id(data, "challengeId")

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(
            transaction, db, session_id, actor_user_id, require_admin=True
        )
        _require_challenges_enabled(context.party)
        challenge_ref, challenge = _load_challenge(
            transaction, db, session_id, challenge_id
        )
        _require_current_active_challenge(context.party, challenge_id, challenge)
        _require_before_deadline(challenge, _now(now_provider))
        transaction.update(
            challenge_ref,
            {"status": status, "updatedAt": firestore.SERVER_TIMESTAMP},
        )
        transaction.update(
            db.collection("parties").document(session_id),
            {"activeChallengeId": None, "updatedAt": firestore.SERVER_TIMESTAMP},
        )
        return {
            "sessionId": session_id,
            "challengeId": challenge_id,
            "status": status,
            "winnerIds": _winner_ids(challenge),
        }

    return _run_command(
        db,
        session_id,
        command_id,
        command_name,
        actor_user_id,
        operation,
        transaction_runner,
    )


def _command_input(
    request: Any,
) -> tuple[str, Mapping[str, Any], str, str]:
    actor_user_id = require_auth(request)
    data = require_object(getattr(request, "data", None))
    session_id = require_string(data, "sessionId", max_length=1_500)
    command_id = require_command_id(data)
    return actor_user_id, data, session_id, command_id


def _run_command(
    db: Any,
    session_id: str,
    command_id: str,
    command_name: str,
    actor_user_id: str,
    operation: Callable[[Any], Mapping[str, Any]],
    transaction_runner: TransactionRunner | None,
) -> Mapping[str, Any]:
    return run_idempotent_command(
        db,
        party_id=session_id,
        command_id=command_id,
        command_name=command_name,
        actor_user_id=actor_user_id,
        operation=operation,
        transaction_runner=transaction_runner,
    )


def _document_id(data: Mapping[str, Any], field_name: str) -> str:
    value = require_string(data, field_name, max_length=1_500)
    if "/" in value:
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            f"{field_name} must not contain '/'.",
        )
    return value


def _challenge_ref(db: Any, session_id: str, challenge_id: str) -> Any:
    return (
        db.collection("parties")
        .document(session_id)
        .collection("challenges")
        .document(challenge_id)
    )


def _load_challenge(
    transaction: Any,
    db: Any,
    session_id: str,
    challenge_id: str,
) -> tuple[Any, Mapping[str, Any]]:
    challenge_ref = _challenge_ref(db, session_id, challenge_id)
    snapshot = transaction.get(challenge_ref)
    if not snapshot.exists:
        raise callable_error(
            https_fn.FunctionsErrorCode.NOT_FOUND, "Challenge was not found."
        )
    return challenge_ref, snapshot.to_dict() or {}


def _require_challenges_enabled(party: Mapping[str, Any]) -> None:
    settings = party.get("moduleSettings")
    if (
        not isinstance(settings, Mapping)
        or settings.get("adminChallengesEnabled") is not True
    ):
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Admin challenges are disabled.",
        )


def _require_current_active_challenge(
    party: Mapping[str, Any],
    challenge_id: str,
    challenge: Mapping[str, Any],
) -> None:
    if (
        party.get("activeChallengeId") != challenge_id
        or challenge.get("status") != "active"
    ):
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Challenge is not active.",
        )


def _require_before_deadline(challenge: Mapping[str, Any], now: datetime) -> None:
    if _as_datetime(challenge.get("endsAt"), "endsAt") <= now:
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Challenge has expired.",
        )


def _active_member_ids(session: Mapping[str, Any]) -> list[str]:
    value = session.get("memberIds")
    if (
        not isinstance(value, Sequence)
        or isinstance(value, (str, bytes))
        or any(not isinstance(item, str) or not item for item in value)
    ):
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Stored Session membership is invalid.",
        )
    return list(dict.fromkeys(value))


def _winner_ids(challenge: Mapping[str, Any]) -> list[str]:
    value = challenge.get("winnerIds", [])
    if (
        not isinstance(value, Sequence)
        or isinstance(value, (str, bytes))
        or any(not isinstance(item, str) or not item for item in value)
        or len(set(value)) != len(value)
    ):
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Stored challenge winners are invalid.",
        )
    return list(value)


def _stored_points(challenge: Mapping[str, Any]) -> int:
    value = challenge.get("pointsUnits")
    if (
        isinstance(value, bool)
        or not isinstance(value, int)
        or not MIN_CHALLENGE_POINTS_UNITS <= value <= MAX_CHALLENGE_POINTS_UNITS
    ):
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Stored challenge points are invalid.",
        )
    return value


def _stored_text(challenge: Mapping[str, Any], field_name: str) -> str:
    value = challenge.get(field_name)
    if not isinstance(value, str) or not value:
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            f"Stored challenge {field_name} is invalid.",
        )
    return value


def _as_datetime(value: Any, field_name: str) -> datetime:
    if not isinstance(value, datetime):
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            f"Stored challenge {field_name} is invalid.",
        )
    return value


def _now(provider: Callable[[], datetime] | None) -> datetime:
    value = provider() if provider is not None else datetime.now(timezone.utc)
    if not isinstance(value, datetime):
        raise TypeError("now_provider must return datetime")
    return value
