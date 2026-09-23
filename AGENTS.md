# AGENTS.md

Improtant note:
This branch is a full backend rewrite. Do not care about preserving data, breaking changes or preserving app behavior. The goal is to incrementally migrate to a new architecture using Convex. The changes can break existing flows and features and that is fine.

This file provides guidance to AI agents when working with code in this repository.

## Project Overview

Remembeer is a Flutter mobile app (iOS & Android) for tracking drinks with social features: sessions, leaderboards, badges, and friends. Backend is Firebase (Auth, Firestore, Storage, Cloud Functions, Messaging). Firebase region: europe-west4.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (freezed, json_serializable, go_router_builder)
dart run build_runner build --delete-conflicting-outputs

# Format
dart format .

# Lint (strict — CI uses --fatal-warnings)
flutter analyze --fatal-warnings
```

**CI checks that generated files (`*.g.dart`, `*.freezed.dart`) are committed and up-to-date.** Always run build_runner after changing models or routes and commit the generated output.

## Architecture

### Layered Feature Structure

Each feature lives in `lib/<feature>/` with up to four layers:

| Layer | Directory | Role |
|---|---|---|
| **Model** | `model/` | Immutable data classes via freezed. Entities extend `Entity` (has `userId`, timestamps, soft-delete `deletedAt`). DTOs extend `ValueObject`. |
| **Controller** | `controller/` | Firestore CRUD. Extend `CrudController<T extends Entity, U extends ValueObject>`. No business logic. |
| **Service** | `service/` | Business logic. Use RxDart (`BehaviorSubject`, `combineLatest`, `switchMap`) for reactive state. |
| **Page/Widget** | `page/`, `widget/` | UI. Pages are full screens; widgets are reusable components. |

### Dependency Injection

GetIt via `lib/ioc/ioc_container.dart`. All singletons registered in `IoCContainer.initialize()` in order: basic services, then controllers, then services. Access with `get<T>()`.

### Routing

go_router with go_router_builder for type-safe routes. Route definitions in `lib/routes.dart`, generated code in `routes.g.dart`. NavbarShellRoute provides 5 bottom tabs: Profile, Leaderboards, Drink (home), Activity, Settings.

### Code Generation

Three generators are used by the project:
- **freezed**: Immutable data classes (`*.freezed.dart`)
- **json_serializable**: JSON serialization with `explicit_to_json: true` (`*.g.dart`)
- **go_router_builder**: Type-safe routes (`routes.g.dart`)

### Key Patterns

- **Feature constants**: Each feature folder has a `constants.dart` file (e.g., `lib/user/constants.dart`, `lib/auth/constants.dart`). Put magic numbers, default values, and config constants there — not inline in code.
- **Soft deletes**: Entities use `deletedAt` field, never hard-deleted from Firestore
- **Server timestamps**: `withServerCreateTimestamps()`, `withServerUpdateTimestamp()`, `withServerDeleteTimestamps()` extension methods on JSON maps
- **Ownership**: All entities have a `userId` field; Firestore rules enforce ownership-based access
- **Global entities**: Some entities (e.g., seed drinks) use a special `globalUserId` and cannot be modified from the app

### Date Handling — Logical Days and End-of-Day Boundary

"Today" is not midnight-to-midnight. Each user has a configurable `endOfDayBoundary` (default 06:00 AM, stored on `UserModel`). A timestamp **before** the boundary belongs to the **previous** logical day. For example, with a 06:00 boundary, a drink at 02:00 AM on Jan 2nd counts as Jan 1st.

The core function is `effectiveDate(DateTime originalDate, TimeOfDay endOfDayBoundary)` in `lib/date/util/date_utils.dart` — it shifts the date back by one day if the time is before the boundary.

This affects all date-sensitive logic:

- **DateService** (`lib/date/service/date_service.dart`): The date selector's `selectedDateStateStream` applies the boundary to both the selected date and "today". `selectedDateBoundaries()` returns a `(start, end)` time window for the logical day — used by `DrinkService` and `SessionService` to query Firestore for a day's drinks/sessions.
- **DrinkService**: Uses `_effectiveDate()` to determine which logical day a drink belongs to when adding/updating/deleting, so user stats (monthly/daily) are attributed to the correct day.
- **UserStatsService**: Uses `effectiveDate` to determine the current logical day for stats calculations.
- **SessionDivider widget**: Uses `effectiveDate` to decide whether a session started "today" or on a past day.

When working with dates in this codebase, always account for the boundary — never assume midnight as the day cutoff.

### Cloud Functions

Python 3.13 functions in `functions/main.py` — push notification triggers for friend requests and session invites.

### Seeding Global Drinks

`assets/seed_data/drinks.json` holds the global drinks. Firestore rules forbid *every* client from writing documents with `userId: "global"`, so seeding runs through the Admin SDK instead:

```bash
# Against production (service account key from the Firebase console, keep it out of the repo)
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json npm run seed

# Against the emulator, no credentials needed
firebase emulators:start --only firestore
FIRESTORE_EMULATOR_HOST=localhost:8080 npm run seed

