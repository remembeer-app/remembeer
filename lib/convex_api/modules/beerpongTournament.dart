// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class BeerpongTournamentApi {
  const BeerpongTournamentApi(this._client);

  final ConvexFunctionCaller _client;

  Future<BeerpongTournamentId> create({
    required double firstPlacePointsUnits,
    required String name,
    required double secondPlacePointsUnits,
    required SessionId sessionId,
    required double teamCount,
    required bool thirdPlaceEnabled,
    required double thirdPlacePointsUnits,
  }) async {
    final raw$ = await _client.mutate(
      'beerpongTournament:create',
      _encodeCreateArgs((
        firstPlacePointsUnits: firstPlacePointsUnits,
        name: name,
        secondPlacePointsUnits: secondPlacePointsUnits,
        sessionId: sessionId,
        teamCount: teamCount,
        thirdPlaceEnabled: thirdPlaceEnabled,
        thirdPlacePointsUnits: thirdPlacePointsUnits,
      )),
    );
    return BeerpongTournamentId(expectString(raw$, label: 'CreateResult'));
  }

  ConvexMutationReference<CreateArgs, BeerpongTournamentId>
  get createMutation => createMutationReference;

  Future<Null> draw({required BeerpongTournamentId id}) async {
    await _client.mutate('beerpongTournament:draw', _encodeDrawArgs((id: id)));
    return null;
  }

  ConvexMutationReference<DrawArgs, void> get drawMutation =>
      drawMutationReference;

  Future<Null> finalize({required BeerpongTournamentId id}) async {
    await _client.mutate(
      'beerpongTournament:finalize',
      _encodeFinalizeArgs((id: id)),
    );
    return null;
  }

  ConvexMutationReference<FinalizeArgs, void> get finalizeMutation =>
      finalizeMutationReference;

  Future<GetTypeResult> getValue({required BeerpongTournamentId id}) async {
    final raw$ = await _client.query(
      'beerpongTournament:get',
      _encodeGetTypeArgs((id: id)),
    );
    return _decodeGetTypeResult(raw$);
  }

  TypedConvexSubscription<GetTypeResult> getValueSubscribe({
    required BeerpongTournamentId id,
  }) {
    final subscription$ = _client.subscribe(
      'beerpongTournament:get',
      _encodeGetTypeArgs((id: id)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<GetTypeResult>(_decodeGetTypeResult(value));
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<GetTypeResult>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<GetTypeResult>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<GetTypeResult>(subscription$, typedStream$);
  }

  ConvexQueryReference<GetTypeArgs, GetTypeResult> get getValueQuery =>
      getValueQueryReference;

  Future<List<BeerpongTournamentDocument>> listForSession({
    required SessionId sessionId,
  }) async {
    final raw$ = await _client.query(
      'beerpongTournament:listForSession',
      _encodeListForSessionArgs((sessionId: sessionId)),
    );
    return expectList(
      raw$,
      label: 'ListForSessionResult',
    ).map((item) => _decodeBeerpongTournamentDocument(item)).toList();
  }

  TypedConvexSubscription<List<BeerpongTournamentDocument>>
  listForSessionSubscribe({required SessionId sessionId}) {
    final subscription$ = _client.subscribe(
      'beerpongTournament:listForSession',
      _encodeListForSessionArgs((sessionId: sessionId)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<BeerpongTournamentDocument>>(
            expectList(
              value,
              label: 'ListForSessionResult',
            ).map((item) => _decodeBeerpongTournamentDocument(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<BeerpongTournamentDocument>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<BeerpongTournamentDocument>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<BeerpongTournamentDocument>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<ListForSessionArgs, List<BeerpongTournamentDocument>>
  get listForSessionQuery => listForSessionQueryReference;

  Future<Null> start({required BeerpongTournamentId id}) async {
    await _client.mutate(
      'beerpongTournament:start',
      _encodeStartArgs((id: id)),
    );
    return null;
  }

  ConvexMutationReference<StartArgs, void> get startMutation =>
      startMutationReference;
}

typedef CreateArgs = ({
  double firstPlacePointsUnits,
  String name,
  double secondPlacePointsUnits,
  SessionId sessionId,
  double teamCount,
  bool thirdPlaceEnabled,
  double thirdPlacePointsUnits,
});

Map<String, dynamic> _encodeCreateArgs(CreateArgs value$) {
  final (
    firstPlacePointsUnits: firstPlacePointsUnits,
    name: name,
    secondPlacePointsUnits: secondPlacePointsUnits,
    sessionId: sessionId,
    teamCount: teamCount,
    thirdPlaceEnabled: thirdPlaceEnabled,
    thirdPlacePointsUnits: thirdPlacePointsUnits,
  ) = value$;
  return <String, dynamic>{
    'firstPlacePointsUnits': firstPlacePointsUnits,
    'name': name,
    'secondPlacePointsUnits': secondPlacePointsUnits,
    'sessionId': sessionId.value,
    'teamCount': teamCount,
    'thirdPlaceEnabled': thirdPlaceEnabled,
    'thirdPlacePointsUnits': thirdPlacePointsUnits,
  };
}

CreateArgs _decodeCreateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgs');
  if (!map.containsKey('firstPlacePointsUnits')) {
    throw FormatException(
      'Missing required field "firstPlacePointsUnits" for CreateArgs',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException('Missing required field "name" for CreateArgs');
  }
  if (!map.containsKey('secondPlacePointsUnits')) {
    throw FormatException(
      'Missing required field "secondPlacePointsUnits" for CreateArgs',
    );
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for CreateArgs');
  }
  if (!map.containsKey('teamCount')) {
    throw FormatException('Missing required field "teamCount" for CreateArgs');
  }
  if (!map.containsKey('thirdPlaceEnabled')) {
    throw FormatException(
      'Missing required field "thirdPlaceEnabled" for CreateArgs',
    );
  }
  if (!map.containsKey('thirdPlacePointsUnits')) {
    throw FormatException(
      'Missing required field "thirdPlacePointsUnits" for CreateArgs',
    );
  }
  return (
    firstPlacePointsUnits: expectDouble(
      map['firstPlacePointsUnits'],
      label: 'CreateArgsFirstPlacePointsUnits',
    ),
    name: expectString(map['name'], label: 'CreateArgsName'),
    secondPlacePointsUnits: expectDouble(
      map['secondPlacePointsUnits'],
      label: 'CreateArgsSecondPlacePointsUnits',
    ),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'CreateArgsSessionId'),
    ),
    teamCount: expectDouble(map['teamCount'], label: 'CreateArgsTeamCount'),
    thirdPlaceEnabled: expectBool(
      map['thirdPlaceEnabled'],
      label: 'CreateArgsThirdPlaceEnabled',
    ),
    thirdPlacePointsUnits: expectDouble(
      map['thirdPlacePointsUnits'],
      label: 'CreateArgsThirdPlacePointsUnits',
    ),
  );
}

typedef DrawArgs = ({BeerpongTournamentId id});

Map<String, dynamic> _encodeDrawArgs(DrawArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

DrawArgs _decodeDrawArgs(dynamic raw) {
  final map = expectMap(raw, label: 'DrawArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for DrawArgs');
  }
  return (
    id: BeerpongTournamentId(expectString(map['id'], label: 'DrawArgsId')),
  );
}

typedef FinalizeArgs = ({BeerpongTournamentId id});

Map<String, dynamic> _encodeFinalizeArgs(FinalizeArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

FinalizeArgs _decodeFinalizeArgs(dynamic raw) {
  final map = expectMap(raw, label: 'FinalizeArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for FinalizeArgs');
  }
  return (
    id: BeerpongTournamentId(expectString(map['id'], label: 'FinalizeArgsId')),
  );
}

enum GetTypeResultMatchesItemKind {
  mainValue('main'),
  thirdPlaceValue('thirdPlace');

  const GetTypeResultMatchesItemKind(this.value);
  final Object? value;

  static GetTypeResultMatchesItemKind fromJson(dynamic raw) {
    switch (raw) {
      case 'main':
        return GetTypeResultMatchesItemKind.mainValue;
      case 'thirdPlace':
        return GetTypeResultMatchesItemKind.thirdPlaceValue;
      default:
        throw FormatException(
          'Expected one of main, thirdPlace for GetTypeResultMatchesItemKind',
        );
    }
  }
}

Map<String, dynamic> _encodeSlotA(SlotA value) {
  switch (value) {
    case Team(teamId: final teamId):
      return <String, dynamic>{'kind': 'team', 'teamId': teamId.value};
    case Winner(matchId: final matchId):
      return <String, dynamic>{'kind': 'winner', 'matchId': matchId.value};
    case Loser(matchId: final matchId):
      return <String, dynamic>{'kind': 'loser', 'matchId': matchId.value};
    case Bye():
      return <String, dynamic>{'kind': 'bye'};
  }
}

SlotA _decodeSlotA(dynamic raw) {
  final map = expectMap(raw, label: 'SlotA');
  if (!map.containsKey('kind')) {
    throw FormatException('Missing discriminator "kind" for SlotA');
  }
  final discriminator = expectString(map['kind'], label: 'SlotAKind');
  switch (discriminator) {
    case 'team':
      if (!map.containsKey('teamId')) {
        throw FormatException('Missing required field "teamId" for Team');
      }
      return Team(
        teamId: BeerpongTeamId(
          expectString(map['teamId'], label: 'TeamTeamId'),
        ),
      );
    case 'winner':
      if (!map.containsKey('matchId')) {
        throw FormatException('Missing required field "matchId" for Winner');
      }
      return Winner(
        matchId: BeerpongMatchId(
          expectString(map['matchId'], label: 'WinnerMatchId'),
        ),
      );
    case 'loser':
      if (!map.containsKey('matchId')) {
        throw FormatException('Missing required field "matchId" for Loser');
      }
      return Loser(
        matchId: BeerpongMatchId(
          expectString(map['matchId'], label: 'LoserMatchId'),
        ),
      );
    case 'bye':
      return const Bye();
    default:
      throw FormatException('Unknown SlotA discriminator: $discriminator');
  }
}

enum GetTypeResultMatchesItemStatus {
  pendingValue('pending'),
  readyValue('ready'),
  completedValue('completed'),
  byeValue('bye');

  const GetTypeResultMatchesItemStatus(this.value);
  final Object? value;

  static GetTypeResultMatchesItemStatus fromJson(dynamic raw) {
    switch (raw) {
      case 'pending':
        return GetTypeResultMatchesItemStatus.pendingValue;
      case 'ready':
        return GetTypeResultMatchesItemStatus.readyValue;
      case 'completed':
        return GetTypeResultMatchesItemStatus.completedValue;
      case 'bye':
        return GetTypeResultMatchesItemStatus.byeValue;
      default:
        throw FormatException(
          'Expected one of pending, ready, completed, bye for GetTypeResultMatchesItemStatus',
        );
    }
  }
}

typedef GetTypeResultMatchesItem = ({
  double creationTime,
  BeerpongMatchId id,
  double? completedAt,
  GetTypeResultMatchesItemKind kind,
  double position,
  double round,
  SlotA slotA,
  SlotA slotB,
  GetTypeResultMatchesItemStatus status,
  BeerpongTeamId? teamAId,
  BeerpongTeamId? teamBId,
  BeerpongTournamentId tournamentId,
  double updatedAt,
  BeerpongTeamId? winnerTeamId,
});

Map<String, dynamic> _encodeGetTypeResultMatchesItem(
  GetTypeResultMatchesItem value$,
) {
  final (
    creationTime: creationTime,
    id: id,
    completedAt: completedAt,
    kind: kind,
    position: position,
    round: round,
    slotA: slotA,
    slotB: slotB,
    status: status,
    teamAId: teamAId,
    teamBId: teamBId,
    tournamentId: tournamentId,
    updatedAt: updatedAt,
    winnerTeamId: winnerTeamId,
  ) = value$;
  return <String, dynamic>{
    '_creationTime': creationTime,
    '_id': id.value,
    'completedAt': completedAt,
    'kind': kind.value,
    'position': position,
    'round': round,
    'slotA': _encodeSlotA(slotA),
    'slotB': _encodeSlotA(slotB),
    'status': status.value,
    'teamAId': switch (teamAId) {
      null => null,
      final v$ => v$.value,
    },
    'teamBId': switch (teamBId) {
      null => null,
      final v$ => v$.value,
    },
    'tournamentId': tournamentId.value,
    'updatedAt': updatedAt,
    'winnerTeamId': switch (winnerTeamId) {
      null => null,
      final v$ => v$.value,
    },
  };
}

GetTypeResultMatchesItem _decodeGetTypeResultMatchesItem(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResultMatchesItem');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('completedAt')) {
    throw FormatException(
      'Missing required field "completedAt" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('position')) {
    throw FormatException(
      'Missing required field "position" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('round')) {
    throw FormatException(
      'Missing required field "round" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('slotA')) {
    throw FormatException(
      'Missing required field "slotA" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('slotB')) {
    throw FormatException(
      'Missing required field "slotB" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('status')) {
    throw FormatException(
      'Missing required field "status" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('teamAId')) {
    throw FormatException(
      'Missing required field "teamAId" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('teamBId')) {
    throw FormatException(
      'Missing required field "teamBId" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('tournamentId')) {
    throw FormatException(
      'Missing required field "tournamentId" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for GetTypeResultMatchesItem',
    );
  }
  if (!map.containsKey('winnerTeamId')) {
    throw FormatException(
      'Missing required field "winnerTeamId" for GetTypeResultMatchesItem',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'GetTypeResultMatchesItemCreationTime',
    ),
    id: BeerpongMatchId(
      expectString(map['_id'], label: 'GetTypeResultMatchesItemId'),
    ),
    completedAt: map['completedAt'] == null
        ? null
        : expectDouble(
            map['completedAt'],
            label: 'GetTypeResultMatchesItemCompletedAt',
          ),
    kind: GetTypeResultMatchesItemKind.fromJson(map['kind']),
    position: expectDouble(
      map['position'],
      label: 'GetTypeResultMatchesItemPosition',
    ),
    round: expectDouble(map['round'], label: 'GetTypeResultMatchesItemRound'),
    slotA: _decodeSlotA(map['slotA']),
    slotB: _decodeSlotA(map['slotB']),
    status: GetTypeResultMatchesItemStatus.fromJson(map['status']),
    teamAId: map['teamAId'] == null
        ? null
        : BeerpongTeamId(
            expectString(
              map['teamAId'],
              label: 'GetTypeResultMatchesItemTeamAId',
            ),
          ),
    teamBId: map['teamBId'] == null
        ? null
        : BeerpongTeamId(
            expectString(
              map['teamBId'],
              label: 'GetTypeResultMatchesItemTeamBId',
            ),
          ),
    tournamentId: BeerpongTournamentId(
      expectString(
        map['tournamentId'],
        label: 'GetTypeResultMatchesItemTournamentId',
      ),
    ),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'GetTypeResultMatchesItemUpdatedAt',
    ),
    winnerTeamId: map['winnerTeamId'] == null
        ? null
        : BeerpongTeamId(
            expectString(
              map['winnerTeamId'],
              label: 'GetTypeResultMatchesItemWinnerTeamId',
            ),
          ),
  );
}

typedef GetTypeResultPlacementsItem = ({
  double placement,
  BeerpongTeamId teamId,
});

Map<String, dynamic> _encodeGetTypeResultPlacementsItem(
  GetTypeResultPlacementsItem value$,
) {
  final (placement: placement, teamId: teamId) = value$;
  return <String, dynamic>{'placement': placement, 'teamId': teamId.value};
}

GetTypeResultPlacementsItem _decodeGetTypeResultPlacementsItem(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResultPlacementsItem');
  if (!map.containsKey('placement')) {
    throw FormatException(
      'Missing required field "placement" for GetTypeResultPlacementsItem',
    );
  }
  if (!map.containsKey('teamId')) {
    throw FormatException(
      'Missing required field "teamId" for GetTypeResultPlacementsItem',
    );
  }
  return (
    placement: expectDouble(
      map['placement'],
      label: 'GetTypeResultPlacementsItemPlacement',
    ),
    teamId: BeerpongTeamId(
      expectString(map['teamId'], label: 'GetTypeResultPlacementsItemTeamId'),
    ),
  );
}

Map<String, dynamic> _encodeBeerpongTeamDocument(BeerpongTeamDocument value$) {
  final (
    tournamentId: tournamentId,
    name: name,
    memberUserIds: memberUserIds,
    updatedAt: updatedAt,
    id: id,
    creationTime: creationTime,
  ) = value$;
  return <String, dynamic>{
    'tournamentId': tournamentId.value,
    'name': name,
    'memberUserIds': memberUserIds.map((item) => item.value).toList(),
    'updatedAt': updatedAt,
    '_id': id.value,
    '_creationTime': creationTime,
  };
}

BeerpongTeamDocument _decodeBeerpongTeamDocument(dynamic raw) {
  final map = expectMap(raw, label: 'BeerpongTeamDocument');
  if (!map.containsKey('tournamentId')) {
    throw FormatException(
      'Missing required field "tournamentId" for BeerpongTeamDocument',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException(
      'Missing required field "name" for BeerpongTeamDocument',
    );
  }
  if (!map.containsKey('memberUserIds')) {
    throw FormatException(
      'Missing required field "memberUserIds" for BeerpongTeamDocument',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for BeerpongTeamDocument',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for BeerpongTeamDocument',
    );
  }
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for BeerpongTeamDocument',
    );
  }
  return (
    tournamentId: BeerpongTournamentId(
      expectString(
        map['tournamentId'],
        label: 'BeerpongTeamDocumentTournamentId',
      ),
    ),
    name: expectString(map['name'], label: 'BeerpongTeamDocumentName'),
    memberUserIds:
        expectList(
              map['memberUserIds'],
              label: 'BeerpongTeamDocumentMemberUserIds',
            )
            .map(
              (item) => UserId(
                expectString(
                  item,
                  label: 'BeerpongTeamDocumentMemberUserIdsItem',
                ),
              ),
            )
            .toList(),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'BeerpongTeamDocumentUpdatedAt',
    ),
    id: BeerpongTeamId(
      expectString(map['_id'], label: 'BeerpongTeamDocumentId'),
    ),
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'BeerpongTeamDocumentCreationTime',
    ),
  );
}

Map<String, dynamic> _encodeBeerpongTournamentDocument(
  BeerpongTournamentDocument value$,
) {
  final (
    sessionId: sessionId,
    name: name,
    status: status,
    teamCount: teamCount,
    thirdPlaceEnabled: thirdPlaceEnabled,
    firstPlacePointsUnits: firstPlacePointsUnits,
    secondPlacePointsUnits: secondPlacePointsUnits,
    thirdPlacePointsUnits: thirdPlacePointsUnits,
    createdByUserId: createdByUserId,
    updatedAt: updatedAt,
    completedAt: completedAt,
    id: id,
    creationTime: creationTime,
  ) = value$;
  return <String, dynamic>{
    'sessionId': sessionId.value,
    'name': name,
    'status': status.value,
    'teamCount': teamCount,
    'thirdPlaceEnabled': thirdPlaceEnabled,
    'firstPlacePointsUnits': firstPlacePointsUnits,
    'secondPlacePointsUnits': secondPlacePointsUnits,
    'thirdPlacePointsUnits': thirdPlacePointsUnits,
    'createdByUserId': createdByUserId.value,
    'updatedAt': updatedAt,
    'completedAt': completedAt,
    '_id': id.value,
    '_creationTime': creationTime,
  };
}

BeerpongTournamentDocument _decodeBeerpongTournamentDocument(dynamic raw) {
  final map = expectMap(raw, label: 'BeerpongTournamentDocument');
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException(
      'Missing required field "name" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('status')) {
    throw FormatException(
      'Missing required field "status" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('teamCount')) {
    throw FormatException(
      'Missing required field "teamCount" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('thirdPlaceEnabled')) {
    throw FormatException(
      'Missing required field "thirdPlaceEnabled" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('firstPlacePointsUnits')) {
    throw FormatException(
      'Missing required field "firstPlacePointsUnits" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('secondPlacePointsUnits')) {
    throw FormatException(
      'Missing required field "secondPlacePointsUnits" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('thirdPlacePointsUnits')) {
    throw FormatException(
      'Missing required field "thirdPlacePointsUnits" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('createdByUserId')) {
    throw FormatException(
      'Missing required field "createdByUserId" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('completedAt')) {
    throw FormatException(
      'Missing required field "completedAt" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for BeerpongTournamentDocument',
    );
  }
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for BeerpongTournamentDocument',
    );
  }
  return (
    sessionId: SessionId(
      expectString(
        map['sessionId'],
        label: 'BeerpongTournamentDocumentSessionId',
      ),
    ),
    name: expectString(map['name'], label: 'BeerpongTournamentDocumentName'),
    status: BeerpongTournamentDocumentStatus.fromJson(map['status']),
    teamCount: expectDouble(
      map['teamCount'],
      label: 'BeerpongTournamentDocumentTeamCount',
    ),
    thirdPlaceEnabled: expectBool(
      map['thirdPlaceEnabled'],
      label: 'BeerpongTournamentDocumentThirdPlaceEnabled',
    ),
    firstPlacePointsUnits: expectDouble(
      map['firstPlacePointsUnits'],
      label: 'BeerpongTournamentDocumentFirstPlacePointsUnits',
    ),
    secondPlacePointsUnits: expectDouble(
      map['secondPlacePointsUnits'],
      label: 'BeerpongTournamentDocumentSecondPlacePointsUnits',
    ),
    thirdPlacePointsUnits: expectDouble(
      map['thirdPlacePointsUnits'],
      label: 'BeerpongTournamentDocumentThirdPlacePointsUnits',
    ),
    createdByUserId: UserId(
      expectString(
        map['createdByUserId'],
        label: 'BeerpongTournamentDocumentCreatedByUserId',
      ),
    ),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'BeerpongTournamentDocumentUpdatedAt',
    ),
    completedAt: map['completedAt'] == null
        ? null
        : expectDouble(
            map['completedAt'],
            label: 'BeerpongTournamentDocumentCompletedAt',
          ),
    id: BeerpongTournamentId(
      expectString(map['_id'], label: 'BeerpongTournamentDocumentId'),
    ),
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'BeerpongTournamentDocumentCreationTime',
    ),
  );
}

typedef GetTypeResult = ({
  List<GetTypeResultMatchesItem> matches,
  List<GetTypeResultPlacementsItem> placements,
  List<BeerpongTeamDocument> teams,
  BeerpongTournamentDocument tournament,
});

Map<String, dynamic> _encodeGetTypeResult(GetTypeResult value$) {
  final (
    matches: matches,
    placements: placements,
    teams: teams,
    tournament: tournament,
  ) = value$;
  return <String, dynamic>{
    'matches': matches
        .map((item) => _encodeGetTypeResultMatchesItem(item))
        .toList(),
    'placements': placements
        .map((item) => _encodeGetTypeResultPlacementsItem(item))
        .toList(),
    'teams': teams.map((item) => _encodeBeerpongTeamDocument(item)).toList(),
    'tournament': _encodeBeerpongTournamentDocument(tournament),
  };
}

GetTypeResult _decodeGetTypeResult(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResult');
  if (!map.containsKey('matches')) {
    throw FormatException('Missing required field "matches" for GetTypeResult');
  }
  if (!map.containsKey('placements')) {
    throw FormatException(
      'Missing required field "placements" for GetTypeResult',
    );
  }
  if (!map.containsKey('teams')) {
    throw FormatException('Missing required field "teams" for GetTypeResult');
  }
  if (!map.containsKey('tournament')) {
    throw FormatException(
      'Missing required field "tournament" for GetTypeResult',
    );
  }
  return (
    matches: expectList(
      map['matches'],
      label: 'GetTypeResultMatches',
    ).map((item) => _decodeGetTypeResultMatchesItem(item)).toList(),
    placements: expectList(
      map['placements'],
      label: 'GetTypeResultPlacements',
    ).map((item) => _decodeGetTypeResultPlacementsItem(item)).toList(),
    teams: expectList(
      map['teams'],
      label: 'GetTypeResultTeams',
    ).map((item) => _decodeBeerpongTeamDocument(item)).toList(),
    tournament: _decodeBeerpongTournamentDocument(map['tournament']),
  );
}

typedef GetTypeArgs = ({BeerpongTournamentId id});

Map<String, dynamic> _encodeGetTypeArgs(GetTypeArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

GetTypeArgs _decodeGetTypeArgs(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for GetTypeArgs');
  }
  return (
    id: BeerpongTournamentId(expectString(map['id'], label: 'GetTypeArgsId')),
  );
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

typedef StartArgs = ({BeerpongTournamentId id});

Map<String, dynamic> _encodeStartArgs(StartArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

StartArgs _decodeStartArgs(dynamic raw) {
  final map = expectMap(raw, label: 'StartArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for StartArgs');
  }
  return (
    id: BeerpongTournamentId(expectString(map['id'], label: 'StartArgsId')),
  );
}

final ConvexMutationReference<CreateArgs, BeerpongTournamentId>
createMutationReference = ConvexMutationReference(
  name: 'beerpongTournament:create',
  encode: (args) => _encodeCreateArgs(args),
  decode: (raw) =>
      BeerpongTournamentId(expectString(raw, label: 'CreateResult')),
);

final ConvexMutationReference<DrawArgs, void> drawMutationReference =
    ConvexMutationReference(
      name: 'beerpongTournament:draw',
      encode: (args) => _encodeDrawArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<FinalizeArgs, void> finalizeMutationReference =
    ConvexMutationReference(
      name: 'beerpongTournament:finalize',
      encode: (args) => _encodeFinalizeArgs(args),
      decode: (raw) => null,
    );

final ConvexQueryReference<GetTypeArgs, GetTypeResult> getValueQueryReference =
    ConvexQueryReference(
      name: 'beerpongTournament:get',
      encode: (args) => _encodeGetTypeArgs(args),
      decodeArgs: (raw) => _decodeGetTypeArgs(raw),
      decode: (raw) => _decodeGetTypeResult(raw),
      encodeResult: (value) => _encodeGetTypeResult(value),
    );

final ConvexQueryReference<ListForSessionArgs, List<BeerpongTournamentDocument>>
listForSessionQueryReference = ConvexQueryReference(
  name: 'beerpongTournament:listForSession',
  encode: (args) => _encodeListForSessionArgs(args),
  decodeArgs: (raw) => _decodeListForSessionArgs(raw),
  decode: (raw) => expectList(
    raw,
    label: 'ListForSessionResult',
  ).map((item) => _decodeBeerpongTournamentDocument(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeBeerpongTournamentDocument(item)).toList(),
);

final ConvexMutationReference<StartArgs, void> startMutationReference =
    ConvexMutationReference(
      name: 'beerpongTournament:start',
      encode: (args) => _encodeStartArgs(args),
      decode: (raw) => null,
    );
