# Convex cleanup status

Convex is the only backend. The old backend, client controllers/services/models,
seed script, configuration, credentials in the client environment, native
integration, and CI setup have been removed. Existing tests and test plumbing
were removed separately; new tests are future work.

Current Convex authentication, queries/mutations, avatars, drink logging,
location selection, profile stats, sessions, parties, leaderboards, friends,
settings, app icons, and quick-add retain their current implementations.

## Deferred data and features

Missing data uses placeholders with TODOs:

- Other users' friend counts: zero.
- Other users' badges: an empty list.
- Session photos: an empty state.
- Session summaries: an empty state.

Push notifications have no active transport or startup integration. These
features should be implemented separately against Convex.

## Remaining operational work

Repository cleanup does not shut down previously deployed resources. Retire the
old hosted backend, schedules, data stores, credentials, and obsolete GitHub
secrets as a separate operational step. No hosted resources were changed here.

Once the rewrite branch is merged and no longer used, retire
`.github/workflows/sync-main-to-convex.yml`, its CI branch trigger, and the
`protect_convex` ruleset in `infra/github/`.

## Validation

Retain formatting, linting, type checking, generated code checks, and mobile
builds. The iOS build requires macOS/Xcode.
