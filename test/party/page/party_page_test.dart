import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/page/party_page.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/party/widget/party_class_selector.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
  testWidgets('restores the requested tab', (tester) async {
    _registerServices(_state());
    addTearDown(get.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: PartyPage(sessionId: 'session-1', tab: PartyTab.ranking),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('User'), findsOneWidget);
    expect(find.byTooltip('Manage Party'), findsOneWidget);
  });

  testWidgets('archived Party removes mutation controls', (tester) async {
    _registerServices(_state(isArchived: true));
    addTearDown(get.reset);

    await tester.pumpWidget(
      const MaterialApp(home: PartyPage(sessionId: 'session-1')),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Archived Party'), findsOneWidget);
    expect(find.byTooltip('Manage Party'), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byType(PartyClassSelector), findsNothing);
  });
}

void _registerServices(PartyState state) {
  get
    ..registerSingleton<DrinkService>(_FakeDrinkService())
    ..registerSingleton<PartyService>(_FakePartyService(state))
    ..registerSingleton<SessionService>(_FakeSessionService());
}

PartyState _state({bool isArchived = false}) {
  final now = DateTime.utc(2026);
  final session = Session(
    id: 'session-1',
    userId: 'user-1',
    createdAt: now,
    updatedAt: now,
    memberIds: const {'user-1'},
    adminIds: const {},
    bannedMemberIds: const {},
    name: 'Test Party',
    startedAt: now,
    endedAt: isArchived ? now.add(const Duration(hours: 1)) : null,
    isSoloSession: false,
    isParty: true,
  );
  final party = Party(
    id: session.id,
    sessionId: session.id,
    status: isArchived ? PartyStatus.archived : PartyStatus.active,
    activatedAt: now,
    activatedByUserId: 'user-1',
    archivedAt: isArchived ? now.add(const Duration(hours: 1)) : null,
    createdAt: now,
    updatedAt: now,
  );
  return PartyState(
    session: session,
    party: party,
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

class _FakeDrinkService implements DrinkService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
