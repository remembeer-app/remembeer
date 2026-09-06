from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from typing import Any

import pytest
from firebase_functions import https_fn
from party_challenges import set_party_module_settings_command
from party_quests import (
    select_quest_partner_command,
    set_party_quest_schedule_command,
    set_quest_template_enabled_command,
)
from party_scoring import canonical_pair_key

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

    def __call__(self, _db: Any, recipients: Any, **values: Any) -> dict[str, Any]:
        self.calls.append({"recipients": list(recipients), **values})
        return {}


def _runner(transaction: Transaction):  # type: ignore[no-untyped-def]
    return lambda callback: callback(transaction)


def _party(**overrides: Any) -> dict[str, Any]:
    value = {
        "status": "active",
        "moduleSettings": {
            "socialQuestsEnabled": True,
            "adminChallengesEnabled": False,
            "beerpongEnabled": False,
        },
        "questSchedule": {
            "minIntervalMinutes": 15,
            "maxIntervalMinutes": 45,
            "defaultDurationMinutes": 15,
            "nextQuestAt": NOW + timedelta(minutes=5),
        },
        "activeQuestId": "quest-a",
    }
    value.update(overrides)
    return value


def _base_store(*, active_quest: bool = True) -> dict[str, dict[str, Any]]:
    store = {
        "sessions/party-a": {
            "userId": "owner",
            "memberIds": ["owner", "a", "b", "c"],
            "adminIds": ["owner"],
        },
        "parties/party-a": _party(activeQuestId="quest-a" if active_quest else None),
    }
    for user_id in ("owner", "a", "b", "c"):
        store[f"parties/party-a/members/{user_id}"] = {
            "userId": user_id,
            "scoreUnits": 0,
            "drinkCount": 0,
            "isActive": True,
            "selectedClass": "beer",
        }
    if active_quest:
        pairs = [
            canonical_pair_key("a", "b"),
            canonical_pair_key("a", "c"),
            canonical_pair_key("b", "c"),
        ]
        store["parties/party-a/quests/quest-a"] = {
            "templateId": "custom-a",
            "titleSnapshot": "Toast",
            "instructionsSnapshot": "Find a partner.",
            "pointsUnits": 25_000,
            "startsAt": NOW - timedelta(minutes=1),
            "endsAt": NOW + timedelta(minutes=5),
            "status": "active",
            "eligibleMemberIds": ["a", "b", "c"],
            "eligiblePairKeys": pairs,
            "completedPairKeys": [],
        }
    return store


def _request(command_id: str, *, actor: str = "owner", **values: Any) -> Request:
    return Request(
        Auth(actor),
        {"sessionId": "party-a", "commandId": command_id, **values},
    )


def test_schedule_settings_are_bounded_admin_only_and_idempotent() -> None:
    db = Database(_base_store(active_quest=False))
    request = _request(
        "schedule-a",
        questSchedule={
            "minIntervalMinutes": 5,
            "maxIntervalMinutes": 180,
            "defaultDurationMinutes": 60,
            "nextQuestAt": NOW - timedelta(days=1),
        },
    )
    transaction = Transaction(db.store)
    result = set_party_quest_schedule_command(
        request,
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(transaction),
    )
    retry = set_party_quest_schedule_command(
        request,
        db,
        now_provider=lambda: pytest.fail("retry ran operation"),
        transaction_runner=_runner(transaction),
    )
    assert retry == result
    assert result["questSchedule"]["nextQuestAt"] == NOW + timedelta(minutes=5)
    assert transaction.updated_paths.count("parties/party-a") == 1

    request.auth = Auth("a")
    request.data["commandId"] = "not-admin"
    with pytest.raises(https_fn.HttpsError) as error:
        set_party_quest_schedule_command(
            request, db, transaction_runner=_runner(Transaction(db.store))
        )
    assert error.value.code == https_fn.FunctionsErrorCode.PERMISSION_DENIED


