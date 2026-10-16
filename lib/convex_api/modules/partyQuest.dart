// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class PartyQuestApi {
  const PartyQuestApi(this._client);

  final ConvexFunctionCaller _client;

  Future<PartyQuestDocument> getValue({required PartyQuestId id}) async {
    final raw$ = await _client.query(
      'partyQuest:get',
      _encodeGetTypeArgs((id: id)),
    );
    return _decodePartyQuestDocument(raw$);
  }

  TypedConvexSubscription<PartyQuestDocument> getValueSubscribe({
    required PartyQuestId id,
  }) {
    final subscription$ = _client.subscribe(
      'partyQuest:get',
      _encodeGetTypeArgs((id: id)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<PartyQuestDocument>(
            _decodePartyQuestDocument(value),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<PartyQuestDocument>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<PartyQuestDocument>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<PartyQuestDocument>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<GetTypeArgs, PartyQuestDocument> get getValueQuery =>
      getValueQueryReference;

  Future<List<PartyQuestDocument>> listForSession({
    required SessionId sessionId,
  }) async {
    final raw$ = await _client.query(
      'partyQuest:listForSession',
      _encodeListForSessionArgs((sessionId: sessionId)),
    );
    return expectList(
      raw$,
      label: 'ListForSessionResult',
    ).map((item) => _decodePartyQuestDocument(item)).toList();
  }

  TypedConvexSubscription<List<PartyQuestDocument>> listForSessionSubscribe({
    required SessionId sessionId,
  }) {
    final subscription$ = _client.subscribe(
      'partyQuest:listForSession',
      _encodeListForSessionArgs((sessionId: sessionId)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<PartyQuestDocument>>(
            expectList(
              value,
              label: 'ListForSessionResult',
            ).map((item) => _decodePartyQuestDocument(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<PartyQuestDocument>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<PartyQuestDocument>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<PartyQuestDocument>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<ListForSessionArgs, List<PartyQuestDocument>>
  get listForSessionQuery => listForSessionQueryReference;

  Future<bool> selectPartner({
    required PartyQuestId questId,
    required UserId selectedUserId,
  }) async {
    final raw$ = await _client.mutate(
      'partyQuest:selectPartner',
      _encodeSelectPartnerArgs((
        questId: questId,
        selectedUserId: selectedUserId,
      )),
    );
    return expectBool(raw$, label: 'SelectPartnerResult');
  }

  ConvexMutationReference<SelectPartnerArgs, bool> get selectPartnerMutation =>
      selectPartnerMutationReference;

  Future<Null> setEnabled({
    required bool enabled,
    required SessionId sessionId,
  }) async {
    await _client.mutate(
      'partyQuest:setEnabled',
      _encodeSetEnabledArgs((enabled: enabled, sessionId: sessionId)),
    );
    return null;
  }

  ConvexMutationReference<SetEnabledArgs, void> get setEnabledMutation =>
      setEnabledMutationReference;

  Future<Null> setSchedule({
    required double defaultDurationMinutes,
    required double maxIntervalMinutes,
    required double minIntervalMinutes,
    required SessionId sessionId,
  }) async {
    await _client.mutate(
      'partyQuest:setSchedule',
      _encodeSetScheduleArgs((
        defaultDurationMinutes: defaultDurationMinutes,
        maxIntervalMinutes: maxIntervalMinutes,
        minIntervalMinutes: minIntervalMinutes,
        sessionId: sessionId,
      )),
    );
    return null;
  }

  ConvexMutationReference<SetScheduleArgs, void> get setScheduleMutation =>
      setScheduleMutationReference;

  Future<PartyQuestId> startNext({required SessionId sessionId}) async {
    final raw$ = await _client.mutate(
      'partyQuest:startNext',
      _encodeStartNextArgs((sessionId: sessionId)),
    );
    return PartyQuestId(expectString(raw$, label: 'StartNextResult'));
  }

  ConvexMutationReference<StartNextArgs, PartyQuestId> get startNextMutation =>
      startNextMutationReference;
}

Map<String, dynamic> _encodePartyQuestDocumentSelectionsItem(
  PartyQuestDocumentSelectionsItem value$,
) {
  final (
    userId: userId,
    selectedUserId: selectedUserId,
    selectedAt: selectedAt,
  ) = value$;
  return <String, dynamic>{
    'userId': userId.value,
    'selectedUserId': selectedUserId.value,
    'selectedAt': selectedAt,
  };
}

PartyQuestDocumentSelectionsItem _decodePartyQuestDocumentSelectionsItem(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'PartyQuestDocumentSelectionsItem');
  if (!map.containsKey('userId')) {
    throw FormatException(
      'Missing required field "userId" for PartyQuestDocumentSelectionsItem',
    );
  }
  if (!map.containsKey('selectedUserId')) {
    throw FormatException(
      'Missing required field "selectedUserId" for PartyQuestDocumentSelectionsItem',
    );
  }
  if (!map.containsKey('selectedAt')) {
    throw FormatException(
      'Missing required field "selectedAt" for PartyQuestDocumentSelectionsItem',
    );
  }
  return (
    userId: UserId(
      expectString(
        map['userId'],
        label: 'PartyQuestDocumentSelectionsItemUserId',
      ),
    ),
    selectedUserId: UserId(
      expectString(
        map['selectedUserId'],
        label: 'PartyQuestDocumentSelectionsItemSelectedUserId',
      ),
    ),
    selectedAt: expectDouble(
      map['selectedAt'],
      label: 'PartyQuestDocumentSelectionsItemSelectedAt',
    ),
  );
}

Map<String, dynamic> _encodePartyQuestDocumentResultsItem(
  PartyQuestDocumentResultsItem value$,
) {
  final (
    firstUserId: firstUserId,
    secondUserId: secondUserId,
    completedAt: completedAt,
  ) = value$;
  return <String, dynamic>{
    'firstUserId': firstUserId.value,
    'secondUserId': secondUserId.value,
    'completedAt': completedAt,
  };
}

PartyQuestDocumentResultsItem _decodePartyQuestDocumentResultsItem(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'PartyQuestDocumentResultsItem');
  if (!map.containsKey('firstUserId')) {
    throw FormatException(
      'Missing required field "firstUserId" for PartyQuestDocumentResultsItem',
    );
  }
  if (!map.containsKey('secondUserId')) {
    throw FormatException(
      'Missing required field "secondUserId" for PartyQuestDocumentResultsItem',
    );
  }
  if (!map.containsKey('completedAt')) {
    throw FormatException(
      'Missing required field "completedAt" for PartyQuestDocumentResultsItem',
    );
  }
  return (
    firstUserId: UserId(
      expectString(
        map['firstUserId'],
        label: 'PartyQuestDocumentResultsItemFirstUserId',
      ),
    ),
    secondUserId: UserId(
      expectString(
        map['secondUserId'],
        label: 'PartyQuestDocumentResultsItemSecondUserId',
      ),
    ),
    completedAt: expectDouble(
      map['completedAt'],
      label: 'PartyQuestDocumentResultsItemCompletedAt',
    ),
  );
}

Map<String, dynamic> _encodeDrinkCategory(DrinkCategory value) {
  switch (value) {
    case Beer():
      return <String, dynamic>{'kind': 'beer'};
    case Cider():
      return <String, dynamic>{'kind': 'cider'};
    case Cocktail():
      return <String, dynamic>{'kind': 'cocktail'};
    case Spirit():
      return <String, dynamic>{'kind': 'spirit'};
    case Wine():
      return <String, dynamic>{'kind': 'wine'};
  }
}

DrinkCategory _decodeDrinkCategory(dynamic raw) {
  final map = expectMap(raw, label: 'DrinkCategory');
  if (!map.containsKey('kind')) {
    throw FormatException('Missing discriminator "kind" for DrinkCategory');
  }
  final discriminator = expectString(map['kind'], label: 'DrinkCategoryKind');
  switch (discriminator) {
    case 'beer':
      return const Beer();
    case 'cider':
      return const Cider();
    case 'cocktail':
      return const Cocktail();
    case 'spirit':
      return const Spirit();
    case 'wine':
      return const Wine();
    default:
      throw FormatException(
        'Unknown DrinkCategory discriminator: $discriminator',
      );
  }
}

Map<String, dynamic> _encodePartyQuestDocument(PartyQuestDocument value) {
  switch (value) {
    case ToastWithClass(
      drinkCategory: final drinkCategory,
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'toastWithClass',
        'drinkCategory': _encodeDrinkCategory(drinkCategory),
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case SameAccent(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'sameAccent',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case DifferentAccent(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'differentAccent',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case NewAlly(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'newAlly',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case SameClass(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'sameClass',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case DifferentClass(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'differentClass',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case BottomQuarter(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'bottomQuarter',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case Leader(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'leader',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case TopThree(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'topThree',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case OppositeRankingHalves(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'oppositeRankingHalves',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case NearbyRank(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'nearbyRank',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case DifferentBeerpongTeam(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'differentBeerpongTeam',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case SameBeerpongTeam(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'sameBeerpongTeam',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case FinalistTeam(
      sessionId: final sessionId,
      title: final title,
      instructions: final instructions,
      pointsUnits: final pointsUnits,
      startsAt: final startsAt,
      endsAt: final endsAt,
      status: final status,
      selections: final selections,
      results: final results,
      updatedAt: final updatedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'finalistTeam',
        'sessionId': sessionId.value,
        'title': title,
        'instructions': instructions,
        'pointsUnits': pointsUnits,
        'startsAt': startsAt,
        'endsAt': endsAt,
        'status': status.value,
        'selections': selections
            .map((item) => _encodePartyQuestDocumentSelectionsItem(item))
            .toList(),
        'results': results
            .map((item) => _encodePartyQuestDocumentResultsItem(item))
            .toList(),
        'updatedAt': updatedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
  }
}

PartyQuestDocument _decodePartyQuestDocument(dynamic raw) {
  final map = expectMap(raw, label: 'PartyQuestDocument');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing discriminator "kind" for PartyQuestDocument',
    );
  }
  final discriminator = expectString(
    map['kind'],
    label: 'PartyQuestDocumentKind',
  );
  switch (discriminator) {
    case 'toastWithClass':
      if (!map.containsKey('drinkCategory')) {
        throw FormatException(
          'Missing required field "drinkCategory" for ToastWithClass',
        );
      }
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for ToastWithClass',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException(
          'Missing required field "title" for ToastWithClass',
        );
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for ToastWithClass',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for ToastWithClass',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException(
          'Missing required field "startsAt" for ToastWithClass',
        );
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException(
          'Missing required field "endsAt" for ToastWithClass',
        );
      }
      if (!map.containsKey('status')) {
        throw FormatException(
          'Missing required field "status" for ToastWithClass',
        );
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for ToastWithClass',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException(
          'Missing required field "results" for ToastWithClass',
        );
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for ToastWithClass',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException(
          'Missing required field "_id" for ToastWithClass',
        );
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for ToastWithClass',
        );
      }
      return ToastWithClass(
        drinkCategory: _decodeDrinkCategory(map['drinkCategory']),
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'sameAccent':
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for SameAccent',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException('Missing required field "title" for SameAccent');
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for SameAccent',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for SameAccent',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException(
          'Missing required field "startsAt" for SameAccent',
        );
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException('Missing required field "endsAt" for SameAccent');
      }
      if (!map.containsKey('status')) {
        throw FormatException('Missing required field "status" for SameAccent');
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for SameAccent',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException(
          'Missing required field "results" for SameAccent',
        );
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for SameAccent',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for SameAccent');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for SameAccent',
        );
      }
      return SameAccent(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'differentAccent':
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for DifferentAccent',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException(
          'Missing required field "title" for DifferentAccent',
        );
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for DifferentAccent',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for DifferentAccent',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException(
          'Missing required field "startsAt" for DifferentAccent',
        );
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException(
          'Missing required field "endsAt" for DifferentAccent',
        );
      }
      if (!map.containsKey('status')) {
        throw FormatException(
          'Missing required field "status" for DifferentAccent',
        );
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for DifferentAccent',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException(
          'Missing required field "results" for DifferentAccent',
        );
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for DifferentAccent',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException(
          'Missing required field "_id" for DifferentAccent',
        );
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for DifferentAccent',
        );
      }
      return DifferentAccent(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'newAlly':
      if (!map.containsKey('sessionId')) {
        throw FormatException('Missing required field "sessionId" for NewAlly');
      }
      if (!map.containsKey('title')) {
        throw FormatException('Missing required field "title" for NewAlly');
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for NewAlly',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for NewAlly',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException('Missing required field "startsAt" for NewAlly');
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException('Missing required field "endsAt" for NewAlly');
      }
      if (!map.containsKey('status')) {
        throw FormatException('Missing required field "status" for NewAlly');
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for NewAlly',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException('Missing required field "results" for NewAlly');
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException('Missing required field "updatedAt" for NewAlly');
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for NewAlly');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for NewAlly',
        );
      }
      return NewAlly(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'sameClass':
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for SameClass',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException('Missing required field "title" for SameClass');
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for SameClass',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for SameClass',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException(
          'Missing required field "startsAt" for SameClass',
        );
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException('Missing required field "endsAt" for SameClass');
      }
      if (!map.containsKey('status')) {
        throw FormatException('Missing required field "status" for SameClass');
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for SameClass',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException('Missing required field "results" for SameClass');
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for SameClass',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for SameClass');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for SameClass',
        );
      }
      return SameClass(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'differentClass':
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for DifferentClass',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException(
          'Missing required field "title" for DifferentClass',
        );
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for DifferentClass',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for DifferentClass',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException(
          'Missing required field "startsAt" for DifferentClass',
        );
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException(
          'Missing required field "endsAt" for DifferentClass',
        );
      }
      if (!map.containsKey('status')) {
        throw FormatException(
          'Missing required field "status" for DifferentClass',
        );
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for DifferentClass',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException(
          'Missing required field "results" for DifferentClass',
        );
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for DifferentClass',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException(
          'Missing required field "_id" for DifferentClass',
        );
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for DifferentClass',
        );
      }
      return DifferentClass(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'bottomQuarter':
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for BottomQuarter',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException(
          'Missing required field "title" for BottomQuarter',
        );
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for BottomQuarter',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for BottomQuarter',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException(
          'Missing required field "startsAt" for BottomQuarter',
        );
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException(
          'Missing required field "endsAt" for BottomQuarter',
        );
      }
      if (!map.containsKey('status')) {
        throw FormatException(
          'Missing required field "status" for BottomQuarter',
        );
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for BottomQuarter',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException(
          'Missing required field "results" for BottomQuarter',
        );
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for BottomQuarter',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for BottomQuarter');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for BottomQuarter',
        );
      }
      return BottomQuarter(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'leader':
      if (!map.containsKey('sessionId')) {
        throw FormatException('Missing required field "sessionId" for Leader');
      }
      if (!map.containsKey('title')) {
        throw FormatException('Missing required field "title" for Leader');
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for Leader',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for Leader',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException('Missing required field "startsAt" for Leader');
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException('Missing required field "endsAt" for Leader');
      }
      if (!map.containsKey('status')) {
        throw FormatException('Missing required field "status" for Leader');
      }
      if (!map.containsKey('selections')) {
        throw FormatException('Missing required field "selections" for Leader');
      }
      if (!map.containsKey('results')) {
        throw FormatException('Missing required field "results" for Leader');
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException('Missing required field "updatedAt" for Leader');
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for Leader');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for Leader',
        );
      }
      return Leader(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'topThree':
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for TopThree',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException('Missing required field "title" for TopThree');
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for TopThree',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for TopThree',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException('Missing required field "startsAt" for TopThree');
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException('Missing required field "endsAt" for TopThree');
      }
      if (!map.containsKey('status')) {
        throw FormatException('Missing required field "status" for TopThree');
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for TopThree',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException('Missing required field "results" for TopThree');
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for TopThree',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for TopThree');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for TopThree',
        );
      }
      return TopThree(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'oppositeRankingHalves':
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for OppositeRankingHalves',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException(
          'Missing required field "title" for OppositeRankingHalves',
        );
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for OppositeRankingHalves',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for OppositeRankingHalves',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException(
          'Missing required field "startsAt" for OppositeRankingHalves',
        );
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException(
          'Missing required field "endsAt" for OppositeRankingHalves',
        );
      }
      if (!map.containsKey('status')) {
        throw FormatException(
          'Missing required field "status" for OppositeRankingHalves',
        );
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for OppositeRankingHalves',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException(
          'Missing required field "results" for OppositeRankingHalves',
        );
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for OppositeRankingHalves',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException(
          'Missing required field "_id" for OppositeRankingHalves',
        );
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for OppositeRankingHalves',
        );
      }
      return OppositeRankingHalves(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'nearbyRank':
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for NearbyRank',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException('Missing required field "title" for NearbyRank');
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for NearbyRank',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for NearbyRank',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException(
          'Missing required field "startsAt" for NearbyRank',
        );
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException('Missing required field "endsAt" for NearbyRank');
      }
      if (!map.containsKey('status')) {
        throw FormatException('Missing required field "status" for NearbyRank');
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for NearbyRank',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException(
          'Missing required field "results" for NearbyRank',
        );
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for NearbyRank',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for NearbyRank');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for NearbyRank',
        );
      }
      return NearbyRank(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'differentBeerpongTeam':
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for DifferentBeerpongTeam',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException(
          'Missing required field "title" for DifferentBeerpongTeam',
        );
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for DifferentBeerpongTeam',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for DifferentBeerpongTeam',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException(
          'Missing required field "startsAt" for DifferentBeerpongTeam',
        );
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException(
          'Missing required field "endsAt" for DifferentBeerpongTeam',
        );
      }
      if (!map.containsKey('status')) {
        throw FormatException(
          'Missing required field "status" for DifferentBeerpongTeam',
        );
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for DifferentBeerpongTeam',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException(
          'Missing required field "results" for DifferentBeerpongTeam',
        );
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for DifferentBeerpongTeam',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException(
          'Missing required field "_id" for DifferentBeerpongTeam',
        );
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for DifferentBeerpongTeam',
        );
      }
      return DifferentBeerpongTeam(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'sameBeerpongTeam':
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for SameBeerpongTeam',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException(
          'Missing required field "title" for SameBeerpongTeam',
        );
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for SameBeerpongTeam',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for SameBeerpongTeam',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException(
          'Missing required field "startsAt" for SameBeerpongTeam',
        );
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException(
          'Missing required field "endsAt" for SameBeerpongTeam',
        );
      }
      if (!map.containsKey('status')) {
        throw FormatException(
          'Missing required field "status" for SameBeerpongTeam',
        );
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for SameBeerpongTeam',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException(
          'Missing required field "results" for SameBeerpongTeam',
        );
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for SameBeerpongTeam',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException(
          'Missing required field "_id" for SameBeerpongTeam',
        );
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for SameBeerpongTeam',
        );
      }
      return SameBeerpongTeam(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    case 'finalistTeam':
      if (!map.containsKey('sessionId')) {
        throw FormatException(
          'Missing required field "sessionId" for FinalistTeam',
        );
      }
      if (!map.containsKey('title')) {
        throw FormatException(
          'Missing required field "title" for FinalistTeam',
        );
      }
      if (!map.containsKey('instructions')) {
        throw FormatException(
          'Missing required field "instructions" for FinalistTeam',
        );
      }
      if (!map.containsKey('pointsUnits')) {
        throw FormatException(
          'Missing required field "pointsUnits" for FinalistTeam',
        );
      }
      if (!map.containsKey('startsAt')) {
        throw FormatException(
          'Missing required field "startsAt" for FinalistTeam',
        );
      }
      if (!map.containsKey('endsAt')) {
        throw FormatException(
          'Missing required field "endsAt" for FinalistTeam',
        );
      }
      if (!map.containsKey('status')) {
        throw FormatException(
          'Missing required field "status" for FinalistTeam',
        );
      }
      if (!map.containsKey('selections')) {
        throw FormatException(
          'Missing required field "selections" for FinalistTeam',
        );
      }
      if (!map.containsKey('results')) {
        throw FormatException(
          'Missing required field "results" for FinalistTeam',
        );
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException(
          'Missing required field "updatedAt" for FinalistTeam',
        );
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for FinalistTeam');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for FinalistTeam',
        );
      }
      return FinalistTeam(
        sessionId: SessionId(
          expectString(map['sessionId'], label: 'PartyQuestDocumentSessionId'),
        ),
        title: expectString(map['title'], label: 'PartyQuestDocumentTitle'),
        instructions: expectString(
          map['instructions'],
          label: 'PartyQuestDocumentInstructions',
        ),
        pointsUnits: expectDouble(
          map['pointsUnits'],
          label: 'PartyQuestDocumentPointsUnits',
        ),
        startsAt: expectDouble(
          map['startsAt'],
          label: 'PartyQuestDocumentStartsAt',
        ),
        endsAt: expectDouble(map['endsAt'], label: 'PartyQuestDocumentEndsAt'),
        status: PartyQuestDocumentStatus.fromJson(map['status']),
        selections: expectList(
          map['selections'],
          label: 'PartyQuestDocumentSelections',
        ).map((item) => _decodePartyQuestDocumentSelectionsItem(item)).toList(),
        results: expectList(
          map['results'],
          label: 'PartyQuestDocumentResults',
        ).map((item) => _decodePartyQuestDocumentResultsItem(item)).toList(),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'PartyQuestDocumentUpdatedAt',
        ),
        id: PartyQuestId(
          expectString(map['_id'], label: 'PartyQuestDocumentId'),
        ),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyQuestDocumentCreationTime',
        ),
      );
    default:
      throw FormatException(
        'Unknown PartyQuestDocument discriminator: $discriminator',
      );
  }
}

