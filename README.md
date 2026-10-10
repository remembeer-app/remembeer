# Remembeer

So that you may never forget how many beers you have consumed.

## Environment

Copy each tracked template to its untracked counterpart:

```bash
cp .env.example .env
cp .env.client.example .env.client
cp .env.local.example .env.local
```

- `.env` configures Docker Compose.
- `.env.client` contains client-safe values bundled into the Flutter app.
- `.env.local` contains local Convex configuration and backend secrets.

Never put secrets in `.env.client`; Flutter packages the entire file in the
application.

For local Android emulator development, set
`CONVEX_CLOUD_ORIGIN=http://10.0.2.2:3210` in `.env`, matching `CONVEX_URL`
in `.env.client`. Convex uses this origin for upload and download URLs;
`127.0.0.1` points to the emulator itself. After changing `.env`, run
`docker compose up -d backend`. For a physical device, use your computer's
LAN address in both settings instead.

CI builds populate `.env.client` from repository secrets, including
`CONVEX_SITE_URL`.

## Convex

The Convex project lives in `convex/` at the repository root.

```bash
npm run convex:dev
npm run convex:generate
npm run convex:typecheck
```

`convex:generate` regenerates the Convex TypeScript bindings, generates the
type-safe Dart client in `lib/convex_api/`, and formats the generated Dart
files. Run it after changing the Convex schema or any public query, mutation,
or action.

The Flutter client includes the complete Dartvex stack: the core client,
Flutter widgets, Better Auth integration, generated API bindings, and optional
SQLite-backed offline support through `dartvex_local`.

## Seed global drinks

The internal `drink:seedGlobal` mutation reads the bundled
`assets/seed_data/drinks.json` catalog. Run `npm run convex:dev` for development
(or deploy the backend for production) after editing the seed file.

```bash
npm run seed:drinks -- '{"dryRun":true}'  # Preview changes
npm run seed:drinks                     # Seed development
npm run seed:drinks -- --prod           # Seed production
npm run test:seed:drinks                # Validate seed data
```

Alternatively, select `drink:seedGlobal` in the Convex dashboard's Functions
page and run it with `{}` or `{"dryRun":true}`. The function is internal and is
not exposed to app clients.

Runs are idempotent: entries are matched by their stable seed IDs, changed
entries are updated, returning entries are restored, and removed entries are
soft-deleted. Custom drinks and global drinks without a `seedKey` are untouched.
The returned counts show created, updated, restored, retired, and unchanged
entries. A dry run performs no writes. Unchanged drinks retain their timestamps.

`npm run seed` remains the legacy Firestore seeder.
