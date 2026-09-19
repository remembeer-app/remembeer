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

CI builds populate `.env.client` from repository secrets, including
`CONVEX_SITE_URL`.

## Convex

The Convex project lives in `convex/` at the repository root.

```bash
npm run convex:dev
npm run convex:typecheck
npm run dartvex:codegen
```
