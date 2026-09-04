"""Server-authoritative beerpong tournament commands.

Handlers remain undecorated for P21 to export. Tournament state, score events,
and command receipts are committed atomically; push delivery is best-effort and
runs only after a successful command.
"""

from collections.abc import Callable, Mapping, Sequence
from dataclasses import asdict
from datetime import datetime, timezone
from hashlib import sha256
from string import hexdigits
from typing import Any

from firebase_admin import firestore
from firebase_functions import https_fn
from party_beerpong_engine import (
    MAX_TEAM_COUNT,
    MIN_TEAM_COUNT,
    READY,
    BeerpongMatch,
    calculate_placements,
    create_tournament_draw,
    record_match_result,
)
from party_common import (
    callable_error,
    load_party_context,
    require_auth,
    require_bool,
    require_command_id,
    require_int,
    require_object,
    require_string,
    run_idempotent_command,
)
from party_notifications import party_notification_data, send_notification_to_users
from party_scoring import (
    SCORE_UNITS_PER_POINT,
    AwardInput,
    ReversalInput,
    create_awards,
    create_reversals,
    deterministic_event_id,
)

MAX_TEAM_NAME_LENGTH = 30
MAX_PLACEMENT_POINTS_UNITS = 500 * SCORE_UNITS_PER_POINT

TransactionRunner = Callable[[Callable[[Any], Mapping[str, Any]]], Mapping[str, Any]]
NotificationDispatcher = Callable[..., Any]


def set_beerpong_opt_in(request: Any) -> Mapping[str, Any]:
    return set_beerpong_opt_in_command(request, firestore.client())


def create_beerpong_tournament(request: Any) -> Mapping[str, Any]:
    return create_beerpong_tournament_command(request, firestore.client())


def redraw_beerpong_tournament(request: Any) -> Mapping[str, Any]:
    return redraw_beerpong_tournament_command(request, firestore.client())


def draw_beerpong_tournament(request: Any) -> Mapping[str, Any]:
    return draw_beerpong_tournament_command(request, firestore.client())


def rename_beerpong_team(request: Any) -> Mapping[str, Any]:
    return rename_beerpong_team_command(request, firestore.client())


def record_beerpong_match_result(request: Any) -> Mapping[str, Any]:
    return record_beerpong_match_result_command(request, firestore.client())


def correct_beerpong_match_result(request: Any) -> Mapping[str, Any]:
    return correct_beerpong_match_result_command(request, firestore.client())


def finalize_beerpong_tournament(request: Any) -> Mapping[str, Any]:
    return finalize_beerpong_tournament_command(request, firestore.client())


