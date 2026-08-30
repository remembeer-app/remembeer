# Party Mode Implementation Plan

## Status

Product decisions are complete. This document is the implementation plan for adapting the competition features from `/home/ondrej/projects/rozlucka` into Remembeer's existing Session-backed Party Mode.

The source project is a reference for behavior and rules, not a code dependency. React, Convex, browser push, and Tailwind code will not be copied into the Flutter/Firebase application.

## Goals

- Turn each converted multi-user Session into a live competition hub.
- Keep the Session as the source of truth for membership, admins, dates, drinks, and archive state.
- Add separate, auditable party scoring without changing global Remembeer statistics or leaderboards.
- Provide Activity, Ranking, and Games top tabs while retaining the app's normal bottom navigation.
- Support automatic social quests, admin challenges, and a flexible beerpong tournament.
- Keep all scoring and game transitions server-authoritative, idempotent, and safe under concurrent clients.
- Preserve an ended party as a read-only archive.

## Confirmed Product Decisions

| Area | Decision |
| --- | --- |
| Product | Live competition hub rather than a pass-the-phone card game |
| Parent entity | Extend an existing Session; party data is linked by Session ID |
| Activation | Converting a Session starts Party Mode immediately |
| Navigation | Top tabs: Activity, Ranking, Games; main bottom navigation remains visible |
| Core score | Party-only score, separate from global statistics and leaderboards |
| Drink score | Existing drink ABV and volume; no separate catalog and no photo bonus |
| Classes | One themed class for each existing drink category, selected per party |
| Missing class | Drinks receive base points; no class bonus |
| Class changes | Session admins can change a member's class; changes affect future drinks only |
| Score history | Immutable score-event ledger; corrections create reversal events |
| Administration | All Session admins can manage Party Mode |
| Modules | Drink scoring is core; social quests, admin challenges, and beerpong have independent toggles |
| Social quests | Cloud-scheduled with admin-controlled duration and random interval range |
| Quest content | Versioned built-in catalog plus party-specific custom templates |
| Quest participants | All active members with a selected class |
| Custom quests | Admin-defined title, instructions, points, and duration; mutual partner confirmation remains required |
| Admin challenges | Timed and admin-created; multiple winners may be awarded |
| Beerpong | Per-party opt-in; 2-16 teams; single elimination; byes; optional third-place match |
| Profiles | Permanent editable male/female gender and auto-assigned, editable accent color |
| Existing users | Required profile-completion screen after login when fields are missing |
| Party end | Freeze all game actions and retain a read-only archive |
| Activity filters | Filter by people and event type |
| Notifications | Send pushes for all actionable party events with direct deep links |
| Language | English only |
| Compatibility | No migration or compatibility layer for Party data created before this implementation |
| Delivery | Phased milestones |

## Non-Goals

- Card decks, turn rotation, truth-or-dare prompts, or pass-the-phone gameplay.
- Guest identities, local players, room codes, or unauthenticated join links.
- Party points affecting monthly user statistics, badges, or global leaderboards.
- Drink-photo uploads, photo scoring, or duplicate-image detection.
- A dedicated Information tab.
- Czech localization or general app localization work.
- Convex integration or reuse of the source project's backend.
- Migration of legacy Party documents or historical production Party scores.

## Feature Mapping From Rozlucka

| Rozlucka feature | Remembeer adaptation |
| --- | --- |
| Fixed drink catalog | Existing `DrinkTypeCore`, `DrinkCategory`, ABV, and volume |
| Permanent four classes | Five party-specific themed classes matching Remembeer's categories |
| Materialized score | Immutable events plus per-party member totals |
| Global activity feed | Feed scoped to one Session-backed party |
| Random social events | Scheduled built-in/custom mutual-selection quests |
| Quick challenges | Admin challenges with multiple winners |
| Fixed eight-team bracket | Configurable 2-16-team single-elimination bracket |
| Gender/accent eligibility | Permanent editable user profile fields |
| Browser push | Existing FCM/APNs notification pipeline |
| Convex scheduled jobs | Firebase scheduled Cloud Functions in `europe-west4` |

