from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from typing import Any

import pytest
from firebase_functions import https_fn
from party_scheduler import run_party_scheduler, start_next_party_quest_command
from party_scoring import canonical_pair_key

from tests.fakes import Database, Snapshot, Transaction

NOW = datetime(2026, 1, 2, 1, tzinfo=timezone.utc)


@dataclass
class Auth:
    uid: str


@dataclass
class Request:
    auth: Auth | None
    data: dict[str, Any]


class PredictableRandom:
    @staticmethod
    def randint(minimum: int, _maximum: int) -> int:
        return minimum

    @staticmethod
    def choice(values: list[Any]) -> Any:
        return values[0]


class Notifications:
    def __init__(self) -> None:
        self.calls: list[dict[str, Any]] = []

    def __call__(self, _db: Any, recipients: Any, **values: Any) -> dict[str, Any]:
        self.calls.append({"recipients": list(recipients), **values})
        return {}


def _runner(db: Database):  # type: ignore[no-untyped-def]
    return lambda callback: callback(Transaction(db.store))


def _request(command_id: str, *, actor: str | None = "a") -> Request:
    return Request(
        Auth(actor) if actor is not None else None,
        {"sessionId": "party-a", "commandId": command_id},
    )


def _party(**overrides: Any) -> dict[str, Any]:
    value = {
        "status": "active",
        "moduleSettings": {"socialQuestsEnabled": True},
        "questSchedule": {
            "minIntervalMinutes": 5,
            "maxIntervalMinutes": 20,
            "defaultDurationMinutes": 15,
            "nextQuestAt": NOW - timedelta(minutes=1),
        },
        "activeQuestId": None,
        "questCycleHistory": [],
        "activeChallengeId": None,
    }
    value.update(overrides)
    return value


def _base_store(*, selected_b: str | None = "wine") -> dict[str, dict[str, Any]]:
    store = {
        "sessions/party-a": {
            "memberIds": ["a", "b", "unselected"],
            "adminIds": ["a"],
            "userId": "a",
        },
        "parties/party-a": _party(),
        "parties/party-a/questTemplates/template-a": {
            "source": "builtIn",
            "title": "Contrast",
            "instructions": "Find another class.",
            "pointsUnits": 20_000,
            "durationMinutes": 10,
            "eligibilityRule": "differentClass",
            "availability": "early",
            "enabled": True,
        },
        "parties/party-a/questTemplates/disabled": {
            "source": "custom",
            "title": "Disabled",
            "instructions": "Never selected.",
            "pointsUnits": 20_000,
            "durationMinutes": 10,
            "eligibilityRule": "allEligibleMembers",
            "enabled": False,
        },
    }
    for user_id, selected_class, accent in (
        ("a", "beer", "amber"),
        ("b", selected_b, "rose"),
        ("unselected", None, "blue"),
    ):
        store[f"parties/party-a/members/{user_id}"] = {
            "userId": user_id,
            "selectedClass": selected_class,
            "scoreUnits": 0,
            "drinkCount": 0,
            "isActive": True,
        }
        store[f"users/{user_id}"] = {
            "username": user_id.upper(),
            "accentColorKey": accent,
        }
    return store


def _snapshot(db: Database, path: str) -> Snapshot:
    return (
        db.collection(path.split("/", maxsplit=1)[0])
        .document(path.split("/", maxsplit=1)[1])
        .get()
    )


def _none(_db: Any, _now: datetime) -> list[Any]:
    return []


def _run(
    db: Database, notifications: Notifications, **providers: Any
) -> dict[str, int]:
    return dict(
        run_party_scheduler(
            db,
            now_provider=lambda: NOW,
            random_source=PredictableRandom(),  # type: ignore[arg-type]
            due_party_provider=providers.get(
                "due", lambda current, _now: [_snapshot(current, "parties/party-a")]
            ),
            expired_quest_provider=providers.get("quests", _none),
            expired_challenge_provider=providers.get("challenges", _none),
            notification_dispatcher=notifications,
            transaction_runner_factory=_runner(db),
        )
    )


def test_due_party_claim_creates_snapshot_advances_schedule_and_notifies() -> None:
    db = Database(_base_store())
    notifications = Notifications()
    result = _run(db, notifications)
    assert result["createdQuests"] == 1
    party = db.store["parties/party-a"]
    quest_id = party["activeQuestId"]
    quest = db.store[f"parties/party-a/quests/{quest_id}"]
    assert quest["templateId"] == "template-a"
    assert quest["eligibleMemberIds"] == ["a", "b"]
    assert quest["eligiblePairKeys"] == [canonical_pair_key("a", "b")]
    assert quest["eligibilityRuleSnapshot"] == "differentClass"
    assert quest["targetClassMemberIds"] == []
    assert quest["endsAt"] == NOW + timedelta(minutes=10)
    assert party["questSchedule"]["nextQuestAt"] == NOW + timedelta(minutes=5)
    assert len(notifications.calls) == 1
    assert notifications.calls[0]["recipients"] == ["a", "b"]
    assert notifications.calls[0]["data"]["sourceId"] == quest_id