@pytest.mark.parametrize(
    "schedule",
    [
        {
            "minIntervalMinutes": 4,
            "maxIntervalMinutes": 10,
            "defaultDurationMinutes": 5,
        },
        {
            "minIntervalMinutes": 5,
            "maxIntervalMinutes": 181,
            "defaultDurationMinutes": 5,
        },
        {
            "minIntervalMinutes": 20,
            "maxIntervalMinutes": 10,
            "defaultDurationMinutes": 5,
        },
        {
            "minIntervalMinutes": 5,
            "maxIntervalMinutes": 10,
            "defaultDurationMinutes": 0,
        },
        {
            "minIntervalMinutes": 5,
            "maxIntervalMinutes": 10,
            "defaultDurationMinutes": 61,
        },
    ],
)
def test_schedule_rejects_invalid_bounds(schedule: dict[str, int]) -> None:
    with pytest.raises(https_fn.HttpsError) as error:
        set_party_quest_schedule_command(
            _request("schedule-a", questSchedule=schedule),
            Database(_base_store(active_quest=False)),
        )
    assert error.value.code == https_fn.FunctionsErrorCode.INVALID_ARGUMENT


def test_social_module_toggle_initializes_clears_and_protects_schedule() -> None:
    store = _base_store(active_quest=False)
    store["parties/party-a"]["moduleSettings"]["socialQuestsEnabled"] = False
    store["parties/party-a"]["questSchedule"]["nextQuestAt"] = None
    db = Database(store)
    enabled_settings = {
        "socialQuestsEnabled": True,
        "adminChallengesEnabled": False,
        "beerpongEnabled": False,
    }
    set_party_module_settings_command(
        _request("enable", moduleSettings=enabled_settings),
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(Transaction(db.store)),
    )
    assert db.store["parties/party-a"]["questSchedule"]["nextQuestAt"] == (
        NOW + timedelta(minutes=15)
    )

    disabled_settings = {**enabled_settings, "socialQuestsEnabled": False}
    set_party_module_settings_command(
        _request("disable", moduleSettings=disabled_settings),
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(Transaction(db.store)),
    )
    assert db.store["parties/party-a"]["questSchedule"]["nextQuestAt"] is None

    db.store["parties/party-a"]["moduleSettings"] = enabled_settings
    db.store["parties/party-a"]["activeQuestId"] = "quest-a"
    with pytest.raises(https_fn.HttpsError) as error:
        set_party_module_settings_command(
            _request("unsafe-disable", moduleSettings=disabled_settings),
            db,
            now_provider=lambda: NOW,
            transaction_runner=_runner(Transaction(db.store)),
        )
    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION


def test_only_built_in_templates_can_be_enabled_or_disabled() -> None:
    db = Database(_base_store(active_quest=False))
    db.store["parties/party-a/questTemplates/builtin"] = {
        "source": "builtIn",
        "enabled": True,
    }
    set_quest_template_enabled_command(
        _request("disable-a", templateId="builtin", enabled=False),
        db,
        transaction_runner=_runner(Transaction(db.store)),
    )
    assert db.store["parties/party-a/questTemplates/builtin"]["enabled"] is False

    db.store["parties/party-a/questTemplates/legacy-custom"] = {
        "source": "custom",
        "enabled": True,
    }
    with pytest.raises(https_fn.HttpsError) as error:
        set_quest_template_enabled_command(
            _request("disable-custom", templateId="legacy-custom", enabled=False),
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )
    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION


