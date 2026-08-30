# P12: Admin Challenge Backend

## Objective

Add timed, multi-winner, server-authoritative admin challenges and correction behavior.

## Dependencies

- P05
- P06

## References

- `PARTY_MODE_PLAN.md`: Admin Challenges
- `/home/ondrej/projects/rozlucka/convex/callToActionQuests.ts`
- `/home/ondrej/projects/rozlucka/src/components/AdminPage.tsx`
- `/home/ondrej/projects/rozlucka/src/components/ActivityPage.tsx`

## Scope

- Implement independent module settings needed by challenges.
- Add create, award-winner, complete, cancel, and reverse-winner commands.
- Enforce one active challenge at a time.
- Permit multiple distinct winners with one deterministic award each.
- Validate admin authority, active membership, status, duration, content, and point limits.
- Add notification dispatch hooks without owning client deep-link parsing.

## Likely Files

- `functions/party_challenges.py`
- `functions/tests/test_party_challenges.py`

## Deliverables

- Challenge command handlers ready for P21 export.
- Exhaustive command/idempotency tests.

## Acceptance Criteria

- Only Session admins can mutate challenges.
- Each active member can win a challenge at most once.
- Multiple winners receive the same configured points.
- Corrections create reversals rather than editing events.
- Disabled, archived, expired, and duplicate actions are rejected.

## Verification

```bash
python -m pytest functions/tests/test_party_challenges.py
python -m compileall functions
```

## Coordination

Do not add scheduler expiry here; P16 owns shared expiry scheduling. Do not edit `functions/main.py`, notification client code, rules, or UI.
