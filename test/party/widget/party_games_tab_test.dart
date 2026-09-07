import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/service/party_challenge_service.dart';
import 'package:remembeer/party/widget/party_games_tab.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
  testWidgets('composes only independently enabled game sections', (
    tester,
  ) async {
    final state = _state(
      settings: const PartyModuleSettings(
        socialQuestsEnabled: true,
        beerpongEnabled: true,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PartyGamesTab(
            state: state,
            members: const [_user],
            challengeService: _FakeChallengeService(),
            onSelectClass: (_) async {},
            socialQuestSectionBuilder: (_, _, _) => const Text('Quest slot'),
            beerpongSectionBuilder: (_, _, _) => const Text('Beerpong slot'),
          ),
        ),
      ),
    );

    expect(find.text('Quest slot'), findsOneWidget);
    expect(find.text('Beerpong slot'), findsOneWidget);
    expect(find.text('Admin challenges'), findsNothing);
  });

  testWidgets('shows the active challenge and recent results', (tester) async {
    final now = DateTime.now();
    final active = _challenge(
      id: 'active',
      createdAt: now,
      endsAt: now.add(const Duration(minutes: 5)),
    );
    final completed = _challenge(
      id: 'completed',
      status: PartyChallengeStatus.completed,
      createdAt: now.subtract(const Duration(minutes: 10)),
      endsAt: now.subtract(const Duration(minutes: 5)),
    );
    final state = _state(
      settings: const PartyModuleSettings(adminChallengesEnabled: true),
      activeChallengeId: active.id,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PartyGamesTab(
            state: state,
            members: const [_user],
            challengeService: _FakeChallengeService([active, completed]),
            onSelectClass: (_) async {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Admin challenges'), findsOneWidget);
    expect(find.text('Challenge active'), findsOneWidget);
    expect(find.text('Recent results'), findsOneWidget);
    expect(find.text('Challenge completed'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}

const _user = UserModel(
  id: 'user-1',
  email: 'user@example.com',
  username: 'User',
  searchableUsername: 'user',
);

PartyState _state({
  required PartyModuleSettings settings,
  String? activeChallengeId,
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
      status: PartyStatus.active,
      activatedAt: now,
      activatedByUserId: 'user-1',
      moduleSettings: settings,
      activeChallengeId: activeChallengeId,
      createdAt: now,
      updatedAt: now,
    ),
    access: PartyAccess.admin,
    lifecycle: PartyLifecycle.active,
    currentMember: PartyMember(
      id: 'user-1',
      userId: 'user-1',
      joinedAt: now,
      updatedAt: now,
    ),
  );
}

PartyChallenge _challenge({
  required String id,
  required DateTime createdAt,
  required DateTime endsAt,
  PartyChallengeStatus status = PartyChallengeStatus.active,
}) => PartyChallenge(
  id: id,
  title: 'Challenge $id',
  instructions: 'Do something memorable.',
  pointsUnits: 50000,
  startsAt: createdAt,
  endsAt: endsAt,
  status: status,
  createdByUserId: 'user-1',
  createdAt: createdAt,
  updatedAt: createdAt,
);

class _FakeChallengeService implements PartyChallengeService {
  _FakeChallengeService([this.challenges = const []]);

  final List<PartyChallenge> challenges;

  @override
  Stream<List<PartyChallenge>> challengesStream(String sessionId) =>
      Stream.value(challenges);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