## User Experience

### Profile Completion

1. Registration collects `gender` as `male` or `female` and assigns an accent from an accessible palette.
2. Existing authenticated users missing either field are redirected to a required profile-completion page before entering the app.
3. Gender and accent remain editable from profile/settings.
4. Store a stable accent key, not an arbitrary color value. Resolve it through a versioned palette in `lib/user/constants.dart`.
5. Profile updates affect future quest eligibility. Active quests retain their eligibility snapshot.

### Party Activation

1. The owner or a Session admin opens the existing conversion action.
2. A callable function verifies that the Session is ongoing, non-solo, and not already a Party.
3. One transaction sets `Session.isParty`, creates the Party root and member records, seeds built-in quest templates, and creates base score events for drinks already in that Session.
4. Pre-conversion drinks receive base points only because no party class existed when they were logged.
5. The app opens the Activity tab immediately. There is no setup gate.
6. New Party installations assume no legacy `isParty` Session without a matching Party document; test data can be reset rather than supported with fallback behavior.

### Party Shell

- Keep `PartyRoute` under the existing `DrinkBranch`, so the main bottom bar remains available.
- Replace the current single ranking page with a `TabBar` and `TabBarView` containing Activity, Ranking, and Games.
- Use the existing Material design language with a stronger celebratory accent in the app bar, active tab, current-game cards, and ranking highlights.
- Put class selection, add-drink, and context-sensitive primary actions in tab content or a FAB.
- Put admin management in an app-bar action visible to Session admins.
- Preserve the selected tab in a `tab` query parameter for restoration and notification deep links.
- Render the same tabs in read-only mode after archive, with all mutation controls removed.

### Activity Tab

- Show newest-first party events with pagination.
- Event cards cover drinks, quest awards, challenge awards, beerpong placements, and reversals.
- Filter by one or more party members and by event type.
- Show a clear reversal state on the original item rather than making it disappear.
- Group events that share a source where useful, such as both members completing a mutual quest or several challenge winners.
- Keep drink count as secondary event/ranking metadata; do not retain the old count-based ranking.

### Ranking Tab

- Rank active and archived party members by current party score descending.
- Use shared ranks for ties and username as a deterministic secondary sort.
- Show points as the primary value and drink count as a secondary statistic.
- Highlight the current user and top three using party accents while retaining accessible theme contrast.
- Read materialized totals from Party member documents; do not recalculate all events on the client.

### Games Tab

- Show the current social quest first when enabled.
- Show the current admin challenge and recent results when enabled.
- Show beerpong enrollment, bracket status, and a route into the bracket when enabled.
- Hide disabled module sections and show an admin shortcut to enable them.
- Allow members to choose their class in this tab until selected. Admin class changes live in Party management.

## Party Classes And Drink Scoring

Use `DrinkCategory` values as stable IDs and presentation-only themed names:

| ID | Working English title |
| --- | --- |
| `beer` | Beer Paladin |
| `cider` | Cider Sentinel |
| `cocktail` | Cocktail Druid |
| `spirit` | Spirit Shaman |
| `wine` | Wine Warrior |

The final titles and illustrations can be refined during visual implementation without changing persisted IDs.

Use integer score units to avoid floating-point aggregation drift. One displayed point equals 1,000 score units.

```text
alcoholMl = volumeInMilliliters * alcoholPercentage / 100
baseUnits = round(alcoholMl * 1000)
classBonusUnits = matchingClass ? round(baseUnits * 0.10) : 0
awardedUnits = baseUnits + classBonusUnits
displayedPoints = awardedUnits / 1000
```

Rules:

