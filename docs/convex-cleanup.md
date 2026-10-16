# Cleanup after the Convex rewrite

Repository audit: 2026-10-16. This maps the remaining architecture cleanup. Existing tests and test plumbing
have been removed at the user's request; new tests will be designed separately.
No deployed infrastructure changes have been made.

The Convex rewrite is the current architecture. Missing features belong in
separate work. Cleanup should remove obsolete implementations and their entry
points without recreating those features or preserving old data and behavior.

## What remains

The primary pages use the generated Convex API and Better Auth. However,
`lib/main.dart` still initializes Firebase and notifications before `runApp`, and
`lib/ioc/ioc_container.dart` still constructs the old authentication,
controllers, and services alongside Convex. These registrations keep much of the
old dependency tree reachable even where no current page calls it.

Four links need attention before the legacy tree can disappear:

- `SessionPhotoRoute` still opens `SessionPhotoViewer`, which subscribes to the
  Firestore-backed `SessionService`. The current session detail page does not
  expose the old photo section.
- The drink log form, location field, location picker, update page, constants,
  and location route still use Firestore's `GeoPoint` as a coordinate value.
- `ProfilePage`, `BadgesSection`, and `SocialSection` still use `UserModel` as a
  display adapter. That model pulls in old monthly/daily stats and mutation
  helpers; the current profile stats already come from Convex.

## Suggested implementation order

Each numbered item is a reviewable cleanup change. The previous test suites,
fixtures, test commands, test dependencies, Firestore test emulator configuration,
and iOS unit-test target have been removed. Linting, type checks, code generation
checks, Python compilation, and mobile builds remain. New tests are separate work.

### 1. Remove the legacy seeder

- Delete `scripts/seed_drinks.mjs` and the legacy `seed` command.
- Keep `seed:drinks` and its seed JSON: these are used by Convex.

Validation: confirm the documented seeding command targets Convex.

### 2. Disconnect deferred features and remove Firebase value types

- Remove `SessionPhotoRoute`, `SessionPhotoViewer`, and the unused old photo
  section/upload implementation. Session photos can return as a separate Convex
  feature; cleanup does not need to implement a replacement.
- Remove `SessionSummaryRoute` and `SummaryPage`, which currently only says
  summaries are awaiting migration. Remove any links to that placeholder.
- Remove the old notification startup call and notification transport service:
  its token storage uses Firestore, callable functions use Firebase Auth, and
  notification cold-start handling waits for a Firebase sign-in even though
  current login uses Better Auth. Remove the token-sync listeners with the old
  settings service in item 3.
- Notification payload parsing/routing is separable from transport. Retain it
  only if there is a current independent caller; otherwise remove its unused
  code too. Do not build a new push pipeline in this cleanup.
- Replace `GeoPoint` with the existing `latlong2.LatLng` or a small plain
  coordinate value throughout the drink log form/picker and location route.
  Convert to generated Convex location inputs at submission. Preserve existing
  location selection behavior.
- Regenerate `routes.g.dart` after removing routes.

Firebase Messaging is a transport choice, not inherently incompatible with
Convex. The recommendation above removes the current obsolete Firebase
notification pipeline because notifications are deferred. A later push feature
can deliberately choose FCM without restoring Firebase Auth/Firestore/Functions.

Validation: current login, drink logging/editing, location selection, and session
management use only Convex; startup no longer waits on notification setup.

### 3. Delete the old Dart architecture and trim display adapters

Remove registrations first, then implementations and their exclusive models:

| Area                       | Cleanup                                                                                                                                                                                                                                                                                                          |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Authentication             | Delete `lib/auth/service/auth_service.dart` and `lib/auth/util/firebase_error_mapper.dart`; retain `ConvexAuthService`.                                                                                                                                                                                          |
| Controllers                | Delete `lib/common/controller/` and the drink, user, user settings, and session controller directories.                                                                                                                                                                                                          |
| Services                   | Delete `ActivityService`, `SessionService`, `SessionPictureService`, `UserService`, and `UserSettingsService`. Their retained callers are legacy widgets, DI registrations, or the deferred paths described above.                                                                                               |
| Client business logic      | Delete the unused `BadgeService` and `UserStatsService` and the legacy `UserStats` typedef after their old widget callers are removed. Preserve badge definitions and presentation used by the current UI.                                                                                                       |
| Activity UI                | Delete unused old `session_card`, `session_drink_log_item`, `session_drink_logs_section`, `session_header_card`, `session_participants_section`, `session_photos_section`, `session_statistics_card`, and `session_user_drink_logs_card` widgets. Delete `SessionWithMembers` and `UserWithDrinkLogs` with them. |
| Other unused widgets/types | Delete `streak_indicator.dart`, `session_divider.dart`, `summary_card.dart`, `user_list_tile.dart`, `SessionWithDrinkLogs`, and `DrinkLogWithSessionId`.                                                                                                                                                         |
| Legacy documents           | Delete `Drink`, `DrinkCreate`, `DrinkLog`, `DrinkLogCreate`, `Session`, `SessionCreate`, and `UserSettings` models once their old callers are gone, including matching generated files.                                                                                                                          |
| Firestore helpers          | Delete `json_firestore_helper.dart`, `query_firestore_helper.dart`, `TimestampConverter`, and `GeoPointConverter`; remove other converters only after their final consumers disappear.                                                                                                                           |
| Base types                 | Remove `Entity`, `EntityWithMembers`, and `ValueObject` after deleting their consumers. Remove `Document` after replacing the profile adapter.                                                                                                                                                                   |

