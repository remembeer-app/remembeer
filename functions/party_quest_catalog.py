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
                f"Find a {_CLASS_TITLES[party_class]}, share a toast, and select "
                "each other before time runs out. Exactly one partner must have "
                "that class."
            ),
            points_units=_points(30),
            duration_minutes=DEFAULT_DURATION_MINUTES,
            eligibility_rule=f"{TARGET_CLASS_PREFIX}{party_class}",
        )
        for party_class in PARTY_CLASSES
    ]


BUILT_IN_QUEST_CATALOG: tuple[BuiltInQuestTemplate, ...] = tuple(
    _class_templates()
    + [
        BuiltInQuestTemplate(
            "same-accent",
            "Color Alliance",
            "Find someone with the same profile accent and select each other.",
            _points(25),
            DEFAULT_DURATION_MINUTES,
            SAME_ACCENT,
        ),
        BuiltInQuestTemplate(
            "different-accent",
            "Color Contrast",
            "Find someone with a different profile accent and select each other.",
            _points(20),
            DEFAULT_DURATION_MINUTES,
            DIFFERENT_ACCENT,
        ),
        BuiltInQuestTemplate(
            "new-ally",
            "New Ally",
            "Find someone you have not completed a social quest with before.",
            _points(30),
            DEFAULT_DURATION_MINUTES,
            NEW_ALLY,
        ),
        BuiltInQuestTemplate(
            "different-class",
            "Cross-Class Alliance",
            "Find someone from a different Party class and select each other.",
            _points(25),
            DEFAULT_DURATION_MINUTES,
            DIFFERENT_CLASS,
        ),
        BuiltInQuestTemplate(
            "same-class",
            "Class Fellowship",
            "Find someone from your Party class and select each other.",
            _points(25),
            DEFAULT_DURATION_MINUTES,
            SAME_CLASS,
        ),
        BuiltInQuestTemplate(
            "rescue-last",
            "Rescue the Underdog",
            "Exactly one partner must be in the bottom quarter of the ranking.",
            _points(30),
            DEFAULT_DURATION_MINUTES,
            BOTTOM_QUARTER,
        ),
        BuiltInQuestTemplate(
            "champion-challenger",
            "Challenge the Champion",
            "Exactly one partner must currently share first place.",
            _points(30),
            DEFAULT_DURATION_MINUTES,
            LEADER,
        ),
        BuiltInQuestTemplate(
            "medalist-hunt",
            "Medalist Hunt",
            "Exactly one partner must currently hold a top-three rank.",
            _points(30),
            DEFAULT_DURATION_MINUTES,
            TOP_THREE,
        ),
        BuiltInQuestTemplate(
            "helping-hand",
            "Helping Hand",
            "Pair one member from the top half with one from the bottom half.",
            _points(30),
            DEFAULT_DURATION_MINUTES,
            OPPOSITE_HALVES,
        ),
        BuiltInQuestTemplate(
            "middle-table",
            "Close Rivals",
            "Find someone no more than three shared ranks away from you.",
            _points(25),
            DEFAULT_DURATION_MINUTES,
            NEARBY_RANK,
        ),
        BuiltInQuestTemplate(
            "beerpong-diplomat",
            "Beerpong Diplomat",
            "Find someone assigned to a different beerpong team.",
            _points(25),
            DEFAULT_DURATION_MINUTES,
            DIFFERENT_BEERPONG_TEAM,
        ),
        BuiltInQuestTemplate(
            "team-morale",
            "Team Morale",
            "Find a member of your beerpong team and select each other.",
            _points(25),
            DEFAULT_DURATION_MINUTES,
            SAME_BEERPONG_TEAM,
        ),
        BuiltInQuestTemplate(
            "final-aura",
            "Finalist Aura",
            "At least one partner must belong to a beerpong finalist team.",
            _points(30),
            DEFAULT_DURATION_MINUTES,
            FINALIST_TEAM,
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
    """Validate built-in rules and enforce custom templates' v1 restriction."""

    if source == "custom":
        if eligibility_rule != ALL_ELIGIBLE_MEMBERS:
            raise ValueError("Custom templates must use allEligibleMembers")
        return
    if source != "builtIn":
        raise ValueError(f"Unknown quest template source: {source}")
    if eligibility_rule in _FIXED_BUILT_IN_RULES:
        return
    if eligibility_rule.startswith(TARGET_CLASS_PREFIX):
        target_class = eligibility_rule.removeprefix(TARGET_CLASS_PREFIX)
        if target_class in PARTY_CLASSES:
            return
    raise ValueError(f"Unknown built-in eligibility rule: {eligibility_rule}")
