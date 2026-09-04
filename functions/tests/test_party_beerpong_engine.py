from collections.abc import Sequence

import pytest

from party_beerpong_engine import (
    BYE,
    COMPLETED,
    MAIN,
    PENDING,
    READY,
    THIRD_PLACE,
    BeerpongMatch,
    balance_teams,
    calculate_placements,
    clear_dependent_results,
    create_tournament_draw,
    dependent_match_ids,
    generate_bracket,
    record_match_result,
    seeded_player_order,
)


def _team_ids(count: int) -> list[str]:
    return [f"team-{index}" for index in range(1, count + 1)]


def _participants(count: int) -> list[str]:
    return [f"user-{index:03}" for index in range(count)]


def _play_all_ready(
    matches: Sequence[BeerpongMatch],
) -> tuple[BeerpongMatch, ...]:
    result = tuple(matches)
    while True:
        ready = next((match for match in result if match.status == READY), None)
        if ready is None:
            return result
        assert ready.team_a_id is not None
        result = record_match_result(result, ready.match_id, ready.team_a_id)


def test_seeded_order_is_repeatable_and_independent_of_input_order() -> None:
    participants = _participants(40)

    first = seeded_player_order(participants, "revealed-seed")
    second = seeded_player_order(list(reversed(participants)), "revealed-seed")

    assert first == second
    assert set(first) == set(participants)
    assert seeded_player_order(participants, "another-seed") != first


@pytest.mark.parametrize("team_count", range(2, 17))
@pytest.mark.parametrize("extra_participants", range(17))
def test_team_balancing_is_exhaustive_for_supported_rosters(
    team_count: int,
    extra_participants: int,
) -> None:
    participants = _participants(team_count + extra_participants)

    teams = balance_teams(participants, team_count, "seed")

    sizes = [len(team.member_ids) for team in teams]
    assigned = [member_id for team in teams for member_id in team.member_ids]
    assert max(sizes) - min(sizes) <= 1
    assert sorted(assigned) == sorted(participants)
    assert [team.seed for team in teams] == list(range(1, team_count + 1))
    assert teams == balance_teams(list(reversed(participants)), team_count, "seed")


@pytest.mark.parametrize("team_count", range(2, 17))
def test_every_supported_team_count_builds_a_valid_bracket(team_count: int) -> None:
    team_ids = _team_ids(team_count)

    matches = generate_bracket(team_ids, third_place_enabled=True)

    main_matches = [match for match in matches if match.kind == MAIN]
    bracket_size = 1 << (team_count - 1).bit_length()
    first_round = [match for match in main_matches if match.round == 1]
    initial_teams = [
        team_id
        for match in first_round
        for team_id in (match.team_a_id, match.team_b_id)
        if team_id is not None
    ]
    assert len(main_matches) == bracket_size - 1
    assert sorted(initial_teams) == sorted(team_ids)
    assert all(
        match.team_a_id is not None or match.team_b_id is not None
        for match in first_round
    )
    assert (
        sum(match.status == BYE for match in first_round) == bracket_size - team_count
    )
    assert sum(match.kind == THIRD_PLACE for match in matches) == (team_count >= 4)


@pytest.mark.parametrize("team_count", range(2, 17))
@pytest.mark.parametrize("third_place_enabled", [False, True])
def test_progression_completes_all_supported_brackets(
    team_count: int,
    third_place_enabled: bool,
) -> None:
    matches = generate_bracket(
        _team_ids(team_count),
        third_place_enabled=third_place_enabled,
    )

    completed = _play_all_ready(matches)
    placements = calculate_placements(completed)

    assert not any(match.status in {READY, PENDING} for match in completed)
    assert set(placements) == set(_team_ids(team_count))
    assert list(placements.values()).count(1) == 1
    assert list(placements.values()).count(2) == 1
    if third_place_enabled and team_count >= 4:
        assert list(placements.values()).count(3) == 1
        assert list(placements.values()).count(4) == 1


def test_standard_seeding_spreads_five_teams_without_empty_matchups() -> None:
    matches = generate_bracket(_team_ids(5))
    first_round = [match for match in matches if match.round == 1]

    assert [
        (match.team_a_id, match.team_b_id, match.status) for match in first_round
    ] == [
        ("team-1", None, BYE),
        ("team-4", "team-5", READY),
        ("team-2", None, BYE),
        ("team-3", None, BYE),
    ]
    second_semifinal = next(
        match for match in matches if match.match_id == "main-r2-p2"
    )
    assert second_semifinal.team_a_id == "team-2"
    assert second_semifinal.team_b_id == "team-3"


