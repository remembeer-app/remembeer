# P14: Party Notifications And Deep Links

## Objective

Define Party push payloads and correctly route notification taps in foreground, background, and terminated app states.

## Dependencies

- P05
- P08

## References

- `PARTY_MODE_PLAN.md`: Notifications And Deep Links
- `functions/main.py`
- `lib/notification/service/notification_service.dart`
- Current notification models and app/router startup
- `/home/ondrej/projects/rozlucka/convex/notifications.ts`
- `/home/ondrej/projects/rozlucka/convex/notificationsAction.ts`
- `/home/ondrej/projects/rozlucka/public/service-worker.js`

## Scope

- Define typed payloads containing type, `sessionId`, destination tab, and source ID.
- Implement recipient helpers, actor exclusion, and missing-token handling.
- Parse and route Party notifications after auth/router readiness.
- Cover Party activation, quests, challenges, beerpong, and archive destinations.
- Ensure malformed payloads and repeated taps fail safely.
- Add Python payload tests and Flutter routing tests.

## Likely Files

- `functions/party_notifications.py`
- Backend notification tests
- Notification type/payload models under `lib/notification/`
- `lib/notification/service/notification_service.dart`
- Routes only if P08's typed routes need a minimal extension
- Flutter notification tests

## Deliverables

- Stable backend/client payload contract.
- Deep-link handling for every planned Party event.

## Acceptance Criteria

- Each event opens the correct Party tab/detail.
- The actor is excluded from redundant pushes.
- Missing/stale tokens never roll back game state.
- Initial-message handling waits for usable auth/router state.
- Malformed and duplicate taps are harmless.

## Verification

```bash
python -m pytest functions/tests/test_party_notifications.py
flutter test test/notification
flutter analyze --fatal-warnings
```

## Coordination

This task owns notification parsing/models. Preserve P08's route tree. Do not export functions from `functions/main.py`; P21 owns registration.
