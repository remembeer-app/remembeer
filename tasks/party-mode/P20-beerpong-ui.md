# P20: Beerpong Flutter Enrollment, Bracket, And Admin UI

## Objective

Build responsive member and admin tournament experiences for enrollment through final results.

## Dependencies

- P08
- P13
- P19

## References

- `PARTY_MODE_PLAN.md`: Games Tab, Beerpong Tournament
- Existing Remembeer responsive/theme/action patterns
- `/home/ondrej/projects/rozlucka/src/components/BeerpongPage.tsx`
- `/home/ondrej/projects/rozlucka/src/components/AdminPage.tsx` (`BeerpongAdminPanel`)

## Scope

- Add member opt-in and enrollment summary.
- Add admin team count, third-place, placement point, draw/redraw, and team rename controls.
- Render teams, ready/pending/completed matches, byes, winners, and placements.
- Support horizontal bracket navigation on narrow screens and effective wide layouts.
- Highlight the current user's team and state without relying only on color.
- Add match result, correction, and finalization confirmations.
- Add finalized and archived read-only modes.

## Likely Files

- `lib/party/service/beerpong_service.dart`
- `lib/party/page/beerpong_page.dart`
- `lib/party/widget/beerpong_bracket.dart`
- Isolated beerpong sections added to Games/management pages
- Beerpong page/widget tests

## Deliverables

- Complete tournament UI from enrollment through archive.
- Responsive widget coverage.

## Acceptance Criteria

- Brackets remain usable on narrow and wide screens.
- Byes and unresolved slots are clear.
- Admin controls appear only for valid states and ready matches.
- Current team/winner states are accessible without color alone.
- Finalized/archive modes reject and hide mutation controls.

## Verification

```bash
flutter test test/party/page/beerpong_page_test.dart test/party/widget/beerpong_bracket_test.dart
flutter analyze --fatal-warnings
```

## Coordination

Add beerpong UI as child widgets to P13's established composition. Do not rewrite challenge or quest sections.
