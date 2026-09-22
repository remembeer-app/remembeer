import pytest

from party_quest_catalog import (
    BUILT_IN_QUEST_CATALOG,
    CATALOG_VERSION,
    DIFFERENT_CLASS,
    EARLY_AVAILABILITY,
    FINAL_AVAILABILITY,
    PARTY_CLASSES,
    REGULAR_AVAILABILITY,
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
    assert [
        template.availability for template in BUILT_IN_QUEST_CATALOG
    ].count(EARLY_AVAILABILITY) == 10
    assert [
        template.availability for template in BUILT_IN_QUEST_CATALOG
    ].count(REGULAR_AVAILABILITY) == 7
    assert [
        template.availability for template in BUILT_IN_QUEST_CATALOG
    ].count(FINAL_AVAILABILITY) == 1


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
        assert document["availability"] in {
            EARLY_AVAILABILITY,
            REGULAR_AVAILABILITY,
            FINAL_AVAILABILITY,
        }
        assert document["pointsUnits"] > 0
        assert "durationMinutes" not in document


def test_non_builtin_template_sources_are_rejected() -> None:
    with pytest.raises(ValueError, match="Unknown quest template source"):
        validate_template_eligibility_rule("custom", "allEligibleMembers")


def test_every_catalog_rule_is_valid_for_builtin_templates() -> None:
    for template in BUILT_IN_QUEST_CATALOG:
        validate_template_eligibility_rule("builtIn", template.eligibility_rule)


def test_every_instruction_uses_toast_and_mutual_selection_copy() -> None:
    for template in BUILT_IN_QUEST_CATALOG:
        assert "Have a toast" in template.instructions
        assert "select each other" in template.instructions
        assert "Find " not in template.instructions

    class_templates = [
        template
        for template in BUILT_IN_QUEST_CATALOG
        if template.eligibility_rule.startswith(TARGET_CLASS_PREFIX)
    ]
    assert all(
        "Exactly one of you must be a" in item.instructions
        for item in class_templates
    )
