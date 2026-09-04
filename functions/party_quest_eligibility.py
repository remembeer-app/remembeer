"""Pure social quest ranking and pair-eligibility engine."""

from collections.abc import Mapping, Sequence
from collections.abc import Set as AbstractSet
from dataclasses import dataclass
from math import ceil, floor
from urllib.parse import quote

from party_quest_catalog import (
    ALL_ELIGIBLE_MEMBERS,
    BOTTOM_QUARTER,
    DIFFERENT_ACCENT,
    DIFFERENT_BEERPONG_TEAM,
    DIFFERENT_CLASS,
    FINALIST_TEAM,
    LEADER,
    NEARBY_RANK,
    NEW_ALLY,
    OPPOSITE_HALVES,
    PARTY_CLASSES,
    SAME_ACCENT,
    SAME_BEERPONG_TEAM,
    SAME_CLASS,
    TARGET_CLASS_PREFIX,
    TOP_THREE,
)


@dataclass(frozen=True)
class QuestMember:
    """All deterministic member inputs needed by catalog rules."""

    user_id: str
    username: str
    score_units: int
    is_active: bool
    selected_class: str | None
    accent_color_key: str | None = None
    beerpong_team_id: str | None = None


@dataclass(frozen=True)
class RankingEntry:
    user_id: str
    rank: int
    position: int
    total: int


@dataclass(frozen=True)
class EligibilityContext:
    rankings: Mapping[str, RankingEntry]
    completed_pair_keys: frozenset[str] = frozenset()
    finalist_team_ids: frozenset[str] = frozenset()


@dataclass(frozen=True)
class EligibilitySnapshot:
    """Persistable result detached from mutable member/profile inputs."""

    eligibility_rule: str
    eligible_member_ids: tuple[str, ...]


def canonical_pair_key(first_user_id: str, second_user_id: str) -> str:
    """Match the immutable ledger's collision-safe mutual-pair key contract."""

    if not first_user_id or not second_user_id:
        raise ValueError("Pair user IDs must not be empty")
    if first_user_id == second_user_id:
        raise ValueError("A mutual pair requires two different users")
    first, second = sorted((first_user_id, second_user_id))
    return f"pair:{quote(first, safe='-_.~')}:{quote(second, safe='-_.~')}"


def candidate_members(members: Sequence[QuestMember]) -> tuple[QuestMember, ...]:
    """Return active, class-selected members in deterministic user-ID order."""

    candidates = [
        member
        for member in members
        if member.is_active and member.selected_class in PARTY_CLASSES
    ]
    user_ids = [member.user_id for member in candidates]
    if any(not user_id for user_id in user_ids) or len(set(user_ids)) != len(user_ids):
        raise ValueError("Candidate member IDs must be non-empty and unique")
    return tuple(sorted(candidates, key=lambda member: member.user_id))


def build_party_rankings(
    members: Sequence[QuestMember],
) -> dict[str, RankingEntry]:
    """Build competition ranks with username/user ID as stable tie ordering."""

    candidates = candidate_members(members)
    ordered = sorted(
        candidates,
        key=lambda member: (
            -member.score_units,
            member.username.casefold(),
            member.username,
            member.user_id,
        ),
    )
    rankings: dict[str, RankingEntry] = {}
    prior_score: int | None = None
    rank = 0
    for index, member in enumerate(ordered):
        if prior_score is None or member.score_units != prior_score:
            rank = index + 1
            prior_score = member.score_units
        rankings[member.user_id] = RankingEntry(
            user_id=member.user_id,
            rank=rank,
            position=index + 1,
            total=len(ordered),
        )
    return rankings


def build_eligibility_context(
    members: Sequence[QuestMember],
    *,
    completed_pair_keys: AbstractSet[str] = frozenset(),
    finalist_team_ids: AbstractSet[str] = frozenset(),
) -> EligibilityContext:
    return EligibilityContext(
        rankings=build_party_rankings(members),
        completed_pair_keys=frozenset(completed_pair_keys),
        finalist_team_ids=frozenset(finalist_team_ids),
    )


