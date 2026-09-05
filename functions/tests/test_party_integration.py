from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any

from party_commands import (
    activate_party_command,
    archive_party_command,
    select_party_class_command,
)
from party_drinks import create_party_drink_command

from tests.fakes import Database, Transaction


@dataclass
class Auth:
    uid: str


@dataclass
class Request:
    auth: Auth
    data: dict[str, Any]


def _run(db: Database):  # type: ignore[no-untyped-def]
    return lambda callback: callback(Transaction(db.store))


def test_activation_class_scoring_retry_and_archive_flow() -> None:
    db = Database(
        {
            "sessions/party-a": {
                "userId": "owner",
                "memberIds": ["owner", "member"],
                "adminIds": ["owner"],
                "bannedMemberIds": [],
                "isSoloSession": False,
                "isParty": False,
                "startedAt": "2026-01-01T18:00:00+00:00",
                "endedAt": None,
                "drinks": [],
            },
            "users/member": {
                "monthlyStats": {},
                "unlockedBadges": {},
                "endOfDayBoundary": {"hour": 6, "minute": 0},
            },
            "drink_types/beer-type": {
                "userId": "global",
                "deletedAt": None,
                "name": "Beer",
                "category": "beer",
                "alcoholPercentage": 5.0,
            },
        }
    )
    notifications: list[dict[str, Any]] = []

    activate_party_command(
        Request(
            Auth("owner"),
            {"sessionId": "party-a", "commandId": "activate-a"},
        ),
        db,
        notification_dispatcher=lambda *args, **kwargs: notifications.append(kwargs),
        transaction_runner=_run(db),
    )
    select_party_class_command(
        Request(
            Auth("member"),
            {
                "sessionId": "party-a",
                "commandId": "class-a",
                "selectedClass": "beer",
            },
        ),
        db,
        transaction_runner=_run(db),
    )
    drink_request = Request(
        Auth("member"),
        {
            "sessionId": "party-a",
            "commandId": "drink-a",
            "drinkId": "drink-a",
            "drinkTypeId": "beer-type",
            "consumedAt": "2026-01-02T02:00:00+00:00",
            "volumeInMilliliters": 500,
            "location": None,
        },
    )
    first = create_party_drink_command(
        drink_request,
        db,
        now_provider=lambda: datetime(2026, 1, 2, 3, tzinfo=timezone.utc),
        transaction_runner=_run(db),
    )
    retry = create_party_drink_command(
        drink_request,
        db,
        now_provider=lambda: datetime(2026, 1, 2, 4, tzinfo=timezone.utc),
        transaction_runner=_run(db),
    )
    archive_party_command(
        Request(
            Auth("owner"),
            {
                "sessionId": "party-a",
                "commandId": "archive-a",
                "endedAt": "2026-01-02T05:00:00+00:00",
            },
        ),
        db,
        notification_dispatcher=lambda *args, **kwargs: notifications.append(kwargs),
        transaction_runner=_run(db),
    )

    assert retry == first
    assert first["awardedScoreUnits"] == 27_500
    assert len(db.store["sessions/party-a"]["drinks"]) == 1
    assert db.store["parties/party-a/members/member"]["scoreUnits"] == 27_500
    assert db.store["parties/party-a"]["status"] == "archived"
    assert db.store["sessions/party-a"]["endedAt"] == "2026-01-02T05:00:00+00:00"
    assert len(notifications) == 2