- A match means the drink's `DrinkCategory` equals the member's selected class when the drink is created.
- No selected class means base points only.
- An admin class change affects only drinks created after the change.
- Editing a drink reverses its original award and creates a new award from the updated immutable snapshot.
- Deleting a drink uses the existing soft-removal flow and creates a reversal event.
- Restoring a drink, if supported by the existing flow, creates a new deterministic award event.
- No mixed-drink reduction and no photo multiplier are carried over from Rozlucka.
- Standard Remembeer logical-day statistics still use the user's `endOfDayBoundary`; Party event ordering uses actual event timestamps and does not redefine logical days.

## Firestore Data Model

Keep `sessions/{sessionId}` authoritative for membership, admins, start/end time, and embedded drinks. Add a top-level Party document with the same ID.

### Party Root

```text
parties/{sessionId}
  sessionId: string
  status: active | archived
  activatedAt: timestamp
  activatedByUserId: string
  archivedAt: timestamp?
  moduleSettings:
    socialQuestsEnabled: bool
    adminChallengesEnabled: bool
    beerpongEnabled: bool
  questSchedule:
    minIntervalMinutes: int
    maxIntervalMinutes: int
    defaultDurationMinutes: int
    nextQuestAt: timestamp?
  activeQuestId: string?
  activeChallengeId: string?
  activeTournamentId: string?
  schemaVersion: int
  createdAt: timestamp
  updatedAt: timestamp
```

The Session remains the membership/admin authority. Do not duplicate mutable `memberIds` or `adminIds` on the Party root unless an index or scheduler query proves that denormalization is required.

### Party Members

```text
parties/{sessionId}/members/{userId}
  userId: string
  selectedClass: beer | cider | cocktail | spirit | wine | null
  classVersion: int
  classChangedAt: timestamp?
  beerpongOptIn: bool
  scoreUnits: int
  drinkCount: int
  joinedAt: timestamp
  updatedAt: timestamp
```

- Create/remove member records in response to valid Session membership changes while the Party is active.
- A newly added member starts with no class, no beerpong opt-in, and zero points.
- Preserve departed members and their score in archived activity/ranking, but mark them inactive if the product continues to allow leaving an active Session.
- Use the current `UserModel` for username, avatar, gender, and accent presentation. Snapshot eligibility inputs on each quest so profile edits do not alter an active quest.

### Immutable Score Events

```text
parties/{sessionId}/events/{eventId}
  kind: drink | socialQuest | adminChallenge | beerpongPlacement | reversal
  recipientUserId: string
  participantIds: string[]
  pointsUnits: int
  sourceCollection: drinks | quests | challenges | tournaments
  sourceId: string
  reversesEventId: string?
  actorUserId: string?
  occurredAt: timestamp
  createdAt: timestamp
  payload: map
```

- One award event has one score recipient. Multi-person outcomes create one event per recipient with a shared source ID.
- Reversals contain a negative `pointsUnits` value equal to the original event and reference it with `reversesEventId`.
- Never update or delete an event after creation.
- Event payloads snapshot the display data needed to audit scoring. Drink payloads include drink ID, category, ABV, volume, alcohol milliliters, selected class, class version, and applied multiplier.
- Update `members/{userId}.scoreUnits` and `drinkCount` in the same server transaction that creates an event.

### Quest Templates

```text
parties/{sessionId}/questTemplates/{templateId}
  source: builtIn | custom
  builtInKey: string?
  title: string
  instructions: string
  pointsUnits: int
  durationMinutes: int
  eligibilityRule: string
  enabled: bool
  catalogVersion: int
  createdByUserId: string?
  createdAt: timestamp
  updatedAt: timestamp
```

- Seed a versioned built-in catalog at activation.
- Adapt the 16 source concepts around class, same/different accent, different gender, interaction history, rank, and beerpong team/finalist state.
- Generalize class-specific templates across all five Remembeer classes rather than privileging the original four.
- Custom templates always use `eligibilityRule: allEligibleMembers`; v1 does not include a rule builder.

