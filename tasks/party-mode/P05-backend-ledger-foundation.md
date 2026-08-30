# P05: Backend Primitives And Immutable Ledger

## Objective

Establish reusable Python infrastructure for authenticated Party commands, idempotency, immutable awards/reversals, aggregate updates, and notification dispatch.

## Dependencies

None. This is part of the initial parallel wave.

## References

- `PARTY_MODE_PLAN.md`: Server-Authoritative Commands, Idempotency And Concurrency
- `functions/main.py`
- `/home/ondrej/projects/rozlucka/convex/scoreHelpers.ts`
- `/home/ondrej/projects/rozlucka/convex/events.ts`

## Scope

- Add auth, Session membership/admin, and active-Party guards.
- Add validated callable-input helpers and consistent errors.
- Add command receipt helpers for exactly-once retries.
- Add deterministic score-event IDs and transaction helpers.
- Add award and reversal primitives that update member totals atomically.
- Implement integer drink-score calculation and canonical mutual-pair keys.
- Extract reusable FCM sending behavior with actor exclusion without changing app routing yet.
- Establish Python test infrastructure if absent.

## Likely Files

- `functions/party_common.py`
- `functions/party_scoring.py`
- `functions/party_notifications.py`
- `functions/tests/test_party_common.py`
- `functions/tests/test_party_scoring.py`
- `functions/requirements.txt` and test requirements if needed

## Deliverables

- Independently tested backend primitives consumed by P06, P09, P12, P15, and P18.
- Clear transaction contracts and deterministic ID conventions.

## Acceptance Criteria

- Repeated `commandId` returns the original result.
- Duplicate awards and duplicate reversals are impossible.
- A reversal exactly negates one award and remains immutable.
- Event creation and member aggregate changes share one transaction.
- Score rounding matches `PARTY_MODE_PLAN.md`.

## Verification

```bash
python -m pytest functions/tests/test_party_common.py functions/tests/test_party_scoring.py
python -m compileall functions
```

## Coordination

Do not export functions from `functions/main.py`; P21 owns final exports. Keep public helper contracts documented for backend feature agents.
