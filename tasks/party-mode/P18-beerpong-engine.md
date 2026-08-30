# P18: Pure Beerpong Tournament Engine

## Objective

Implement deterministic team balancing and flexible single-elimination bracket logic independently of Firebase.

## Dependencies

- P01
- P03
- P05

## References

- `PARTY_MODE_PLAN.md`: Beerpong Tournament
- `/home/ondrej/projects/rozlucka/convex/beerpong.ts`

## Scope

- Implement seeded random player ordering.
- Balance team sizes and distribute male/female participants as evenly as practical.
- Validate 2-16 teams and participant constraints.
- Generate next-power-of-two brackets with byes.
- Add optional third-place match generation.
- Propagate winners/losers and calculate placements.
- Identify dependent results that must clear after an earlier correction.
- Keep all functions pure and exhaustively test each team count.

## Likely Files

- `functions/party_beerpong_engine.py`
- `functions/tests/test_party_beerpong_engine.py`

## Deliverables

- Pure deterministic engine consumed by P19.
- Tests covering team counts 2 through 16 and varied rosters.

## Acceptance Criteria

- Team sizes differ by at most one.
- Gender distribution is as even as possible for the roster.
- Identical roster/seed/settings produce identical output.
- Every allowed team count creates a valid bracket.
- Byes, third place, propagation, and correction dependencies are correct.

## Verification

```bash
python -m pytest functions/tests/test_party_beerpong_engine.py
python -m compileall functions
```

## Coordination

Do not access Firestore, send notifications, edit Flutter, or export functions. P19 wraps this engine in authoritative commands.
