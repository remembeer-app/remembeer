import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:remembeer/party/model/party_event_page.dart';
import 'package:remembeer/party/service/party_activity_service.dart';

void main() {
  test('paginates newest-first pages without replacing prior events', () async {
    final requests = <Set<String>>[];
    var call = 0;
    final service = PartyActivityService(
      sessionId: 'party-1',
      fetchPage:
          ({
            required sessionId,
            required kinds,
            required participantIds,
            startAfter,
          }) async {
            requests.add(participantIds);
            call += 1;
            return PartyEventPage(
              events: [_event('event-$call', minute: 3 - call)],
              hasMore: call == 1,
            );
          },
    );

    await service.loadInitial();
    await service.loadMore();

    expect(service.state.events.map((event) => event.id), [
      'event-1',
      'event-2',
    ]);
    expect(service.state.hasMore, isFalse);
    expect(requests, hasLength(2));
  });

  test('filters forward OR selections in both ANDed categories', () async {
    Set<String>? people;
    Set<PartyEventKind>? selectedKinds;
    final service = PartyActivityService(
      sessionId: 'party-1',
      fetchPage:
          ({
            required sessionId,
            required kinds,
            required participantIds,
            startAfter,
          }) async {
            people = participantIds;
            selectedKinds = kinds;
            return const PartyEventPage(events: [], hasMore: false);
          },
    );
    const filters = PartyActivityFilters(
      participantIds: {'a', 'b'},
      kinds: {PartyEventKind.drink, PartyEventKind.socialQuest},
    );

    await service.setFilters(filters);

    expect(people, {'a', 'b'});
    expect(selectedKinds, {PartyEventKind.drink, PartyEventKind.socialQuest});
    expect(service.state.filters, filters);
  });

  test('groups shared outcomes and marks original awards reversed', () {
    final questA = _event(
      'quest-a',
      kind: PartyEventKind.socialQuest,
      sourceId: 'quest-1',
    );
    final questB = _event(
      'quest-b',
      kind: PartyEventKind.socialQuest,
      sourceId: 'quest-1',
      recipientId: 'b',
    );
    final reversal = _event(
      'reversal-a',
      kind: PartyEventKind.reversal,
      sourceId: 'quest-1',
      reversesEventId: 'quest-a',
      points: -1000,
    );

    final groups = groupPartyEvents([reversal, questA, questB]);

    expect(groups, hasLength(2));
    expect(groups.first.events.single, reversal);
    expect(groups.last.events, [questA, questB]);
    expect(groups.last.isReversed, isTrue);
  });
}

PartyEvent _event(
  String id, {
  int minute = 0,
  PartyEventKind kind = PartyEventKind.drink,
  String sourceId = 'drink-1',
  String recipientId = 'a',
  String? reversesEventId,
  int points = 1000,
}) => PartyEvent(
  id: id,
  kind: kind,
  recipientUserId: recipientId,
  participantIds: [recipientId],
  pointsUnits: points,
  sourceCollection: kind == PartyEventKind.socialQuest
      ? PartyEventSourceCollection.quests
      : PartyEventSourceCollection.drinks,
  sourceId: sourceId,
  reversesEventId: reversesEventId,
  occurredAt: DateTime.utc(2026, 1, 1, 12, minute),
  createdAt: DateTime.utc(2026, 1, 1, 12, minute),
);
