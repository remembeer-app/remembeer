from dataclasses import dataclass
from typing import Any

import pytest
from firebase_functions import https_fn

from party_commands import (
    activate_party_command,
    archive_party_command,
    sync_party_membership_command,
)
from tests.fakes import Database, Transaction


@dataclass
class Auth:
    uid: str


@dataclass
class Request:
    auth: Auth | None
    data: dict[str, Any]


def _runner(transaction: Transaction):  # type: ignore[no-untyped-def]
    return lambda callback: callback(transaction)


def _session(**overrides: Any) -> dict[str, Any]:
    session = {
        "userId": "owner",
        "memberIds": ["owner", "admin", "member"],
        "adminIds": ["owner", "admin"],
        "bannedMemberIds": [],
        "isSoloSession": False,
        "isParty": False,
        "startedAt": "2026-01-01T18:00:00",
        "endedAt": None,
        "drinks": [],
    }
    session.update(overrides)
    return session


def _active_party() -> dict[str, Any]:
    return {
        "status": "active",
        "questSchedule": {
            "minIntervalMinutes": 15,
            "maxIntervalMinutes": 45,
            "defaultDurationMinutes": 15,
            "nextQuestAt": "future",
        },
        "activeQuestId": "quest-a",
        "activeChallengeId": "challenge-a",
        "activeTournamentId": "tournament-a",
    }


def test_admin_activation_creates_complete_party_and_base_awards_once() -> None:
    drink = {
        "id": "drink-a",
        "consumedByUserId": "member",
        "consumedAt": "2026-01-01T20:00:00",
        "drinkType": {
            "name": "Beer",
            "category": "beer",
            "alcoholPercentage": 5.0,
        },
        "volumeInMilliliters": 500,
    }
    db = Database({"sessions/session-a": _session(drinks=[drink])})
    transaction = Transaction(db.store)
    request = Request(
        Auth("admin"),
        {"sessionId": "session-a", "commandId": "activate-a"},
    )
    template = {
        "source": "builtIn",
        "title": "Meet",
        "createdAt": "now",
    }

    result = activate_party_command(
        request,
        db,
        template_seed_provider=lambda _: [("meet", template)],
        transaction_runner=_runner(transaction),
    )
    retry = activate_party_command(
        request,
        db,
        template_seed_provider=lambda _: pytest.fail("retry reseeded templates"),
        transaction_runner=_runner(transaction),
    )

    assert retry == result
    assert result == {
        "sessionId": "session-a",
        "memberCount": 3,
        "templateCount": 1,
        "initialAwardCount": 1,
    }
    assert db.store["sessions/session-a"]["isParty"] is True
    assert db.store["parties/session-a"]["status"] == "active"
    assert db.store["parties/session-a/members/member"] == {
        "userId": "member",
        "selectedClass": None,
        "classVersion": 0,
        "classChangedAt": None,
        "beerpongOptIn": False,
        "scoreUnits": 25_000,
        "drinkCount": 1,
        "isActive": True,
        "joinedAt": db.store["parties/session-a/members/member"]["joinedAt"],
        "updatedAt": db.store["parties/session-a/members/member"]["updatedAt"],
    }
    event = db.store["parties/session-a/events/drink:drink-a:v:1"]
    assert event["pointsUnits"] == 25_000
    assert event["payload"]["selectedClass"] is None
    assert event["payload"]["appliedMultiplier"] == 1
    assert db.store["parties/session-a/questTemplates/meet"] == template
    assert (
        transaction.created_paths.count("parties/session-a/events/drink:drink-a:v:1")
        == 1
    )


def test_activation_uses_versioned_builtin_catalog_by_default() -> None:
    db = Database({"sessions/session-a": _session()})

    result = activate_party_command(
        Request(
            Auth("owner"),
            {"sessionId": "session-a", "commandId": "activate-a"},
        ),
        db,
        transaction_runner=_runner(Transaction(db.store)),
    )

    assert result["templateCount"] == 18
    template = db.store["parties/session-a/questTemplates/builtin-v1-toast-with-beer"]
    assert template["source"] == "builtIn"
    assert template["builtInKey"] == "toast-with-beer"
    assert template["catalogVersion"] == 1
    assert template["eligibilityRule"] == "oneMemberClass:beer"


