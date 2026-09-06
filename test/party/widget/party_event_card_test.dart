import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:remembeer/party/service/party_activity_service.dart';
import 'package:remembeer/party/widget/party_event_card.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
  testWidgets('editable card is visibly tappable and exposes edit semantics', (
    tester,
  ) async {
    var edits = 0;
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PartyEventCard(
            group: PartyEventGroup(events: [_drinkEvent()], isReversed: false),
            membersById: _membersById,
            onEdit: () => edits += 1,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('Editable. Tap to edit.')),
      findsOneWidget,
    );

    await tester.tap(find.byType(PartyEventCard));
    expect(edits, 1);
    semantics.dispose();
  });

  testWidgets('renders each quest recipient with their own name and points', (
    tester,
  ) async {
    final events = [
      _questEvent('award-a', 'a', 6000),
      _questEvent('award-b', 'b', 4000),
    ];
    final groups = groupPartyEvents(events);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              for (final group in groups)
                PartyEventCard(group: group, membersById: _membersById),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(PartyEventCard), findsNWidgets(2));
    expect(find.text('Alice completed Find your match'), findsOneWidget);
    expect(find.text('+6'), findsOneWidget);
    expect(find.text('Bob completed Find your match'), findsOneWidget);
    expect(find.text('+4'), findsOneWidget);
  });
}

PartyEvent _drinkEvent() => PartyEvent(
  id: 'drink-event',
  kind: PartyEventKind.drink,
  recipientUserId: 'a',
  participantIds: const ['a'],
  pointsUnits: 1000,
  sourceCollection: PartyEventSourceCollection.drinks,
  sourceId: 'drink-1',
  occurredAt: DateTime.utc(2026),
  createdAt: DateTime.utc(2026),
  payload: const {'drinkName': 'Beer', 'revision': 1},
);

PartyEvent _questEvent(String id, String recipientUserId, int pointsUnits) =>
    PartyEvent(
      id: id,
      kind: PartyEventKind.socialQuest,
      recipientUserId: recipientUserId,
      participantIds: const ['a', 'b'],
      pointsUnits: pointsUnits,
      sourceCollection: PartyEventSourceCollection.quests,
      sourceId: 'quest-1',
      occurredAt: DateTime.utc(2026),
      createdAt: DateTime.utc(2026),
      payload: const {
        'pairKey': 'a__b',
        'allocationVersion': 1,
        'title': 'Find your match',
      },
    );

const _membersById = {
  'a': UserModel(
    id: 'a',
    email: 'alice@example.com',
    username: 'Alice',
    searchableUsername: 'alice',
  ),
  'b': UserModel(
    id: 'b',
    email: 'bob@example.com',
    username: 'Bob',
    searchableUsername: 'bob',
  ),
};
