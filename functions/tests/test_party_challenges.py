from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from typing import Any

import pytest
from firebase_functions import https_fn

from party_challenges import (
    award_admin_challenge_winner_command,
    cancel_admin_challenge_command,
    complete_admin_challenge_command,
    create_admin_challenge_command,
    reverse_admin_challenge_winner_command,
    set_party_module_settings_command,
)
from tests.fakes import Database, Transaction

NOW = datetime(2026, 1, 2, 1, tzinfo=timezone.utc)


@dataclass
class Auth:
    uid: str


@dataclass
class Request:
    auth: Auth | None
    data: dict[str, Any]


class Notifications:
    def __init__(self) -> None:
        self.calls: list[dict[str, Any]] = []

    def __call__(self, db: Any, recipients: Any, **values: Any) -> dict[str, Any]:
        del db
        self.calls.append({"recipients": list(recipients), **values})
        return {}


def _runner(transaction: Transaction):  # type: ignore[no-untyped-def]
    return lambda callback: callback(transaction)


def _session(**overrides: Any) -> dict[str, Any]:
    value = {
        "userId": "owner",
        "memberIds": ["owner", "admin", "member-a", "member-b"],
        "adminIds": ["owner", "admin"],
        "isParty": True,
    }
    value.update(overrides)
    return value


def _party(**overrides: Any) -> dict[str, Any]:
    value = {
        "status": "active",
        "moduleSettings": {
            "socialQuestsEnabled": False,
            "adminChallengesEnabled": True,
            "beerpongEnabled": False,
        },
        "activeChallengeId": None,
    }
    value.update(overrides)
    return value


def _member(user_id: str, score: int = 0) -> dict[str, Any]:
    return {
        "userId": user_id,
        "scoreUnits": score,
        "drinkCount": 0,
        "isActive": True,
    }


def _challenge(**overrides: Any) -> dict[str, Any]:
    value = {
        "title": "Dance",
        "instructions": "Dance on the table.",
        "pointsUnits": 50_000,
        "startsAt": NOW - timedelta(minutes=1),
        "endsAt": NOW + timedelta(minutes=5),
        "status": "active",
        "winnerIds": [],
        "createdByUserId": "admin",
        "createdAt": NOW,
        "updatedAt": NOW,
    }
    value.update(overrides)
    return value


def _base_store(*, active_challenge: bool = False) -> dict[str, dict[str, Any]]:
    store = {
        "sessions/party-a": _session(),
        "parties/party-a": _party(
            activeChallengeId="challenge-a" if active_challenge else None
        ),
    }
    for user_id in ("owner", "admin", "member-a", "member-b"):
        store[f"parties/party-a/members/{user_id}"] = _member(user_id)
    if active_challenge:
        store["parties/party-a/challenges/challenge-a"] = _challenge()
    return store


def _request(command_id: str, **overrides: Any) -> Request:
    data = {
        "sessionId": "party-a",
        "commandId": command_id,
        "challengeId": "challenge-a",
    }
    data.update(overrides)
    return Request(Auth("admin"), data)


def _create_request(command_id: str = "create-a", **overrides: Any) -> Request:
    data = {
        "title": "  Dance  ",
        "instructions": "  Dance on the table.  ",
        "pointsUnits": 50_000,
        "durationMinutes": 5,
    }
    data.update(overrides)
    return _request(command_id, **data)


def test_settings_are_admin_only_atomic_and_idempotent() -> None:
    db = Database(_base_store())
    settings = {
        "socialQuestsEnabled": True,
        "adminChallengesEnabled": True,
        "beerpongEnabled": True,
    }
    request = _request("settings-a", moduleSettings=settings)
    transaction = Transaction(db.store)

    result = set_party_module_settings_command(
        request, db, transaction_runner=_runner(transaction)
    )
    retry = set_party_module_settings_command(
        request, db, transaction_runner=_runner(transaction)
    )

    assert retry == result
    assert result["moduleSettings"] == settings
    assert db.store["parties/party-a"]["moduleSettings"] == settings
    assert transaction.updated_paths.count("parties/party-a") == 1

    request.auth = Auth("member-a")
    request.data["commandId"] = "settings-member"
    with pytest.raises(https_fn.HttpsError) as error:
        set_party_module_settings_command(
            request,
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )
    assert error.value.code == https_fn.FunctionsErrorCode.PERMISSION_DENIED


