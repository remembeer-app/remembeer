# P21: Final Function Export, Integration, And Hardening

## Objective

Wire all completed Party modules together, resolve shared-file integration, remove obsolete behavior, and run the full release gate.

## Dependencies

- P01 through P20

## References

- Entire `PARTY_MODE_PLAN.md`
- `tasks/party-mode/README.md`
- Handoffs and verification notes from every prerequisite task
- Existing CI in `.github/workflows/`

## Scope

- Export all callables, triggers, and schedulers from `functions/main.py` in `europe-west4`.
- Resolve route, DI, Games tab, lifecycle, drink, notification, rules, and index integration.
- Remove the old client-computed count ranking after replacement tests pass.
- Add end-to-end Emulator scenarios from activation through archive.
- Test command retries, concurrent actions, scheduler claims, and archive races.
- Review query/index costs and notification behavior.
- Add CI coverage for Python and rules tests where practical.
- Run code generation, formatting, strict analysis, all tests, and manual mobile notification checks.

## Likely Files

- `functions/main.py` and requirements
- Shared Flutter route/DI/Party/Session/drink/notification files
- `firestore.rules` and `firestore.indexes.json` for final corrections only
- Cross-feature and integration tests
- CI workflow
- Obsolete `lib/party/widget/party_ranking.dart`

## Deliverables

- Fully integrated Party Mode.
- Complete automated release gate and documented manual test results.
- No obsolete or duplicate Party implementation paths.

## Acceptance Criteria

- Activation, scoring, activity, ranking, challenges, quests, beerpong, notifications, and archive work end to end.
- Party points never affect global leaderboards and normal stats remain correct.
- All protected mutations reject archived Parties and unauthorized users.
- Retries/concurrency cannot duplicate state or score.
- Profile completion cannot be bypassed.
- Generated files are current and all source/test/config changes are consistent.

## Verification

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-warnings
flutter test --coverage
python -m pytest functions/tests
python -m compileall functions
npx firebase emulators:exec --only firestore "npm test"
git diff --exit-code -- '*.g.dart' '*.freezed.dart'
```

Perform Android and iOS manual checks for foreground, background, and terminated-app notification routing. Record any environment-limited checks explicitly.

## Coordination

This is the only task expected to touch many shared files. Preserve all verified feature behavior, resolve conflicts rather than replacing modules wholesale, and do not weaken rules to make integration tests pass.