# Preview without writing
npm run seed -- --dry-run
```

The script is idempotent: it upserts every entry (preserving `createdAt`) and soft-deletes global drinks that are no longer in the seed file. Drink logs embed their own copy of the name, category and alcohol percentage, so retiring a drink never changes anyone's history. `test/drink/seed_data/drinks_seed_test.dart` validates the JSON before it can be seeded.

### Dynamic App Icon

The launcher icon is a bumblebee whose mood follows how much pure alcohol the user has logged on the current logical day (end-of-day boundary applies). There are 8 phases, `a` (sober) to `h` (exhausted); the artwork lives in `assets/app_icon/bumblebeer_<phase>.svg`.

- **Step**: `appIconPhaseStepMl` in `lib/app_icon/constants.dart` is the only tuning knob — every that many ml of alcohol advances the icon by one phase; the last phase is kept once reached.
- **Dart**: `AppIconPhase.forAlcoholMl()` (`lib/app_icon/type/`) maps ml to a phase. `AppIconService` (`lib/app_icon/service/`) watches the current user's daily stats plus app resume events and sends the phase over the `app_icon` method channel (`setIcon`, argument `phase`), deduplicated with `distinct()`. Signing out resets to phase `a`.
- **iOS**: `AppDelegate.swift` calls `setAlternateIconName`. Phase `a` is the primary `AppIcon.appiconset`; the others are `AppIcon-bumblebeer_<phase>.appiconset`, listed in the `ASSETCATALOG_COMPILER_ALTERNATE_APPICON_NAMES` build setting. iOS only allows the change while the app is active (pending changes are applied on `didBecomeActive`) and shows a system alert on every switch.
- **Android**: one `activity-alias` per phase (`.BumblebeerA`…`.BumblebeerH`) in `AndroidManifest.xml`, all targeting `MainActivity`; only `A` is enabled by default. `MainActivity.kt` stores the requested phase and swaps the enabled alias in `onStop()` so the launcher never sees the change mid-session. Icons are adaptive (`mipmap-anydpi-v26/ic_launcher_bumblebeer_<phase>.xml` over a shared gradient `drawable/ic_launcher_background.xml`) with legacy PNG fallbacks.

Regenerate every iOS/Android icon resource after changing the SVGs or the background with:

```bash
python3 scripts/generate_app_icons.py   # needs Google Chrome (headless render) and macOS sips
```

Adding a phase means: a new SVG, a new enum value in `AppIconPhase`, a new alias in the manifest, adding the phase to `APP_ICON_PHASES` in `MainActivity.kt`, appending the icon set name to the Xcode build setting, and re-running the script.

## UI Patterns

### Page Structure

Every page wraps its content in `PageTemplate` (Scaffold + AppBar + SafeArea + padding). Settings-style pages use `SettingsPageTemplate` which adds a hint box and optional save FAB.

Typical page skeleton:

```dart
class SomePage extends StatelessWidget {
  SomePage({super.key});

  final _someService = get<SomeService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Title'),
      child: AsyncBuilder<SomeModel>(
        stream: _someService.someStream,
        builder: (context, data) {
          return /* UI using data */;
        },
      ),
    );
  }
}
```

### AsyncBuilder

`AsyncBuilder<T>` is the primary way to connect reactive data to UI. It accepts either a `stream` or a `future` (exactly one), handles loading/error states by default, and calls `builder` when data is available. Use it instead of raw `StreamBuilder`/`FutureBuilder`. Pages often nest multiple AsyncBuilders for independent data sources.

### Service Access in Pages

Pages obtain services as final fields via `get<T>()` (not in `build()`). Services expose `Stream`s for reactive data and `Future`s for one-shot operations. Pages hold no local state beyond what services provide — the service layer owns all business state via RxDart streams.

### Forms

Use `LoadingForm` for any form with async submission. It provides:
- `buildTextField()`, `buildPasswordField()`, `buildSubmitButton()`, `buildErrorMessage()` — consistent styled inputs
- `runAction()` — wraps async calls with loading spinner and error handling
- `validate()` — form validation
- Optional `errorMapper` for translating exceptions to user-facing messages

### Destructive Actions

Use `showConfirmationDialog()` from `lib/common/action/confirmation_dialog.dart` for any destructive action. Set `isDestructive: true` to style the button with error color.

### Notifications

Use `showSuccessNotification()` or `showNotification()` from `lib/common/action/notifications.dart` for toast feedback (toastification package, 4s auto-close).

### Navigation

- **Tab routes**: Use typed go_router routes (e.g., `const FriendRequestsRoute().go(context)`)
- **Sub-pages/modals**: Use `Navigator.of(context).push(MaterialPageRoute(...))` for detail/edit pages not in the tab structure
- **After deletion**: `Navigator.of(context).popUntil((route) => route.isFirst)` to return to root

### Styling Conventions

- Date/time formatting via `intl` package (`DateFormat`) — not manual string interpolation
- Colors always via `Theme.of(context).colorScheme.*` — never hardcoded (except notifications, which have a TODO for this)
- Spacing via `Gap` widget (from gap package), not manual SizedBox
- Cards typically use `Card(child: ListTile(...))` pattern
- Empty states: centered Column with large muted icon + title + subtitle text
- Button types: `FilledButton` for primary actions, `OutlinedButton`/`TextButton` for secondary, `ElevatedButton.icon` for profile actions

## Lint Rules

Extremely strict analysis_options.yaml with ~120 rules. Notable enforced patterns:
- `always_use_package_imports` (no relative imports)
- `prefer_single_quotes`
- `prefer_final_locals` and `prefer_final_in_for_each`
- `avoid_print` (no print statements)
- `prefer_const_constructors` and `prefer_const_literals_to_create_immutables`
- `avoid_dynamic_calls` with strict-casts, strict-inference, strict-raw-types
- `flutter_style_todos` (TODOs must be `// TODO(username): message`)
- `sort_pub_dependencies`
