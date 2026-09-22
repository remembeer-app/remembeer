import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_quest.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/service/party_challenge_service.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/widget/party_live_banner.dart';
import 'package:remembeer/session/model/session.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1, 20);

  testWidgets('renders nothing for an active Party without running games', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        PartyLiveBanner(
          state: _state(
            settings: const PartyModuleSettings(
              socialQuestsEnabled: true,
              adminChallengesEnabled: true,
            ),
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          questService: _FakeQuestService(),
          challengeService: _FakeChallengeService(),
          now: now,
        ),
      ),
    );

    expect(tester.getSize(find.byType(PartyLiveBanner)).height, 0);
  });

  testWidgets('shows the running quest and challenge with countdowns', (
    tester,
  ) async {
    final quest = _quest(id: 'quest-1', now: now);
    final challenge = _challenge(id: 'challenge-1', now: now);
    await tester.pumpWidget(
      _wrap(
        PartyLiveBanner(
          state: _state(
            settings: const PartyModuleSettings(
              socialQuestsEnabled: true,
              adminChallengesEnabled: true,
            ),
            activeQuestId: quest.id,
            activeChallengeId: challenge.id,
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          questService: _FakeQuestService([quest]),
          challengeService: _FakeChallengeService([challenge]),
          now: now,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('SOCIAL QUEST'), findsOneWidget);
    expect(find.text('Toast time'), findsOneWidget);
    expect(find.text('12:00 left'), findsOneWidget);
    expect(find.text('ADMIN CHALLENGE'), findsOneWidget);
    expect(find.text('Chug contest'), findsOneWidget);
    expect(find.text('1h 30m left'), findsOneWidget);
  });

  testWidgets('hides games that are disabled, finished or expired', (
    tester,
  ) async {
    final expiredQuest = _quest(
      id: 'quest-1',
      now: now,
      endsAt: now.subtract(const Duration(seconds: 1)),
    );
    final completedChallenge = _challenge(
      id: 'challenge-1',
      now: now,
      status: PartyChallengeStatus.completed,
    );
    await tester.pumpWidget(
      _wrap(
        PartyLiveBanner(
          state: _state(
            settings: const PartyModuleSettings(
              socialQuestsEnabled: true,
              adminChallengesEnabled: true,
            ),
            activeQuestId: expiredQuest.id,
            activeChallengeId: completedChallenge.id,
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          questService: _FakeQuestService([expiredQuest]),
          challengeService: _FakeChallengeService([completedChallenge]),
          now: now,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('SOCIAL QUEST'), findsNothing);
    expect(find.text('ADMIN CHALLENGE'), findsNothing);

    final disabledQuest = _quest(id: 'quest-2', now: now);
    await tester.pumpWidget(
      _wrap(
        PartyLiveBanner(
          state: _state(
            settings: const PartyModuleSettings(),
            activeQuestId: disabledQuest.id,
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          questService: _FakeQuestService([disabledQuest]),
          challengeService: _FakeChallengeService(),
          now: now,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('SOCIAL QUEST'), findsNothing);
  });

  testWidgets('marks an archived Party', (tester) async {
    await tester.pumpWidget(
      _wrap(
        PartyLiveBanner(
          state: _state(
            settings: const PartyModuleSettings(socialQuestsEnabled: true),
            activeQuestId: 'quest-1',
            isArchived: true,
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          questService: _FakeQuestService(),
          challengeService: _FakeChallengeService(),
          now: now,
        ),
      ),
    );

    expect(find.text('Archived Party'), findsOneWidget);
    expect(find.text('SOCIAL QUEST'), findsNothing);
  });
}

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [child],
    ),
  ),
);

PartyState _state({
  required PartyModuleSettings settings,
  String? activeQuestId,
  String? activeChallengeId,
  bool isArchived = false,
}) {
  final now = DateTime.utc(2026);
  final session = Session(
    id: 'session-1',
    userId: 'user-1',
    createdAt: now,
    updatedAt: now,
    memberIds: const {'user-1'},
    adminIds: const {},
    bannedMemberIds: const {},
    name: 'Party',
    startedAt: now,
    isSoloSession: false,
    isParty: true,
  );
  return PartyState(
    session: session,
    party: Party(
      id: session.id,
      sessionId: session.id,
      status: isArchived ? PartyStatus.archived : PartyStatus.active,
      activatedAt: now,
      activatedByUserId: 'user-1',
      moduleSettings: settings,
      activeQuestId: activeQuestId,
      activeChallengeId: activeChallengeId,
      createdAt: now,
      updatedAt: now,
    ),
    access: PartyAccess.member,
    lifecycle: isArchived ? PartyLifecycle.archived : PartyLifecycle.active,
    currentMember: PartyMember(
      id: 'user-1',
      userId: 'user-1',
      joinedAt: now,
      updatedAt: now,
    ),
  );
}

PartyQuest _quest({
  required String id,
  required DateTime now,
  DateTime? endsAt,
  PartyQuestStatus status = PartyQuestStatus.active,
}) => PartyQuest(
  id: id,
  templateId: 'template-1',
  titleSnapshot: 'Toast time',
  instructionsSnapshot: 'Find a partner and toast.',
  eligibilityRuleSnapshot: 'any',
  targetClassMemberIds: const [],
  pointsUnits: 10000,
  startsAt: now.subtract(const Duration(minutes: 3)),
  endsAt: endsAt ?? now.add(const Duration(minutes: 12)),
  status: status,
  createdAt: now,
);

PartyChallenge _challenge({
  required String id,
  required DateTime now,
  PartyChallengeStatus status = PartyChallengeStatus.active,
}) => PartyChallenge(
  id: id,
  title: 'Chug contest',
  instructions: 'Fastest finisher wins.',
  pointsUnits: 50000,
  startsAt: now,
  endsAt: now.add(const Duration(hours: 1, minutes: 30)),
  status: status,
  createdByUserId: 'user-1',
  createdAt: now,
  updatedAt: now,
);

class _FakeQuestService implements PartyQuestService {
  _FakeQuestService([this.quests = const []]);

  final List<PartyQuest> quests;

  @override
  Stream<List<PartyQuest>> questsStream(String sessionId) =>
      Stream.value(quests);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeChallengeService implements PartyChallengeService {
  _FakeChallengeService([this.challenges = const []]);

  final List<PartyChallenge> challenges;

  @override
  Stream<List<PartyChallenge>> challengesStream(String sessionId) =>
      Stream.value(challenges);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