### Active Social Quests

```text
parties/{sessionId}/quests/{questId}
  templateId: string
  titleSnapshot: string
  instructionsSnapshot: string
  pointsUnits: int
  startsAt: timestamp
  endsAt: timestamp
  status: active | expired | cancelled
  eligibleMemberIds: string[]
  completedPairKeys: string[]
  createdAt: timestamp

parties/{sessionId}/quests/{questId}/selections/{userId}
  selectorUserId: string
  selectedUserId: string
  selectedAt: timestamp
```

- Only one scheduled social quest is active per Party.
- Eligible members are active Session members with a selected class who satisfy the template rule at creation time.
- A member selects one eligible partner.
- When A selects B and B has selected A, a transaction records the canonical pair key and awards both members exactly once.
- A quest remains active until its deadline so multiple pairs can complete it.
- Selection changes are allowed until a member's pair has completed; a completed pair is immutable.

### Admin Challenges

```text
parties/{sessionId}/challenges/{challengeId}
  title: string
  instructions: string
  pointsUnits: int
  startsAt: timestamp
  endsAt: timestamp
  status: active | completed | expired | cancelled
  winnerIds: string[]
  createdByUserId: string
  createdAt: timestamp
  updatedAt: timestamp
```

- Allow one active challenge at a time.
- Any Session admin can add multiple distinct winners before the deadline.
- Each winner receives the configured points once.
- An admin explicitly completes/cancels it, or the scheduler expires it at the deadline.
- Correcting a mistaken winner creates a reversal; it does not delete the award.

### Beerpong Tournament

```text
parties/{sessionId}/tournaments/{tournamentId}
  status: enrollment | active | completed | cancelled
  participantIds: string[]
  teamCount: int
  thirdPlaceEnabled: bool
  firstPlacePointsUnits: int
  secondPlacePointsUnits: int
  thirdPlacePointsUnits: int
  randomSeedHash: string
  randomSeedReveal: string?
  createdByUserId: string
  createdAt: timestamp
  completedAt: timestamp?

parties/{sessionId}/tournaments/{tournamentId}/teams/{teamId}
  name: string
  memberIds: string[]
  seed: int
  placement: int?

parties/{sessionId}/tournaments/{tournamentId}/matches/{matchId}
  round: int
  position: int
  kind: main | thirdPlace
  teamAId: string?
  teamBId: string?
  winnerTeamId: string?
  loserTeamId: string?
  status: pending | ready | completed | bye
  nextMatchId: string?
  nextSlot: a | b | null
```

- Members opt in per Party before enrollment is locked.
- An admin chooses a team count from 2 through `min(16, participantCount)` and generates teams.
- Server-side seeded randomization balances team sizes and distributes male/female participants as evenly as practical.
- Team sizes may differ by at most one.
- Generate the next power-of-two bracket and advance byes transactionally.
- Admins may rename teams before the first result; roster changes require redrawing the tournament.
- Earlier-result corrections clear dependent unfinalized results.
- Finalization creates immutable placement events for every team member.
- A finalized tournament correction uses reversal events before replacement placement awards.

### User Profile Additions

Add to `UserModel`:

```text
gender: male | female
accentColorKey: string
```

Both are editable by the owning user. Firestore rules validate the enum and palette key. Registration and required profile completion guarantee non-null values in the new code; no long-term nullable compatibility branch is retained.

## Server-Authoritative Commands

Use callable Cloud Functions for all operations that create score or advance game state. Direct client writes are limited to safe presentation/profile fields allowed by rules.

Suggested callables:

```text
activate_party
set_party_module_settings
set_party_quest_schedule
select_party_class
set_party_member_class
set_beerpong_opt_in
create_party_drink
update_party_drink
delete_party_drink
create_custom_quest_template
set_quest_template_enabled
select_quest_partner
create_admin_challenge
award_admin_challenge_winner
complete_admin_challenge
reverse_party_event
create_beerpong_tournament
record_beerpong_match_result
finalize_beerpong_tournament
archive_party
```