def test_third_place_receives_semifinal_losers() -> None:
    matches = generate_bracket(_team_ids(4), third_place_enabled=True)
    matches = record_match_result(matches, "main-r1-p1", "team-1")
    matches = record_match_result(matches, "main-r1-p2", "team-2")
    third_place = next(match for match in matches if match.kind == THIRD_PLACE)

    assert (third_place.team_a_id, third_place.team_b_id) == ("team-4", "team-3")
    assert third_place.status == READY


def test_correction_clears_only_transitive_dependents_and_repropagates() -> None:
    completed = _play_all_ready(
        generate_bracket(_team_ids(8), third_place_enabled=True)
    )
    original = {match.match_id: match for match in completed}

    assert dependent_match_ids(completed, "main-r1-p1") == (
        "main-r2-p1",
        "main-r3-p1",
        "third-place",
    )
    corrected = record_match_result(completed, "main-r1-p1", "team-8")
    by_id = {match.match_id: match for match in corrected}

    assert by_id["main-r1-p1"].winner_team_id == "team-8"
    assert by_id["main-r2-p1"].status == READY
    assert by_id["main-r2-p1"].team_a_id == "team-8"
    assert by_id["main-r3-p1"].status == PENDING
    assert by_id["third-place"].status == PENDING
    assert by_id["main-r2-p2"] == original["main-r2-p2"]
    assert completed == tuple(original.values())


def test_explicit_downstream_reset_retains_source_result() -> None:
    completed = _play_all_ready(generate_bracket(_team_ids(4)))

    reset = clear_dependent_results(completed, "main-r1-p1")
    by_id = {match.match_id: match for match in reset}

    assert by_id["main-r1-p1"].status == COMPLETED
    assert by_id["main-r2-p1"].status == READY
    assert by_id["main-r2-p1"].winner_team_id is None


def test_placements_are_withheld_for_pending_third_place() -> None:
    matches = generate_bracket(_team_ids(4), third_place_enabled=True)
    matches = record_match_result(matches, "main-r1-p1", "team-1")
    matches = record_match_result(matches, "main-r1-p2", "team-2")
    matches = record_match_result(matches, "main-r2-p1", "team-1")

    assert calculate_placements(matches) == {"team-2": 2, "team-1": 1}

    matches = record_match_result(matches, "third-place", "team-3")
    assert calculate_placements(matches) == {
        "team-2": 2,
        "team-1": 1,
        "team-3": 3,
        "team-4": 4,
    }


def test_draw_combines_deterministic_balancing_and_bracket() -> None:
    draw = create_tournament_draw(
        _participants(23),
        7,
        "seed-reveal",
        third_place_enabled=True,
    )

    assert draw == create_tournament_draw(
        list(reversed(_participants(23))),
        7,
        "seed-reveal",
        third_place_enabled=True,
    )
    assert len(draw.teams) == 7
    assert len(draw.matches) == 8


@pytest.mark.parametrize("team_count", [0, 1, 17])
def test_invalid_team_counts_are_rejected(team_count: int) -> None:
    with pytest.raises(ValueError, match="team_count"):
        balance_teams(_participants(20), team_count, "seed")
    with pytest.raises(ValueError, match="team_count"):
        generate_bracket(_team_ids(team_count))


def test_participant_and_result_constraints_are_rejected() -> None:
    with pytest.raises(ValueError, match="at least"):
        balance_teams(["only", "two"], 3, "seed")
    with pytest.raises(ValueError, match="unique"):
        balance_teams(["same", "same"], 2, "seed")
    with pytest.raises(ValueError, match="non-empty"):
        balance_teams(["a", ""], 2, "seed")
    with pytest.raises(ValueError, match="random_seed"):
        balance_teams(["a", "b"], 2, "")

    matches = generate_bracket(_team_ids(3))
    with pytest.raises(ValueError, match="ready or completed"):
        record_match_result(matches, "main-r2-p1", "team-1")
    with pytest.raises(ValueError, match="team in the match"):
        record_match_result(matches, "main-r1-p2", "team-1")
    with pytest.raises(ValueError, match="Unknown match"):
        record_match_result(matches, "missing", "team-1")


def test_recording_identical_result_is_a_no_op() -> None:
    matches = generate_bracket(_team_ids(2))
    completed = record_match_result(matches, "main-r1-p1", "team-1")

    assert record_match_result(completed, "main-r1-p1", "team-1") is completed
