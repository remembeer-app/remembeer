import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_quest_template.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/page/party_quest_management_page.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/session/model/session.dart';

void main() {
  testWidgets('active admin can manage the grouped quest catalog', (
    tester,
  ) async {
    final state = _state();
    await tester.pumpWidget(
      MaterialApp(
        home: PartyQuestManagementPage(
          sessionId: 'party-1',
          partyService: _FakePartyService(state),
          questService: _FakeQuestService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Quest catalog'), findsWidgets);
    expect(find.text('Early quests'), findsOneWidget);
    expect(find.text('Toast together'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);
  });

  testWidgets('non-admin cannot manage quest templates', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PartyQuestManagementPage(
          sessionId: 'party-1',
          partyService: _FakePartyService(_state(access: PartyAccess.member)),
          questService: _FakeQuestService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Only Party admins can manage this Party.'),
      findsOneWidget,
    );
    expect(find.byType(SwitchListTile), findsNothing);
  });
}

PartyState _state({PartyAccess access = PartyAccess.admin}) {
  final now = DateTime.utc(2026);
  final session = Session(
    id: 'party-1',
    userId: 'user-1',
    createdAt: now,
    updatedAt: now,
    memberIds: const {'user-1'},
    adminIds: const {'user-1'},
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
      moduleSettings: const PartyModuleSettings(socialQuestsEnabled: true),
      createdAt: now,
      updatedAt: now,
    ),
    access: access,
    lifecycle: PartyLifecycle.active,
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
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeQuestService implements PartyQuestService {
  @override
  Stream<List<PartyQuestTemplate>> templatesStream(String sessionId) =>
      Stream.value([
        PartyQuestTemplate(
          id: 'template-1',
          source: PartyQuestTemplateSource.builtIn,
          builtInKey: 'same-accent',
          title: 'Toast together',
          instructions: 'Have a toast and select each other.',
          pointsUnits: 25000,
          durationMinutes: 15,
          eligibilityRule: 'sameAccent',
          availability: PartyQuestAvailability.early,
          catalogVersion: 1,
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        ),
      ]);

  @override
  Future<void> setTemplateEnabled(
    String sessionId,
    String templateId,
    bool enabled,
  ) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