typedef GetTypeArgs = ({PartyQuestId id});

Map<String, dynamic> _encodeGetTypeArgs(GetTypeArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

GetTypeArgs _decodeGetTypeArgs(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for GetTypeArgs');
  }
  return (id: PartyQuestId(expectString(map['id'], label: 'GetTypeArgsId')));
}

typedef ListForSessionArgs = ({SessionId sessionId});

Map<String, dynamic> _encodeListForSessionArgs(ListForSessionArgs value$) {
  final (sessionId: sessionId) = value$;
  return <String, dynamic>{'sessionId': sessionId.value};
}

ListForSessionArgs _decodeListForSessionArgs(dynamic raw) {
  final map = expectMap(raw, label: 'ListForSessionArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for ListForSessionArgs',
    );
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'ListForSessionArgsSessionId'),
    ),
  );
}

typedef SelectPartnerArgs = ({PartyQuestId questId, UserId selectedUserId});

Map<String, dynamic> _encodeSelectPartnerArgs(SelectPartnerArgs value$) {
  final (questId: questId, selectedUserId: selectedUserId) = value$;
  return <String, dynamic>{
    'questId': questId.value,
    'selectedUserId': selectedUserId.value,
  };
}

SelectPartnerArgs _decodeSelectPartnerArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SelectPartnerArgs');
  if (!map.containsKey('questId')) {
    throw FormatException(
      'Missing required field "questId" for SelectPartnerArgs',
    );
  }
  if (!map.containsKey('selectedUserId')) {
    throw FormatException(
      'Missing required field "selectedUserId" for SelectPartnerArgs',
    );
  }
  return (
    questId: PartyQuestId(
      expectString(map['questId'], label: 'SelectPartnerArgsQuestId'),
    ),
    selectedUserId: UserId(
      expectString(
        map['selectedUserId'],
        label: 'SelectPartnerArgsSelectedUserId',
      ),
    ),
  );
}

