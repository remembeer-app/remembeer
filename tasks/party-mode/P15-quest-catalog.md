# P15: Built-In Quest Catalog And Eligibility Engine

## Objective

Port and generalize Rozlucka's 16 social quest concepts into a versioned, testable five-class eligibility engine.

## Dependencies

- P01
- P03
- P05

## References

- `PARTY_MODE_PLAN.md`: Quest Templates, Active Social Quests
- `/home/ondrej/projects/rozlucka/convex/randomEvents.ts`
- `/home/ondrej/projects/rozlucka/convex/schema.ts`

## Scope

- Define a versioned English built-in catalog.
- Generalize class quests across beer, cider, cocktail, spirit, and wine.
- Implement same/different accent, different gender, new ally/history, ranking, team, and finalist eligibility.
- Define deterministic inputs and outputs independent of Firestore calls.
- Handle ranking ties consistently with Party ranking rules.
- Support custom templates through `allEligibleMembers` only.
- Produce eligibility snapshots that remain unchanged after profile edits.

## Likely Files

- `functions/party_quest_catalog.py`
- `functions/party_quest_eligibility.py`
- `functions/tests/test_party_quest_catalog.py`
- `functions/tests/test_party_quest_eligibility.py`

## Deliverables

- Pure catalog and eligibility APIs consumed by P16.
- Tests for every rule and boundary.

## Acceptance Criteria

- All 16 source concepts are represented or explicitly generalized.
- All five classes are treated symmetrically.
- Only active, class-selected members can enter candidate sets.
- Profile changes after creation cannot alter a snapshot.
- Empty and fewer-than-two eligible cases are deterministic.

## Verification

```bash
python -m pytest functions/tests/test_party_quest_catalog.py functions/tests/test_party_quest_eligibility.py
python -m compileall functions
```

## Coordination

Keep this engine pure and do not implement schedulers, Firestore commands, notifications, UI, rules, or `main.py` exports.