def test_duplicate_due_snapshots_and_retry_do_not_duplicate_quest_or_dispatch() -> None:
    db = Database(_base_store())
    notifications = Notifications()

    def duplicates(current: Database, _now: datetime) -> list[Snapshot]:
        snapshot = _snapshot(current, "parties/party-a")
        return [snapshot, snapshot]

    result = _run(db, notifications, due=duplicates)
    assert result["createdQuests"] == 1
    assert result["skippedParties"] == 1
    assert (
        len([path for path in db.store if path.startswith("parties/party-a/quests/")])
        == 1
    )
    assert len(notifications.calls) == 1

    retry = _run(db, notifications)
    assert retry["createdQuests"] == 0
    assert len(notifications.calls) == 1


def test_insufficient_eligibility_advances_without_creating_or_notifying() -> None:
    db = Database(_base_store(selected_b="beer"))
    notifications = Notifications()
    result = _run(db, notifications)
    assert result["advancedParties"] == 1
    assert db.store["parties/party-a"]["activeQuestId"] is None
    assert db.store["parties/party-a"]["questSchedule"]["nextQuestAt"] == (
        NOW + timedelta(minutes=5)
    )
    assert notifications.calls == []
    assert db.store["parties/party-a"]["questCycleHistory"] == ["template-a"]


def test_no_enabled_template_advances_schedule() -> None:
    store = _base_store()
    store["parties/party-a/questTemplates/template-a"]["enabled"] = False
    db = Database(store)
    result = _run(db, Notifications())
    assert result["advancedParties"] == 1
    assert db.store["parties/party-a"]["activeQuestId"] is None


def test_scheduler_ignores_enabled_legacy_custom_templates() -> None:
    store = _base_store()
    store["parties/party-a/questTemplates/template-a"]["enabled"] = False
    store["parties/party-a/questTemplates/legacy-custom"] = {
        "source": "custom",
        "title": "Legacy",
        "instructions": "Must not run.",
        "pointsUnits": 20_000,
        "durationMinutes": 10,
        "eligibilityRule": "allEligibleMembers",
        "availability": "early",
        "enabled": True,
    }
    db = Database(store)
    result = _run(db, Notifications())
    assert result["advancedParties"] == 1
    assert db.store["parties/party-a"]["activeQuestId"] is None
    assert not any(path.startswith("parties/party-a/quests/") for path in db.store)


def test_immediate_start_is_successful_idempotent_and_notifies_once() -> None:
    db = Database(_base_store())
    notifications = Notifications()
    request = _request("start-a")
    transaction = Transaction(db.store)
    result = start_next_party_quest_command(
        request,
        db,
        now_provider=lambda: NOW,
        random_source=PredictableRandom(),  # type: ignore[arg-type]
        notification_dispatcher=notifications,
        transaction_runner=lambda callback: callback(transaction),
    )
    retry = start_next_party_quest_command(
        request,
        db,
        now_provider=lambda: pytest.fail("retry ran operation"),
        random_source=PredictableRandom(),  # type: ignore[arg-type]
        notification_dispatcher=notifications,
        transaction_runner=lambda callback: callback(transaction),
    )
    assert retry == result
    assert result["started"] is True
    assert result["templateId"] == "template-a"
    assert result["questId"] == "manual-start-a"
    assert db.store["parties/party-a"]["activeQuestId"] == "manual-start-a"
    assert db.store["parties/party-a"]["questSchedule"]["nextQuestAt"] == (
        NOW + timedelta(minutes=5)
    )
    assert transaction.created_paths.count("parties/party-a/quests/manual-start-a") == 1
    assert len(notifications.calls) == 1
    assert notifications.calls[0]["data"]["type"] == "party_quest_started"


def test_immediate_start_requires_authentication_and_admin_access() -> None:
    db = Database(_base_store())
    with pytest.raises(https_fn.HttpsError) as unauthenticated:
        start_next_party_quest_command(_request("missing-auth", actor=None), db)
    assert unauthenticated.value.code == https_fn.FunctionsErrorCode.UNAUTHENTICATED

    with pytest.raises(https_fn.HttpsError) as forbidden:
        start_next_party_quest_command(
            _request("not-admin", actor="b"),
            db,
            transaction_runner=_runner(db),
        )
    assert forbidden.value.code == https_fn.FunctionsErrorCode.PERMISSION_DENIED


