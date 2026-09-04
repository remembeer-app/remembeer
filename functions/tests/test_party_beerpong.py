from dataclasses import dataclass
from datetime import datetime, timezone
from hashlib import sha256
from typing import Any

import pytest
from firebase_functions import https_fn
from party_beerpong import (
    correct_beerpong_match_result_command,
    create_beerpong_tournament_command,
    draw_beerpong_tournament_command,
    finalize_beerpong_tournament_command,
    record_beerpong_match_result_command,
    redraw_beerpong_tournament_command,
    rename_beerpong_team_command,
    set_beerpong_opt_in_command,
)
from party_challenges import set_party_module_settings_command

from tests.fakes import Database, Transaction

NOW = datetime(2026, 9, 4, 20, tzinfo=timezone.utc)
SEED = "auditable-seed"
SEED_HASH = sha256(SEED.encode()).hexdigest()


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


def _party(**overrides: Any) -> dict[str, Any]:
    value = {
        "status": "active",
        "moduleSettings": {
            "socialQuestsEnabled": False,
            "adminChallengesEnabled": False,
            "beerpongEnabled": True,
        },
        "activeTournamentId": None,
    }
    value.update(overrides)
    return value


def _store() -> dict[str, dict[str, Any]]:
    members = ["owner", "admin", "member-a", "member-b"]
    store = {
        "sessions/party-a": {
            "userId": "owner",
            "adminIds": ["owner", "admin"],
            "memberIds": members,
            "isParty": True,
        },
        "parties/party-a": _party(),
    }
    for member_id in members:
        store[f"parties/party-a/members/{member_id}"] = {
            "userId": member_id,
            "beerpongOptIn": False,
            "scoreUnits": 0,
            "drinkCount": 0,
            "isActive": True,
        }
    return store


def _request(command_id: str, *, user_id: str = "admin", **values: Any) -> Request:
    data = {
        "sessionId": "party-a",
        "commandId": command_id,
        "tournamentId": "tournament-a",
    }
    data.update(values)
    return Request(Auth(user_id), data)


def _create_request(command_id: str = "create") -> Request:
    return _request(
        command_id,
        teamCount=4,
        thirdPlaceEnabled=True,
        firstPlacePointsUnits=200_000,
        secondPlacePointsUnits=100_000,
        thirdPlacePointsUnits=50_000,
        randomSeedHash=SEED_HASH,
    )


def _command(command: Any, request: Request, db: Database, **options: Any):  # type: ignore[no-untyped-def]
    return command(
        request,
        db,
        now_provider=lambda: NOW,
        transaction_runner=_runner(Transaction(db.store)),
        **options,
    )


def _create_and_enroll(db: Database, notifications: Notifications) -> int:
    result = create_beerpong_tournament_command(
        _create_request(),
        db,
        notification_dispatcher=notifications,
        transaction_runner=_runner(Transaction(db.store)),
    )
    revision = result["revision"]
    for index, member_id in enumerate(("owner", "admin", "member-a", "member-b")):
        result = set_beerpong_opt_in_command(
            _request(
                f"opt-{index}",
                user_id=member_id,
                optedIn=True,
                expectedRevision=revision,
            ),
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )
        revision = result["revision"]
    return revision


def _draw(db: Database, notifications: Notifications, revision: int) -> int:
    result = draw_beerpong_tournament_command(
        _request("draw", expectedRevision=revision, randomSeedReveal=SEED),
        db,
        notification_dispatcher=notifications,
        transaction_runner=_runner(Transaction(db.store)),
    )
    return result["revision"]


def _ready_matches(db: Database) -> list[tuple[str, dict[str, Any]]]:
    prefix = "parties/party-a/tournaments/tournament-a/matches/"
    return [
        (path.rsplit("/", 1)[-1], value)
        for path, value in sorted(db.store.items())
        if path.startswith(prefix) and value["status"] == "ready"
    ]


def _play_all(db: Database, notifications: Notifications, revision: int) -> int:
    index = 0
    while ready := _ready_matches(db):
        match_id, match = ready[0]
        result = _command(
            record_beerpong_match_result_command,
            _request(
                f"result-{index}",
                matchId=match_id,
                winnerTeamId=match["teamAId"],
                expectedRevision=revision,
            ),
            db,
            notification_dispatcher=notifications,
        )
        revision = result["revision"]
        index += 1
    return revision


