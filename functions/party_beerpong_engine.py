"""Pure deterministic team draw and single-elimination tournament engine."""

from collections.abc import Sequence
from dataclasses import dataclass, replace
from hashlib import sha256

MIN_TEAM_COUNT = 2
MAX_TEAM_COUNT = 16

PENDING = "pending"
READY = "ready"
COMPLETED = "completed"
BYE = "bye"

MAIN = "main"
THIRD_PLACE = "thirdPlace"

_WINNER = "winner"
_LOSER = "loser"


@dataclass(frozen=True)
class BeerpongTeam:
    team_id: str
    seed: int
    member_ids: tuple[str, ...]


@dataclass(frozen=True)
class BeerpongMatch:
    """One immutable match state plus its engine-only source metadata."""

    match_id: str
    round: int
    position: int
    kind: str
    team_a_id: str | None
    team_b_id: str | None
    winner_team_id: str | None
    loser_team_id: str | None
    status: str
    next_match_id: str | None
    next_slot: str | None
    source_a_match_id: str | None = None
    source_b_match_id: str | None = None
    source_a_outcome: str = _WINNER
    source_b_outcome: str = _WINNER


@dataclass(frozen=True)
class BeerpongDraw:
    teams: tuple[BeerpongTeam, ...]
    matches: tuple[BeerpongMatch, ...]


def seeded_player_order(
    participant_ids: Sequence[str],
    random_seed: str,
) -> tuple[str, ...]:
    """Return a stable pseudorandom order independent of input query order."""

    participants = _validate_participants(participant_ids)
    if not isinstance(random_seed, str) or not random_seed:
        raise ValueError("random_seed must be a non-empty string")

    seed_bytes = random_seed.encode()

    def draw_key(participant_id: str) -> tuple[bytes, str]:
        participant_bytes = participant_id.encode()
        framed = (
            len(seed_bytes).to_bytes(8, "big")
            + seed_bytes
            + len(participant_bytes).to_bytes(8, "big")
            + participant_bytes
        )
        return sha256(framed).digest(), participant_id

    return tuple(sorted(participants, key=draw_key))


def balance_teams(
    participant_ids: Sequence[str],
    team_count: int,
    random_seed: str,
) -> tuple[BeerpongTeam, ...]:
    """Draw participants and deal them round-robin into balanced seeded teams."""

    _validate_team_count(team_count)
    participants = _validate_participants(participant_ids)
    if len(participants) < team_count:
        raise ValueError("participant count must be at least team_count")

    ordered = seeded_player_order(participants, random_seed)
    members: list[list[str]] = [[] for _ in range(team_count)]
    for index, participant_id in enumerate(ordered):
        members[index % team_count].append(participant_id)
    return tuple(
        BeerpongTeam(
            team_id=f"team-{index + 1}",
            seed=index + 1,
            member_ids=tuple(team_members),
        )
        for index, team_members in enumerate(members)
    )


def create_tournament_draw(
    participant_ids: Sequence[str],
    team_count: int,
    random_seed: str,
    *,
    third_place_enabled: bool = False,
) -> BeerpongDraw:
    teams = balance_teams(participant_ids, team_count, random_seed)
    matches = generate_bracket(
        [team.team_id for team in teams],
        third_place_enabled=third_place_enabled,
    )
    return BeerpongDraw(teams, matches)