### Party Drink Commands

Party-targeted drink creation, update, and deletion must move behind callables. Non-Party drink flows can remain client-controlled.

Each Party drink callable must perform the existing `DrinkService` invariants and updates plus Party scoring in one server-controlled operation:

- Verify authentication, active Session membership, ownership for updates/deletes, Session time bounds, Party status, and drink capacity.
- Resolve and validate the referenced drink type/category, ABV, volume, and location.
- Update the Session's embedded drinks.
- Update normal user daily/monthly statistics using the user's configured logical-day boundary.
- Preserve existing badge behavior or invoke the same authoritative badge calculation after the transaction.
- Snapshot the current Party class and class version.
- Create/reverse immutable Party events and update the Party member aggregate.
- Return the created/updated drink and score result to Flutter.

This avoids forged scores and class-change races that would occur if scoring were added as a second client write.

### Idempotency And Concurrency

- Every mutating callable accepts a client-generated `commandId`.
- Store command receipts under `parties/{sessionId}/commands/{commandId}` and return the prior result on retry.
- Use deterministic award IDs derived from source and recipient, for example `drink:{drinkId}:v:{revision}` and `challenge:{challengeId}:winner:{userId}`.
- Keep a monotonic revision for changed drink awards; reverse the currently active revision before awarding the next.
- Use Firestore transactions for event creation, member totals, quest pair completion, challenge winners, bracket propagation, and Party archive.
- Reject commands when the Party is archived, the module is disabled, the source is expired, or the expected source revision changed.
- Scheduled work must claim due Party/quest documents transactionally before sending notifications.
- Treat notification delivery as at-least-once and make notification-open routing idempotent.

## Scheduled Cloud Functions

Add Python scheduled functions in `europe-west4`:

### Social Quest Scheduler

- Run every minute.
- Query active Parties with social quests enabled and `nextQuestAt <= now`.
- Transactionally verify no active quest, select an enabled template, calculate eligible members, create the quest, and set the next random interval.
- Clamp admin settings to constants, for example duration 1-60 minutes and delay range 5-180 minutes.
- If fewer than two members are eligible, advance `nextQuestAt` without creating a quest.
- Send a push to eligible members after the transaction commits.

### Expiry And Archive Cleanup

- Expire overdue quests and challenges.
- Clear matching active IDs on the Party root.
- Do not delete expired content.
- Ensure archiving cancels future scheduling by clearing `nextQuestAt` in the archive transaction.

Split the growing backend into focused modules imported by `functions/main.py`, for example `party_commands.py`, `party_scheduler.py`, `party_scoring.py`, `party_beerpong.py`, and `party_notifications.py`. Keep `main.py` as the Firebase entry point.

## Notifications And Deep Links

Add typed notification payloads containing `sessionId`, destination tab, and source ID where relevant.

| Event | Recipients | Destination |
| --- | --- | --- |
| Party activated | Session members except actor | Activity |
| Social quest started | Eligible members | Games / quest detail |
| Mutual quest completed | Both matched members | Activity / quest detail |
| Admin challenge started | Active members | Games / challenge detail |
| Challenge winner added | Winner | Activity / challenge detail |
| Beerpong enrollment opened/locked | Active members or opted-in members | Games / tournament |
| Beerpong match ready/result | Affected team members | Tournament |
| Tournament completed | Participants | Ranking / tournament |
| Party archived | Session members | Read-only Activity |

- Update `NotificationService` to route foreground, background, and terminated-app taps directly to `PartyRoute` or a nested Party route.
- Do not send the actor a redundant push for an action they just completed.
- Continue respecting the existing per-user notification token availability.

## Flutter Architecture

Follow the repository's model/controller/service/page layering.

