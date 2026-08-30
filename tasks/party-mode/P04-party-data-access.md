# P04: Party Controllers, Baseline Services, And DI

## Objective

Add typed Firestore reads, callable wrappers, reactive Party composition, and dependency injection without placing business logic in controllers.

## Dependencies

- P03

## References

- `PARTY_MODE_PLAN.md`: Flutter Architecture, Routes
- `lib/ioc/ioc_container.dart`
- Existing controller/service patterns under `lib/session/`, `lib/leaderboard/`, and `lib/activity/`
- `lib/common/widget/async_builder.dart`

## Scope

- Add explicit typed references for Party root and nested collections.
- Expose Party/member streams and paginated event queries.
- Expose quest, challenge, tournament, team, and match streams.
- Add callable invocation support using `commandId` and `europe-west4`.
- Compose Session, Party, current member, membership, admin, and archive state in services.
- Register controllers before services in GetIt.

## Likely Files

- `lib/party/controller/party_controller.dart`
- `lib/party/controller/party_event_controller.dart`
- `lib/party/controller/party_game_controller.dart`
- `lib/party/service/party_service.dart`
- Supporting typed query/command result files under `lib/party/`
- `lib/ioc/ioc_container.dart`
- `test/party/controller/` and `test/party/service/`

## Deliverables

- Testable read APIs and callable wrappers.
- Baseline reactive Party state suitable for P08 and feature services.
- Complete DI registration.

## Acceptance Criteria

- Controllers contain no scoring, eligibility, or tournament decisions.
- Nested collection paths are explicit and typed.
- Callable requests include idempotency IDs and target the correct region.
- Service streams distinguish non-member, member, admin, active, and archived states.

## Verification

```bash
flutter test test/party/controller test/party/service
flutter analyze --fatal-warnings
```

## Coordination

This task owns Party-related edits to `lib/ioc/ioc_container.dart`. Later feature agents should add feature services through existing extension points or leave final registration cleanup to P21.