@pytest.mark.parametrize("precondition", ["disabled", "active"])
def test_immediate_start_rejects_party_preconditions(precondition: str) -> None:
    store = _base_store()
    if precondition == "disabled":
        store["parties/party-a"]["moduleSettings"]["socialQuestsEnabled"] = False
    else:
        store["parties/party-a"]["activeQuestId"] = "existing"
    db = Database(store)
    with pytest.raises(https_fn.HttpsError) as error:
        start_next_party_quest_command(
            _request(f"start-{precondition}"),
            db,
            transaction_runner=_runner(db),
        )
    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION


def test_immediate_start_does_not_retry_after_selected_template_is_ineligible() -> None:
    store = _base_store(selected_b="beer")
    original_next = store["parties/party-a"]["questSchedule"]["nextQuestAt"]
    store["parties/party-a/questTemplates/z-eligible-second"] = {
        "source": "builtIn",
        "title": "Any pair",
        "instructions": "Find anyone.",
        "pointsUnits": 20_000,
        "durationMinutes": 10,
        "eligibilityRule": "allEligibleMembers",
        "availability": "early",
        "enabled": True,
    }
    db = Database(store)
    notifications = Notifications()
    result = start_next_party_quest_command(
        _request("ineligible"),
        db,
        now_provider=lambda: NOW,
        random_source=PredictableRandom(),  # type: ignore[arg-type]
        notification_dispatcher=notifications,
        transaction_runner=_runner(db),
    )
    assert result == {
        "sessionId": "party-a",
        "started": False,
        "reason": "insufficientEligibility",
        "templateId": "template-a",
    }
    assert db.store["parties/party-a"]["activeQuestId"] is None
    assert db.store["parties/party-a"]["questSchedule"]["nextQuestAt"] == original_next
    assert notifications.calls == []
    assert db.store["parties/party-a"]["questCycleHistory"] == []


def _add_template(
    store: dict[str, dict[str, Any]],
    template_id: str,
    availability: str,
    *,
    enabled: bool = True,
    rule: str = "differentClass",
) -> None:
    store[f"parties/party-a/questTemplates/{template_id}"] = {
        "source": "builtIn",
        "title": template_id,
        "instructions": "Have a toast and select each other.",
        "pointsUnits": 20_000,
        "durationMinutes": 10,
        "eligibilityRule": rule,
        "availability": availability,
        "enabled": enabled,
    }


@pytest.mark.parametrize(
    ("history_size", "expected_template"),
    [(4, "z-early"), (5, "a-regular"), (10, "a-final")],
)
def test_successful_start_count_filters_availability_phase(
    history_size: int,
    expected_template: str,
) -> None:
    store = _base_store()
    del store["parties/party-a/questTemplates/template-a"]
    store["parties/party-a"]["questCycleHistory"] = [
        f"used-{index}" for index in range(history_size)
    ]
    _add_template(store, "z-early", "early")
    _add_template(store, "a-regular", "regular")
    _add_template(store, "a-final", "final")
    db = Database(store)

    result = start_next_party_quest_command(
        _request(f"phase-{history_size}"),
        db,
        now_provider=lambda: NOW,
        random_source=PredictableRandom(),  # type: ignore[arg-type]
        notification_dispatcher=Notifications(),
        transaction_runner=_runner(db),
    )

    assert result["templateId"] == expected_template


def test_repeated_history_entries_still_unlock_the_regular_phase() -> None:
    store = _base_store()
    del store["parties/party-a/questTemplates/template-a"]
    store["parties/party-a"]["questCycleHistory"] = ["same-template"] * 5
    _add_template(store, "z-early", "early")
    _add_template(store, "a-regular", "regular")
    db = Database(store)

    result = start_next_party_quest_command(
        _request("repeated-history"),
        db,
        now_provider=lambda: NOW,
        random_source=PredictableRandom(),  # type: ignore[arg-type]
        notification_dispatcher=Notifications(),
        transaction_runner=_runner(db),
    )

    assert result["templateId"] == "a-regular"


def test_cycle_prefers_unused_unlocked_template() -> None:
    store = _base_store()
    store["parties/party-a"]["questCycleHistory"] = ["template-a"]
    _add_template(store, "z-unused", "early")
    db = Database(store)

    result = start_next_party_quest_command(
        _request("unused"),
        db,
        now_provider=lambda: NOW,
        random_source=PredictableRandom(),  # type: ignore[arg-type]
        notification_dispatcher=Notifications(),
        transaction_runner=_runner(db),
    )

    assert result["templateId"] == "z-unused"
    assert db.store["parties/party-a"]["questCycleHistory"] == [
        "template-a",
        "z-unused",
    ]


