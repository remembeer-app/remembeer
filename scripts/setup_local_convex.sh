#!/usr/bin/env bash
# Prepares the Convex deployment from .env.local: auth secret, functions,
# static JWKS and seed drinks. Safe to rerun.
set -euo pipefail

convex() { npx convex "$@" 2>/dev/null; }

if [[ -z "$(convex env get BETTER_AUTH_SECRET)" ]]; then
  echo "Setting BETTER_AUTH_SECRET"
  convex env set BETTER_AUTH_SECRET "$(openssl rand -base64 32)" >/dev/null
fi

# auth.config.ts reads JWKS, so it must exist before the first push.
if [[ -z "$(convex env get JWKS)" ]]; then
  convex env set JWKS "" >/dev/null
fi

echo "Deploying functions"
npx convex deploy -y

# The backend cannot reach its own *.localhost site URL from inside the
# cluster, so it verifies tokens against this static copy instead.
echo "Storing static JWKS"
npm run --silent auth:jwks >/dev/null

echo "Redeploying with JWKS"
npx convex deploy -y

echo "Seeding drinks"
npm run --silent seed:drinks
