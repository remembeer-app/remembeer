# P16: Quest Commands, Scheduler, And Expiry

## Objective

Implement custom templates, schedule configuration, due-Party claims, social quests, reciprocal selections, awards, and shared expiry.

## Dependencies

- P06
- P12
- P14
- P15

## References

- `PARTY_MODE_PLAN.md`: Active Social Quests, Scheduled Cloud Functions
- `/home/ondrej/projects/rozlucka/convex/randomEvents.ts`
- `/home/ondrej/projects/rozlucka/convex/notifications.ts`
- `/home/ondrej/projects/rozlucka/convex/callToActionQuests.ts`

## Scope

- Implement bounded schedule settings and custom template CRUD/enable commands.
- Add a one-minute due-Party scheduler with transactional claims.
- Select enabled templates, compute eligibility snapshots, create at most one active quest, and randomize the next interval.
- Advance scheduling without a quest when fewer than two members qualify.
- Implement reciprocal partner selection and exactly-once pair awards.
- Expire overdue quests and challenges without deleting history.
- Send notifications only after state commits.

## Likely Files

- `functions/party_quests.py`
- `functions/party_scheduler.py`
- `functions/tests/test_party_quests.py`
- `functions/tests/test_party_scheduler.py`

## Deliverables

- Quest/template commands and scheduled handlers ready for P21 export.
- Scheduler race/idempotency tests.

## Acceptance Criteria

- A Party has at most one active social quest.
- Reciprocal concurrent selections award each member once.
- Completed pairs cannot change; pending selections can.
- Disabled/archived Parties never schedule.
- Retries do not duplicate quests, awards, or dispatches.
- Expired content remains readable with terminal status.

## Verification

```bash
python -m pytest functions/tests/test_party_quests.py functions/tests/test_party_scheduler.py
python -m compileall functions
```

## Coordination

Use P14's payload contract and P12's challenge state shape. Do not edit rules, indexes, or `functions/main.py`; report scheduler indexes to P07.
