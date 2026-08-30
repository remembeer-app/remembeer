# P02: Required Profile Rollout And Editing

## Objective

Collect gender during registration, assign an accent, require existing users to complete missing fields, and expose later editing.

## Dependencies

- P01

## References

- `PARTY_MODE_PLAN.md`: Profile Completion
- Current auth, router, profile, and settings code under `lib/auth/`, `lib/routes.dart`, `lib/user/`, and `lib/user_settings/`
- `/home/ondrej/projects/rozlucka/src/components/AuthForm.tsx`
- `/home/ondrej/projects/rozlucka/src/components/ProfilePage.tsx`

## Scope

- Add male/female selection to email registration and any Google first-login onboarding.
- Assign the deterministic accent from P01 during profile creation.
- Add a required profile-completion page for authenticated users with missing fields.
- Add router redirection without loops or flashes into protected app pages.
- Add editable gender/accent controls to the established profile/settings UI.
- Add widget and routing tests for complete and incomplete users.

## Likely Files

- Registration/login pages and auth service under `lib/auth/`
- New profile-completion page
- Profile/settings pages under `lib/user/` and `lib/user_settings/`
- `lib/routes.dart` and generated `lib/routes.g.dart`
- Auth/profile widget tests

## Deliverables

- Complete registration and existing-user onboarding flows.
- Profile editing UI using existing form and notification patterns.
- Route guard tests, including Google sign-in behavior.

## Acceptance Criteria

- An authenticated incomplete user cannot enter normal app routes.
- The completion route cannot redirect to itself in a loop.
- New email and Google-created profiles have both fields.
- Users can edit both values later.
- Invalid or absent choices cannot be submitted.

## Verification

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/auth test/user
flutter analyze --fatal-warnings
```

## Coordination

This task owns the first route changes. P08 must build on its resulting route tree rather than replacing it.