def is_eligible_pair(
    eligibility_rule: str,
    first: QuestMember,
    second: QuestMember,
    context: EligibilityContext,
) -> bool:
    """Evaluate one symmetric partner pair for a persisted rule string."""

    if (
        first.user_id == second.user_id
        or not _is_candidate(first)
        or not _is_candidate(second)
    ):
        return False
    if eligibility_rule == ALL_ELIGIBLE_MEMBERS:
        return True
    if eligibility_rule.startswith(TARGET_CLASS_PREFIX):
        target_class = eligibility_rule.removeprefix(TARGET_CLASS_PREFIX)
        if target_class not in PARTY_CLASSES:
            raise ValueError(f"Unknown target Party class: {target_class}")
        return (first.selected_class == target_class) != (
            second.selected_class == target_class
        )
    if eligibility_rule == SAME_ACCENT:
        return (
            first.accent_color_key is not None
            and first.accent_color_key == second.accent_color_key
        )
    if eligibility_rule == DIFFERENT_ACCENT:
        return (
            first.accent_color_key is not None
            and second.accent_color_key is not None
            and first.accent_color_key != second.accent_color_key
        )
    if eligibility_rule == NEW_ALLY:
        return (
            canonical_pair_key(first.user_id, second.user_id)
            not in context.completed_pair_keys
        )
    if eligibility_rule == SAME_CLASS:
        return first.selected_class == second.selected_class
    if eligibility_rule == DIFFERENT_CLASS:
        return first.selected_class != second.selected_class
    if eligibility_rule in {
        BOTTOM_QUARTER,
        LEADER,
        TOP_THREE,
        OPPOSITE_HALVES,
        NEARBY_RANK,
    }:
        return _ranking_pair_is_eligible(eligibility_rule, first, second, context)
    if eligibility_rule == DIFFERENT_BEERPONG_TEAM:
        return (
            first.beerpong_team_id is not None
            and second.beerpong_team_id is not None
            and first.beerpong_team_id != second.beerpong_team_id
        )
    if eligibility_rule == SAME_BEERPONG_TEAM:
        return (
            first.beerpong_team_id is not None
            and first.beerpong_team_id == second.beerpong_team_id
        )
    if eligibility_rule == FINALIST_TEAM:
        return (
            first.beerpong_team_id in context.finalist_team_ids
            or second.beerpong_team_id in context.finalist_team_ids
        )
    raise ValueError(f"Unknown eligibility rule: {eligibility_rule}")


def eligible_partner_ids(
    eligibility_rule: str,
    selector_user_id: str,
    members: Sequence[QuestMember],
    *,
    completed_pair_keys: AbstractSet[str] = frozenset(),
    finalist_team_ids: AbstractSet[str] = frozenset(),
) -> tuple[str, ...]:
    candidates = candidate_members(members)
    by_id = {member.user_id: member for member in candidates}
    selector = by_id.get(selector_user_id)
    if selector is None:
        return ()
    context = build_eligibility_context(
        candidates,
        completed_pair_keys=completed_pair_keys,
        finalist_team_ids=finalist_team_ids,
    )
    return tuple(
        member.user_id
        for member in candidates
        if is_eligible_pair(eligibility_rule, selector, member, context)
    )


def create_eligibility_snapshot(
    eligibility_rule: str,
    members: Sequence[QuestMember],
    *,
    completed_pair_keys: AbstractSet[str] = frozenset(),
    finalist_team_ids: AbstractSet[str] = frozenset(),
) -> EligibilitySnapshot:
    """Snapshot candidates that have at least one valid partner for the rule."""

    candidates = candidate_members(members)
    context = build_eligibility_context(
        candidates,
        completed_pair_keys=completed_pair_keys,
        finalist_team_ids=finalist_team_ids,
    )
    eligible_ids = tuple(
        member.user_id
        for member in candidates
        if any(
            is_eligible_pair(eligibility_rule, member, partner, context)
            for partner in candidates
            if partner.user_id != member.user_id
        )
    )
    return EligibilitySnapshot(eligibility_rule, eligible_ids)


def _is_candidate(member: QuestMember) -> bool:
    return member.is_active and member.selected_class in PARTY_CLASSES


def _ranking_pair_is_eligible(
    rule: str,
    first: QuestMember,
    second: QuestMember,
    context: EligibilityContext,
) -> bool:
    first_rank = context.rankings.get(first.user_id)
    second_rank = context.rankings.get(second.user_id)
    if first_rank is None or second_rank is None:
        return False
    if rule == BOTTOM_QUARTER:
        threshold = floor(first_rank.total * 0.75)
        return _exactly_one(first_rank.rank > threshold, second_rank.rank > threshold)
    if rule == LEADER:
        return _exactly_one(first_rank.rank == 1, second_rank.rank == 1)
    if rule == TOP_THREE:
        return _exactly_one(first_rank.rank <= 3, second_rank.rank <= 3)
    if rule == OPPOSITE_HALVES:
        threshold = ceil(first_rank.total / 2)
        return _exactly_one(first_rank.rank <= threshold, second_rank.rank <= threshold)
    return abs(first_rank.rank - second_rank.rank) <= 3


def _exactly_one(first: bool, second: bool) -> bool:
    return first != second
