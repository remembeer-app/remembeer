# P02: Profile Accent Rollout And Editing

## Objective

Assign an accent during registration, prompt existing users when it is missing, and expose later editing.

## Dependencies

- P01

## References

- `PARTY_MODE_PLAN.md`: Profile Accents
- Current auth, router, profile, and settings code under `lib/auth/`, `lib/routes.dart`, `lib/user/`, and `lib/user_settings/`
- `/home/ondrej/projects/rozlucka/src/components/AuthForm.tsx`
- `/home/ondrej/projects/rozlucka/src/components/ProfilePage.tsx`

## Scope

- Assign the deterministic accent from P01 during email and Google profile creation.
- Show a non-blocking warning on the current user's profile when the accent is missing.
- Add editable accent controls to the established profile/settings UI.
- Add widget tests for accent selection and the missing-accent warning.

## Likely Files

- Registration/login pages and auth service under `lib/auth/`
- Profile/settings pages under `lib/user/` and `lib/user_settings/`
- Profile widget tests

## Deliverables

- Deterministic registration defaults and an existing-user profile prompt.
- Profile editing UI using existing form and notification patterns.

## Acceptance Criteria

- New email and Google-created profiles have an accent.
- Existing users missing an accent can use the app and see a profile warning.
- Users can edit their accent later.
- Invalid or absent choices cannot be submitted.

## Verification

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/auth test/user
flutter analyze --fatal-warnings
```

## Coordination

P08 may build its Party route tree independently; this task does not add a profile-completion route.