typedef SetEnabledArgs = ({bool enabled, SessionId sessionId});

Map<String, dynamic> _encodeSetEnabledArgs(SetEnabledArgs value$) {
  final (enabled: enabled, sessionId: sessionId) = value$;
  return <String, dynamic>{'enabled': enabled, 'sessionId': sessionId.value};
}

SetEnabledArgs _decodeSetEnabledArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SetEnabledArgs');
  if (!map.containsKey('enabled')) {
    throw FormatException(
      'Missing required field "enabled" for SetEnabledArgs',
    );
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for SetEnabledArgs',
    );
  }
  return (
    enabled: expectBool(map['enabled'], label: 'SetEnabledArgsEnabled'),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'SetEnabledArgsSessionId'),
    ),
  );
}

typedef SetScheduleArgs = ({
  double defaultDurationMinutes,
  double maxIntervalMinutes,
  double minIntervalMinutes,
  SessionId sessionId,
});

Map<String, dynamic> _encodeSetScheduleArgs(SetScheduleArgs value$) {
  final (
    defaultDurationMinutes: defaultDurationMinutes,
    maxIntervalMinutes: maxIntervalMinutes,
    minIntervalMinutes: minIntervalMinutes,
    sessionId: sessionId,
  ) = value$;
  return <String, dynamic>{
    'defaultDurationMinutes': defaultDurationMinutes,
    'maxIntervalMinutes': maxIntervalMinutes,
    'minIntervalMinutes': minIntervalMinutes,
    'sessionId': sessionId.value,
  };
}

