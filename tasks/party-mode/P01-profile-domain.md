# P01: Profile Domain And Persistence

## Objective

Add stable accent-color support to the user domain, including deterministic defaults and owned profile updates.

## Dependencies

None. This is part of the initial parallel wave.

## References

- `PARTY_MODE_PLAN.md`: Profile Accents, User Profile Additions
- `lib/user/model/user_model.dart`
- `lib/user/constants.dart`
- `lib/user/controller/user_controller.dart`
- `lib/user/service/user_service.dart`
- `/home/ondrej/projects/rozlucka/convex/profile.ts`
- `/home/ondrej/projects/rozlucka/convex/auth.ts`
- `/home/ondrej/projects/rozlucka/src/lib/accentColors.ts`

## Scope

- Add a versioned, accessible accent palette represented by stable keys rather than arbitrary stored colors.
- Implement deterministic accent assignment from a stable user seed.
- Extend `UserModel` serialization and profile persistence.
- Expose validated accent update operations.
- Keep a missing accent readable at the deserialization boundary so existing users can see P02's profile warning. New profiles persist the accent key.

## Likely Files

- `lib/user/model/user_model.dart` and generated outputs
- `lib/user/constants.dart`
- `lib/user/controller/user_controller.dart`
- `lib/user/service/user_service.dart`
- `test/user/model/`
- `test/user/service/`

## Deliverables

- Accent domain APIs.
- Safe JSON round trips for documents with and without an accent.
- Deterministic accent tests and profile update tests.
- Generated Freezed/JSON files.

## Acceptance Criteria

- Accent persistence uses a known palette key.
- The same stable seed always selects the same default accent.
- Existing documents missing the accent key deserialize safely.
- Updates preserve unrelated user data.

## Verification

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/user
flutter analyze --fatal-warnings
```

## Coordination

Do not edit routes or registration pages; P02 owns the rollout UI. Document any Firestore validation requirements for P07.