Replace the display-only `UserModel` adapter in `ProfilePage`, `BadgesSection`,
and `SocialSection` with explicit display inputs or a small presentation model.
Do not pass fake empty email/search fields or preserve unused client mutation
methods. Then delete the old `UserModel`, `MonthlyStats`, and `DailyStats` family
and their generated files.

`UnlockedBadge` and its presentation helpers can stay if useful; they are still
used by current badge UI. `DrinkSnapshot` and its category JSON converter become
removal candidates when the old model/service tree is gone. Keep the generated
Convex `DrinkCategory` types and the category display extension.

Remove obsolete constants by usage, including Firestore query batch limits,
embedded-session drink limits, and old photo upload limits. Keep constraints
still used by current forms. Retain shared widgets and utilities that still
serve Convex pages: `LoadingForm`, `AsyncBuilder`, username search normalization,
password validation, and date utilities are not obsolete just because they
predate the rewrite.

Validation: regenerate Freezed/JSON/routes output; run Flutter analysis.
Inspect the remaining imports rather than deleting whole feature directories.

### 4. Remove Firebase backend, dependencies, and native setup

After items 2–3 remove Flutter callers:

- Delete the tracked `functions/` tree, including its requirements file.
- Delete `.firebaserc`, `firebase.json`, `firestore.rules`,
  `firestore.indexes.json`, and `storage.rules`.
- Remove Flutter dependencies `cloud_firestore`, `cloud_functions`,
  `firebase_auth`, `firebase_core`, `firebase_messaging`, and `firebase_storage`.
  Delete `lib/firebase_options.dart` and the Firebase initialization/imports in
  `main.dart`.
- Remove `google_sign_in`, its unused Google icon asset, and
  `GOOGLE_AUTH_SERVER_CLIENT_ID` configuration; current login/register use email
  and password through Better Auth.
- Remove `flutter_local_notifications` if its notification service was its last
  caller. Audit unused direct dependencies such as `crypto`, `cupertino_icons`,
  and `dartvex_local` rather than assuming they are required by current code.
  Preserve the Dartvex packages used by the current app.
- Remove the remaining `firebase-admin` npm dependency with the legacy seeder.
  Regenerate both lockfiles through package managers.
- Remove the Google Services Gradle plugin from `android/settings.gradle.kts`
  and `android/app/build.gradle.kts`, its JSON example, and CI steps producing
  `android/app/google-services.json`.
- Remove Google sign-in URL configuration and `GIDClientID` from
  `ios/Runner/Info.plist`. Preserve the `remembeer` URL scheme used by quick-add.
- With push deferred, remove push-only background mode, entitlements, Xcode
  capability wiring, and Android notification-only resources/permissions after
  checking their consumers. Preserve image picker/cropper, location, app icons,
  and widget configuration used by current features.
- Remove Firebase/Google auth values from `.env.client.example` and every CI
  environment creation block. Update related ignore rules/comments.
- Review the Android API 34 entry in `devenv.nix`, explicitly labeled as needed
  for Firestore. Remove it if no remaining build requirement needs it. Do not
  remove Python globally: `scripts/generate_app_icons.py` remains useful.

Native plugin registrants and platform dependency output should be regenerated
through Flutter/platform tooling, not edited to remove individual plugin lines.

Validation: install dependencies, regenerate code, run `flutter analyze
--fatal-warnings`, `npm run check`, and Android
and iOS builds. Confirm app startup needs only the remaining client environment
values. Smoke-test auth/account deletion, profile, settings, drinks, sessions,
parties, friends, leaderboards, avatars, app icons, and quick-add.

### 5. Update architecture docs and retire migration scaffolding

- Rewrite `AGENTS.md` to describe Convex/Better Auth, generated Dart APIs/widgets,
  backend access checks, current schemas, code generation, and checks. Remove
  instructions for Firestore controllers, server timestamp map helpers, global
  owner sentinel IDs, Python functions, and nonexistent old date/drink services.
  Retain logical-day rules and their current Convex implementation.
- Remove legacy seeder documentation from `README.md` and `AGENTS.md`. Update
  the README's optional offline-support claim if `dartvex_local` is removed.
- Remove user-facing migration/backend terminology, including the Better Auth
  login/register success messages; these should describe the user's action.
- Once the rewrite branch is merged and no longer used, retire
  `.github/workflows/sync-main-to-convex.yml`, the `convex` branch CI trigger,
  and the `protect_convex` ruleset/docs in `infra/github/`. These remain useful
  until branch consolidation; rewrite completion alone does not retire them.
- Leave `convex/_generated/` and `lib/convex_api/` under code generation. Some
  generated modules have no direct app imports but are exported or generated
  from backend endpoints; that is not evidence they should be hand-deleted.

## Deployed resources: separate operational follow-up

Deleting repository files does not shut down deployed Firebase resources.
Inventory and explicitly retire obsolete Functions (including schedules and
notification senders), Firestore, Storage, Firebase Auth, app registrations,
service accounts/credentials, and GitHub secrets after the new release/cutover.
No data migration or compatibility layer is required by this cleanup. Coordinate
this with any still-running old release; no deployed resources were inspected
or changed for this audit. If future push deliberately retains FCM, preserve
only the resources it needs.

## Completion criteria

- App startup and DI have no Firebase dependency or old service registrations.
- Handwritten Dart has no Firebase/Firestore imports, including value types.
- Missing photo/summary/push features have no obsolete backend entry points.
- No existing test suites, test commands, or test-only infrastructure remain.
- Deleted models have no leftover generated files.
- Current code generation, checks, and mobile builds pass.
- Contributor documentation describes the architecture actually in use.
