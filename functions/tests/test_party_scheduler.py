from datetime import datetime, timedelta, timezone
from typing import Any

from party_scheduler import run_party_scheduler
from party_scoring import canonical_pair_key

from tests.fakes import Database, Snapshot, Transaction

NOW = datetime(2026, 1, 2, 1, tzinfo=timezone.utc)


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


def test_no_enabled_template_advances_schedule() -> None:
    store = _base_store()
    store["parties/party-a/questTemplates/template-a"]["enabled"] = False
    db = Database(store)
    result = _run(db, Notifications())
    assert result["advancedParties"] == 1
    assert db.store["parties/party-a"]["activeQuestId"] is None


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
