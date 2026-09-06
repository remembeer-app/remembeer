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

  test('keeps quest recipient allocations separate and marks reversal', () {
    final questA = _event(
      'quest-a',
      kind: PartyEventKind.socialQuest,
      sourceId: 'quest-1',
      participantIds: const ['a', 'b'],
      payload: const {'pairKey': 'a__b', 'allocationVersion': 1},
    );
    final questB = _event(
      'quest-b',
      kind: PartyEventKind.socialQuest,
      sourceId: 'quest-1',
      recipientId: 'b',
      participantIds: const ['a', 'b'],
      payload: const {'pairKey': 'a__b', 'allocationVersion': 1},
    );
    final reversal = _event(
      'reversal-a',
      kind: PartyEventKind.reversal,
      sourceId: 'quest-1',
      reversesEventId: 'quest-a',
      points: -1000,
    );

    final groups = groupPartyEvents([reversal, questA, questB]);

    expect(groups, hasLength(3));
    expect(groups.first.events.single, reversal);
    expect(groups[1].events.single, questA);
    expect(groups[1].isReversed, isTrue);
    expect(groups.last.events.single, questB);
    expect(groups.last.isReversed, isFalse);
  });

  test('separates quest allocation versions for the same recipient', () {
    final first = _event(
      'quest-a-v1',
      kind: PartyEventKind.socialQuest,
      sourceId: 'quest-1',
      payload: const {'pairKey': 'a__b', 'allocationVersion': 1},
    );
    final second = _event(
      'quest-a-v2',
      kind: PartyEventKind.socialQuest,
      sourceId: 'quest-1',
      payload: const {'pairKey': 'a__b', 'allocationVersion': 2},
    );

    expect(groupPartyEvents([first, second]), hasLength(2));
  });

  test('keeps beerpong team member allocations separate', () {
    final first = _event(
      'placement-a',
      kind: PartyEventKind.beerpongPlacement,
      sourceId: 'tournament-1',
      participantIds: const ['a', 'b'],
      payload: const {
        'generation': 2,
        'teamId': 'team-1',
        'allocationVersion': 1,
      },
    );
    final second = _event(
      'placement-b',
      kind: PartyEventKind.beerpongPlacement,
      sourceId: 'tournament-1',
      recipientId: 'b',
      participantIds: const ['a', 'b'],
      payload: const {
        'generation': 2,
        'teamId': 'team-1',
        'allocationVersion': 1,
      },
    );

    final groups = groupPartyEvents([first, second]);

    expect(groups, hasLength(2));
    expect(groups.map((group) => group.events.single.recipientUserId), [
      'a',
      'b',
    ]);
  });

  test('still groups active shared challenge awards', () {
    final first = _event(
      'challenge-a',
      kind: PartyEventKind.adminChallenge,
      sourceId: 'challenge-1',
    );
    final second = _event(
      'challenge-b',
      kind: PartyEventKind.adminChallenge,
      sourceId: 'challenge-1',
      recipientId: 'b',
    );

    final groups = groupPartyEvents([first, second]);

    expect(groups, hasLength(1));
    expect(groups.single.events, [first, second]);
  });
}

PartyEvent _event(
  String id, {
  int minute = 0,
  PartyEventKind kind = PartyEventKind.drink,
  String sourceId = 'drink-1',
  String recipientId = 'a',
  List<String>? participantIds,
  String? reversesEventId,
  int points = 1000,
  Map<String, Object?> payload = const {},
}) => PartyEvent(
  id: id,
  kind: kind,
  recipientUserId: recipientId,
  participantIds: participantIds ?? [recipientId],
  pointsUnits: points,
  sourceCollection: switch (kind) {
    PartyEventKind.socialQuest => PartyEventSourceCollection.quests,
    PartyEventKind.adminChallenge => PartyEventSourceCollection.challenges,
    PartyEventKind.beerpongPlacement => PartyEventSourceCollection.tournaments,
    _ => PartyEventSourceCollection.drinks,
  },
  sourceId: sourceId,
  reversesEventId: reversesEventId,
  occurredAt: DateTime.utc(2026, 1, 1, 12, minute),
  createdAt: DateTime.utc(2026, 1, 1, 12, minute),
  payload: payload,
);
