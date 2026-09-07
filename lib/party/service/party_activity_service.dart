import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:remembeer/party/controller/party_event_controller.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:remembeer/party/model/party_event_page.dart';

@immutable
class PartyActivityFilters {
  const PartyActivityFilters({
    this.participantIds = const {},
    this.kinds = const {},
  });

  final Set<String> participantIds;
  final Set<PartyEventKind> kinds;

  bool get isEmpty => participantIds.isEmpty && kinds.isEmpty;

  PartyActivityFilters copyWith({
    Set<String>? participantIds,
    Set<PartyEventKind>? kinds,
  }) => PartyActivityFilters(
    participantIds: participantIds ?? this.participantIds,
    kinds: kinds ?? this.kinds,
  );

  @override
  bool operator ==(Object other) =>
      other is PartyActivityFilters &&
      setEquals(participantIds, other.participantIds) &&
      setEquals(kinds, other.kinds);

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(participantIds),
    Object.hashAllUnordered(kinds),
  );
}

@immutable
class PartyActivityState {
  const PartyActivityState({
    this.events = const [],
    this.filters = const PartyActivityFilters(),
    this.hasMore = false,
    this.isLoading = false,
    this.error,
  });

  final List<PartyEvent> events;
  final PartyActivityFilters filters;
  final bool hasMore;
  final bool isLoading;
  final Object? error;

  PartyActivityState copyWith({
    List<PartyEvent>? events,
    PartyActivityFilters? filters,
    bool? hasMore,
    bool? isLoading,
    Object? error,
    bool clearError = false,
  }) => PartyActivityState(
    events: events ?? this.events,
    filters: filters ?? this.filters,
    hasMore: hasMore ?? this.hasMore,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : error ?? this.error,
  );
}

typedef PartyEventPageFetcher =
    Future<PartyEventPage> Function({
      required String sessionId,
      required Set<PartyEventKind> kinds,
      required Set<String> participantIds,
      DocumentSnapshot<PartyEvent>? startAfter,
    });

class PartyActivityService extends ChangeNotifier {
  PartyActivityService({
    required this.sessionId,
    PartyEventController? eventController,
    PartyEventPageFetcher? fetchPage,
  }) : assert(
         eventController != null || fetchPage != null,
         'Provide an event controller or page fetcher.',
       ),
       _fetchPage = fetchPage ?? _controllerFetcher(eventController!);

  final String sessionId;
  final PartyEventPageFetcher _fetchPage;
  DocumentSnapshot<PartyEvent>? _cursor;
  var _requestVersion = 0;
  var _state = const PartyActivityState();

  PartyActivityState get state => _state;

  Future<void> loadInitial() => _load(replace: true);

  Future<void> setFilters(PartyActivityFilters filters) async {
    if (filters == _state.filters) {
      return;
    }
    _state = PartyActivityState(filters: filters);
    _cursor = null;
    notifyListeners();
    await _load(replace: true);
  }

  Future<void> loadMore() async {
    if (!_state.hasMore || _state.isLoading) {
      return;
    }
    await _load(replace: false);
  }

  Future<void> _load({required bool replace}) async {
    final requestVersion = ++_requestVersion;
    final filters = _state.filters;
    _state = _state.copyWith(isLoading: true, clearError: true);
    notifyListeners();
    try {
      final page = await _fetchPage(
        sessionId: sessionId,
        kinds: filters.kinds,
        participantIds: filters.participantIds,
        startAfter: replace ? null : _cursor,
      );
      if (requestVersion != _requestVersion) {
        return;
      }
      _cursor = page.cursor;
      _state = PartyActivityState(
        events: List.unmodifiable(
          replace ? page.events : [..._state.events, ...page.events],
        ),
        filters: filters,
        hasMore: page.hasMore,
      );
    } on Object catch (error) {
      if (requestVersion == _requestVersion) {
        _state = _state.copyWith(isLoading: false, error: error);
      }
    }
    notifyListeners();
  }
}

PartyEventPageFetcher _controllerFetcher(PartyEventController controller) {
  Future<PartyEventPage> fetch({
    required String sessionId,
    required Set<PartyEventKind> kinds,
    required Set<String> participantIds,
    DocumentSnapshot<PartyEvent>? startAfter,
  }) => controller.fetchEventPage(
    sessionId: sessionId,
    kinds: kinds,
    participantIds: participantIds,
    startAfter: startAfter,
  );

  return fetch;
}

@immutable
class PartyEventGroup {
  const PartyEventGroup({required this.events, required this.isReversed});

  final List<PartyEvent> events;
  final bool isReversed;
}

List<PartyEventGroup> groupPartyEvents(List<PartyEvent> events) {
  final reversedEventIds = events
      .where((event) => event.kind == PartyEventKind.reversal)
      .map((event) => event.reversesEventId)
      .whereType<String>()
      .toSet();
  final groups = <PartyEventGroup>[];
  final groupedIndexes = <String, int>{};
  for (final event in events) {
    final canGroup =
        event.kind != PartyEventKind.drink &&
        event.kind != PartyEventKind.reversal;
    final key =
        '${event.kind.name}:${event.sourceCollection.name}:${event.sourceId}';
    final existingIndex = canGroup ? groupedIndexes[key] : null;
    if (existingIndex != null) {
      final existing = groups[existingIndex];
      groups[existingIndex] = PartyEventGroup(
        events: [...existing.events, event],
        isReversed: existing.isReversed || reversedEventIds.contains(event.id),
      );
      continue;
    }
    if (canGroup) {
      groupedIndexes[key] = groups.length;
    }
    groups.add(
      PartyEventGroup(
        events: [event],
        isReversed: reversedEventIds.contains(event.id),
      ),
    );
  }
  return groups;
}
