"""Versioned built-in social quest catalog.

The source catalog's gender quest is generalized to ``differentClass`` because
Remembeer has no gender profile field. Its three class-target quests are
expanded across all five Party classes, so the resulting catalog has eighteen
templates while preserving all sixteen source concepts.
"""

from collections.abc import Sequence
from dataclasses import dataclass
from typing import Any

CATALOG_VERSION = 1
DEFAULT_DURATION_MINUTES = 15
POINT_UNITS_PER_POINT = 1_000
PARTY_CLASSES = ("beer", "cider", "cocktail", "spirit", "wine")

EARLY_AVAILABILITY = "early"
REGULAR_AVAILABILITY = "regular"
FINAL_AVAILABILITY = "final"
QUEST_AVAILABILITIES = (
    EARLY_AVAILABILITY,
    REGULAR_AVAILABILITY,
    FINAL_AVAILABILITY,
)

ALL_ELIGIBLE_MEMBERS = "allEligibleMembers"
SAME_ACCENT = "sameAccent"
DIFFERENT_ACCENT = "differentAccent"
NEW_ALLY = "newAlly"
SAME_CLASS = "sameClass"
DIFFERENT_CLASS = "differentClass"
BOTTOM_QUARTER = "bottomQuarter"
LEADER = "leader"
TOP_THREE = "topThree"
OPPOSITE_HALVES = "oppositeRankingHalves"
NEARBY_RANK = "nearbyRank"
DIFFERENT_BEERPONG_TEAM = "differentBeerpongTeam"
SAME_BEERPONG_TEAM = "sameBeerpongTeam"
FINALIST_TEAM = "finalistTeam"
TARGET_CLASS_PREFIX = "oneMemberClass:"

_FIXED_BUILT_IN_RULES = frozenset(
    {
        SAME_ACCENT,
        DIFFERENT_ACCENT,
        NEW_ALLY,
        SAME_CLASS,
        DIFFERENT_CLASS,
        BOTTOM_QUARTER,
        LEADER,
        TOP_THREE,
        OPPOSITE_HALVES,
        NEARBY_RANK,
        DIFFERENT_BEERPONG_TEAM,
        SAME_BEERPONG_TEAM,
        FINALIST_TEAM,
    }
)


@dataclass(frozen=True)
class BuiltInQuestTemplate:
    """Firestore-independent representation of a built-in template."""

    key: str
    title: str
    instructions: str
    points_units: int
    duration_minutes: int
    eligibility_rule: str
    availability: str

    @property
    def template_id(self) -> str:
        return f"builtin-v{CATALOG_VERSION}-{self.key}"

    def seed_document(self, created_at: Any) -> dict[str, Any]:
        return {
            "source": "builtIn",
            "builtInKey": self.key,
            "title": self.title,
            "instructions": self.instructions,
            "pointsUnits": self.points_units,
            "durationMinutes": self.duration_minutes,
            "eligibilityRule": self.eligibility_rule,
            "availability": self.availability,
            "enabled": True,
            "catalogVersion": CATALOG_VERSION,
            "createdByUserId": None,
            "createdAt": created_at,
            "updatedAt": created_at,
        }


_CLASS_TITLES = {
    "beer": "Beer Paladin",
    "cider": "Cider Sentinel",
    "cocktail": "Cocktail Druid",
    "spirit": "Spirit Shaman",
    "wine": "Wine Warrior",
}


def _points(value: int) -> int:
    return value * POINT_UNITS_PER_POINT


def _class_templates() -> list[BuiltInQuestTemplate]:
    return [
        BuiltInQuestTemplate(
            key=f"toast-with-{party_class}",
            title=f"Toast with a {_CLASS_TITLES[party_class]}",
            instructions=(
                "Have a toast together and select each other before time runs "
                "out. Exactly one of you must be a "
                f"{_CLASS_TITLES[party_class]}."
            ),
            points_units=_points(30),
            duration_minutes=DEFAULT_DURATION_MINUTES,
            eligibility_rule=f"{TARGET_CLASS_PREFIX}{party_class}",
            availability=EARLY_AVAILABILITY,
        )
        for party_class in PARTY_CLASSES
    ]