def test_settings_cannot_disable_an_active_challenge() -> None:
    db = Database(_base_store(active_challenge=True))
    request = _request(
        "settings-a",
        moduleSettings={
            "socialQuestsEnabled": False,
            "adminChallengesEnabled": False,
            "beerpongEnabled": False,
        },
    )

    with pytest.raises(https_fn.HttpsError) as error:
        set_party_module_settings_command(
            request,
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION
    assert (
        db.store["parties/party-a"]["moduleSettings"]["adminChallengesEnabled"] is True
    )


def test_create_sets_deadline_active_pointer_notifies_once_and_is_idempotent() -> None:
    db = Database(_base_store())
    transaction = Transaction(db.store)
    notifications = Notifications()
    request = _create_request()

    result = create_admin_challenge_command(
        request,
        db,
        now_provider=lambda: NOW,
        notification_dispatcher=notifications,
        transaction_runner=_runner(transaction),
    )
    retry = create_admin_challenge_command(
        request,
        db,
        now_provider=lambda: pytest.fail("retry evaluated command"),
        notification_dispatcher=notifications,
        transaction_runner=_runner(transaction),
    )

    assert retry == result
    challenge = db.store["parties/party-a/challenges/challenge-a"]
    assert challenge["title"] == "Dance"
    assert challenge["instructions"] == "Dance on the table."
    assert challenge["startsAt"] == NOW
    assert challenge["endsAt"] == NOW + timedelta(minutes=5)
    assert challenge["winnerIds"] == []
    assert db.store["parties/party-a"]["activeChallengeId"] == "challenge-a"
    assert (
        transaction.created_paths.count("parties/party-a/challenges/challenge-a") == 1
    )
    assert len(notifications.calls) == 1
    assert notifications.calls[0]["recipients"] == [
        "owner",
        "admin",
        "member-a",
        "member-b",
    ]
    assert notifications.calls[0]["data"] == {
        "type": "party_challenge_started",
        "sessionId": "party-a",
        "tab": "games",
        "sourceId": "challenge-a",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
    }


@pytest.mark.parametrize(
    ("store_change", "request_change", "expected_code"),
    [
        (
            lambda store: store["parties/party-a"]["moduleSettings"].update(
                adminChallengesEnabled=False
            ),
            {},
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            lambda store: store["parties/party-a"].update(status="archived"),
            {},
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            lambda store: store["parties/party-a"].update(activeChallengeId="other"),
            {},
            https_fn.FunctionsErrorCode.ALREADY_EXISTS,
        ),
        (
            lambda store: None,
            {"durationMinutes": 0},
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
        ),
        (
            lambda store: None,
            {"durationMinutes": 61},
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
        ),
        (
            lambda store: None,
            {"pointsUnits": 999},
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
        ),
        (
            lambda store: None,
            {"pointsUnits": 500_001},
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
        ),
        (
            lambda store: None,
            {"title": "  "},
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
        ),
    ],
)
def test_create_rejects_disabled_archived_active_and_invalid_content(
    store_change: Any,
    request_change: dict[str, Any],
    expected_code: https_fn.FunctionsErrorCode,
) -> None:
    store = _base_store()
    store_change(store)
    db = Database(store)

    with pytest.raises(https_fn.HttpsError) as error:
        create_admin_challenge_command(
            _create_request(**request_change),
            db,
            now_provider=lambda: NOW,
            notification_dispatcher=Notifications(),
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == expected_code
    assert "parties/party-a/challenges/challenge-a" not in db.store


def test_multiple_distinct_winners_receive_equal_points_once() -> None:
    db = Database(_base_store(active_challenge=True))
    notifications = Notifications()

    first = award_admin_challenge_winner_command(
        _request("winner-a", winnerUserId="member-a"),
        db,
        now_provider=lambda: NOW,
        notification_dispatcher=notifications,
        transaction_runner=_runner(Transaction(db.store)),
    )
    second_request = _request("winner-b", winnerUserId="member-b")
    transaction = Transaction(db.store)
    second = award_admin_challenge_winner_command(
        second_request,
        db,
        now_provider=lambda: NOW,
        notification_dispatcher=notifications,
        transaction_runner=_runner(transaction),
    )
    retry = award_admin_challenge_winner_command(
        second_request,
        db,
        now_provider=lambda: pytest.fail("retry evaluated command"),
        notification_dispatcher=notifications,
        transaction_runner=_runner(transaction),
    )

    assert retry == second
    assert first["pointsUnits"] == second["pointsUnits"] == 50_000
    assert db.store["parties/party-a/challenges/challenge-a"]["winnerIds"] == [
        "member-a",
        "member-b",
    ]
    for user_id in ("member-a", "member-b"):
        assert db.store[f"parties/party-a/members/{user_id}"]["scoreUnits"] == 50_000
        event = db.store[
            f"parties/party-a/events/challenge:challenge-a:winner:{user_id}"
        ]
        assert event["kind"] == "adminChallenge"
        assert event["sourceCollection"] == "challenges"
        assert event["pointsUnits"] == 50_000
    assert len(notifications.calls) == 2


@pytest.mark.parametrize(
    ("store_change", "winner", "expected_code"),
    [
        (
            lambda store: None,
            "outsider",
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            lambda store: store["parties/party-a/members/member-a"].update(
                isActive=False
            ),
            "member-a",
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            lambda store: store["parties/party-a/challenges/challenge-a"].update(
                endsAt=NOW
            ),
            "member-a",
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            lambda store: store["parties/party-a/challenges/challenge-a"].update(
                status="completed"
            ),
            "member-a",
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            lambda store: store["parties/party-a"]["moduleSettings"].update(
                adminChallengesEnabled=False
            ),
            "member-a",
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            lambda store: store["parties/party-a"].update(status="archived"),
            "member-a",
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
    ],
)
def test_award_rejects_inactive_member_expiry_status_disabled_and_archive(
    store_change: Any,
    winner: str,
    expected_code: https_fn.FunctionsErrorCode,
) -> None:
    store = _base_store(active_challenge=True)
    store_change(store)
    db = Database(store)

    with pytest.raises(https_fn.HttpsError) as error:
        award_admin_challenge_winner_command(
            _request("winner-a", winnerUserId=winner),
            db,
            now_provider=lambda: NOW,
            notification_dispatcher=Notifications(),
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == expected_code


def test_competing_duplicate_winner_is_rejected_without_second_award() -> None:
    db = Database(_base_store(active_challenge=True))
    request = _request("winner-a", winnerUserId="member-a")
    award_admin_challenge_winner_command(
        request,
        db,
        now_provider=lambda: NOW,
        notification_dispatcher=Notifications(),
        transaction_runner=_runner(Transaction(db.store)),
    )

    with pytest.raises(https_fn.HttpsError) as error:
        award_admin_challenge_winner_command(
            _request("winner-competing", winnerUserId="member-a"),
            db,
            now_provider=lambda: NOW,
            notification_dispatcher=Notifications(),
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == https_fn.FunctionsErrorCode.ALREADY_EXISTS
    assert db.store["parties/party-a/members/member-a"]["scoreUnits"] == 50_000


@pytest.mark.parametrize(
    ("command", "status"),
    [
        (complete_admin_challenge_command, "completed"),
        (cancel_admin_challenge_command, "cancelled"),
    ],
)
def test_complete_and_cancel_clear_pointer_and_are_idempotent(
    command: Any, status: str
) -> None:
    db = Database(_base_store(active_challenge=True))
    request = _request(f"{status}-a")
    transaction = Transaction(db.store)

    result = command(
        request,
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(transaction),
    )
    retry = command(
        request,
        db,
        now_provider=lambda: pytest.fail("retry evaluated command"),
        transaction_runner=_runner(transaction),
    )

    assert retry == result
    assert result["status"] == status
    assert db.store["parties/party-a/challenges/challenge-a"]["status"] == status
    assert db.store["parties/party-a"]["activeChallengeId"] is None


def test_complete_rejects_expired_challenge_without_closing_it() -> None:
    store = _base_store(active_challenge=True)
    store["parties/party-a/challenges/challenge-a"]["endsAt"] = NOW
    db = Database(store)

    with pytest.raises(https_fn.HttpsError) as error:
        complete_admin_challenge_command(
            _request("complete-a"),
            db,
            now_provider=lambda: NOW,
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION
    assert db.store["parties/party-a/challenges/challenge-a"]["status"] == "active"


def test_completed_winner_correction_creates_one_reversal_and_keeps_history() -> None:
    db = Database(_base_store(active_challenge=True))
    award_admin_challenge_winner_command(
        _request("winner-a", winnerUserId="member-a"),
        db,
        now_provider=lambda: NOW,
        notification_dispatcher=Notifications(),
        transaction_runner=_runner(Transaction(db.store)),
    )
    complete_admin_challenge_command(
        _request("complete-a"),
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(Transaction(db.store)),
    )
    request = _request("reverse-a", winnerUserId="member-a")
    transaction = Transaction(db.store)

    result = reverse_admin_challenge_winner_command(
        request,
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(transaction),
    )
    retry = reverse_admin_challenge_winner_command(
        request,
        db,
        now_provider=lambda: pytest.fail("retry evaluated command"),
        transaction_runner=_runner(transaction),
    )

    assert retry == result
    assert result["reversalEventId"] == (
        "reversal:challenge%3Achallenge-a%3Awinner%3Amember-a"
    )
    reversal = db.store[
        "parties/party-a/events/reversal:challenge%3Achallenge-a%3Awinner%3Amember-a"
    ]
    assert reversal["pointsUnits"] == -50_000
    assert reversal["reversesEventId"] == ("challenge:challenge-a:winner:member-a")
    assert db.store["parties/party-a/members/member-a"]["scoreUnits"] == 0
    assert db.store["parties/party-a/challenges/challenge-a"]["winnerIds"] == [
        "member-a"
    ]
    assert (
        transaction.created_paths.count(
            "parties/party-a/events/"
            "reversal:challenge%3Achallenge-a%3Awinner%3Amember-a"
        )
        == 1
    )


def test_competing_reversal_and_expired_reversal_are_rejected() -> None:
    db = Database(_base_store(active_challenge=True))
    award_admin_challenge_winner_command(
        _request("winner-a", winnerUserId="member-a"),
        db,
        now_provider=lambda: NOW,
        notification_dispatcher=Notifications(),
        transaction_runner=_runner(Transaction(db.store)),
    )
    reverse_admin_challenge_winner_command(
        _request("reverse-a", winnerUserId="member-a"),
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(Transaction(db.store)),
    )

    with pytest.raises(https_fn.HttpsError) as duplicate_error:
        reverse_admin_challenge_winner_command(
            _request("reverse-competing", winnerUserId="member-a"),
            db,
            now_provider=lambda: NOW,
            transaction_runner=_runner(Transaction(db.store)),
        )
    assert duplicate_error.value.code == https_fn.FunctionsErrorCode.ALREADY_EXISTS

    for status in ("cancelled", "expired"):
        db.store["parties/party-a/challenges/challenge-a"]["status"] = status
        with pytest.raises(https_fn.HttpsError) as status_error:
            reverse_admin_challenge_winner_command(
                _request(f"reverse-{status}", winnerUserId="member-a"),
                db,
                now_provider=lambda: NOW,
                transaction_runner=_runner(Transaction(db.store)),
            )
        assert (
            status_error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION
        )


def test_all_mutations_require_session_admin() -> None:
    commands = [
        (
            create_admin_challenge_command,
            _create_request("create-member"),
            {"notification_dispatcher": Notifications()},
            _base_store(),
        ),
        (
            award_admin_challenge_winner_command,
            _request("award-member", winnerUserId="member-b"),
            {"notification_dispatcher": Notifications()},
            _base_store(active_challenge=True),
        ),
        (
            complete_admin_challenge_command,
            _request("complete-member"),
            {},
            _base_store(active_challenge=True),
        ),
        (
            cancel_admin_challenge_command,
            _request("cancel-member"),
            {},
            _base_store(active_challenge=True),
        ),
        (
            reverse_admin_challenge_winner_command,
            _request("reverse-member", winnerUserId="member-a"),
            {},
            _base_store(active_challenge=True),
        ),
    ]
    for command, request, options, store in commands:
        request.auth = Auth("member-a")
        db = Database(store)
        with pytest.raises(https_fn.HttpsError) as error:
            command(
                request,
                db,
                now_provider=lambda: NOW,
                transaction_runner=_runner(Transaction(db.store)),
                **options,
            )
        assert error.value.code == https_fn.FunctionsErrorCode.PERMISSION_DENIED
