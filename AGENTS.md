# AGENTS.md

This file provides guidance to AI agents working in this repository.

## Project Overview

Remembeer is a Flutter mobile app (iOS and Android) for tracking drinks with
sessions, parties, leaderboards, badges, and friends. Convex is the only backend;
Better Auth handles authentication. Missing features are separate work. Use
hardcoded placeholders with TODOs when their data is not available yet.

## Common Commands

```bash
flutter pub get
npm ci

# Generate Freezed, JSON serialization, and typed routes
dart run build_runner build --delete-conflicting-outputs

# Generate Convex TypeScript bindings and the typed Dart API/widgets
npm run convex:generate

dart format .
npm run format
flutter analyze --fatal-warnings
npm run check
```

JavaScript/TypeScript uses npm-locked Oxlint (including type-aware promise rules)
and Oxfmt. Keep Oxfmt defaults; `.oxfmtrc.json` only controls exclusions. Run
`npm run lint:fix` for safe lint fixes. Generated Convex bindings, native platform
files, lockfiles, and build output are excluded from formatting.

CI checks generated output. Run build_runner after changing Freezed models or
routes and commit generated output. Run `npm run convex:generate` after changing
the backend schema or public endpoints. Existing tests and test plumbing have
been removed; a new suite will be designed separately.

## Architecture

### Flutter features

Feature UI lives in `lib/<feature>/page/` and `widget/`. Pages use generated
Convex query/mutation widgets from `lib/convex_api/widgets/`; services use the
typed `ConvexApi`. Generated API code lives in `lib/convex_api/` and must not be
edited manually. Keep presentation models small; business rules and access
checks belong in Convex.

### Dependency injection and startup

GetIt registrations live in `lib/ioc/ioc_container.dart`; access them with
`get<T>()`. The container registers the Convex client/runtime, Better Auth
provider, typed API, `ConvexAuthService`, location, drink logging, app icons, and
avatar services. `main.dart` loads `.env.client` and initializes the app icon
service and quick-add channel. Client environment values are `CONVEX_URL` and
`CONVEX_SITE_URL`; do not put backend secrets in this bundled file.

### Routing and code generation

go_router with go_router_builder provides typed routes in `lib/routes.dart` and
`routes.g.dart`. NavbarShellRoute has Profile, Leaderboards, Drink, Activity, and
Settings tabs. Freezed and json_serializable generate model implementations and
JSON serialization where needed. Keep all generated output committed.

### Backend

Convex schema lives in `convex/schema.ts` with feature schemas, queries,
mutations, access helpers, and scheduled work under `convex/`. Better Auth is
configured in `convex/auth.ts`, `auth.config.ts`, and `http.ts`. Enforce access
and ownership on the server; use generated ID types in Flutter. Global drinks
have `ownerId: null`. Follow each table's schema for deletion and ownership.

### Shared conventions

Put feature constants in `lib/<feature>/constants.dart`. Use existing shared
forms, query/mutation widgets, and theme conventions. Do not revive legacy
backend layers for deferred functionality.

### Logical days

A user's day ends at their configurable `endOfDayBoundary` (default 06:00), in
their configured time zone. A drink at 02:00 on Jan 2 therefore belongs to Jan 1
with the default boundary. Backend date logic lives in
`convex/lib/logicalDay.ts` and `convex/lib/timeZone.ts`; Flutter display helpers
live in `lib/date/util/date_utils.dart`.

Always account for the day boundary and time zone. Current day queries and stats
provide refresh times for rollover; keep app resume and timer refresh behavior.
Do not assume midnight as the cutoff.

### Seeding global drinks

`assets/seed_data/drinks.json` is bundled into internal mutation
`drink:seedGlobal`. Deploy catalog changes before running it.

```bash
npm run seed:drinks -- '{"dryRun":true}'
npm run seed:drinks
npm run seed:drinks -- --prod
```

The dashboard can run the same mutation with `{}` or `{"dryRun":true}`. Seed
entries use stable `seedKey` values from JSON IDs. Seeding creates, updates,
restores, and retires managed entries while leaving custom/unmanaged drinks and
unchanged timestamps alone. Flutter clients cannot call this internal mutation.

