import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_quest_template.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/page/party_management_page.dart';
import 'package:remembeer/party/service/party_challenge_service.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
  testWidgets('member cannot see Party management mutations', (tester) async {
    await tester.pumpWidget(_page(_state(access: PartyAccess.member)));
    await tester.pumpAndSettle();

    expect(
      find.text('Only Party admins can manage this Party.'),
      findsOneWidget,
    );
    expect(find.byType(SwitchListTile), findsNothing);
    expect(find.text('Start challenge'), findsNothing);
  });

  testWidgets('archived Party management is read-only', (tester) async {
    await tester.pumpWidget(_page(_state(isArchived: true)));
    await tester.pumpAndSettle();

    expect(find.text('This Party is archived and read-only.'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNothing);
  });

  testWidgets('admin sees module, schedule, and challenge controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      _page(
        _state(
          settings: const PartyModuleSettings(
            socialQuestsEnabled: true,
            adminChallengesEnabled: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SwitchListTile), findsNWidgets(3));
    expect(find.text('Social quest schedule'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Start challenge'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Start challenge'), findsWidgets);
  });
}

Widget _page(PartyState state) => MaterialApp(
  home: PartyManagementPage(
    sessionId: state.session.id,
    partyService: _FakePartyService(state),
    sessionService: _FakeSessionService(),
    challengeService: _FakeChallengeService(),
    questService: _FakeQuestService(),
  ),
);

PartyState _state({
  PartyAccess access = PartyAccess.admin,
  bool isArchived = false,
  PartyModuleSettings settings = const PartyModuleSettings(),
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
    endedAt: isArchived ? now.add(const Duration(hours: 1)) : null,
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
      createdAt: now,
      updatedAt: now,
    ),
    access: access,
    lifecycle: isArchived ? PartyLifecycle.archived : PartyLifecycle.active,
    currentMember: PartyMember(
      id: 'user-1',
      userId: 'user-1',
      joinedAt: now,
      updatedAt: now,
    ),
  );
}

class _FakePartyService implements PartyService {
  _FakePartyService(this.state);

  final PartyState state;

  @override
  Stream<PartyState> stateStream(String sessionId) => Stream.value(state);

  @override
  Stream<List<PartyMember>> membersStream(String sessionId) =>
      Stream.value([state.currentMember!]);

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
  @override
  Stream<List<PartyChallenge>> challengesStream(String sessionId) =>
      Stream.value(const []);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeQuestService implements PartyQuestService {
  @override
  Stream<List<PartyQuestTemplate>> templatesStream(String sessionId) =>
      Stream.value(const []);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
