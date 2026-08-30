# P09: Server-Authoritative Party Drink Commands

## Objective

Implement create, update, and delete commands for Party drinks while preserving normal statistics, logical-day attribution, and badge behavior.

## Dependencies

- P05
- P06

## References

- `PARTY_MODE_PLAN.md`: Party Classes And Drink Scoring, Party Drink Commands
- `lib/drink/service/drink_service.dart`
- `lib/drink/model/drink.dart`
- `lib/user/model/user_model.dart`
- `lib/user/service/user_stats_service.dart`
- `lib/date/util/date_utils.dart`
- `lib/badge/`
- `/home/ondrej/projects/rozlucka/convex/drinkClass.ts`
- `/home/ondrej/projects/rozlucka/convex/events.ts`

## Scope

- Port existing Party-targeted drink invariants and side effects to server-controlled transactions.
- Implement create/update/delete commands with ownership, capacity, time, type, volume, location, and archive validation.
- Snapshot class and class version at creation.
- Create immutable award revisions and reversal events for edits/deletes.
- Reproduce user daily/monthly stats using `endOfDayBoundary` and preserve badge behavior.
- Keep Party points isolated from global leaderboard/stat values.
- Add idempotency and race tests.

## Likely Files

- `functions/party_drinks.py`
- `functions/party_user_stats.py`
- `functions/party_badges.py`
- Backend tests for drinks/stats/badges

## Deliverables

- `create_party_drink`, `update_party_drink`, and `delete_party_drink` handlers ready for P21 export.
- Behavior-parity tests against documented Dart calculations.

## Acceptance Criteria

- Base score is `round(alcoholMl * 1000)` with a rounded 10% matching-class bonus.
- Missing/mismatched class receives base only.
- Edit reverses the active revision before a replacement award; delete reverses once.
- Retry/concurrency cannot duplicate score or stats.
- Logical-day and badge outputs match existing app behavior.

## Verification

```bash
python -m pytest functions/tests/test_party_drinks.py functions/tests/test_party_user_stats.py
python -m compileall functions
```

## Coordination

Treat Dart drink files as behavioral references only; P10 owns their edits. Do not edit rules or `functions/main.py`; report required protections to P07.