def set_beerpong_opt_in_command(
    request: Any,
    db: Any,
    *,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    tournament_id = _document_id(data, "tournamentId")
    opted_in = require_bool(data, "optedIn")
    expected_revision = require_int(data, "expectedRevision", minimum=0)

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(transaction, db, session_id, actor_id)
        _require_beerpong_enabled(context.party)
        tournament_ref, tournament = _load_tournament(
            transaction, db, session_id, tournament_id
        )
        _require_current_tournament(context.party, tournament_id)
        _require_status(tournament, "enrollment")
        revision = _require_revision(tournament, expected_revision)
        member_ref = _party_ref(db, session_id).collection("members").document(actor_id)
        member_snapshot = transaction.get(member_ref)
        if (
            not member_snapshot.exists
            or (member_snapshot.to_dict() or {}).get("isActive") is not True
        ):
            raise _failed("Only active Party members can enroll.")
        transaction.update(
            member_ref,
            {"beerpongOptIn": opted_in, "updatedAt": firestore.SERVER_TIMESTAMP},
        )
        transaction.update(
            tournament_ref,
            {"revision": revision + 1, "updatedAt": firestore.SERVER_TIMESTAMP},
        )
        return {
            "sessionId": session_id,
            "tournamentId": tournament_id,
            "optedIn": opted_in,
            "revision": revision + 1,
        }

    return _run_command(
        db,
        session_id,
        command_id,
        "set_beerpong_opt_in",
        actor_id,
        operation,
        transaction_runner,
    )


def create_beerpong_tournament_command(
    request: Any,
    db: Any,
    *,
    notification_dispatcher: NotificationDispatcher = send_notification_to_users,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    tournament_id = _document_id(data, "tournamentId")
    settings = _tournament_settings(data)
    random_seed_hash = _seed_hash(data)
    did_create = False
    recipients: Sequence[str] = ()

    def operation(transaction: Any) -> Mapping[str, Any]:
        nonlocal did_create, recipients
        did_create = False
        context = load_party_context(
            transaction, db, session_id, actor_id, require_admin=True
        )
        _require_beerpong_enabled(context.party)
        if context.party.get("activeTournamentId") is not None:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "A beerpong tournament is already current.",
            )
        tournament_ref = _tournament_ref(db, session_id, tournament_id)
        if transaction.get(tournament_ref).exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "Tournament ID already exists.",
            )
        tournament = {
            "status": "enrollment",
            "participantIds": [],
            **settings,
            "randomSeedHash": random_seed_hash,
            "randomSeedReveal": None,
            "revision": 0,
            "awardGeneration": 0,
            "placementAwardEventIds": [],
            "createdByUserId": actor_id,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
            "completedAt": None,
        }
        transaction.create(tournament_ref, tournament)
        transaction.update(
            _party_ref(db, session_id),
            {
                "activeTournamentId": tournament_id,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        recipients = _session_member_ids(context.session)
        did_create = True
        return {
            "sessionId": session_id,
            "tournamentId": tournament_id,
            "status": "enrollment",
            "revision": 0,
        }

    result = _run_command(
        db,
        session_id,
        command_id,
        "create_beerpong_tournament",
        actor_id,
        operation,
        transaction_runner,
    )
    if did_create:
        _notify(
            notification_dispatcher,
            db,
            recipients,
            actor_id,
            "Beerpong enrollment is open",
            "Opt in before the teams are drawn.",
            "party_beerpong_enrollment",
            session_id,
            tournament_id,
        )
    return result


def redraw_beerpong_tournament_command(
    request: Any,
    db: Any,
    *,
    notification_dispatcher: NotificationDispatcher = send_notification_to_users,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    tournament_id = _document_id(data, "tournamentId")
    expected_revision = require_int(data, "expectedRevision", minimum=0)
    settings = _tournament_settings(data)
    random_seed_hash = _seed_hash(data)
    did_redraw = False
    recipients: Sequence[str] = ()

    def operation(transaction: Any) -> Mapping[str, Any]:
        nonlocal did_redraw, recipients
        did_redraw = False
        context = load_party_context(
            transaction, db, session_id, actor_id, require_admin=True
        )
        _require_beerpong_enabled(context.party)
        _require_current_tournament(context.party, tournament_id)
        tournament_ref, tournament = _load_tournament(
            transaction, db, session_id, tournament_id
        )
        _require_status(tournament, "active")
        revision = _require_revision(tournament, expected_revision)
        teams = _collection_documents(transaction, tournament_ref.collection("teams"))
        matches = _collection_documents(
            transaction, tournament_ref.collection("matches")
        )
        if any(value.get("status") == "completed" for _, value in matches):
            raise _failed("A tournament with results cannot be redrawn.")
        for reference, _ in (*teams, *matches):
            transaction.delete(reference)
        transaction.update(
            tournament_ref,
            {
                "status": "enrollment",
                "participantIds": [],
                **settings,
                "randomSeedHash": random_seed_hash,
                "randomSeedReveal": None,
                "revision": revision + 1,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        recipients = _session_member_ids(context.session)
        did_redraw = True
        return {
            "sessionId": session_id,
            "tournamentId": tournament_id,
            "status": "enrollment",
            "revision": revision + 1,
        }

    result = _run_command(
        db,
        session_id,
        command_id,
        "redraw_beerpong_tournament",
        actor_id,
        operation,
        transaction_runner,
    )
    if did_redraw:
        _notify(
            notification_dispatcher,
            db,
            recipients,
            actor_id,
            "Beerpong enrollment reopened",
            "Teams will be redrawn after enrollment.",
            "party_beerpong_enrollment",
            session_id,
            tournament_id,
        )
    return result


def draw_beerpong_tournament_command(
    request: Any,
    db: Any,
    *,
    notification_dispatcher: NotificationDispatcher = send_notification_to_users,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    tournament_id = _document_id(data, "tournamentId")
    expected_revision = require_int(data, "expectedRevision", minimum=0)
    seed_reveal = require_string(
        data, "randomSeedReveal", max_length=1_000, strip=False
    )
    did_draw = False
    participants: Sequence[str] = ()
    ready_recipients: list[Sequence[str]] = []

    def operation(transaction: Any) -> Mapping[str, Any]:
        nonlocal did_draw, participants, ready_recipients
        did_draw = False
        ready_recipients = []
        context = load_party_context(
            transaction, db, session_id, actor_id, require_admin=True
        )
        _require_beerpong_enabled(context.party)
        _require_current_tournament(context.party, tournament_id)
        tournament_ref, tournament = _load_tournament(
            transaction, db, session_id, tournament_id
        )
        _require_status(tournament, "enrollment")
        revision = _require_revision(tournament, expected_revision)
        if sha256(seed_reveal.encode()).hexdigest() != tournament.get("randomSeedHash"):
            raise _failed("randomSeedReveal does not match the committed hash.")
        participant_ids = _opted_in_member_ids(
            transaction, db, context.session, session_id
        )
        team_count = _stored_team_count(tournament)
        if len(participant_ids) < team_count:
            raise _failed(
                "The opted-in roster must contain at least one member per team."
            )
        draw = create_tournament_draw(
            participant_ids,
            team_count,
            seed_reveal,
            third_place_enabled=tournament.get("thirdPlaceEnabled") is True,
        )
        for team in draw.teams:
            transaction.create(
                tournament_ref.collection("teams").document(team.team_id),
                {
                    "name": f"Team {team.seed}",
                    "memberIds": list(team.member_ids),
                    "seed": team.seed,
                    "placement": None,
                },
            )
        for match in draw.matches:
            transaction.create(
                tournament_ref.collection("matches").document(match.match_id),
                _match_document(match),
            )
        transaction.update(
            tournament_ref,
            {
                "status": "active",
                "participantIds": participant_ids,
                "randomSeedReveal": seed_reveal,
                "revision": revision + 1,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        participants = participant_ids
        teams_by_id = {team.team_id: list(team.member_ids) for team in draw.teams}
        ready_recipients = [
            list(
                dict.fromkeys(
                    teams_by_id[match.team_a_id] + teams_by_id[match.team_b_id]
                )
            )
            for match in draw.matches
            if match.status == READY
            and match.team_a_id is not None
            and match.team_b_id is not None
        ]
        did_draw = True
        return {
            "sessionId": session_id,
            "tournamentId": tournament_id,
            "status": "active",
            "participantCount": len(participant_ids),
            "teamCount": team_count,
            "revision": revision + 1,
        }

    result = _run_command(
        db,
        session_id,
        command_id,
        "draw_beerpong_tournament",
        actor_id,
        operation,
        transaction_runner,
    )
    if did_draw:
        _notify(
            notification_dispatcher,
            db,
            participants,
            actor_id,
            "Beerpong teams are ready",
            "Enrollment is locked and the bracket is live.",
            "party_beerpong_enrollment",
            session_id,
            tournament_id,
        )
        for recipients in ready_recipients:
            _notify(
                notification_dispatcher,
                db,
                recipients,
                actor_id,
                "Your beerpong match is ready",
                "Open the tournament bracket for your matchup.",
                "party_beerpong_match_ready",
                session_id,
                tournament_id,
            )
    return result


def rename_beerpong_team_command(
    request: Any,
    db: Any,
    *,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    tournament_id = _document_id(data, "tournamentId")
    team_id = _document_id(data, "teamId")
    name = require_string(data, "name", max_length=MAX_TEAM_NAME_LENGTH)
    expected_revision = require_int(data, "expectedRevision", minimum=0)

    def operation(transaction: Any) -> Mapping[str, Any]:
        context = load_party_context(
            transaction, db, session_id, actor_id, require_admin=True
        )
        _require_beerpong_enabled(context.party)
        _require_current_tournament(context.party, tournament_id)
        tournament_ref, tournament = _load_tournament(
            transaction, db, session_id, tournament_id
        )
        _require_status(tournament, "active")
        revision = _require_revision(tournament, expected_revision)
        match_rows = _collection_documents(
            transaction, tournament_ref.collection("matches")
        )
        if any(value.get("status") == "completed" for _, value in match_rows):
            raise _failed("Teams can only be renamed before the first result.")
        team_ref = tournament_ref.collection("teams").document(team_id)
        if not transaction.get(team_ref).exists:
            raise callable_error(
                https_fn.FunctionsErrorCode.NOT_FOUND, "Beerpong team was not found."
            )
        transaction.update(team_ref, {"name": name})
        transaction.update(
            tournament_ref,
            {"revision": revision + 1, "updatedAt": firestore.SERVER_TIMESTAMP},
        )
        return {
            "sessionId": session_id,
            "tournamentId": tournament_id,
            "teamId": team_id,
            "name": name,
            "revision": revision + 1,
        }

    return _run_command(
        db,
        session_id,
        command_id,
        "rename_beerpong_team",
        actor_id,
        operation,
        transaction_runner,
    )


def record_beerpong_match_result_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    notification_dispatcher: NotificationDispatcher = send_notification_to_users,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    return _match_result_command(
        request,
        db,
        correction=False,
        now_provider=now_provider,
        notification_dispatcher=notification_dispatcher,
        transaction_runner=transaction_runner,
    )


def correct_beerpong_match_result_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    notification_dispatcher: NotificationDispatcher = send_notification_to_users,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    return _match_result_command(
        request,
        db,
        correction=True,
        now_provider=now_provider,
        notification_dispatcher=notification_dispatcher,
        transaction_runner=transaction_runner,
    )


def _match_result_command(
    request: Any,
    db: Any,
    *,
    correction: bool,
    now_provider: Callable[[], datetime] | None,
    notification_dispatcher: NotificationDispatcher,
    transaction_runner: TransactionRunner | None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    tournament_id = _document_id(data, "tournamentId")
    match_id = _document_id(data, "matchId")
    winner_team_id = _document_id(data, "winnerTeamId")
    expected_revision = require_int(data, "expectedRevision", minimum=0)
    did_change = False
    result_recipients: Sequence[str] = ()
    ready_notifications: list[tuple[str, Sequence[str]]] = []

    def operation(transaction: Any) -> Mapping[str, Any]:
        nonlocal did_change, result_recipients, ready_notifications
        did_change = False
        ready_notifications = []
        context = load_party_context(
            transaction, db, session_id, actor_id, require_admin=True
        )
        _require_beerpong_enabled(context.party)
        _require_current_tournament(context.party, tournament_id)
        tournament_ref, tournament = _load_tournament(
            transaction, db, session_id, tournament_id
        )
        if tournament.get("status") not in {"active", "completed"}:
            raise _failed("Tournament results can only change after the draw.")
        revision = _require_revision(tournament, expected_revision)
        match_rows = _collection_documents(
            transaction, tournament_ref.collection("matches")
        )
        team_rows = _collection_documents(
            transaction, tournament_ref.collection("teams")
        )
        matches = tuple(
            _stored_match(_reference_id(reference), value)
            for reference, value in match_rows
        )
        by_id = {match.match_id: match for match in matches}
        selected = by_id.get(match_id)
        if selected is None:
            raise callable_error(
                https_fn.FunctionsErrorCode.NOT_FOUND, "Beerpong match was not found."
            )
        if correction:
            if selected.status != "completed":
                raise _failed("Only completed match results can be corrected.")
            if selected.winner_team_id == winner_team_id:
                raise _failed("The corrected winner must be different.")
        elif selected.status != READY:
            raise _failed("Only ready matches can receive a new result.")

        now = _now(now_provider)
        if tournament.get("status") == "completed":
            if not correction:
                raise _failed("A completed tournament requires a correction command.")
            award_ids = _stored_strings(tournament, "placementAwardEventIds")
            reversals = create_reversals(
                transaction,
                _party_ref(db, session_id),
                [
                    ReversalInput(
                        award_event_id=event_id,
                        occurred_at=now,
                        actor_user_id=actor_id,
                        reason="beerpongResultCorrection",
                    )
                    for event_id in award_ids
                ],
            )
            if not all(value.created for value in reversals):
                raise callable_error(
                    https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                    "Tournament placement awards were already reversed.",
                )

        try:
            updated = record_match_result(matches, match_id, winner_team_id)
        except ValueError as error:
            raise _failed(str(error)) from error
        updated_by_id = {match.match_id: match for match in updated}
        for reference, _ in match_rows:
            reference_id = _reference_id(reference)
            old_match = by_id[reference_id]
            new_match = updated_by_id[reference_id]
            if old_match != new_match:
                transaction.update(reference, _match_document(new_match))
        teams = {_reference_id(reference): value for reference, value in team_rows}
        if tournament.get("status") == "completed":
            for reference, _ in team_rows:
                transaction.update(reference, {"placement": None})
        transaction.update(
            tournament_ref,
            {
                "status": "active",
                "completedAt": None,
                "placementAwardEventIds": [],
                "revision": revision + 1,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        affected_team_ids = [selected.team_a_id, selected.team_b_id]
        result_recipients = _team_member_ids(teams, affected_team_ids)
        for old_match, new_match in zip(matches, updated, strict=True):
            if old_match.status != READY and new_match.status == READY:
                ready_notifications.append(
                    (
                        new_match.match_id,
                        _team_member_ids(
                            teams, [new_match.team_a_id, new_match.team_b_id]
                        ),
                    )
                )
        did_change = True
        return {
            "sessionId": session_id,
            "tournamentId": tournament_id,
            "matchId": match_id,
            "winnerTeamId": winner_team_id,
            "corrected": correction,
            "revision": revision + 1,
        }

    command_name = (
        "correct_beerpong_match_result"
        if correction
        else "record_beerpong_match_result"
    )
    result = _run_command(
        db,
        session_id,
        command_id,
        command_name,
        actor_id,
        operation,
        transaction_runner,
    )
    if did_change:
        _notify(
            notification_dispatcher,
            db,
            result_recipients,
            actor_id,
            "Beerpong result updated",
            "The bracket has been updated.",
            "party_beerpong_match_result",
            session_id,
            tournament_id,
        )
        for ready_match_id, recipients in ready_notifications:
            _notify(
                notification_dispatcher,
                db,
                recipients,
                actor_id,
                "Your beerpong match is ready",
                "Open the tournament bracket for your matchup.",
                "party_beerpong_match_ready",
                session_id,
                tournament_id,
            )
    return result


def finalize_beerpong_tournament_command(
    request: Any,
    db: Any,
    *,
    now_provider: Callable[[], datetime] | None = None,
    notification_dispatcher: NotificationDispatcher = send_notification_to_users,
    transaction_runner: TransactionRunner | None = None,
) -> Mapping[str, Any]:
    actor_id, data, session_id, command_id = _command_input(request)
    tournament_id = _document_id(data, "tournamentId")
    expected_revision = require_int(data, "expectedRevision", minimum=0)
    did_finalize = False
    participants: Sequence[str] = ()

    def operation(transaction: Any) -> Mapping[str, Any]:
        nonlocal did_finalize, participants
        did_finalize = False
        context = load_party_context(
            transaction, db, session_id, actor_id, require_admin=True
        )
        _require_beerpong_enabled(context.party)
        _require_current_tournament(context.party, tournament_id)
        tournament_ref, tournament = _load_tournament(
            transaction, db, session_id, tournament_id
        )
        _require_status(tournament, "active")
        revision = _require_revision(tournament, expected_revision)
        match_rows = _collection_documents(
            transaction, tournament_ref.collection("matches")
        )
        team_rows = _collection_documents(
            transaction, tournament_ref.collection("teams")
        )
        matches = tuple(
            _stored_match(_reference_id(reference), value)
            for reference, value in match_rows
        )
        placements = calculate_placements(matches)
        teams = {_reference_id(reference): value for reference, value in team_rows}
        if set(placements) != set(teams):
            raise _failed(
                "Every required match must have a result before finalization."
            )
        generation = _stored_nonnegative_int(tournament, "awardGeneration") + 1
        points_by_placement = {
            1: _stored_points(tournament, "firstPlacePointsUnits"),
            2: _stored_points(tournament, "secondPlacePointsUnits"),
            3: _stored_points(tournament, "thirdPlacePointsUnits"),
        }
        now = _now(now_provider)
        awards: list[AwardInput] = []
        for team_id, placement in placements.items():
            member_ids = _stored_strings(teams[team_id], "memberIds")
            points = points_by_placement.get(placement)
            if points is None:
                continue
            for member_id in member_ids:
                awards.append(
                    AwardInput(
                        event_id=_placement_award_id(
                            tournament_id, generation, member_id
                        ),
                        kind="beerpongPlacement",
                        recipient_user_id=member_id,
                        participant_ids=member_ids,
                        points_units=points,
                        source_collection="tournaments",
                        source_id=tournament_id,
                        occurred_at=now,
                        actor_user_id=actor_id,
                        payload={
                            "tournamentId": tournament_id,
                            "teamId": team_id,
                            "teamName": teams[team_id].get("name"),
                            "placement": placement,
                            "generation": generation,
                        },
                    )
                )
        award_results = create_awards(transaction, _party_ref(db, session_id), awards)
        if not all(value.created for value in award_results):
            raise callable_error(
                https_fn.FunctionsErrorCode.ALREADY_EXISTS,
                "Tournament placement awards already exist.",
            )
        for reference, _ in team_rows:
            transaction.update(
                reference, {"placement": placements[_reference_id(reference)]}
            )
        event_ids = [award.event_id for award in awards]
        transaction.update(
            tournament_ref,
            {
                "status": "completed",
                "completedAt": now,
                "awardGeneration": generation,
                "placementAwardEventIds": event_ids,
                "revision": revision + 1,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            },
        )
        participants = _stored_strings(tournament, "participantIds")
        did_finalize = True
        return {
            "sessionId": session_id,
            "tournamentId": tournament_id,
            "status": "completed",
            "placements": placements,
            "awardEventIds": event_ids,
            "revision": revision + 1,
        }

    result = _run_command(
        db,
        session_id,
        command_id,
        "finalize_beerpong_tournament",
        actor_id,
        operation,
        transaction_runner,
    )
    if did_finalize:
        _notify(
            notification_dispatcher,
            db,
            participants,
            actor_id,
            "Beerpong tournament completed",
            "Final placements and points are ready.",
            "party_beerpong_completed",
            session_id,
            tournament_id,
        )
    return result


def _tournament_settings(data: Mapping[str, Any]) -> Mapping[str, Any]:
    first = require_int(
        data,
        "firstPlacePointsUnits",
        minimum=SCORE_UNITS_PER_POINT,
        maximum=MAX_PLACEMENT_POINTS_UNITS,
    )
    second = require_int(
        data,
        "secondPlacePointsUnits",
        minimum=SCORE_UNITS_PER_POINT,
        maximum=MAX_PLACEMENT_POINTS_UNITS,
    )
    third = require_int(
        data,
        "thirdPlacePointsUnits",
        minimum=SCORE_UNITS_PER_POINT,
        maximum=MAX_PLACEMENT_POINTS_UNITS,
    )
    if not first >= second >= third:
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "Placement points must not increase for lower placements.",
        )
    return {
        "teamCount": require_int(
            data, "teamCount", minimum=MIN_TEAM_COUNT, maximum=MAX_TEAM_COUNT
        ),
        "thirdPlaceEnabled": require_bool(data, "thirdPlaceEnabled"),
        "firstPlacePointsUnits": first,
        "secondPlacePointsUnits": second,
        "thirdPlacePointsUnits": third,
    }


def _seed_hash(data: Mapping[str, Any]) -> str:
    value = require_string(data, "randomSeedHash", max_length=64)
    if len(value) != 64 or any(character not in hexdigits for character in value):
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            "randomSeedHash must be a SHA-256 hex digest.",
        )
    return value.lower()


def _match_document(match: BeerpongMatch) -> Mapping[str, Any]:
    values = asdict(match)
    return {
        "round": values["round"],
        "position": values["position"],
        "kind": values["kind"],
        "teamAId": values["team_a_id"],
        "teamBId": values["team_b_id"],
        "winnerTeamId": values["winner_team_id"],
        "loserTeamId": values["loser_team_id"],
        "status": values["status"],
        "nextMatchId": values["next_match_id"],
        "nextSlot": values["next_slot"],
        "sourceAMatchId": values["source_a_match_id"],
        "sourceBMatchId": values["source_b_match_id"],
        "sourceAOutcome": values["source_a_outcome"],
        "sourceBOutcome": values["source_b_outcome"],
    }


def _stored_match(match_id: str, value: Mapping[str, Any]) -> BeerpongMatch:
    try:
        return BeerpongMatch(
            match_id=match_id,
            round=_required_int(value, "round"),
            position=_required_int(value, "position"),
            kind=_required_string(value, "kind"),
            team_a_id=_optional_stored_string(value, "teamAId"),
            team_b_id=_optional_stored_string(value, "teamBId"),
            winner_team_id=_optional_stored_string(value, "winnerTeamId"),
            loser_team_id=_optional_stored_string(value, "loserTeamId"),
            status=_required_string(value, "status"),
            next_match_id=_optional_stored_string(value, "nextMatchId"),
            next_slot=_optional_stored_string(value, "nextSlot"),
            source_a_match_id=_optional_stored_string(value, "sourceAMatchId"),
            source_b_match_id=_optional_stored_string(value, "sourceBMatchId"),
            source_a_outcome=_required_string(value, "sourceAOutcome"),
            source_b_outcome=_required_string(value, "sourceBOutcome"),
        )
    except (TypeError, ValueError) as error:
        raise _failed("Stored beerpong match is invalid.") from error


def _opted_in_member_ids(
    transaction: Any,
    db: Any,
    session: Mapping[str, Any],
    session_id: str,
) -> list[str]:
    result: list[str] = []
    for member_id in _session_member_ids(session):
        snapshot = transaction.get(
            _party_ref(db, session_id).collection("members").document(member_id)
        )
        member = snapshot.to_dict() or {}
        if (
            snapshot.exists
            and member.get("isActive") is True
            and member.get("beerpongOptIn") is True
        ):
            result.append(member_id)
    return result


def _team_member_ids(
    teams: Mapping[str, Mapping[str, Any]], team_ids: Sequence[str | None]
) -> list[str]:
    result: list[str] = []
    for team_id in team_ids:
        if team_id is not None and team_id in teams:
            result.extend(_stored_strings(teams[team_id], "memberIds"))
    return list(dict.fromkeys(result))


def _collection_documents(
    transaction: Any, collection: Any
) -> list[tuple[Any, Mapping[str, Any]]]:
    return [
        (snapshot.reference, snapshot.to_dict() or {})
        for snapshot in transaction.get(collection)
    ]


def _reference_id(reference: Any) -> str:
    return reference.path.rsplit("/", 1)[-1]


def _load_tournament(
    transaction: Any, db: Any, session_id: str, tournament_id: str
) -> tuple[Any, Mapping[str, Any]]:
    reference = _tournament_ref(db, session_id, tournament_id)
    snapshot = transaction.get(reference)
    if not snapshot.exists:
        raise callable_error(
            https_fn.FunctionsErrorCode.NOT_FOUND, "Beerpong tournament was not found."
        )
    return reference, snapshot.to_dict() or {}


def _require_beerpong_enabled(party: Mapping[str, Any]) -> None:
    settings = party.get("moduleSettings")
    if not isinstance(settings, Mapping) or settings.get("beerpongEnabled") is not True:
        raise _failed("Beerpong is disabled.")


def _require_current_tournament(party: Mapping[str, Any], tournament_id: str) -> None:
    if party.get("activeTournamentId") != tournament_id:
        raise _failed("Tournament is not current for this Party.")


def _require_status(tournament: Mapping[str, Any], status: str) -> None:
    if tournament.get("status") != status:
        raise _failed(f"Tournament must be {status}.")


def _require_revision(tournament: Mapping[str, Any], expected: int) -> int:
    revision = _stored_nonnegative_int(tournament, "revision")
    if revision != expected:
        raise callable_error(
            https_fn.FunctionsErrorCode.ABORTED,
            "Tournament revision changed; reload before retrying.",
        )
    return revision


def _stored_team_count(tournament: Mapping[str, Any]) -> int:
    value = _required_int(tournament, "teamCount")
    if not MIN_TEAM_COUNT <= value <= MAX_TEAM_COUNT:
        raise _failed("Stored tournament teamCount is invalid.")
    return value


def _stored_points(tournament: Mapping[str, Any], field: str) -> int:
    value = _required_int(tournament, field)
    if not SCORE_UNITS_PER_POINT <= value <= MAX_PLACEMENT_POINTS_UNITS:
        raise _failed(f"Stored tournament {field} is invalid.")
    return value


def _stored_nonnegative_int(document: Mapping[str, Any], field: str) -> int:
    value = document.get(field)
    if isinstance(value, bool) or not isinstance(value, int) or value < 0:
        raise _failed(f"Stored tournament {field} is invalid.")
    return value


def _required_int(document: Mapping[str, Any], field: str) -> int:
    value = document.get(field)
    if isinstance(value, bool) or not isinstance(value, int):
        raise TypeError(field)
    return value


def _required_string(document: Mapping[str, Any], field: str) -> str:
    value = document.get(field)
    if not isinstance(value, str) or not value:
        raise ValueError(field)
    return value


def _optional_stored_string(document: Mapping[str, Any], field: str) -> str | None:
    value = document.get(field)
    if value is None:
        return None
    if not isinstance(value, str) or not value:
        raise ValueError(field)
    return value


def _stored_strings(document: Mapping[str, Any], field: str) -> list[str]:
    value = document.get(field, [])
    if (
        not isinstance(value, Sequence)
        or isinstance(value, (str, bytes))
        or any(not isinstance(item, str) or not item for item in value)
        or len(set(value)) != len(value)
    ):
        raise _failed(f"Stored tournament {field} is invalid.")
    return list(value)


def _session_member_ids(session: Mapping[str, Any]) -> list[str]:
    try:
        return _stored_strings(session, "memberIds")
    except https_fn.HttpsError as error:
        raise _failed("Stored Session membership is invalid.") from error


def _placement_award_id(tournament_id: str, generation: int, member_id: str) -> str:
    return deterministic_event_id(
        "tournament", tournament_id, "placement", "v", str(generation), member_id
    )


def _command_input(request: Any) -> tuple[str, Mapping[str, Any], str, str]:
    actor_id = require_auth(request)
    data = require_object(getattr(request, "data", None))
    session_id = require_string(data, "sessionId", max_length=1_500)
    return actor_id, data, session_id, require_command_id(data)


def _document_id(data: Mapping[str, Any], field: str) -> str:
    value = require_string(data, field, max_length=1_500)
    if "/" in value:
        raise callable_error(
            https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            f"{field} must not contain '/'.",
        )
    return value


def _party_ref(db: Any, session_id: str) -> Any:
    return db.collection("parties").document(session_id)


def _tournament_ref(db: Any, session_id: str, tournament_id: str) -> Any:
    return _party_ref(db, session_id).collection("tournaments").document(tournament_id)


def _run_command(
    db: Any,
    session_id: str,
    command_id: str,
    command_name: str,
    actor_id: str,
    operation: Callable[[Any], Mapping[str, Any]],
    runner: TransactionRunner | None,
) -> Mapping[str, Any]:
    return run_idempotent_command(
        db,
        party_id=session_id,
        command_id=command_id,
        command_name=command_name,
        actor_user_id=actor_id,
        operation=operation,
        transaction_runner=runner,
    )


def _notify(
    dispatcher: NotificationDispatcher,
    db: Any,
    recipients: Sequence[str],
    actor_id: str,
    title: str,
    body: str,
    notification_type: str,
    session_id: str,
    source_id: str,
) -> None:
    dispatcher(
        db,
        recipients,
        actor_user_id=actor_id,
        title=title,
        body=body,
        data=party_notification_data(
            notification_type, session_id, source_id=source_id
        ),
    )


def _now(provider: Callable[[], datetime] | None) -> datetime:
    value = provider() if provider is not None else datetime.now(timezone.utc)
    if not isinstance(value, datetime):
        raise TypeError("now_provider must return datetime")
    return value


def _failed(message: str) -> https_fn.HttpsError:
    return callable_error(https_fn.FunctionsErrorCode.FAILED_PRECONDITION, message)