def test_disabled_unused_pool_falls_back_to_repeat_and_advances_history() -> None:
    store = _base_store()
    store["parties/party-a"]["questCycleHistory"] = ["template-a"]
    _add_template(store, "unused-disabled", "early", enabled=False)
    db = Database(store)

    result = start_next_party_quest_command(
        _request("repeat"),
        db,
        now_provider=lambda: NOW,
        random_source=PredictableRandom(),  # type: ignore[arg-type]
        notification_dispatcher=Notifications(),
        transaction_runner=_runner(db),
    )

    assert result["templateId"] == "template-a"
    assert db.store["parties/party-a"]["questCycleHistory"] == [
        "template-a",
        "template-a",
    ]


def test_eighteenth_successful_start_resets_cycle_history() -> None:
    store = _base_store()
    store["parties/party-a"]["questCycleHistory"] = [
        f"used-{index}" for index in range(17)
    ]
    store["parties/party-a/questTemplates/template-a"]["enabled"] = False
    _add_template(store, "final-start", "final")
    db = Database(store)

    result = start_next_party_quest_command(
        _request("cycle-reset"),
        db,
        now_provider=lambda: NOW,
        random_source=PredictableRandom(),  # type: ignore[arg-type]
        notification_dispatcher=Notifications(),
        transaction_runner=_runner(db),
    )

    assert result["started"] is True
    assert result["templateId"] == "final-start"
    assert db.store["parties/party-a"]["questCycleHistory"] == []


def test_target_class_members_are_snapshotted_from_creation_candidates() -> None:
    store = _base_store()
    template = store["parties/party-a/questTemplates/template-a"]
    template["eligibilityRule"] = "oneMemberClass:wine"
    db = Database(store)

    result = start_next_party_quest_command(
        _request("target-snapshot"),
        db,
        now_provider=lambda: NOW,
        random_source=PredictableRandom(),  # type: ignore[arg-type]
        notification_dispatcher=Notifications(),
        transaction_runner=_runner(db),
    )
    quest = db.store[f"parties/party-a/quests/{result['questId']}"]

    assert quest["eligibilityRuleSnapshot"] == "oneMemberClass:wine"
    assert quest["targetClassMemberIds"] == ["b"]


def test_disabled_archived_future_and_already_active_parties_are_never_claimed() -> (
    None
):
    changes = [
        lambda party: party.update(status="archived"),
        lambda party: party["moduleSettings"].update(socialQuestsEnabled=False),
        lambda party: party["questSchedule"].update(
            nextQuestAt=NOW + timedelta(minutes=1)
        ),
        lambda party: party.update(activeQuestId="existing"),
    ]
    for change in changes:
        db = Database(_base_store())
        change(db.store["parties/party-a"])
        result = _run(db, Notifications())
        assert result["createdQuests"] == 0
        assert result["skippedParties"] == 1


def test_expiry_marks_quest_and_challenge_terminal_and_clears_matching_pointers() -> (
    None
):
    store = _base_store()
    store["parties/party-a"].update(
        activeQuestId="quest-old", activeChallengeId="challenge-old"
    )
    store["parties/party-a/quests/quest-old"] = {
        "status": "active",
        "endsAt": NOW,
    }
    store["parties/party-a/challenges/challenge-old"] = {
        "status": "active",
        "endsAt": NOW - timedelta(seconds=1),
        "winnerIds": ["a"],
    }
    db = Database(store)
    result = _run(
        db,
        Notifications(),
        due=_none,
        quests=lambda current, _now: [
            _snapshot(current, "parties/party-a/quests/quest-old")
        ],
        challenges=lambda current, _now: [
            _snapshot(current, "parties/party-a/challenges/challenge-old")
        ],
    )
    assert result["expiredQuests"] == 1
    assert result["expiredChallenges"] == 1
    assert db.store["parties/party-a/quests/quest-old"]["status"] == "expired"
    challenge = db.store["parties/party-a/challenges/challenge-old"]
    assert challenge["status"] == "expired"
    assert challenge["winnerIds"] == ["a"]
    assert db.store["parties/party-a"]["activeQuestId"] is None
    assert db.store["parties/party-a"]["activeChallengeId"] is None


def test_expiry_retry_and_stale_pointer_do_not_rewrite_terminal_history() -> None:
    store = _base_store()
    store["parties/party-a"].update(activeQuestId="newer")
    store["parties/party-a/quests/old"] = {"status": "active", "endsAt": NOW}
    db = Database(store)
    provider = lambda current, _now: [_snapshot(current, "parties/party-a/quests/old")]
    first = _run(db, Notifications(), due=_none, quests=provider)
    second = _run(db, Notifications(), due=_none, quests=provider)
    assert first["expiredQuests"] == 1
    assert second["expiredQuests"] == 0
    assert db.store["parties/party-a"]["activeQuestId"] == "newer"
    assert "parties/party-a/quests/old" in db.store
