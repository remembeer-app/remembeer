import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/page/challenge_detail_page.dart';
import 'package:remembeer/party/service/party_challenge_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
  testWidgets('already awarded winner is disabled', (tester) async {
    final challenge = _challenge();
    await tester.pumpWidget(_page(_state(), challenge));
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.text('Already awarded'), findsOneWidget);
    final awardButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Award'),
    );
    expect(awardButton.onPressed, isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('archived challenge exposes no admin actions', (tester) async {
    await tester.pumpWidget(_page(_state(isArchived: true), _challenge()));
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.text('Archived Party'), findsOneWidget);
    expect(find.text('Complete challenge'), findsNothing);
    expect(find.text('Cancel challenge'), findsNothing);
    expect(find.text('Correct'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Widget _page(PartyState state, PartyChallenge challenge) => MaterialApp(
  home: ChallengeDetailPage(
    sessionId: state.session.id,
    challengeId: challenge.id,
    partyService: _FakePartyService(state),
    sessionService: _FakeSessionService(),
    challengeService: _FakeChallengeService(challenge),
  ),
);

PartyState _state({bool isArchived = false}) {
  final now = DateTime.now();
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
    endedAt: isArchived ? now : null,
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
      activeChallengeId: 'challenge-1',
      createdAt: now,
      updatedAt: now,
    ),
    access: PartyAccess.admin,
    lifecycle: isArchived ? PartyLifecycle.archived : PartyLifecycle.active,
    currentMember: PartyMember(
      id: 'user-1',
      userId: 'user-1',
      joinedAt: now,
      updatedAt: now,
    ),
  );
}

PartyChallenge _challenge() {
  final now = DateTime.now();
  return PartyChallenge(
    id: 'challenge-1',
    title: 'Dance-off',
    instructions: 'Dance until the music stops.',
    pointsUnits: 50000,
    startsAt: now,
    endsAt: now.add(const Duration(minutes: 5)),
    status: PartyChallengeStatus.active,
    winnerIds: const ['user-1'],
    createdByUserId: 'user-1',
    createdAt: now,
    updatedAt: now,
  );
}

class _FakePartyService implements PartyService {
  _FakePartyService(this.state);

  final PartyState state;

  @override
  Stream<PartyState> stateStream(String sessionId) => Stream.value(state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSessionService implements SessionService {
  @override
  Stream<List<UserModel>> sessionMembersStream(String sessionId) =>
      Stream.value([
        const UserModel(
          id: 'user-1',
          email: 'user@example.com',
          username: 'User',
          searchableUsername: 'user',
        ),
      ]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeChallengeService implements PartyChallengeService {
  _FakeChallengeService(this.challenge);

  final PartyChallenge challenge;

  @override
  Stream<PartyChallengeDetailState> challengeStateStream(
    String sessionId,
    String challengeId,
  ) => Stream.value(
    PartyChallengeDetailState(
      challenge: challenge,
      reversedWinnerIds: const {},
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
