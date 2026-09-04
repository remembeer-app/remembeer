import pytest

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
    SAME_ACCENT,
    SAME_BEERPONG_TEAM,
    SAME_CLASS,
    TARGET_CLASS_PREFIX,
    TOP_THREE,
)
from party_quest_eligibility import (
    QuestMember,
    build_party_rankings,
    canonical_pair_key,
    create_eligibility_snapshot,
    eligible_partner_ids,
)


def _member(
    user_id: str,
    *,
    party_class: str | None = "beer",
    accent: str | None = "amber",
    score: int = 0,
    active: bool = True,
    team: str | None = None,
) -> QuestMember:
    return QuestMember(user_id, user_id, score, active, party_class, accent, team)


def test_candidates_require_active_membership_and_selected_valid_class() -> None:
    members = [
        _member("eligible"),
        _member("inactive", active=False),
        _member("unselected", party_class=None),
        _member("invalid", party_class="mead"),
    ]

    snapshot = create_eligibility_snapshot(ALL_ELIGIBLE_MEMBERS, members)

    assert snapshot.eligible_member_ids == ()
    assert eligible_partner_ids(ALL_ELIGIBLE_MEMBERS, "eligible", members) == ()


@pytest.mark.parametrize("party_class", ["beer", "cider", "cocktail", "spirit", "wine"])
def test_target_class_rules_treat_all_five_classes_symmetrically(
    party_class: str,
) -> None:
    members = [
        _member("target", party_class=party_class),
        _member("other", party_class="wine" if party_class != "wine" else "beer"),
        _member("also-target", party_class=party_class),
    ]

    rule = f"{TARGET_CLASS_PREFIX}{party_class}"
    assert eligible_partner_ids(rule, "target", members) == ("other",)
    assert eligible_partner_ids(rule, "other", members) == ("also-target", "target")


@pytest.mark.parametrize(
    ("rule", "expected"),
    [
        (SAME_ACCENT, ("same",)),
        (DIFFERENT_ACCENT, ("different",)),
        (SAME_CLASS, ("missing-accent", "same")),
        (DIFFERENT_CLASS, ("different",)),
    ],
)
def test_profile_and_class_rules(rule: str, expected: tuple[str, ...]) -> None:
    members = [
        _member("selector"),
        _member("same"),
        _member("different", party_class="wine", accent="rose"),
        _member("missing-accent", accent=None),
    ]
    assert eligible_partner_ids(rule, "selector", members) == expected


def test_new_ally_excludes_completed_pairs_regardless_of_pair_order() -> None:
    members = [_member("a"), _member("b"), _member("c")]
    history = {canonical_pair_key("b", "a")}

    assert eligible_partner_ids(
        NEW_ALLY, "a", members, completed_pair_keys=history
    ) == ("c",)


def test_ranking_uses_shared_ranks_and_deterministic_tie_order() -> None:
    members = [
        QuestMember("z", "Zed", 100, True, "beer"),
        QuestMember("a", "Amy", 100, True, "beer"),
        QuestMember("b", "Bob", 50, True, "beer"),
        QuestMember("c", "Cal", 0, True, "beer"),
    ]

    rankings = build_party_rankings(members)

    assert (rankings["a"].rank, rankings["a"].position) == (1, 1)
    assert (rankings["z"].rank, rankings["z"].position) == (1, 2)
    assert rankings["b"].rank == 3
    assert rankings["c"].rank == 4
    assert eligible_partner_ids(LEADER, "a", members) == ("b", "c")
    assert eligible_partner_ids(TOP_THREE, "a", members) == ("c",)
    assert eligible_partner_ids(BOTTOM_QUARTER, "c", members) == ("a", "b", "z")
    assert eligible_partner_ids(OPPOSITE_HALVES, "c", members) == ("a", "z")
    assert eligible_partner_ids(NEARBY_RANK, "a", members) == ("b", "c", "z")


def test_ranking_boundaries_do_not_split_score_ties() -> None:
    members = [
        _member("a", score=30),
        _member("b", score=20),
        _member("c", score=20),
        _member("d", score=0),
    ]

    assert eligible_partner_ids(OPPOSITE_HALVES, "d", members) == ("a", "b", "c")
    assert eligible_partner_ids(BOTTOM_QUARTER, "d", members) == ("a", "b", "c")


def test_beerpong_team_and_finalist_rules() -> None:
    members = [
        _member("selector", team="finalist"),
        _member("teammate", team="finalist"),
        _member("opponent", team="other"),
        _member("unassigned"),
    ]
    assert eligible_partner_ids(SAME_BEERPONG_TEAM, "selector", members) == (
        "teammate",
    )
    assert eligible_partner_ids(DIFFERENT_BEERPONG_TEAM, "selector", members) == (
        "opponent",
    )
    assert eligible_partner_ids(
        FINALIST_TEAM,
        "selector",
        members,
        finalist_team_ids={"finalist"},
    ) == ("opponent", "teammate", "unassigned")


def test_snapshot_is_sorted_and_unchanged_after_profile_input_changes() -> None:
    members = [_member("z", accent="amber"), _member("a", accent="amber")]
    snapshot = create_eligibility_snapshot(SAME_ACCENT, members)
    members[0] = _member("z", accent="rose")

    assert snapshot.eligible_member_ids == ("a", "z")
    assert create_eligibility_snapshot(SAME_ACCENT, members).eligible_member_ids == ()


@pytest.mark.parametrize("count", [0, 1])
def test_fewer_than_two_candidates_produce_empty_snapshot(count: int) -> None:
    members = [_member("only")][:count]
    assert (
        create_eligibility_snapshot(ALL_ELIGIBLE_MEMBERS, members).eligible_member_ids
        == ()
    )


def test_unknown_rules_and_target_classes_fail_explicitly() -> None:
    members = [_member("a"), _member("b")]
    with pytest.raises(ValueError, match="Unknown eligibility rule"):
        create_eligibility_snapshot("unknown", members)
    with pytest.raises(ValueError, match="Unknown target Party class"):
        create_eligibility_snapshot(f"{TARGET_CLASS_PREFIX}mead", members)
