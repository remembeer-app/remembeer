from dataclasses import dataclass
from datetime import datetime
from typing import Any

import pytest
from firebase_functions import https_fn
from party_drinks import (
    create_party_drink_command,
    delete_party_drink_command,
    update_party_drink_command,
)

from tests.fakes import Database, Transaction


@dataclass
class Auth:
    uid: str


@dataclass
class Request:
    auth: Auth | None
    data: dict[str, Any]


NOW = datetime.fromisoformat("2026-01-02T03:00:00+00:00")


def _runner(transaction: Transaction):  # type: ignore[no-untyped-def]
    return lambda callback: callback(transaction)


def _session(**overrides: Any) -> dict[str, Any]:
    value = {
        "userId": "owner",
        "memberIds": ["owner", "member"],
        "adminIds": ["owner"],
        "isSoloSession": False,
        "isParty": True,
        "startedAt": "2026-01-01T18:00:00+00:00",
        "endedAt": "2026-01-02T06:00:00+00:00",
        "drinks": [],
    }
    value.update(overrides)
    return value


def _party(status: str = "active") -> dict[str, Any]:
    return {"status": status}


def _member(**overrides: Any) -> dict[str, Any]:
    value = {
        "userId": "member",
        "selectedClass": "beer",
        "classVersion": 3,
        "scoreUnits": 0,
        "drinkCount": 0,
        "isActive": True,
    }
    value.update(overrides)
    return value


def _user(**overrides: Any) -> dict[str, Any]:
    value = {
        "id": "member",
        "monthlyStats": {},
        "unlockedBadges": {},
        "endOfDayBoundary": {"hour": 6, "minute": 0},
    }
    value.update(overrides)
    return value


def _drink_type(
    category: str = "beer", percentage: float = 5.0, user_id: str = "global"
) -> dict[str, Any]:
    return {
        "userId": user_id,
        "deletedAt": None,
        "name": category.title(),
        "category": category,
        "alcoholPercentage": percentage,
    }


def _request(command_id: str, **overrides: Any) -> Request:
    data = {
        "sessionId": "party-a",
        "commandId": command_id,
        "drinkId": "drink-a",
        "drinkTypeId": "beer-type",
        "consumedAt": "2026-01-02T02:00:00+00:00",
        "volumeInMilliliters": 500,
        "location": {"latitude": 49.2, "longitude": 16.6},
    }
    data.update(overrides)
    return Request(Auth("member"), data)


def _base_store() -> dict[str, dict[str, Any]]:
    return {
        "sessions/party-a": _session(),
        "parties/party-a": _party(),
        "parties/party-a/members/member": _member(),
        "users/member": _user(),
        "drink_types/beer-type": _drink_type(),
        "drink_types/wine-type": _drink_type("wine", 12.0, "member"),
    }


def test_create_snapshots_class_scores_stats_and_is_idempotent() -> None:
    db = Database(_base_store())
    transaction = Transaction(db.store)
    request = _request("create-a")

    result = create_party_drink_command(
        request,
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(transaction),
    )
    retry = create_party_drink_command(
        request,
        db,
        now_provider=lambda: pytest.fail("retry evaluated command"),
        transaction_runner=_runner(transaction),
    )

    assert retry == result
    assert result["baseScoreUnits"] == 25_000
    assert result["classBonusUnits"] == 2_500
    assert result["awardedScoreUnits"] == 27_500
    drink = db.store["sessions/party-a"]["drinks"][0]
    assert drink["partyRevision"] == 1
    assert drink["drinkType"] == {
        "name": "Beer",
        "category": "beer",
        "alcoholPercentage": 5.0,
    }
    event = db.store["parties/party-a/events/drink:drink-a:v:1"]
    assert event["payload"]["selectedClass"] == "beer"
    assert event["payload"]["classVersion"] == 3
    assert event["payload"]["appliedMultiplier"] == 1.1
    assert db.store["parties/party-a/members/member"]["scoreUnits"] == 27_500
    assert db.store["parties/party-a/members/member"]["drinkCount"] == 1
    stats = db.store["users/member"]["monthlyStats"]["2026_1"]
    assert stats["beersConsumed"] == 1
    assert stats["alcoholConsumedMl"] == 25
    assert stats["dailyStats"]["1"]["beersAfter6pm"] == 1
    assert (
        transaction.created_paths.count("parties/party-a/events/drink:drink-a:v:1") == 1
    )


def test_missing_or_mismatched_class_gets_base_only() -> None:
    for selected_class in (None, "wine"):
        store = _base_store()
        store["parties/party-a/members/member"]["selectedClass"] = selected_class
        db = Database(store)

        result = create_party_drink_command(
            _request(f"create-{selected_class}"),
            db,
            now_provider=lambda: NOW,
            transaction_runner=_runner(Transaction(db.store)),
        )

        assert result["awardedScoreUnits"] == 25_000
        assert result["classBonusUnits"] == 0


