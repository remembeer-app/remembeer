import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:remembeer/party/service/party_activity_service.dart';
import 'package:remembeer/party/widget/party_event_card.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
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
