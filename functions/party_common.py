"""Shared validation, authorization, and idempotency for Party callables.

Feature handlers should call :func:`run_idempotent_command` and perform all
authoritative writes in the supplied transaction. A command receipt is created
in that same transaction, so a successful retry returns the stored result.
"""

from collections.abc import Callable, Mapping, Sequence
from dataclasses import dataclass
from typing import Any, TypeVar

from firebase_admin import firestore
from firebase_functions import https_fn

_T = TypeVar("_T")
_DEFAULT_STRING_MAX_LENGTH = 1_000
_COMMAND_ID_MAX_LENGTH = 128


@dataclass(frozen=True)
class PartyCommandContext:
    """Authoritative Session and Party snapshots read in one transaction."""

    party_id: str
    user_id: str
    session: Mapping[str, Any]
    party: Mapping[str, Any]


def callable_error(
    code: https_fn.FunctionsErrorCode,
    message: str,
) -> https_fn.HttpsError:
    """Create the consistent public error type expected by callable clients."""

    return https_fn.HttpsError(code=code, message=message)


def require_auth(request: Any) -> str:
    """Return the callable user's UID or raise ``UNAUTHENTICATED``."""

    auth = getattr(request, "auth", None)
    uid = getattr(auth, "uid", None) if auth is not None else None
    if uid is None and isinstance(auth, Mapping):
        uid = auth.get("uid")
    if not isinstance(uid, str) or not uid:
        raise callable_error(
            https_fn.FunctionsErrorCode.UNAUTHENTICATED,
            "Authentication is required.",
        )
    return uid


def require_object(value: Any, field_name: str = "data") -> Mapping[str, Any]:
    if not isinstance(value, Mapping):
        raise _invalid_argument(f"{field_name} must be an object.")
    return value


def require_string(
    data: Mapping[str, Any],
    field_name: str,
    *,
    max_length: int = _DEFAULT_STRING_MAX_LENGTH,
    strip: bool = True,
) -> str:
    value = data.get(field_name)
    if not isinstance(value, str):
        raise _invalid_argument(f"{field_name} must be a string.")
    result = value.strip() if strip else value
    if not result:
        raise _invalid_argument(f"{field_name} must not be empty.")
    if len(result) > max_length:
        raise _invalid_argument(
            f"{field_name} must be at most {max_length} characters.",
        )
    return result


def optional_string(
    data: Mapping[str, Any],
    field_name: str,
    *,
    max_length: int = _DEFAULT_STRING_MAX_LENGTH,
) -> str | None:
    if data.get(field_name) is None:
        return None
    return require_string(data, field_name, max_length=max_length)


def require_bool(data: Mapping[str, Any], field_name: str) -> bool:
    value = data.get(field_name)
    if not isinstance(value, bool):
        raise _invalid_argument(f"{field_name} must be a boolean.")
    return value


def require_int(
    data: Mapping[str, Any],
    field_name: str,
    *,
    minimum: int | None = None,
    maximum: int | None = None,
) -> int:
    value = data.get(field_name)
    if isinstance(value, bool) or not isinstance(value, int):
        raise _invalid_argument(f"{field_name} must be an integer.")
    if minimum is not None and value < minimum:
        raise _invalid_argument(f"{field_name} must be at least {minimum}.")
    if maximum is not None and value > maximum:
        raise _invalid_argument(f"{field_name} must be at most {maximum}.")
    return value


def require_string_list(
    data: Mapping[str, Any],
    field_name: str,
    *,
    min_items: int = 0,
    max_items: int = 100,
) -> list[str]:
    value = data.get(field_name)
    if isinstance(value, (str, bytes)) or not isinstance(value, Sequence):
        raise _invalid_argument(f"{field_name} must be an array of strings.")
    if not min_items <= len(value) <= max_items:
        raise _invalid_argument(
            f"{field_name} must contain between {min_items} and {max_items} items.",
        )
    result: list[str] = []
    for item in value:
        if not isinstance(item, str) or not item:
            raise _invalid_argument(f"{field_name} must contain non-empty strings.")
        result.append(item)
    return result


def require_command_id(data: Mapping[str, Any]) -> str:
    command_id = require_string(
        data,
        "commandId",
        max_length=_COMMAND_ID_MAX_LENGTH,
    )
    if "/" in command_id:
        raise _invalid_argument("commandId must not contain '/'.")
    return command_id