def test_competing_create_command_cannot_duplicate_drink_score_or_stats() -> None:
    db = Database(_base_store())
    create_party_drink_command(
        _request("create-first"),
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(Transaction(db.store)),
    )

    with pytest.raises(https_fn.HttpsError) as error:
        create_party_drink_command(
            _request("create-competing"),
            db,
            now_provider=lambda: NOW,
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == https_fn.FunctionsErrorCode.ALREADY_EXISTS
    assert len(db.store["sessions/party-a"]["drinks"]) == 1
    assert db.store["parties/party-a/members/member"]["scoreUnits"] == 27_500
    assert db.store["users/member"]["monthlyStats"]["2026_1"]["beersConsumed"] == 1


def test_update_reverses_active_revision_and_replaces_stats_and_award() -> None:
    db = Database(_base_store())
    create_party_drink_command(
        _request("create-a"),
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(Transaction(db.store)),
    )
    request = _request(
        "update-a",
        drinkTypeId="wine-type",
        consumedAt="2026-01-01T20:00:00+00:00",
        volumeInMilliliters=200,
        location=None,
    )

    result = update_party_drink_command(
        request,
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(Transaction(db.store)),
    )

    assert result["awardEventId"] == "drink:drink-a:v:2"
    assert result["reversalEventId"] == "reversal:drink%3Adrink-a%3Av%3A1"
    assert result["awardedScoreUnits"] == 24_000
    drink = db.store["sessions/party-a"]["drinks"][0]
    assert drink["partyRevision"] == 2
    assert drink["drinkType"]["category"] == "wine"
    reversal = db.store["parties/party-a/events/reversal:drink%3Adrink-a%3Av%3A1"]
    assert reversal["pointsUnits"] == -27_500
    assert reversal["reversesEventId"] == "drink:drink-a:v:1"
    assert db.store["parties/party-a/members/member"]["scoreUnits"] == 24_000
    assert db.store["parties/party-a/members/member"]["drinkCount"] == 1
    stats = db.store["users/member"]["monthlyStats"]["2026_1"]
    assert stats["beersConsumed"] == 0
    assert stats["alcoholConsumedMl"] == 24


def test_delete_reverses_once_and_retry_does_not_repeat_side_effects() -> None:
    db = Database(_base_store())
    create_party_drink_command(
        _request("create-a"),
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(Transaction(db.store)),
    )
    request = _request("delete-a")
    transaction = Transaction(db.store)

    result = delete_party_drink_command(
        request,
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(transaction),
    )
    retry = delete_party_drink_command(
        request,
        db,
        now_provider=lambda: pytest.fail("retry evaluated command"),
        transaction_runner=_runner(transaction),
    )

    assert retry == result
    assert db.store["sessions/party-a"]["drinks"] == []
    assert db.store["parties/party-a/members/member"]["scoreUnits"] == 0
    assert db.store["parties/party-a/members/member"]["drinkCount"] == 0
    stats = db.store["users/member"]["monthlyStats"]["2026_1"]
    assert stats["beersConsumed"] == 0
    assert stats["alcoholConsumedMl"] == 0
    assert (
        transaction.created_paths.count(
            "parties/party-a/events/reversal:drink%3Adrink-a%3Av%3A1"
        )
        == 1
    )


@pytest.mark.parametrize(
    ("store_change", "request_change", "expected_code"),
    [
        (
            lambda store: store["parties/party-a"].update(status="archived"),
            {},
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            lambda store: store["sessions/party-a"].update(
                drinks=[{"id": str(index)} for index in range(1_000)]
            ),
            {},
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            lambda store: None,
            {"consumedAt": "2026-01-02T07:00:00+00:00"},
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
        ),
        (
            lambda store: store["drink_types/beer-type"].update(userId="other"),
            {},
            https_fn.FunctionsErrorCode.PERMISSION_DENIED,
        ),
    ],
)
def test_create_validates_archive_capacity_time_and_drink_type_ownership(
    store_change: Any,
    request_change: dict[str, Any],
    expected_code: https_fn.FunctionsErrorCode,
) -> None:
    store = _base_store()
    store_change(store)
    db = Database(store)

    with pytest.raises(https_fn.HttpsError) as error:
        create_party_drink_command(
            _request("invalid-a", **request_change),
            db,
            now_provider=lambda: NOW,
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == expected_code


def test_update_rejects_another_members_drink() -> None:
    other_drink = {
        "id": "drink-a",
        "consumedByUserId": "owner",
        "consumedAt": "2026-01-01T20:00:00+00:00",
        "drinkType": {
            "name": "Beer",
            "category": "beer",
            "alcoholPercentage": 5.0,
        },
        "volumeInMilliliters": 500,
        "partyRevision": 1,
    }
    store = _base_store()
    store["sessions/party-a"]["drinks"] = [other_drink]
    db = Database(store)

    with pytest.raises(https_fn.HttpsError) as error:
        update_party_drink_command(
            _request("update-other"),
            db,
            now_provider=lambda: NOW,
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == https_fn.FunctionsErrorCode.PERMISSION_DENIED
