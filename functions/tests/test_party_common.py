from dataclasses import dataclass

import pytest
from firebase_functions import https_fn
from party_common import (
    load_party_context,
    require_auth,
    require_command_id,
    require_int,
    require_session_admin,
    run_idempotent_command,
)

from tests.fakes import Database, Transaction


@dataclass
class Auth:
    uid: str


@dataclass
class Request:
    auth: Auth | None


def test_require_auth_and_validated_integer() -> None:
    assert require_auth(Request(Auth("user-a"))) == "user-a"
    assert require_int({"points": 10}, "points", minimum=1, maximum=10) == 10

    with pytest.raises(https_fn.HttpsError) as auth_error:
        require_auth(Request(None))
    assert auth_error.value.code == https_fn.FunctionsErrorCode.UNAUTHENTICATED

    with pytest.raises(https_fn.HttpsError) as integer_error:
        require_int({"points": True}, "points")
    assert integer_error.value.code == https_fn.FunctionsErrorCode.INVALID_ARGUMENT

    with pytest.raises(https_fn.HttpsError):
        require_command_id({"commandId": "invalid/path"})


def test_admin_guard_accepts_owner_and_rejects_member() -> None:
    session = {"userId": "owner", "adminIds": ["admin"]}
    require_session_admin(session, "owner")
    require_session_admin(session, "admin")

    with pytest.raises(https_fn.HttpsError) as error:
        require_session_admin(session, "member")
    assert error.value.code == https_fn.FunctionsErrorCode.PERMISSION_DENIED


def test_load_party_context_checks_membership_and_active_status() -> None:
    db = Database(
        {
            "sessions/party-a": {
                "userId": "owner",
                "memberIds": ["owner", "member"],
                "adminIds": ["owner"],
            },
            "parties/party-a": {"status": "active"},
        }
    )
    context = load_party_context(Transaction(db.store), db, "party-a", "member")
    assert context.party_id == "party-a"

    db.store["parties/party-a"]["status"] = "archived"
    with pytest.raises(https_fn.HttpsError) as error:
        load_party_context(Transaction(db.store), db, "party-a", "member")
    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION


def test_repeated_command_returns_original_result_without_repeating_operation() -> None:
    db = Database()
    transaction = Transaction(db.store)
    calls = 0

    def operation(current_transaction: Transaction) -> dict[str, object]:
        nonlocal calls
        calls += 1
        assert current_transaction is transaction
        return {"created": True, "value": calls}

    def runner(callback):  # type: ignore[no-untyped-def]
        return callback(transaction)

    first = run_idempotent_command(
        db,
        party_id="party-a",
        command_id="command-a",
        command_name="test_command",
        actor_user_id="user-a",
        operation=operation,
        transaction_runner=runner,
    )
    second = run_idempotent_command(
        db,
        party_id="party-a",
        command_id="command-a",
        command_name="test_command",
        actor_user_id="user-a",
        operation=operation,
        transaction_runner=runner,
    )

    assert first == {"created": True, "value": 1}
    assert second == first
    assert calls == 1
    assert transaction.created_paths == ["parties/party-a/commands/command-a"]


def test_command_id_cannot_be_reused_by_another_command() -> None:
    db = Database()
    transaction = Transaction(db.store)

    def runner(callback):  # type: ignore[no-untyped-def]
        return callback(transaction)

    run_idempotent_command(
        db,
        party_id="party-a",
        command_id="command-a",
        command_name="first",
        actor_user_id="user-a",
        operation=lambda _: {"ok": True},
        transaction_runner=runner,
    )
    with pytest.raises(https_fn.HttpsError) as error:
        run_idempotent_command(
            db,
            party_id="party-a",
            command_id="command-a",
            command_name="second",
            actor_user_id="user-a",
            operation=lambda _: {"ok": False},
            transaction_runner=runner,
        )
    assert error.value.code == https_fn.FunctionsErrorCode.ALREADY_EXISTS