BUILT_IN_QUEST_CATALOG: tuple[BuiltInQuestTemplate, ...] = tuple(
    _class_templates()
    + [
        BuiltInQuestTemplate(
            "same-accent",
            "Color Alliance",
            (
                "Have a toast with someone with the same profile accent and select "
                "each other."
            ),
            _points(25),
            DEFAULT_DURATION_MINUTES,
            SAME_ACCENT,
            EARLY_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "different-accent",
            "Color Contrast",
            (
                "Have a toast with someone with a different profile accent and "
                "select each other."
            ),
            _points(20),
            DEFAULT_DURATION_MINUTES,
            DIFFERENT_ACCENT,
            EARLY_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "new-ally",
            "New Ally",
            (
                "Have a toast with someone you have not completed a social quest "
                "with before and select each other."
            ),
            _points(30),
            DEFAULT_DURATION_MINUTES,
            NEW_ALLY,
            EARLY_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "different-class",
            "Cross-Class Alliance",
            (
                "Have a toast with someone from a different Party class and select "
                "each other."
            ),
            _points(25),
            DEFAULT_DURATION_MINUTES,
            DIFFERENT_CLASS,
            EARLY_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "same-class",
            "Class Fellowship",
            (
                "Have a toast with someone from your Party class and select each "
                "other."
            ),
            _points(25),
            DEFAULT_DURATION_MINUTES,
            SAME_CLASS,
            EARLY_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "rescue-last",
            "Rescue the Underdog",
            (
                "Have a toast and select each other. Exactly one of you must be in "
                "the bottom quarter of the ranking."
            ),
            _points(30),
            DEFAULT_DURATION_MINUTES,
            BOTTOM_QUARTER,
            REGULAR_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "champion-challenger",
            "Challenge the Champion",
            (
                "Have a toast and select each other. Exactly one of you must "
                "currently share first place."
            ),
            _points(30),
            DEFAULT_DURATION_MINUTES,
            LEADER,
            REGULAR_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "medalist-hunt",
            "Medalist Hunt",
            (
                "Have a toast and select each other. Exactly one of you must "
                "currently hold a top-three rank."
            ),
            _points(30),
            DEFAULT_DURATION_MINUTES,
            TOP_THREE,
            REGULAR_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "helping-hand",
            "Helping Hand",
            (
                "Have a toast across the ranking halves and select each other. One "
                "of you must be in the top half and the other in the bottom half."
            ),
            _points(30),
            DEFAULT_DURATION_MINUTES,
            OPPOSITE_HALVES,
            REGULAR_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "middle-table",
            "Close Rivals",
            (
                "Have a toast with someone no more than three shared ranks away and "
                "select each other."
            ),
            _points(25),
            DEFAULT_DURATION_MINUTES,
            NEARBY_RANK,
            REGULAR_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "beerpong-diplomat",
            "Beerpong Diplomat",
            (
                "Have a toast with someone assigned to a different beerpong team "
                "and select each other."
            ),
            _points(25),
            DEFAULT_DURATION_MINUTES,
            DIFFERENT_BEERPONG_TEAM,
            REGULAR_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "team-morale",
            "Team Morale",
            (
                "Have a toast with a member of your beerpong team and select each "
                "other."
            ),
            _points(25),
            DEFAULT_DURATION_MINUTES,
            SAME_BEERPONG_TEAM,
            REGULAR_AVAILABILITY,
        ),
        BuiltInQuestTemplate(
            "final-aura",
            "Finalist Aura",
            (
                "Have a toast and select each other. At least one of you must belong "
                "to a beerpong finalist team."
            ),
            _points(30),
            DEFAULT_DURATION_MINUTES,
            FINALIST_TEAM,
            FINAL_AVAILABILITY,
        ),
    ]
)


def built_in_quest_catalog() -> Sequence[BuiltInQuestTemplate]:
    """Return the immutable catalog in stable seed order."""

    return BUILT_IN_QUEST_CATALOG


def built_in_template_seed_documents(
    created_at: Any,
) -> tuple[tuple[str, dict[str, Any]], ...]:
    """Convert the catalog to complete quest-template seed documents."""

    return tuple(
        (template.template_id, template.seed_document(created_at))
        for template in BUILT_IN_QUEST_CATALOG
    )


def validate_template_eligibility_rule(source: str, eligibility_rule: str) -> None:
    """Validate an eligibility rule from a built-in template."""

    if source != "builtIn":
        raise ValueError(f"Unknown quest template source: {source}")
    if eligibility_rule in _FIXED_BUILT_IN_RULES:
        return
    if eligibility_rule.startswith(TARGET_CLASS_PREFIX):
        target_class = eligibility_rule.removeprefix(TARGET_CLASS_PREFIX)
        if target_class in PARTY_CLASSES:
            return
    raise ValueError(f"Unknown built-in eligibility rule: {eligibility_rule}")