def generate_bracket(
    team_ids: Sequence[str],
    *,
    third_place_enabled: bool = False,
) -> tuple[BeerpongMatch, ...]:
    """Build a next-power-of-two bracket and propagate first-round byes."""

    teams = _validate_team_ids(team_ids)
    team_count = len(teams)
    bracket_size = 1 << (team_count - 1).bit_length()
    round_count = bracket_size.bit_length() - 1
    seed_slots = _seed_positions(bracket_size)
    seeded_teams = {seed: team_id for seed, team_id in enumerate(teams, start=1)}
    matches: list[BeerpongMatch] = []

    for position in range(1, bracket_size // 2 + 1):
        team_a_id = seeded_teams.get(seed_slots[(position - 1) * 2])
        team_b_id = seeded_teams.get(seed_slots[(position - 1) * 2 + 1])
        next_match_id, next_slot = _next_match(round_count, 1, position)
        if team_a_id is not None and team_b_id is not None:
            status = READY
            winner_team_id = None
        else:
            status = BYE
            winner_team_id = team_a_id or team_b_id
        matches.append(
            BeerpongMatch(
                match_id=_main_match_id(1, position),
                round=1,
                position=position,
                kind=MAIN,
                team_a_id=team_a_id,
                team_b_id=team_b_id,
                winner_team_id=winner_team_id,
                loser_team_id=None,
                status=status,
                next_match_id=next_match_id,
                next_slot=next_slot,
            )
        )

    for round_number in range(2, round_count + 1):
        match_count = bracket_size // (1 << round_number)
        for position in range(1, match_count + 1):
            source_a = _main_match_id(round_number - 1, position * 2 - 1)
            source_b = _main_match_id(round_number - 1, position * 2)
            next_match_id, next_slot = _next_match(
                round_count,
                round_number,
                position,
            )
            matches.append(
                BeerpongMatch(
                    match_id=_main_match_id(round_number, position),
                    round=round_number,
                    position=position,
                    kind=MAIN,
                    team_a_id=None,
                    team_b_id=None,
                    winner_team_id=None,
                    loser_team_id=None,
                    status=PENDING,
                    next_match_id=next_match_id,
                    next_slot=next_slot,
                    source_a_match_id=source_a,
                    source_b_match_id=source_b,
                )
            )

    # Fewer than four teams cannot supply two semifinal losers.
    if third_place_enabled and team_count >= 4:
        semifinal_round = round_count - 1
        matches.append(
            BeerpongMatch(
                match_id="third-place",
                round=round_count,
                position=1,
                kind=THIRD_PLACE,
                team_a_id=None,
                team_b_id=None,
                winner_team_id=None,
                loser_team_id=None,
                status=PENDING,
                next_match_id=None,
                next_slot=None,
                source_a_match_id=_main_match_id(semifinal_round, 1),
                source_b_match_id=_main_match_id(semifinal_round, 2),
                source_a_outcome=_LOSER,
                source_b_outcome=_LOSER,
            )
        )

    return _recompute_matches(matches)


def record_match_result(
    matches: Sequence[BeerpongMatch],
    match_id: str,
    winner_team_id: str,
) -> tuple[BeerpongMatch, ...]:
    """Record or correct a result, clearing every result that depends on it."""

    current = _match_map(matches)
    match = current.get(match_id)
    if match is None:
        raise ValueError(f"Unknown match: {match_id}")
    if match.status not in {READY, COMPLETED}:
        raise ValueError("Only ready or completed matches can receive a result")
    if winner_team_id not in {match.team_a_id, match.team_b_id}:
        raise ValueError("winner_team_id must be a team in the match")
    if match.winner_team_id == winner_team_id:
        return tuple(matches)

    dependent_ids = set(dependent_match_ids(matches, match_id))
    updated: list[BeerpongMatch] = []
    for item in matches:
        if item.match_id == match_id:
            loser_team_id = (
                item.team_b_id if winner_team_id == item.team_a_id else item.team_a_id
            )
            updated.append(
                replace(
                    item,
                    winner_team_id=winner_team_id,
                    loser_team_id=loser_team_id,
                    status=COMPLETED,
                )
            )
        elif item.match_id in dependent_ids:
            updated.append(_without_result(item))
        else:
            updated.append(item)
    return _recompute_matches(updated)


def dependent_match_ids(
    matches: Sequence[BeerpongMatch],
    match_id: str,
) -> tuple[str, ...]:
    """Return direct and transitive dependents in bracket order."""

    match_by_id = _match_map(matches)
    if match_id not in match_by_id:
        raise ValueError(f"Unknown match: {match_id}")

    dependent_ids: set[str] = set()
    pending = [match_id]
    while pending:
        source_id = pending.pop()
        for match in matches:
            if match.match_id in dependent_ids:
                continue
            if source_id in {match.source_a_match_id, match.source_b_match_id}:
                dependent_ids.add(match.match_id)
                pending.append(match.match_id)
    return tuple(match.match_id for match in matches if match.match_id in dependent_ids)


def clear_dependent_results(
    matches: Sequence[BeerpongMatch],
    match_id: str,
) -> tuple[BeerpongMatch, ...]:
    """Clear downstream outcomes while retaining the selected match's result."""

    dependent_ids = set(dependent_match_ids(matches, match_id))
    reset = [
        _without_result(match) if match.match_id in dependent_ids else match
        for match in matches
    ]
    return _recompute_matches(reset)


def calculate_placements(
    matches: Sequence[BeerpongMatch],
) -> dict[str, int]:
    """Calculate currently known elimination placements, including ties."""

    match_by_id = _match_map(matches)
    main_matches = [match for match in matches if match.kind == MAIN]
    if not main_matches:
        return {}
    final_round = max(match.round for match in main_matches)
    final = next(
        match
        for match in main_matches
        if match.round == final_round and match.position == 1
    )
    placements: dict[str, int] = {}
    for match in main_matches:
        if match.status != COMPLETED or match.loser_team_id is None:
            continue
        placement = (1 << (final_round - match.round)) + 1
        placements[match.loser_team_id] = placement
    if final.status == COMPLETED and final.winner_team_id is not None:
        placements[final.winner_team_id] = 1

    third_place = next(
        (match for match in matches if match.kind == THIRD_PLACE),
        None,
    )
    if third_place is not None:
        semifinal_ids = {
            third_place.source_a_match_id,
            third_place.source_b_match_id,
        }
        for semifinal_id in semifinal_ids:
            semifinal = match_by_id.get(semifinal_id)
            if semifinal is not None and semifinal.loser_team_id is not None:
                placements.pop(semifinal.loser_team_id, None)
        if third_place.status == COMPLETED:
            if third_place.winner_team_id is not None:
                placements[third_place.winner_team_id] = 3
            if third_place.loser_team_id is not None:
                placements[third_place.loser_team_id] = 4
    return placements


def _validate_team_count(team_count: int) -> None:
    if isinstance(team_count, bool) or not isinstance(team_count, int):
        raise TypeError("team_count must be an integer")
    if not MIN_TEAM_COUNT <= team_count <= MAX_TEAM_COUNT:
        raise ValueError(
            f"team_count must be between {MIN_TEAM_COUNT} and {MAX_TEAM_COUNT}"
        )


def _validate_participants(participant_ids: Sequence[str]) -> tuple[str, ...]:
    if isinstance(participant_ids, (str, bytes)):
        raise TypeError("participant_ids must be a sequence of strings")
    participants = tuple(participant_ids)
    if any(
        not isinstance(participant_id, str) or not participant_id
        for participant_id in participants
    ):
        raise ValueError("participant IDs must be non-empty strings")
    if len(set(participants)) != len(participants):
        raise ValueError("participant IDs must be unique")
    return participants


def _validate_team_ids(team_ids: Sequence[str]) -> tuple[str, ...]:
    teams = _validate_participants(team_ids)
    _validate_team_count(len(teams))
    return teams


def _seed_positions(bracket_size: int) -> tuple[int, ...]:
    positions = [1, 2]
    size = 2
    while size < bracket_size:
        size *= 2
        positions = [value for seed in positions for value in (seed, size + 1 - seed)]
    return tuple(positions)


def _main_match_id(round_number: int, position: int) -> str:
    return f"main-r{round_number}-p{position}"


def _next_match(
    round_count: int,
    round_number: int,
    position: int,
) -> tuple[str | None, str | None]:
    if round_number == round_count:
        return None, None
    return (
        _main_match_id(round_number + 1, (position + 1) // 2),
        "a" if position % 2 == 1 else "b",
    )


def _match_map(matches: Sequence[BeerpongMatch]) -> dict[str, BeerpongMatch]:
    result = {match.match_id: match for match in matches}
    if len(result) != len(matches):
        raise ValueError("match IDs must be unique")
    return result


def _without_result(match: BeerpongMatch) -> BeerpongMatch:
    return replace(
        match,
        winner_team_id=None,
        loser_team_id=None,
        status=PENDING,
    )


def _source_team(
    source: BeerpongMatch | None,
    outcome: str,
) -> str | None:
    if source is None or source.status not in {COMPLETED, BYE}:
        return None
    return source.winner_team_id if outcome == _WINNER else source.loser_team_id


def _recompute_matches(
    matches: Sequence[BeerpongMatch],
) -> tuple[BeerpongMatch, ...]:
    recomputed: dict[str, BeerpongMatch] = {}
    result: list[BeerpongMatch] = []
    for match in matches:
        if match.source_a_match_id is None and match.source_b_match_id is None:
            updated = match
        else:
            team_a_id = _source_team(
                recomputed.get(match.source_a_match_id or ""),
                match.source_a_outcome,
            )
            team_b_id = _source_team(
                recomputed.get(match.source_b_match_id or ""),
                match.source_b_outcome,
            )
            has_valid_result = (
                match.status == COMPLETED
                and match.winner_team_id in {team_a_id, team_b_id}
                and match.loser_team_id in {team_a_id, team_b_id}
                and match.winner_team_id != match.loser_team_id
            )
            updated = replace(
                match,
                team_a_id=team_a_id,
                team_b_id=team_b_id,
                winner_team_id=match.winner_team_id if has_valid_result else None,
                loser_team_id=match.loser_team_id if has_valid_result else None,
                status=(
                    COMPLETED
                    if has_valid_result
                    else READY
                    if team_a_id is not None and team_b_id is not None
                    else PENDING
                ),
            )
        recomputed[updated.match_id] = updated
        result.append(updated)
    return tuple(result)
