# P03: Party Models And Constants

## Objective

Define typed Flutter models and constants for every planned Party document before data access and UI work starts.

## Dependencies

None. This is part of the initial parallel wave.

## References

- `PARTY_MODE_PLAN.md`: Party Classes And Drink Scoring, Firestore Data Model
- Existing model/converter patterns under `lib/session/model/`, `lib/drink/model/`, and `lib/common/converter/`
- `/home/ondrej/projects/rozlucka/convex/schema.ts`
- `/home/ondrej/projects/rozlucka/src/lib/registrationClasses.ts`

## Scope

- Model Party root, member, immutable event, quest template, quest, selection, challenge, tournament, team, and match documents.
- Define exact persisted enums and nested value objects.
- Add five class metadata entries mapped to existing `DrinkCategory` values.
- Add constants for point units, pagination, text/point/duration bounds, scheduling bounds, and tournament limits.
- Add score formatting and JSON round-trip tests.

## Likely Files

- `lib/party/constants.dart`
- New files under `lib/party/model/`
- Generated `*.freezed.dart` and `*.g.dart`
- `test/party/model/`

## Deliverables

- Complete immutable typed representation of the approved schema.
- Enums whose JSON strings match the plan exactly.
- Unit tests for serialization, equality, defaults, and score display.

## Acceptance Criteria

- Every planned persisted field is represented.
- Score values use integer units throughout.
- Invalid enum values fail predictably instead of silently changing meaning.
- Round-trip tests cover each model and optional field.
- Magic limits live in `lib/party/constants.dart`.

## Verification

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/party/model
flutter analyze --fatal-warnings
```

## Coordination

Do not add controllers, services, routes, or UI. P04 consumes these models. If backend naming needs adjustment later, preserve persisted strings or coordinate a deliberate pre-release schema change.