```text
lib/party/
  constants.dart
  model/
    party.dart
    party_member.dart
    party_event.dart
    party_quest_template.dart
    party_quest.dart
    party_challenge.dart
    beerpong_tournament.dart
    beerpong_team.dart
    beerpong_match.dart
  controller/
    party_controller.dart
    party_event_controller.dart
    party_game_controller.dart
  service/
    party_service.dart
    party_ranking_service.dart
    party_quest_service.dart
    party_challenge_service.dart
    beerpong_service.dart
  page/
    party_page.dart
    party_management_page.dart
    party_profile_page.dart
    quest_detail_page.dart
    challenge_detail_page.dart
    beerpong_page.dart
  widget/
    party_activity_tab.dart
    party_activity_filters.dart
    party_event_card.dart
    party_ranking_tab.dart
    party_games_tab.dart
    party_class_selector.dart
    party_module_settings.dart
    quest_card.dart
    challenge_card.dart
    beerpong_bracket.dart
```

Guidelines:

- Controllers expose typed Firestore streams and callable wrappers; they contain no business rules.
- Services compose Session, Party, member, event, quest, challenge, and tournament streams with RxDart.
- Pages obtain services with `get<T>()` and render streams through `AsyncBuilder`.
- Keep tab state in the route/query state rather than a global singleton.
- Do not use the generic root `CrudController` for heterogeneous nested Party collections where explicit typed references are clearer.
- Register Party controllers before Party services in `IoCContainer`.
- Put point multipliers, interval limits, class metadata, event page size, and tournament limits in `lib/party/constants.dart`.

## Routes

Retain the current route and add nested typed routes:

```text
/drink/parties/:sessionId?tab=activity|ranking|games
/drink/parties/:sessionId/manage
/drink/parties/:sessionId/quests/:questId
/drink/parties/:sessionId/challenges/:challengeId
/drink/parties/:sessionId/tournaments/:tournamentId
```

- Invalid/missing `tab` defaults to Activity.
- Detail routes return to the prior Party tab.
- Regenerate and commit `lib/routes.g.dart` after route changes.

## Security Rules

Add helpers that read the parent Session by Party ID:

```text
isSessionMember(sessionId)
isSessionAdmin(sessionId)
isActiveParty(sessionId)
```

Rules must enforce:

- Only Session members can read Party documents and subcollections.
- Clients cannot create, update, or delete Party score events or member totals.
- Game transitions and award operations are callable-only.
- Archived Party data is readable but immutable.
- Party Session drink mutations are callable-only; tighten the current rule that broadly allows members to change the shared `drinks` array.
- Non-Party drink and Session behavior remains unchanged unless needed to close an existing privilege gap.
- Users may update only their own valid gender and accent key, alongside the profile fields already allowed.
- Custom quest/challenge input limits are enforced server-side; rules remain deny-by-default for direct writes.

Add Firebase Emulator rules tests before deploying the broader Party rules.

## Firestore Indexes

Add only indexes required by implemented queries, expected to include:

```text
parties: status ASC, moduleSettings.socialQuestsEnabled ASC, questSchedule.nextQuestAt ASC
party members: scoreUnits DESC, userId ASC
party events: occurredAt DESC
party events: kind ASC, occurredAt DESC
party events: participantIds ARRAY_CONTAINS, occurredAt DESC
party events: participantIds ARRAY_CONTAINS, kind ASC, occurredAt DESC
party quests: status ASC, endsAt ASC
party challenges: status ASC, endsAt ASC
party tournaments: status ASC, createdAt DESC
party matches: round ASC, position ASC
```

Disable indexing for large immutable payload maps and long instructions where no query requires them.

## Existing Files Expected To Change