SetScheduleArgs _decodeSetScheduleArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SetScheduleArgs');
  if (!map.containsKey('defaultDurationMinutes')) {
    throw FormatException(
      'Missing required field "defaultDurationMinutes" for SetScheduleArgs',
    );
  }
  if (!map.containsKey('maxIntervalMinutes')) {
    throw FormatException(
      'Missing required field "maxIntervalMinutes" for SetScheduleArgs',
    );
  }
  if (!map.containsKey('minIntervalMinutes')) {
    throw FormatException(
      'Missing required field "minIntervalMinutes" for SetScheduleArgs',
    );
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for SetScheduleArgs',
    );
  }
  return (
    defaultDurationMinutes: expectDouble(
      map['defaultDurationMinutes'],
      label: 'SetScheduleArgsDefaultDurationMinutes',
    ),
    maxIntervalMinutes: expectDouble(
      map['maxIntervalMinutes'],
      label: 'SetScheduleArgsMaxIntervalMinutes',
    ),
    minIntervalMinutes: expectDouble(
      map['minIntervalMinutes'],
      label: 'SetScheduleArgsMinIntervalMinutes',
    ),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'SetScheduleArgsSessionId'),
    ),
  );
}

typedef StartNextArgs = ({SessionId sessionId});

Map<String, dynamic> _encodeStartNextArgs(StartNextArgs value$) {
  final (sessionId: sessionId) = value$;
  return <String, dynamic>{'sessionId': sessionId.value};
}

