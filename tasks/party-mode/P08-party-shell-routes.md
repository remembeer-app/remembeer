# P08: Three-Tab Party Shell And Typed Routes

## Objective

Replace the current ranking-only Party page with Activity, Ranking, and Games top tabs while preserving the main bottom navigation.

## Dependencies

- P02
- P04
- P06

## References

- `PARTY_MODE_PLAN.md`: Party Shell, Routes
- `lib/party/page/party_page.dart`
- `lib/party/widget/party_ranking.dart`
- `lib/routes.dart`
- `lib/common/widget/nav_bar.dart`

## Scope

- Add a typed `tab` query parameter with Activity as default and safe invalid-value fallback.
- Build a `TabBar`/`TabBarView` inside the existing Drink branch.
- Add typed management, quest, challenge, and tournament detail routes.
- Add admin app-bar access, Party status presentation, and archive read-only state.
- Provide stable placeholder tab widgets for feature agents to replace/extend.
- Preserve tab context when opening and returning from details.

## Likely Files

- `lib/party/page/party_page.dart`
- Initial tab widgets under `lib/party/widget/`
- `lib/routes.dart` and generated `lib/routes.g.dart`
- `test/party/page/party_page_test.dart`
- Route tests

## Deliverables

- Working three-tab Party shell under the persistent app navigation.
- Typed nested Party routes and restoration tests.

## Acceptance Criteria

- `/drink/parties/:sessionId` remains under `DrinkBranch` and the main bottom bar stays visible.
- Activity is selected for missing or invalid tab values.
- Route restoration selects the requested tab.
- Detail routes return to the prior Party context.
- Archived Parties expose no mutation controls.

## Verification

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/party/page test/routes
flutter analyze --fatal-warnings
```

## Coordination

Build on P02's routes. P13 owns the final Games layout; P11 owns Activity/Ranking content. Keep tab widgets separable to reduce merge conflicts.