```text
lib/party/page/party_page.dart
lib/party/widget/party_ranking.dart
lib/routes.dart
lib/routes.g.dart
lib/ioc/ioc_container.dart

lib/session/controller/session_controller.dart
lib/session/service/session_service.dart
lib/session/page/edit_session_page.dart
lib/session/page/session_management_page.dart

lib/drink/service/drink_service.dart
lib/drink/page/add_drink_page.dart
lib/drink/page/update_drink_page.dart

lib/user/model/user_model.dart
lib/user/model/user_model.freezed.dart
lib/user/model/user_model.g.dart
lib/user/controller/user_controller.dart
lib/user/service/user_service.dart
lib/user/constants.dart

lib/auth/...
lib/notification/service/notification_service.dart

functions/main.py
functions/requirements.txt
firestore.rules
firestore.indexes.json
```

The exact auth/profile page paths should be confirmed when implementing profile completion because current registration behavior is spread across Auth and User services. Every changed Freezed/JSON model and typed route requires regenerated committed output.

## Delivery Milestones

### Milestone 1: Profile And Party Foundation

- Add gender/accent models, registration fields, required existing-user onboarding, profile editing, constants, rules, and tests.
- Add Party root/member models, controllers, services, IoC registrations, rules, and indexes.
- Replace client-only conversion with atomic `activate_party`.
- Add Party archive lifecycle linked to Session end.
- Build the three-tab Party shell and read-only archive state.

Acceptance criteria:

- New and existing users cannot bypass required profile completion.
- Any Session admin can activate an eligible Session exactly once.
- Members can open the three Party tabs; non-members cannot read Party data.
- Ending the Session freezes Party writes while retaining reads.

### Milestone 2: Scoring, Activity, And Ranking

- Add Party class selection and admin class changes.
- Implement server-authoritative Party drink create/update/delete paths.
- Add immutable events, reversals, member aggregates, pagination, and Activity filters.
- Replace drink-count ranking with Party score ranking.
- Preserve normal user statistics, badges, and logical-day behavior.

Acceptance criteria:

- Drink points match the documented alcohol/class formula.
- A missing class receives base points and a later class change is not retroactive.
- Retries and concurrent writes never duplicate an award.
- Editing/deleting creates auditable reversals and correct totals.
- Global Remembeer statistics remain correct and Party points remain isolated.

### Milestone 3: Admin Challenges And Notifications

- Add independent module settings and Party management UI.
- Add challenge create, multi-winner award, complete, cancel, expiry, and reversal flows.
- Add typed Party notification payloads and deep-link routing.

Acceptance criteria:

- Multiple winners can be awarded once each before completion/expiry.
- Only Session admins can manage challenges.
- Push taps open the correct Party tab/detail in all app lifecycle states.

### Milestone 4: Scheduled Social Quests

- Port and generalize the built-in quest catalog.
- Add custom templates and enable/disable controls.
- Add configurable duration and random interval bounds.
- Implement scheduler claims, eligibility snapshots, mutual selections, awards, expiry, and notifications.

Acceptance criteria:

- Only eligible, active, class-selected members can participate.
- Reciprocal selections award both users once, including under concurrent submissions.
- Disabled/archived Parties produce no scheduled quests.
- Scheduler retries do not create duplicate active quests or notifications.

### Milestone 5: Beerpong

- Add opt-in enrollment, admin team-count selection, balanced server draw, team naming, bracket UI, match progression, byes, optional third place, and placement scoring.
- Add tournament notifications and correction/reversal flows.

Acceptance criteria:

- Draws support 2-16 teams and non-power-of-two brackets.
- Team sizes differ by at most one and gender distribution is balanced where possible.
- Winners propagate correctly; dependent results reset safely after correction.
- Final placement awards are exactly-once and auditable.

### Milestone 6: Hardening And Release

- Complete emulator integration, concurrency, notification, widget, and navigation coverage.
- Review query costs, scheduler limits, indexes, and event pagination.
- Run code generation, formatting, and strict analysis.
- Perform Android and iOS manual testing with foreground/background/terminated notifications.
- Remove the old client-computed Party ranking implementation after replacement coverage passes.