StartNextArgs _decodeStartNextArgs(dynamic raw) {
  final map = expectMap(raw, label: 'StartNextArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for StartNextArgs',
    );
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'StartNextArgsSessionId'),
    ),
  );
}

final ConvexQueryReference<GetTypeArgs, PartyQuestDocument>
getValueQueryReference = ConvexQueryReference(
  name: 'partyQuest:get',
  encode: (args) => _encodeGetTypeArgs(args),
  decodeArgs: (raw) => _decodeGetTypeArgs(raw),
  decode: (raw) => _decodePartyQuestDocument(raw),
  encodeResult: (value) => _encodePartyQuestDocument(value),
);

final ConvexQueryReference<ListForSessionArgs, List<PartyQuestDocument>>
listForSessionQueryReference = ConvexQueryReference(
  name: 'partyQuest:listForSession',
  encode: (args) => _encodeListForSessionArgs(args),
  decodeArgs: (raw) => _decodeListForSessionArgs(raw),
  decode: (raw) => expectList(
    raw,
    label: 'ListForSessionResult',
  ).map((item) => _decodePartyQuestDocument(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodePartyQuestDocument(item)).toList(),
);

final ConvexMutationReference<SelectPartnerArgs, bool>
selectPartnerMutationReference = ConvexMutationReference(
  name: 'partyQuest:selectPartner',
  encode: (args) => _encodeSelectPartnerArgs(args),
  decode: (raw) => expectBool(raw, label: 'SelectPartnerResult'),
);

final ConvexMutationReference<SetEnabledArgs, void>
setEnabledMutationReference = ConvexMutationReference(
  name: 'partyQuest:setEnabled',
  encode: (args) => _encodeSetEnabledArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<SetScheduleArgs, void>
setScheduleMutationReference = ConvexMutationReference(
  name: 'partyQuest:setSchedule',
  encode: (args) => _encodeSetScheduleArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<StartNextArgs, PartyQuestId>
startNextMutationReference = ConvexMutationReference(
  name: 'partyQuest:startNext',
  encode: (args) => _encodeStartNextArgs(args),
  decode: (raw) => PartyQuestId(expectString(raw, label: 'StartNextResult')),
);
