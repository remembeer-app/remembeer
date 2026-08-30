# P06: Party Activation, Membership, And Archive Lifecycle

## Objective

Replace direct Session conversion with atomic Party activation and keep active membership and archive state synchronized.

## Dependencies

- P03
- P05

## References

- `PARTY_MODE_PLAN.md`: Party Activation, Party Root, Party Members
- `lib/session/controller/session_controller.dart`
- `lib/session/service/session_service.dart`
- `lib/session/page/edit_session_page.dart`
- `lib/session/page/session_management_page.dart`
- `functions/main.py` for registration style only

## Scope

- Implement `activate_party` and `archive_party` backend commands.
- Permit any Session admin to activate an ongoing non-solo Session exactly once.
- Atomically create Party root/members, set `Session.isParty`, seed templates through P15-compatible hooks, and award existing Session drinks at base score only.
- Add Party-aware membership synchronization while active.
- Archive when the underlying Session ends and clear future scheduling.
- Replace the current direct Dart conversion call with the callable wrapper.

## Likely Files

- `functions/party_commands.py`
- `functions/tests/test_party_activation.py`
- Session controller/service and conversion UI files
- Party service callable wrappers where needed

## Deliverables

- Transactional activation/archive lifecycle.
- Session membership behavior documented and implemented for active Parties.
- Flutter conversion flow using server authority.

## Acceptance Criteria

- Owner and admins can activate; ordinary members, solo Sessions, ended Sessions, and duplicates are rejected.
- Session flag, Party root, members, templates, receipts, and initial awards cannot partially commit.
- Existing drinks receive base points exactly once.
- Newly added members start with no class, opt-out, and zero score.
- Archive preserves reads and rejects future mutations.

## Verification

```bash
python -m pytest functions/tests/test_party_activation.py
flutter test test/session test/party/service
flutter analyze --fatal-warnings
```

## Coordination

This task owns Session conversion/lifecycle files. Do not edit `functions/main.py`, Firestore rules, or route structure. Give P07 a list of required Session/Party write restrictions.