Acceptance criteria:

- `dart run build_runner build --delete-conflicting-outputs` produces no uncommitted generated drift.
- `dart format .` succeeds.
- `flutter analyze --fatal-warnings` succeeds.
- All unit, widget, rules, emulator, and Cloud Function tests pass.

## Test Strategy

### Pure Unit Tests

- Base score and 10% class bonus for all five categories.
- Integer rounding at ABV/volume boundaries.
- Class-version snapshot behavior.
- Shared leaderboard ranks and deterministic tie ordering.
- Built-in quest eligibility rules for class, gender, accent, ranking, history, and beerpong state.
- Team balancing, seeded shuffle, byes, match propagation, third-place generation, and downstream reset.

### Flutter Widget Tests

- Profile completion and profile editing.
- Activity/Ranking/Games tabs and query-parameter selection.
- Member versus admin controls.
- Class selection, disabled modules, loading/error/empty states, and archived read-only state.
- Activity person/event filters and paginated append.
- Beerpong bracket layouts on narrow and wide screens.

### Firestore Rules Tests

- Member/admin/non-member reads and writes for every Party path.
- Direct event/score writes denied.
- Active versus archived behavior.
- Party versus non-Party Session drink writes.
- Valid and invalid profile gender/accent updates.
- Custom content input constraints and deny-by-default coverage.

### Cloud Function And Emulator Tests

- Activation by owner/admin and rejection for member, solo, ended, duplicate, or malformed Session.
- Pre-conversion drink base awards exactly once.
- Create/update/delete drink transactions preserve stats and score.
- Idempotent command retries and concurrent drink operations.
- Challenge multi-winner awards and explicit reversals.
- Quest scheduler interval bounds, insufficient eligibility, disabled modules, claim races, and expiry.
- Reciprocal quest selections submitted concurrently.
- Beerpong draws at boundaries, result races, finalization, and corrections.
- Archive races against every mutating command.

### Notification Tests

- Correct recipient set and actor exclusion.
- Correct payload for each actionable event.
- Foreground, background, and terminated-app route handling.
- Missing/expired FCM token behavior does not roll back game state.

## Risks And Mitigations

| Risk | Mitigation |
| --- | --- |
| Embedded Session drinks create document contention | Keep existing limit initially; transact carefully; monitor writes and consider a future drink subcollection migration outside this scope |
| Duplicate callable/scheduler execution | Command receipts, deterministic event IDs, and transactional source-state checks |
| Forged or inconsistent Party score | Callable-only Party drink and award operations; deny direct score writes |
| Class changes racing with drinks | Snapshot class and monotonic class version inside the same server transaction |
| Scheduler cost or fan-out | One-minute indexed due query, bounded batch size, transactional claims, and follow-up invocations |
| Large event history | Paginated queries, small immutable documents, disabled payload indexes, and no unbounded client subscriptions |
| Notification duplication | Idempotent routing and dispatch identifiers; game state never depends on push success |
| Broad current Session rules | Tighten Party Session writes before enabling scoring; add emulator regression tests for normal Sessions |
| Profile field rollout blocks users | Small required completion flow with deterministic accent default and clear validation |
| Scope size | Deliver milestone by milestone behind module toggles; do not start beerpong before scoring and event foundations are stable |

## Definition Of Done

- All five milestones are implemented and Milestone 6 hardening passes.
- Party score is server-authoritative, isolated from global stats, and fully auditable.
- Activity, Ranking, Games, quests, challenges, and beerpong work for concurrent authenticated members.
- Session admins have the agreed controls and ordinary members cannot mutate protected state.
- Scheduled behavior and notification deep links work without an admin device being open.
- Ending a Session reliably freezes its Party into a readable archive.
- Generated files, rules, indexes, backend functions, and automated tests are committed together with their source changes.
