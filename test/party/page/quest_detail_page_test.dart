import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_quest.dart';
import 'package:remembeer/party/model/party_quest_selection.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/page/quest_detail_page.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:toastification/toastification.dart';

void main() {
  testWidgets('shows only snapshot-eligible partners and allows a change', (
    tester,
  ) async {
    final now = DateTime.now();
    final quest = _quest(
      now,
      eligibleMemberIds: const ['current', 'first', 'second'],
    );
    final service = _FakeQuestService(
      PartyQuestDetailState(
        quest: quest,
        selections: [_selection('current', 'first', now)],
      ),
    );

    await tester.pumpWidget(_page(_state(now), service));
    await _pumpStreams(tester);

    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
    expect(find.text('Ineligible'), findsNothing);
    expect(find.text('Waiting for mutual confirmation'), findsOneWidget);
    expect(find.textContaining('You can change your choice'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Choose'));
    await tester.pump();

    expect(service.selectedUserId, 'second');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('completed mutual pair is immutable', (tester) async {
    final now = DateTime.now();
    final quest = _quest(
      now,
      eligibleMemberIds: const ['current', 'first'],
      completedPairKeys: [partyQuestPairKey('current', 'first')],
    );
    final service = _FakeQuestService(
      PartyQuestDetailState(
        quest: quest,
        selections: [
          _selection('current', 'first', now),
          _selection('first', 'current', now),
        ],
      ),
    );

    await tester.pumpWidget(_page(_state(now), service));
    await _pumpStreams(tester);

    expect(find.text('Quest completed'), findsOneWidget);
    expect(find.textContaining('This pair is final.'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Choose'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Selected'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('archived quest remains readable and non-interactive', (
    tester,
  ) async {
    final now = DateTime.now();
    final service = _FakeQuestService(
      PartyQuestDetailState(
        quest: _quest(now, eligibleMemberIds: const ['current', 'first']),
        selections: const [],
      ),
    );

    await tester.pumpWidget(_page(_state(now, archived: true), service));
    await _pumpStreams(tester);

    expect(find.text('Find your match'), findsOneWidget);
    expect(find.text('Archived Party'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Future<void> _pumpStreams(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
  await tester.pump();
}

Widget _page(PartyState state, _FakeQuestService questService) =>
    ToastificationWrapper(
      child: MaterialApp(
        home: QuestDetailPage(
          sessionId: state.session.id,
          questId: 'quest-1',
          partyService: _FakePartyService(state),
          sessionService: _FakeSessionService(),
          questService: questService,
        ),
      ),
    );

PartyState _state(DateTime now, {bool archived = false}) {
  final session = Session(
    id: 'session-1',
    userId: 'current',
    createdAt: now,
    updatedAt: now,
    memberIds: const {'current', 'first', 'second', 'ineligible'},
    adminIds: const {},
    bannedMemberIds: const {},
    name: 'Party',
    startedAt: now,
    endedAt: archived ? now : null,
    isSoloSession: false,
    isParty: true,
  );
  return PartyState(
    session: session,
    party: Party(
      id: session.id,
      sessionId: session.id,
      status: archived ? PartyStatus.archived : PartyStatus.active,
      activatedAt: now,
      activatedByUserId: 'current',
      moduleSettings: const PartyModuleSettings(socialQuestsEnabled: true),
      activeQuestId: 'quest-1',
      createdAt: now,
      updatedAt: now,
    ),
    access: PartyAccess.member,
    lifecycle: archived ? PartyLifecycle.archived : PartyLifecycle.active,
    currentMember: PartyMember(
      id: 'current',
      userId: 'current',
      joinedAt: now,
      updatedAt: now,
    ),
  );
}

PartyQuest _quest(
  DateTime now, {
  required List<String> eligibleMemberIds,
  List<String> completedPairKeys = const [],
}) => PartyQuest(
  id: 'quest-1',
  templateId: 'template-1',
  titleSnapshot: 'Find your match',
  instructionsSnapshot: 'Choose a partner.',
  pointsUnits: 25000,
  startsAt: now.subtract(const Duration(minutes: 1)),
  endsAt: now.add(const Duration(minutes: 5)),
  status: PartyQuestStatus.active,
  eligibleMemberIds: eligibleMemberIds,
  completedPairKeys: completedPairKeys,
  createdAt: now,
);

PartyQuestSelection _selection(
  String selectorUserId,
  String selectedUserId,
  DateTime now,
) => PartyQuestSelection(
  id: selectorUserId,
  selectorUserId: selectorUserId,
  selectedUserId: selectedUserId,
  selectedAt: now,
);

const _members = [
  UserModel(
    id: 'current',
    email: 'current@example.com',
    username: 'Current',
    searchableUsername: 'current',
  ),
  UserModel(
    id: 'first',
    email: 'first@example.com',
    username: 'First',
    searchableUsername: 'first',
  ),
  UserModel(
    id: 'second',
    email: 'second@example.com',
    username: 'Second',
    searchableUsername: 'second',
  ),
  UserModel(
    id: 'ineligible',
    email: 'ineligible@example.com',
    username: 'Ineligible',
    searchableUsername: 'ineligible',
  ),
];

class _FakePartyService implements PartyService {
  _FakePartyService(this.state);

  final PartyState state;

  @override
  String get currentUserId => 'current';

  @override
  Stream<PartyState> stateStream(String sessionId) => Stream.value(state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSessionService implements SessionService {
  @override
  Stream<List<UserModel>> sessionMembersStream(String sessionId) =>
      Stream.value(_members);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeQuestService implements PartyQuestService {
  _FakeQuestService(this.state);

  final PartyQuestDetailState state;
  String? selectedUserId;

  @override
  Stream<PartyQuestDetailState> questStateStream(
    String sessionId,
    String questId,
  ) => Stream.value(state);

  @override
  Future<bool> selectPartner({
    required String sessionId,
    required String questId,
    required String selectedUserId,
  }) async {
    this.selectedUserId = selectedUserId;
    return false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
