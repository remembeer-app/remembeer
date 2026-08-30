# P10: Party Drink Client Routing And Class Selection

## Objective

Route every Party drink mutation through backend callables and add member/admin class controls without changing non-Party behavior.

## Dependencies

- P04
- P09

## References

- `PARTY_MODE_PLAN.md`: Games Tab, Party Classes And Drink Scoring
- `lib/drink/service/drink_service.dart`
- `lib/drink/page/add_drink_page.dart`
- Existing drink update/delete and quick-add call sites
- Existing form/loading/notification patterns
- `/home/ondrej/projects/rozlucka/src/components/AuthForm.tsx` for class-selection behavior only

## Scope

- Detect Party targets and delegate create/update/delete/quick-add to callable wrappers.
- Preserve the current direct path for non-Party Sessions.
- Generate stable command IDs and map callable results/errors.
- Build five-class member selection UI.
- Add admin class changes for active members with prospective-only explanation.
- Remove class/mutation controls when archived.

## Likely Files

- `lib/drink/service/drink_service.dart`
- Add/update/delete drink pages and widgets
- `lib/party/service/party_service.dart`
- `lib/party/widget/party_class_selector.dart`
- `lib/party/page/party_profile_page.dart`
- Drink and class widget tests

## Deliverables

- Complete Party/non-Party client routing.
- Member self-selection and admin class-management flows.

## Acceptance Criteria

- All Party drink entry points, including long-press quick add, use callables.
- Non-Party flows remain behaviorally unchanged.
- Members can select an initial class.
- Admins can change any active member's class.
- UI states clearly that changes affect future drinks only.

## Verification

```bash
flutter test test/drink test/party/widget/party_class_selector_test.dart
flutter analyze --fatal-warnings
```

## Coordination

This task owns shared Dart drink files. Do not recompute Party points on the client. Coordinate any Party service API additions with P04 rather than duplicating controllers.