def test_pending_selection_can_change_then_reciprocal_pair_awards_once() -> None:
    store = _base_store()
    store["parties/party-a/quests/quest-a"]["pointsUnits"] = 25_001
    db = Database(store)
    notifications = Notifications()
    first = select_quest_partner_command(
        _request("select-a-c", actor="a", questId="quest-a", selectedUserId="c"),
        db,
        now_provider=lambda: NOW,
        notification_dispatcher=notifications,
        transaction_runner=_runner(Transaction(db.store)),
    )
    assert first["matched"] is False
    changed = select_quest_partner_command(
        _request("select-a-b", actor="a", questId="quest-a", selectedUserId="b"),
        db,
        now_provider=lambda: NOW,
        notification_dispatcher=notifications,
        transaction_runner=_runner(Transaction(db.store)),
    )
    assert changed["matched"] is False
    request = _request("select-b-a", actor="b", questId="quest-a", selectedUserId="a")
    transaction = Transaction(db.store)
    matched = select_quest_partner_command(
        request,
        db,
        now_provider=lambda: NOW,
        notification_dispatcher=notifications,
        transaction_runner=_runner(transaction),
    )
    retry = select_quest_partner_command(
        request,
        db,
        now_provider=lambda: pytest.fail("retry ran operation"),
        notification_dispatcher=notifications,
        transaction_runner=_runner(transaction),
    )
    assert retry == matched
    assert matched["matched"] is True
    assert db.store["parties/party-a/members/a"]["scoreUnits"] == 12_501
    assert db.store["parties/party-a/members/b"]["scoreUnits"] == 12_500
    assert len(matched["awardEventIds"]) == 2
    assert all(":allocation:v:2:member:" in value for value in matched["awardEventIds"])
    events = [
        db.store[f"parties/party-a/events/{event_id}"]
        for event_id in matched["awardEventIds"]
    ]
    assert all(event["participantIds"] == ["a", "b"] for event in events)
    assert [event["pointsUnits"] for event in events] == [12_501, 12_500]
    assert events[0]["payload"]["allocation"] == {
        "version": 2,
        "totalPointsUnits": 25_001,
        "recipientCount": 2,
        "recipientIndex": 0,
        "basePointsUnits": 12_500,
        "remainderUnits": 1,
    }
    assert len(notifications.calls) == 1
    assert notifications.calls[0]["data"]["type"] == "party_quest_completed"


def test_completed_pair_is_immutable_and_competing_completion_cannot_award() -> None:
    db = Database(_base_store())
    for actor, selected, command in (("a", "b", "a-b"), ("b", "a", "b-a")):
        select_quest_partner_command(
            _request(command, actor=actor, questId="quest-a", selectedUserId=selected),
            db,
            now_provider=lambda: NOW,
            notification_dispatcher=Notifications(),
            transaction_runner=_runner(Transaction(db.store)),
        )
    with pytest.raises(https_fn.HttpsError) as error:
        select_quest_partner_command(
            _request("a-c", actor="a", questId="quest-a", selectedUserId="c"),
            db,
            now_provider=lambda: NOW,
            transaction_runner=_runner(Transaction(db.store)),
        )
    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION
    assert db.store["parties/party-a/members/a"]["scoreUnits"] == 12_500


@pytest.mark.parametrize(
    "change",
    [
        lambda store: store["parties/party-a"].update(status="archived"),
        lambda store: store["parties/party-a"]["moduleSettings"].update(
            socialQuestsEnabled=False
        ),
        lambda store: store["parties/party-a/quests/quest-a"].update(status="expired"),
        lambda store: store["parties/party-a/quests/quest-a"].update(endsAt=NOW),
        lambda store: store["parties/party-a/quests/quest-a"].update(
            eligibleMemberIds=["a"]
        ),
        lambda store: store["parties/party-a/quests/quest-a"].update(
            eligiblePairKeys=[]
        ),
    ],
)
def test_selection_rejects_inactive_disabled_expired_and_ineligible(
    change: Any,
) -> None:
    store = _base_store()
    change(store)
    db = Database(store)
    with pytest.raises(https_fn.HttpsError) as error:
        select_quest_partner_command(
            _request("a-b", actor="a", questId="quest-a", selectedUserId="b"),
            db,
            now_provider=lambda: NOW,
            transaction_runner=_runner(Transaction(db.store)),
        )
    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION
