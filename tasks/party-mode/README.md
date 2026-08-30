# Party Mode Task Index

These tasks implement [`PARTY_MODE_PLAN.md`](../../PARTY_MODE_PLAN.md). Each task is intended for one focused coding agent. Agents must read the plan, this index, their task file, the repository `AGENTS.md`, and all listed source references before editing.

## Execution Rules

- Respect task dependencies. Do not implement a blocked task against guessed APIs.
- Keep changes inside the task's ownership area unless the task explicitly names a shared file.
- Never revert unrelated or concurrent changes.
- Backend feature tasks add focused Python modules and tests. Only P21 should perform final exports from `functions/main.py`.
- P07 owns `firestore.rules` and `firestore.indexes.json`; other agents should document required rule/index changes for P07 instead of editing those files.
- Regenerate and commit Freezed, JSON, and typed-route outputs whenever their sources change.
- Use Firebase region `europe-west4`.
- Treat Rozlucka as behavioral source material, not code that can be copied directly.

## Task Graph

| ID | Task | Depends on | Parallel notes |
| --- | --- | --- | --- |
| [P01](P01-profile-domain.md) | Profile domain and persistence | None | Initial parallel wave |
| [P02](P02-profile-rollout-ui.md) | Required profile rollout and editing | P01 | Owns auth/profile route edits |
| [P03](P03-party-models.md) | Party models and constants | None | Initial parallel wave |
| [P04](P04-party-data-access.md) | Party controllers, services, and DI | P03 | Owns Party DI registration |
| [P05](P05-backend-ledger-foundation.md) | Backend primitives and immutable ledger | None | Initial parallel wave |
| [P06](P06-party-lifecycle.md) | Activation, membership, and archive | P03, P05 | Owns Session conversion files |
| [P07](P07-firestore-security.md) | Rules, indexes, and emulator tests | P01, P06, P09, P12, P16, P19 | Run after command/query shapes settle |
| [P08](P08-party-shell-routes.md) | Three-tab shell and routes | P02, P04, P06 | Owns Party route structure |
| [P09](P09-party-drink-backend.md) | Party drink backend | P05, P06 | Can parallel with P12/P15/P18 |
| [P10](P10-party-drink-client.md) | Party drink client and classes | P04, P09 | Owns Dart drink integration |
| [P11](P11-activity-ranking.md) | Activity and ranking | P04, P08, P09 | Independent UI after shell |
| [P12](P12-challenge-backend.md) | Admin challenge backend | P05, P06 | Can parallel with P09/P15/P18 |
| [P13](P13-challenge-management-ui.md) | Management, Games, challenge UI | P04, P08, P12 | Establishes shared Games layout |
| [P14](P14-party-notifications.md) | Notifications and deep links | P05, P08 | Owns notification parsing |
| [P15](P15-quest-catalog.md) | Quest catalog and eligibility | P01, P03, P05 | Pure backend domain work |
| [P16](P16-quest-scheduler-backend.md) | Quest commands and scheduler | P06, P12, P14, P15 | Backend integration |
| [P17](P17-quest-ui.md) | Social quest Flutter experience | P08, P13, P16 | Extend Games through child widgets |
| [P18](P18-beerpong-engine.md) | Pure beerpong engine | P01, P03, P05 | Pure backend domain work |
| [P19](P19-beerpong-backend.md) | Beerpong commands and scoring | P06, P14, P18 | Backend integration |
| [P20](P20-beerpong-ui.md) | Beerpong Flutter experience | P08, P13, P19 | Extend Games through child widgets |
| [P21](P21-final-integration.md) | Final integration and hardening | P01-P20 | Inherently shared final pass |

## Recommended Waves

1. P01, P03, and P05 in parallel.
2. P02, P04, P06, P09, P12, P15, and P18 as dependencies allow.
3. P08, P10, P14, P16, and P19 as dependencies allow.
4. P11 and P13 after the shell; P17 and P20 after P13.
5. P07 after backend/query shapes are final.
6. P21 after all feature tasks merge.

## Shared-File Ownership

| Shared area | Sequence |
| --- | --- |
| `lib/routes.dart`, `lib/routes.g.dart` | P02, then P08, then P14 only if required, then P21 |
| `lib/ioc/ioc_container.dart` | P04, then P21 |
| Session conversion/lifecycle files | P06, then P21 |
| Dart drink service/pages | P10, then P21 |
| `party_games_tab.dart`, management page | P13 establishes structure; P17/P20 add isolated child sections; P21 resolves integration |
| Notification service/models | P14, then P21 |
| `firestore.rules`, `firestore.indexes.json` | P07, then P21 |
| `functions/main.py` | P21 only |

## Completion

A task is complete only when its deliverables and acceptance criteria pass, generated files are current, and the task's verification commands have been run. If a command cannot run, the agent must record the exact blocker in its handoff.
