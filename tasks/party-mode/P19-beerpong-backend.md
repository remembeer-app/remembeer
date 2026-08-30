# P19: Beerpong Commands, Scoring, And Notifications

## Objective

Wrap the pure tournament engine in authoritative Party commands, immutable placement scoring, and actionable notifications.

## Dependencies

- P06
- P14
- P18

## References

- `PARTY_MODE_PLAN.md`: Beerpong Tournament, Notifications And Deep Links
- `/home/ondrej/projects/rozlucka/convex/beerpong.ts`

## Scope

- Add member opt-in during enrollment.
- Add admin tournament create/redraw, team rename, match result, correction, and finalize commands.
- Enforce 2-16 team and roster constraints.
- Store auditable random seed hash/reveal and expected revisions.
- Generate exactly-once placement awards for all placed team members.
- Reverse and replace final awards during valid corrections.
- Send enrollment, match-ready/result, and completion pushes through P14.

## Likely Files

- `functions/party_beerpong.py`
- `functions/tests/test_party_beerpong.py`

## Deliverables

- Tournament command handlers ready for P21 export.
- Transaction, correction, and scoring tests.

## Acceptance Criteria

- Members can change only their own opt-in during enrollment.
- Only admins draw, rename, record, correct, and finalize.
- Result races fail through expected-revision checks.
- Finalization awards each eligible team member exactly once.
- Archived Parties reject all tournament actions.
- Notifications use the agreed typed payloads.

## Verification

```bash
python -m pytest functions/tests/test_party_beerpong.py
python -m compileall functions
```

## Coordination

Do not edit Flutter, rules, indexes, or `functions/main.py`. Report match/tournament query indexes and protected paths to P07.