@pytest.mark.parametrize(
    ("actor", "overrides", "expected_code"),
    [
        ("member", {}, https_fn.FunctionsErrorCode.PERMISSION_DENIED),
        (
            "owner",
            {"isSoloSession": True},
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            "owner",
            {"endedAt": "2026-01-01T21:00:00"},
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            "owner",
            {"isParty": True},
            https_fn.FunctionsErrorCode.ALREADY_EXISTS,
        ),
    ],
)
def test_activation_rejects_ineligible_sessions(
    actor: str,
    overrides: dict[str, Any],
    expected_code: https_fn.FunctionsErrorCode,
) -> None:
    db = Database({"sessions/session-a": _session(**overrides)})
    request = Request(
        Auth(actor),
        {"sessionId": "session-a", "commandId": "activate-a"},
    )

    with pytest.raises(https_fn.HttpsError) as error:
        activate_party_command(
            request,
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == expected_code
    assert "parties/session-a" not in db.store


def test_duplicate_party_document_is_rejected_even_if_session_flag_is_false() -> None:
    db = Database(
        {
            "sessions/session-a": _session(),
            "parties/session-a": _active_party(),
        }
    )
    with pytest.raises(https_fn.HttpsError) as error:
        activate_party_command(
            Request(
                Auth("owner"),
                {"sessionId": "session-a", "commandId": "activate-a"},
            ),
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )
    assert error.value.code == https_fn.FunctionsErrorCode.ALREADY_EXISTS


def test_active_party_membership_adds_defaults_and_preserves_departed_score() -> None:
    db = Database(
        {
            "sessions/session-a": _session(isParty=True),
            "parties/session-a": _active_party(),
            "parties/session-a/members/member": {
                "userId": "member",
                "scoreUnits": 12_000,
                "drinkCount": 2,
                "selectedClass": "beer",
                "isActive": True,
            },
        }
    )
    leave_transaction = Transaction(db.store)
    sync_party_membership_command(
        Request(
            Auth("member"),
            {
                "sessionId": "session-a",
                "commandId": "leave-a",
                "action": "leave",
                "memberId": "member",
            },
        ),
        db,
        transaction_runner=_runner(leave_transaction),
    )
    assert "member" not in db.store["sessions/session-a"]["memberIds"]
    departed = db.store["parties/session-a/members/member"]
    assert departed["isActive"] is False
    assert departed["scoreUnits"] == 12_000
    assert departed["selectedClass"] == "beer"

    add_transaction = Transaction(db.store)
    sync_party_membership_command(
        Request(
            Auth("owner"),
            {
                "sessionId": "session-a",
                "commandId": "add-a",
                "action": "add",
                "memberId": "new-member",
            },
        ),
        db,
        transaction_runner=_runner(add_transaction),
    )
    added = db.store["parties/session-a/members/new-member"]
    assert added["selectedClass"] is None
    assert added["beerpongOptIn"] is False
    assert added["scoreUnits"] == 0
    assert added["drinkCount"] == 0
    assert added["isActive"] is True


def test_archive_ends_session_and_clears_all_future_activity() -> None:
    db = Database(
        {
            "sessions/session-a": _session(isParty=True),
            "parties/session-a": _active_party(),
        }
    )
    request = Request(
        Auth("admin"),
        {
            "sessionId": "session-a",
            "commandId": "archive-a",
            "endedAt": "2026-01-02T01:00:00",
        },
    )
    transaction = Transaction(db.store)

    result = archive_party_command(
        request,
        db,
        transaction_runner=_runner(transaction),
    )
    retry = archive_party_command(
        request,
        db,
        transaction_runner=_runner(transaction),
    )

    assert retry == result
    assert db.store["sessions/session-a"]["endedAt"] == "2026-01-02T01:00:00"
    party = db.store["parties/session-a"]
    assert party["status"] == "archived"
    assert party["questSchedule"]["nextQuestAt"] is None
    assert party["activeQuestId"] is None
    assert party["activeChallengeId"] is None
    assert party["activeTournamentId"] is None

    with pytest.raises(https_fn.HttpsError) as error:
        sync_party_membership_command(
            Request(
                Auth("owner"),
                {
                    "sessionId": "session-a",
                    "commandId": "after-archive",
                    "action": "add",
                    "memberId": "late-member",
                },
            ),
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )
    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION
