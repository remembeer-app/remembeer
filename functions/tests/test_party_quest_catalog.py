import pytest

from party_quest_catalog import (
    BUILT_IN_QUEST_CATALOG,
    CATALOG_VERSION,
    DIFFERENT_CLASS,
    PARTY_CLASSES,
    TARGET_CLASS_PREFIX,
    built_in_template_seed_documents,
    validate_template_eligibility_rule,
)


def test_catalog_preserves_source_concepts_and_generalizes_all_classes() -> None:
    assert len(BUILT_IN_QUEST_CATALOG) == 18
    assert {
        template.eligibility_rule
        for template in BUILT_IN_QUEST_CATALOG
        if template.eligibility_rule.startswith(TARGET_CLASS_PREFIX)
    } == {f"{TARGET_CLASS_PREFIX}{party_class}" for party_class in PARTY_CLASSES}
    assert DIFFERENT_CLASS in {
        template.eligibility_rule for template in BUILT_IN_QUEST_CATALOG
    }
    assert len({template.key for template in BUILT_IN_QUEST_CATALOG}) == 18
    assert len({template.template_id for template in BUILT_IN_QUEST_CATALOG}) == 18


def test_seed_documents_match_party_template_schema() -> None:
    timestamp = object()
    seeds = built_in_template_seed_documents(timestamp)

    assert seeds[0][0] == "builtin-v1-toast-with-beer"
    assert all(seed[0].startswith("builtin-v1-") for seed in seeds)
    for _, document in seeds:
        assert document["source"] == "builtIn"
        assert document["catalogVersion"] == CATALOG_VERSION
        assert document["createdByUserId"] is None
        assert document["createdAt"] is timestamp
        assert document["updatedAt"] is timestamp
        assert document["enabled"] is True
        assert document["pointsUnits"] > 0
        assert document["durationMinutes"] > 0


def test_custom_templates_are_restricted_to_all_eligible_members() -> None:
    validate_template_eligibility_rule("custom", "allEligibleMembers")

    with pytest.raises(ValueError, match="Custom templates"):
        validate_template_eligibility_rule("custom", "sameAccent")


def test_every_catalog_rule_is_valid_for_builtin_templates() -> None:
    for template in BUILT_IN_QUEST_CATALOG:
        validate_template_eligibility_rule("builtIn", template.eligibility_rule)