def test_enrollment_is_self_only_revisioned_idempotent_and_notified_once() -> None:
    db = Database(_store())
    notifications = Notifications()
    transaction = Transaction(db.store)
    request = _create_request()

    created = create_beerpong_tournament_command(
        request,
        db,
        notification_dispatcher=notifications,
        transaction_runner=_runner(transaction),
    )
    retry = create_beerpong_tournament_command(
        request,
        db,
        notification_dispatcher=notifications,
        transaction_runner=_runner(transaction),
    )
    opted = set_beerpong_opt_in_command(
        _request("opt", user_id="member-a", optedIn=True, expectedRevision=0),
        db,
        transaction_runner=_runner(Transaction(db.store)),
    )

    assert retry == created
    assert opted["revision"] == 1
    assert db.store["parties/party-a/members/member-a"]["beerpongOptIn"] is True
    assert db.store["parties/party-a/members/admin"]["beerpongOptIn"] is False
    assert db.store["parties/party-a"]["activeTournamentId"] == "tournament-a"
    assert len(notifications.calls) == 1
    assert notifications.calls[0]["data"]["type"] == "party_beerpong_enrollment"


@pytest.mark.parametrize("team_count", [1, 17])
def test_create_rejects_team_count_outside_two_through_sixteen(
    team_count: int,
) -> None:
    db = Database(_store())
    request = _create_request()
    request.data["teamCount"] = team_count

    with pytest.raises(https_fn.HttpsError) as error:
        create_beerpong_tournament_command(
            request,
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == https_fn.FunctionsErrorCode.INVALID_ARGUMENT


def test_draw_verifies_seed_roster_balancing_and_default_names() -> None:
    db = Database(_store())
    notifications = Notifications()
    revision = _create_and_enroll(db, notifications)

    with pytest.raises(https_fn.HttpsError) as error:
        draw_beerpong_tournament_command(
            _request(
                "bad-draw",
                expectedRevision=revision,
                randomSeedReveal="wrong",
            ),
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )
    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION

    revision = _draw(db, notifications, revision)
    tournament = db.store["parties/party-a/tournaments/tournament-a"]
    teams = [
        value
        for path, value in db.store.items()
        if "/tournaments/tournament-a/teams/" in path
    ]

    assert revision == 5
    assert tournament["status"] == "active"
    assert tournament["randomSeedReveal"] == SEED
    assert sorted(team["name"] for team in teams) == [
        "Team 1",
        "Team 2",
        "Team 3",
        "Team 4",
    ]
    assert sorted(member for team in teams for member in team["memberIds"]) == [
        "admin",
        "member-a",
        "member-b",
        "owner",
    ]
    assert len(notifications.calls[-1]["recipients"]) == 2
    assert notifications.calls[-1]["data"]["type"] == "party_beerpong_match_ready"
    assert notifications.calls[-1]["data"]["sourceId"] == "tournament-a"


def test_redraw_reopens_enrollment_and_rename_stops_after_first_result() -> None:
    db = Database(_store())
    notifications = Notifications()
    revision = _draw(db, notifications, _create_and_enroll(db, notifications))
    renamed = rename_beerpong_team_command(
        _request(
            "rename", teamId="team-1", name="  Champions  ", expectedRevision=revision
        ),
        db,
        transaction_runner=_runner(Transaction(db.store)),
    )
    revision = renamed["revision"]
    match_id, match = _ready_matches(db)[0]
    result = _command(
        record_beerpong_match_result_command,
        _request(
            "first-result",
            matchId=match_id,
            winnerTeamId=match["teamAId"],
            expectedRevision=revision,
        ),
        db,
        notification_dispatcher=notifications,
    )

    assert (
        db.store["parties/party-a/tournaments/tournament-a/teams/team-1"]["name"]
        == "Champions"
    )
    with pytest.raises(https_fn.HttpsError):
        rename_beerpong_team_command(
            _request(
                "late-rename",
                teamId="team-2",
                name="Late",
                expectedRevision=result["revision"],
            ),
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )
    with pytest.raises(https_fn.HttpsError):
        redraw_request = _create_request("late-redraw")
        redraw_request.data["expectedRevision"] = result["revision"]
        redraw_beerpong_tournament_command(
            redraw_request,
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )


def test_redraw_before_results_clears_draw_and_allows_roster_change() -> None:
    db = Database(_store())
    notifications = Notifications()
    revision = _draw(db, notifications, _create_and_enroll(db, notifications))
    new_seed = "new-seed"
    request = _create_request("redraw")
    request.data.update(
        expectedRevision=revision,
        randomSeedHash=sha256(new_seed.encode()).hexdigest(),
    )

    redrawn = redraw_beerpong_tournament_command(
        request,
        db,
        notification_dispatcher=notifications,
        transaction_runner=_runner(Transaction(db.store)),
    )
    opted = set_beerpong_opt_in_command(
        _request(
            "leave-roster",
            user_id="member-b",
            optedIn=False,
            expectedRevision=redrawn["revision"],
        ),
        db,
        transaction_runner=_runner(Transaction(db.store)),
    )

    assert redrawn["status"] == "enrollment"
    assert not any("/matches/" in path for path in db.store)
    assert opted["revision"] == revision + 2


def test_stale_result_race_is_aborted_and_progression_notifies_affected_teams() -> None:
    db = Database(_store())
    notifications = Notifications()
    revision = _draw(db, notifications, _create_and_enroll(db, notifications))
    ready = _ready_matches(db)
    first_id, first = ready[0]
    second_id, second = ready[1]

    result = _command(
        record_beerpong_match_result_command,
        _request(
            "race-a",
            matchId=first_id,
            winnerTeamId=first["teamAId"],
            expectedRevision=revision,
        ),
        db,
        notification_dispatcher=notifications,
    )
    with pytest.raises(https_fn.HttpsError) as error:
        _command(
            record_beerpong_match_result_command,
            _request(
                "race-b",
                matchId=second_id,
                winnerTeamId=second["teamAId"],
                expectedRevision=revision,
            ),
            db,
            notification_dispatcher=notifications,
        )

    assert result["revision"] == revision + 1
    assert error.value.code == https_fn.FunctionsErrorCode.ABORTED
    assert notifications.calls[-1]["data"]["type"] == "party_beerpong_match_result"
    assert notifications.calls[-1]["data"]["sourceId"] == "tournament-a"


def test_finalize_is_exactly_once_and_final_correction_reverses_then_replaces() -> None:
    db = Database(_store())
    notifications = Notifications()
    revision = _draw(db, notifications, _create_and_enroll(db, notifications))
    revision = _play_all(db, notifications, revision)
    request = _request("finalize", expectedRevision=revision)
    transaction = Transaction(db.store)

    finalized = finalize_beerpong_tournament_command(
        request,
        db,
        now_provider=lambda: NOW,
        notification_dispatcher=notifications,
        transaction_runner=_runner(transaction),
    )
    retry = finalize_beerpong_tournament_command(
        request,
        db,
        now_provider=lambda: pytest.fail("retry evaluated command"),
        notification_dispatcher=notifications,
        transaction_runner=_runner(transaction),
    )
    assert retry == finalized
    assert len(finalized["awardEventIds"]) == 3
    assert sorted(
        db.store[f"parties/party-a/members/{member}"]["scoreUnits"]
        for member in ("owner", "admin", "member-a", "member-b")
    ) == [0, 50_000, 100_000, 200_000]

    final_path = next(
        path
        for path, value in db.store.items()
        if "/matches/" in path
        and value["nextMatchId"] is None
        and value["kind"] == "main"
    )
    final = db.store[final_path]
    corrected_winner = (
        final["teamBId"]
        if final["winnerTeamId"] == final["teamAId"]
        else final["teamAId"]
    )
    corrected = _command(
        correct_beerpong_match_result_command,
        _request(
            "correct-final",
            matchId=final_path.rsplit("/", 1)[-1],
            winnerTeamId=corrected_winner,
            expectedRevision=finalized["revision"],
        ),
        db,
        notification_dispatcher=notifications,
    )
    assert all(
        db.store[f"parties/party-a/members/{member}"]["scoreUnits"] == 0
        for member in ("owner", "admin", "member-a", "member-b")
    )
    assert len([path for path in db.store if "/events/reversal:" in path]) == 3

    replacement = _command(
        finalize_beerpong_tournament_command,
        _request("refinalize", expectedRevision=corrected["revision"]),
        db,
        notification_dispatcher=notifications,
    )
    assert len(replacement["awardEventIds"]) == 3
    assert all(":v:2:" in event_id for event_id in replacement["awardEventIds"])
    assert len([path for path in db.store if "/events/tournament:" in path]) == 6


@pytest.mark.parametrize(
    ("command", "request_factory"),
    [
        (
            create_beerpong_tournament_command,
            lambda: _create_request("archived-create"),
        ),
        (
            set_beerpong_opt_in_command,
            lambda: _request(
                "archived-opt", user_id="member-a", optedIn=True, expectedRevision=0
            ),
        ),
        (
            redraw_beerpong_tournament_command,
            lambda: _request(
                "archived-redraw",
                expectedRevision=0,
                teamCount=4,
                thirdPlaceEnabled=True,
                firstPlacePointsUnits=200_000,
                secondPlacePointsUnits=100_000,
                thirdPlacePointsUnits=50_000,
                randomSeedHash=SEED_HASH,
            ),
        ),
        (
            draw_beerpong_tournament_command,
            lambda: _request(
                "archived-draw", expectedRevision=0, randomSeedReveal=SEED
            ),
        ),
        (
            rename_beerpong_team_command,
            lambda: _request(
                "archived-rename",
                expectedRevision=0,
                teamId="team-1",
                name="Name",
            ),
        ),
        (
            record_beerpong_match_result_command,
            lambda: _request(
                "archived-record",
                expectedRevision=0,
                matchId="match-1",
                winnerTeamId="team-1",
            ),
        ),
        (
            correct_beerpong_match_result_command,
            lambda: _request(
                "archived-correct",
                expectedRevision=0,
                matchId="match-1",
                winnerTeamId="team-1",
            ),
        ),
        (
            finalize_beerpong_tournament_command,
            lambda: _request("archived-finalize", expectedRevision=0),
        ),
    ],
)
def test_archived_party_rejects_tournament_actions(
    command: Any, request_factory: Any
) -> None:
    store = _store()
    store["parties/party-a"] = _party(
        status="archived", activeTournamentId="tournament-a"
    )
    store["parties/party-a/tournaments/tournament-a"] = {
        "status": "enrollment",
        "revision": 0,
    }
    db = Database(store)
    with pytest.raises(https_fn.HttpsError) as error:
        command(
            request_factory(),
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION


@pytest.mark.parametrize(
    ("command", "request_factory"),
    [
        (create_beerpong_tournament_command, lambda: _create_request("member-create")),
        (
            redraw_beerpong_tournament_command,
            lambda: _request(
                "member-redraw",
                expectedRevision=0,
                teamCount=4,
                thirdPlaceEnabled=True,
                firstPlacePointsUnits=200_000,
                secondPlacePointsUnits=100_000,
                thirdPlacePointsUnits=50_000,
                randomSeedHash=SEED_HASH,
            ),
        ),
        (
            draw_beerpong_tournament_command,
            lambda: _request("member-draw", expectedRevision=0, randomSeedReveal=SEED),
        ),
        (
            rename_beerpong_team_command,
            lambda: _request(
                "member-rename", expectedRevision=0, teamId="team-1", name="Name"
            ),
        ),
        (
            record_beerpong_match_result_command,
            lambda: _request(
                "member-record",
                expectedRevision=0,
                matchId="match-1",
                winnerTeamId="team-1",
            ),
        ),
        (
            correct_beerpong_match_result_command,
            lambda: _request(
                "member-correct",
                expectedRevision=0,
                matchId="match-1",
                winnerTeamId="team-1",
            ),
        ),
        (
            finalize_beerpong_tournament_command,
            lambda: _request("member-finalize", expectedRevision=0),
        ),
    ],
)
def test_tournament_management_is_admin_only(
    command: Any, request_factory: Any
) -> None:
    db = Database(_store())
    request = request_factory()
    request.auth = Auth("member-a")

    with pytest.raises(https_fn.HttpsError) as error:
        command(
            request,
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == https_fn.FunctionsErrorCode.PERMISSION_DENIED


def test_module_cannot_be_disabled_while_tournament_is_current() -> None:
    store = _store()
    store["parties/party-a"]["activeTournamentId"] = "tournament-a"
    store["parties/party-a/tournaments/tournament-a"] = {"status": "active"}
    db = Database(store)

    with pytest.raises(https_fn.HttpsError) as error:
        set_party_module_settings_command(
            _request(
                "disable",
                moduleSettings={
                    "socialQuestsEnabled": False,
                    "adminChallengesEnabled": False,
                    "beerpongEnabled": False,
                },
            ),
            db,
            transaction_runner=_runner(Transaction(db.store)),
        )

    assert error.value.code == https_fn.FunctionsErrorCode.FAILED_PRECONDITION