def require_session_member(session: Mapping[str, Any], user_id: str) -> None:
    member_ids = session.get("memberIds", [])
    if user_id not in member_ids:
        raise callable_error(
            https_fn.FunctionsErrorCode.PERMISSION_DENIED,
            "Active Session membership is required.",
        )


def require_session_admin(session: Mapping[str, Any], user_id: str) -> None:
    admin_ids = session.get("adminIds", [])
    if user_id != session.get("userId") and user_id not in admin_ids:
        raise callable_error(
            https_fn.FunctionsErrorCode.PERMISSION_DENIED,
            "Session admin access is required.",
        )


def require_active_party(party: Mapping[str, Any]) -> None:
    if party.get("status") != "active":
        raise callable_error(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Party is not active.",
        )


def load_party_context(
    transaction: Any,
    db: Any,
    party_id: str,
    user_id: str,
    *,
    require_admin: bool = False,
    require_active: bool = True,
) -> PartyCommandContext:
    """Read and authorize a Session-backed Party inside ``transaction``."""

    session_snapshot = transaction.get(db.collection("sessions").document(party_id))
    party_snapshot = transaction.get(db.collection("parties").document(party_id))
    if not session_snapshot.exists or not party_snapshot.exists:
        raise callable_error(
            https_fn.FunctionsErrorCode.NOT_FOUND,
            "Session-backed Party was not found.",
        )

    session = session_snapshot.to_dict() or {}
    party = party_snapshot.to_dict() or {}
    require_session_member(session, user_id)
    if require_admin:
        require_session_admin(session, user_id)
    if require_active:
        require_active_party(party)
    return PartyCommandContext(party_id, user_id, session, party)


def command_receipt_ref(db: Any, party_id: str, command_id: str) -> Any:
    return (
        db.collection("parties")
        .document(party_id)
        .collection("commands")
        .document(command_id)
    )


def read_command_receipt(
    transaction: Any,
    receipt_ref: Any,
    *,
    command_name: str,
    actor_user_id: str,
) -> Mapping[str, Any] | None:
    snapshot = transaction.get(receipt_ref)
    if not snapshot.exists:
        return None
    receipt = snapshot.to_dict() or {}
    if (
        receipt.get("commandName") != command_name
        or receipt.get("actorUserId") != actor_user_id
    ):
        raise callable_error(
            https_fn.FunctionsErrorCode.ALREADY_EXISTS,
            "commandId was already used for a different command.",
        )
    result = receipt.get("result")
    if not isinstance(result, Mapping):
        raise callable_error(
            https_fn.FunctionsErrorCode.INTERNAL,
            "Stored command result is invalid.",
        )
    return result


def create_command_receipt(
    transaction: Any,
    receipt_ref: Any,
    *,
    command_name: str,
    actor_user_id: str,
    result: Mapping[str, Any],
) -> None:
    transaction.create(
        receipt_ref,
        {
            "commandName": command_name,
            "actorUserId": actor_user_id,
            "result": dict(result),
            "createdAt": firestore.SERVER_TIMESTAMP,
        },
    )


def run_idempotent_command(
    db: Any,
    *,
    party_id: str,
    command_id: str,
    command_name: str,
    actor_user_id: str,
    operation: Callable[[Any], Mapping[str, Any]],
    transaction_runner: Callable[[Callable[[Any], _T]], _T] | None = None,
) -> Mapping[str, Any]:
    """Run ``operation`` and persist its result exactly once.

    ``operation`` must make every command write through the provided transaction.
    The optional runner is intended for unit tests; production uses Firestore's
    retrying transaction decorator.
    """

    receipt_ref = command_receipt_ref(db, party_id, command_id)

    def execute(transaction: Any) -> Mapping[str, Any]:
        prior_result = read_command_receipt(
            transaction,
            receipt_ref,
            command_name=command_name,
            actor_user_id=actor_user_id,
        )
        if prior_result is not None:
            return prior_result
        result = operation(transaction)
        if not isinstance(result, Mapping):
            raise TypeError("Idempotent command operations must return a mapping.")
        create_command_receipt(
            transaction,
            receipt_ref,
            command_name=command_name,
            actor_user_id=actor_user_id,
            result=result,
        )
        return result

    if transaction_runner is not None:
        return transaction_runner(execute)
    return firestore.transactional(execute)(db.transaction())


def _invalid_argument(message: str) -> https_fn.HttpsError:
    return callable_error(https_fn.FunctionsErrorCode.INVALID_ARGUMENT, message)
