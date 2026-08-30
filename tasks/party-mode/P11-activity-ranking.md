# P11: Party Activity Feed And Score Ranking

## Objective

Replace the old drink-count view with paginated auditable activity and materialized score ranking.

## Dependencies

- P04
- P08
- P09

## References

- `PARTY_MODE_PLAN.md`: Activity Tab, Ranking Tab, Immutable Score Events
- Current `lib/party/widget/party_ranking.dart`
- Existing activity widgets/services under `lib/activity/`
- `/home/ondrej/projects/rozlucka/src/components/ActivityPage.tsx`
- `/home/ondrej/projects/rozlucka/src/components/LeaderboardPage.tsx`
- `/home/ondrej/projects/rozlucka/convex/events.ts`
- `/home/ondrej/projects/rozlucka/convex/leaderboard.ts`

## Scope

- Implement newest-first event pagination.
- Filter by multiple people and event kinds using OR within a category and AND across categories.
- Render drink, quest, challenge, placement, and reversal events.
- Keep reversed awards visible and visibly reversed.
- Group shared-source outcomes where useful.
- Rank Party members by aggregate score with shared ranks and deterministic username ordering.
- Show current-user/top-three treatment and secondary drink count.

## Likely Files

- `lib/party/service/party_ranking_service.dart`
- `lib/party/widget/party_activity_tab.dart`
- `party_activity_filters.dart`
- `party_event_card.dart`
- `party_ranking_tab.dart`
- Related service/widget tests
- Delete old ranking widget only after replacement passes

## Deliverables

- Production Activity and Ranking tabs.
- Pagination/filter/rank tests.

## Acceptance Criteria

- Ranking reads member aggregates and never folds the full event ledger client-side.
- Ties share a rank and sort deterministically.
- Filters use the approved combination semantics.
- Reversals remain auditable.
- Archived Party rendering remains fully readable.

## Verification

```bash
flutter test test/party/service/party_ranking_service_test.dart test/party/widget
flutter analyze --fatal-warnings
```

## Coordination

Own Activity/Ranking tab internals, not the shell or routes. Preserve P08's tab contracts and P13's Games work.
