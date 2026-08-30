# P17: Social Quest Flutter Experience

## Objective

Add member quest participation and admin quest-template/schedule management to the established Party UI.

## Dependencies

- P08
- P13
- P16

## References

- `PARTY_MODE_PLAN.md`: Games Tab, Quest Templates, Active Social Quests
- Existing form, picker, confirmation, and `AsyncBuilder` patterns
- `/home/ondrej/projects/rozlucka/src/components/ActivityPage.tsx` (`RandomEventSheet` behavior)
- `/home/ondrej/projects/rozlucka/src/components/AdminPage.tsx` scheduling controls

## Scope

- Add active quest card/countdown and quest detail route content.
- Show only snapshot-eligible partners.
- Support pending selection changes and immutable completed-pair state.
- Add custom template creation and built-in enable/disable management.
- Add bounded duration/min/max interval forms.
- Add disabled, insufficient-participant, empty, expired, and archived states.

## Likely Files

- `lib/party/service/party_quest_service.dart`
- `lib/party/page/quest_detail_page.dart`
- `lib/party/widget/quest_card.dart`
- Isolated quest sections added to Games/management pages
- Quest page/widget tests

## Deliverables

- Complete member and admin quest experience.
- Widget tests for countdown and selection states.

## Acceptance Criteria

- Ineligible users never appear in partner selection.
- Pending selection can change until a reciprocal match completes.
- Completed pair state is immutable and clearly shown.
- Custom forms explain mutual confirmation and enforce limits.
- Archived Parties remain readable and non-interactive.

## Verification

```bash
flutter test test/party/page/quest_detail_page_test.dart test/party/widget/quest_card_test.dart
flutter analyze --fatal-warnings
```

## Coordination

Add quest UI as child widgets to P13's Games/management composition. Do not rewrite the shared parent or challenge section.