### Dynamic App Icon

The launcher icon is a bumblebee whose mood follows how much pure alcohol the user has logged on the current logical day (end-of-day boundary applies). There are 8 phases, `a` (sober) to `h` (exhausted); the artwork lives in `assets/app_icon/bumblebeer_<phase>.svg`.

- **Step**: `appIconPhaseStepMl` in `lib/app_icon/constants.dart` is the only tuning knob — every that many ml of alcohol advances the icon by one phase; the last phase is kept once reached.
- **Dart/Convex**: `AppIconPhase.forAlcoholMl()` (`lib/app_icon/type/`) maps ml to a phase. `AppIconService` (`lib/app_icon/service/`) is initialized in `main.dart` and subscribes to `user:currentDayConsumption` while authenticated with Convex. The query sums current logical-day alcohol using the user's time zone and end-of-day boundary, and returns `nextRefreshAt` for day rollover or a future logged drink. The service refreshes on that timer and app resume, and sends changed phases over the `app_icon` method channel (`setIcon`, argument `phase`). Signing out resets to phase `a`.
- **iOS**: `AppDelegate.swift` calls `setAlternateIconName`. Phase `a` is the primary `AppIcon.appiconset`; the others are `AppIcon-bumblebeer_<phase>.appiconset`, listed in the `ASSETCATALOG_COMPILER_ALTERNATE_APPICON_NAMES` build setting. iOS only allows the change while the app is active (pending changes are applied on `didBecomeActive`) and shows a system alert on every switch.
- **Android**: one `activity-alias` per phase (`.BumblebeerA`…`.BumblebeerH`) in `AndroidManifest.xml`, all targeting `MainActivity`; only `A` is enabled by default. `MainActivity.kt` stores the requested phase and swaps the enabled alias in `onStop()` so the launcher never sees the change mid-session. Icons are adaptive (`mipmap-anydpi-v26/ic_launcher_bumblebeer_<phase>.xml` over a shared gradient `drawable/ic_launcher_background.xml`) with legacy PNG fallbacks.

Regenerate every iOS/Android icon resource after changing the SVGs or the background with:

```bash
python3 scripts/generate_app_icons.py   # needs Google Chrome (headless render) and macOS sips
```

Adding a phase means: a new SVG, a new enum value in `AppIconPhase`, a new alias in the manifest, adding the phase to `APP_ICON_PHASES` in `MainActivity.kt`, appending the icon set name to the Xcode build setting, and re-running the script.

### Quick Add Home Screen Widget

A one-tap "+1" widget that logs the user's default drink. Both platforms end up calling `quickAddPressed` on the `quick_add_action` method channel, which `lib/main.dart` handles with `DrinkLogService.addDefaultDrinkLog()`; there is no widget-specific Dart code.

- **Android**: `QuickAddWidgetProvider.kt` (layout `res/layout/quick_add_widget_layout.xml`, colors in `res/values/colors.xml`) launches `MainActivity` with the `QUICK_ADD_ACTION` intent, which invokes the channel method.
- **iOS**: the `QuickAddWidgetExtension` target (`ios/QuickAddWidget/`, WidgetKit, `systemSmall` only) opens `remembeer://quick-add`. The `remembeer` URL scheme is registered in `Runner/Info.plist`; `AppDelegate.swift` registers itself as a Flutter scene life cycle delegate, matches the URL on both cold start (`scene:willConnectToSession:options:`) and warm start (`scene:openURLContexts:`), and invokes the channel method once the `FlutterViewController` has rendered its first frame (earlier messages would be dropped by the engine). The extension's bundle id is `cz.remembeer.com.QuickAddWidget`; its version comes from `Flutter/Generated.xcconfig`, and release builds expect a manual provisioning profile named `Remembeer Quick Add Widget App Store` (see `ios/ExportOptions.plist`).

## UI Patterns

### Page Structure

Every page wraps its content in `PageTemplate` (Scaffold + AppBar + SafeArea + padding). Settings-style pages use `SettingsPage` which adds an optional hint box, supports app-bar actions and configurable padding, and fills the remaining space with its child.

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
