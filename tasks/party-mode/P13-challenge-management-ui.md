# P13: Party Management, Games Tab, And Challenge UI

## Objective

Build Party management, the extensible Games tab structure, and member/admin challenge experiences.

## Dependencies

- P04
- P08
- P12

## References

- `PARTY_MODE_PLAN.md`: Games Tab, Admin Challenges
- Existing `SettingsPageTemplate`, `LoadingForm`, confirmation-dialog, and notification patterns
- `/home/ondrej/projects/rozlucka/src/components/AdminPage.tsx`
- `/home/ondrej/projects/rozlucka/src/components/ActivityPage.tsx`

## Scope

- Build the Party management page and independent module toggles.
- Establish Games as composed quest, challenge, and beerpong sections so later agents can add child widgets without rewriting the page.
- Add challenge creation, current state, countdown, recent results, multi-winner selection, complete, cancel, and reversal controls.
- Enforce admin/member/archive presentation rules.

## Likely Files

- `lib/party/service/party_challenge_service.dart`
- `lib/party/page/party_management_page.dart`
- `lib/party/page/challenge_detail_page.dart`
- `lib/party/widget/party_games_tab.dart`
- `party_module_settings.dart`
- `challenge_card.dart`
- Related page/widget tests

## Deliverables

- Extensible Games layout and complete challenge UI.
- Admin management controls using established app patterns.

## Acceptance Criteria

- Members cannot see admin mutations.
- Modules appear independently according to settings.
- Duplicate winner choices are disabled.
- Countdown/status behavior is clear at expiry.
- Corrections and cancellations require destructive confirmations.
- Archived views are read-only.

## Verification

```bash
flutter test test/party/page/party_management_page_test.dart test/party/widget/party_games_tab_test.dart
flutter analyze --fatal-warnings
```

## Coordination

P17 and P20 will add isolated child sections to the Games/management structure. Avoid placing quest or beerpong business state directly in the parent widgets.
