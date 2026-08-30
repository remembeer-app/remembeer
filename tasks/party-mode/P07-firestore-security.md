# P07: Firestore Rules, Indexes, And Emulator Coverage

## Objective

Enforce Session-backed Party privacy and callable-only mutation, then add indexes for finalized Party queries.

## Dependencies

- P01
- P06
- P09
- P12
- P16
- P19

## References

- `PARTY_MODE_PLAN.md`: Security Rules, Firestore Indexes
- `firestore.rules`
- `firestore.indexes.json`
- `firebase.json`
- Query and command implementations produced by prerequisite tasks

## Scope

- Add Session membership/admin/active-Party rule helpers.
- Permit Party reads only to Session members.
- Deny direct writes to events, aggregates, game transitions, and archived Party data.
- Make embedded drink changes callable-only when `Session.isParty` is true while preserving non-Party behavior.
- Validate owned profile gender and accent-key updates.
- Add exact composite indexes required by implemented queries and disable unused large-field indexes.
- Establish Firestore Emulator rules tests if absent.

## Likely Files

- `firestore.rules`
- `firestore.indexes.json`
- `firebase.json`
- Rules-test package configuration and tests

## Deliverables

- Least-privilege rules and regression tests.
- Deployable index configuration derived from actual queries.

## Acceptance Criteria

- Non-members cannot read Party data.
- Members/admins cannot directly forge protected state.
- Archived Parties reject all direct mutations.
- Party Session drinks cannot be changed directly.
- Existing non-Party Session/drink flows continue to pass regression tests.
- Invalid profile enum/palette values are denied.
- Every Party query has a matching index.

## Verification

```bash
npx firebase emulators:exec --only firestore "npm test"
flutter analyze --fatal-warnings
```

Also validate `firestore.indexes.json` as JSON and run any repository-specific Firebase dry-run command available in the installed CLI.

## Coordination

This task exclusively owns `firestore.rules` and `firestore.indexes.json` until P21. Do not broaden unrelated collection access while adding Party helpers.

P01 profile validation requirements:

- `gender` accepts only `male` or `female`.
- `accentColorKey` accepts only `amber`, `rose`, `violet`, `sky`, `emerald`, `lime`, `orange`, or `fuchsia` (palette version 1).
- Profile-field updates are owner-only and must preserve all unrelated user fields.
