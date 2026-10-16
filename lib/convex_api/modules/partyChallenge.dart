// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class PartyChallengeApi {
  const PartyChallengeApi(this._client);

  final ConvexFunctionCaller _client;

  Future<Null> addWinner({
    required PartyChallengeId id,
    required UserId userId,
  }) async {
    await _client.mutate(
      'partyChallenge:addWinner',
      _encodeAddWinnerArgs((id: id, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<AddWinnerArgs, void> get addWinnerMutation =>
      addWinnerMutationReference;

  Future<Null> cancel({required PartyChallengeId id}) async {
    await _client.mutate('partyChallenge:cancel', _encodeCancelArgs((id: id)));
    return null;
  }

  ConvexMutationReference<CancelArgs, void> get cancelMutation =>
      cancelMutationReference;

  Future<Null> complete({required PartyChallengeId id}) async {
    await _client.mutate(
      'partyChallenge:complete',
      _encodeCompleteArgs((id: id)),
    );
    return null;
  }

  ConvexMutationReference<CompleteArgs, void> get completeMutation =>
      completeMutationReference;

  Future<PartyChallengeId> create({
    required double durationMinutes,
    required String instructions,
    required double pointsUnits,
    required SessionId sessionId,
    required String title,
  }) async {
    final raw$ = await _client.mutate(
      'partyChallenge:create',
      _encodeCreateArgs((
        durationMinutes: durationMinutes,
        instructions: instructions,
        pointsUnits: pointsUnits,
        sessionId: sessionId,
        title: title,
      )),
    );
    return PartyChallengeId(expectString(raw$, label: 'CreateResult'));
  }

  ConvexMutationReference<CreateArgs, PartyChallengeId> get createMutation =>
      createMutationReference;

  Future<PartyChallengeDocument> getValue({
    required PartyChallengeId id,
  }) async {
    final raw$ = await _client.query(
      'partyChallenge:get',
      _encodeGetTypeArgs((id: id)),
    );
    return _decodePartyChallengeDocument(raw$);
  }

  TypedConvexSubscription<PartyChallengeDocument> getValueSubscribe({
    required PartyChallengeId id,
  }) {
    final subscription$ = _client.subscribe(
      'partyChallenge:get',
      _encodeGetTypeArgs((id: id)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<PartyChallengeDocument>(
            _decodePartyChallengeDocument(value),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<PartyChallengeDocument>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<PartyChallengeDocument>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<PartyChallengeDocument>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<GetTypeArgs, PartyChallengeDocument> get getValueQuery =>
      getValueQueryReference;

  Future<List<PartyChallengeDocument>> listForSession({
    required SessionId sessionId,
  }) async {
    final raw$ = await _client.query(
      'partyChallenge:listForSession',
      _encodeListForSessionArgs((sessionId: sessionId)),
    );
    return expectList(
      raw$,
      label: 'ListForSessionResult',
    ).map((item) => _decodePartyChallengeDocument(item)).toList();
  }

  TypedConvexSubscription<List<PartyChallengeDocument>>
  listForSessionSubscribe({required SessionId sessionId}) {
    final subscription$ = _client.subscribe(
      'partyChallenge:listForSession',
      _encodeListForSessionArgs((sessionId: sessionId)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<PartyChallengeDocument>>(
            expectList(
              value,
              label: 'ListForSessionResult',
            ).map((item) => _decodePartyChallengeDocument(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<PartyChallengeDocument>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<PartyChallengeDocument>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<PartyChallengeDocument>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<ListForSessionArgs, List<PartyChallengeDocument>>
  get listForSessionQuery => listForSessionQueryReference;

  Future<Null> removeWinner({
    required PartyChallengeId id,
    required UserId userId,
  }) async {
    await _client.mutate(
      'partyChallenge:removeWinner',
      _encodeRemoveWinnerArgs((id: id, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<RemoveWinnerArgs, void> get removeWinnerMutation =>
      removeWinnerMutationReference;

  Future<Null> setEnabled({
    required bool enabled,
    required SessionId sessionId,
  }) async {
    await _client.mutate(
      'partyChallenge:setEnabled',
      _encodeSetEnabledArgs((enabled: enabled, sessionId: sessionId)),
    );
    return null;
  }

  ConvexMutationReference<SetEnabledArgs, void> get setEnabledMutation =>
      setEnabledMutationReference;

  Future<Null> update({
    Optional<double> durationMinutes = const Optional.absent(),
    required PartyChallengeId id,
    Optional<String> instructions = const Optional.absent(),
    Optional<double> pointsUnits = const Optional.absent(),
    Optional<String> title = const Optional.absent(),
  }) async {
    await _client.mutate(
      'partyChallenge:update',
      _encodeUpdateArgs((
        durationMinutes: durationMinutes,
        id: id,
        instructions: instructions,
        pointsUnits: pointsUnits,
        title: title,
      )),
    );
    return null;
  }

  ConvexMutationReference<UpdateArgs, void> get updateMutation =>
      updateMutationReference;
}

typedef AddWinnerArgs = ({PartyChallengeId id, UserId userId});

Map<String, dynamic> _encodeAddWinnerArgs(AddWinnerArgs value$) {
  final (id: id, userId: userId) = value$;
  return <String, dynamic>{'id': id.value, 'userId': userId.value};
}

AddWinnerArgs _decodeAddWinnerArgs(dynamic raw) {
  final map = expectMap(raw, label: 'AddWinnerArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for AddWinnerArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for AddWinnerArgs');
  }
  return (
    id: PartyChallengeId(expectString(map['id'], label: 'AddWinnerArgsId')),
    userId: UserId(expectString(map['userId'], label: 'AddWinnerArgsUserId')),
  );
}

typedef CancelArgs = ({PartyChallengeId id});

Map<String, dynamic> _encodeCancelArgs(CancelArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

CancelArgs _decodeCancelArgs(dynamic raw) {
  final map = expectMap(raw, label: 'CancelArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for CancelArgs');
  }
  return (id: PartyChallengeId(expectString(map['id'], label: 'CancelArgsId')));
}

typedef CompleteArgs = ({PartyChallengeId id});

Map<String, dynamic> _encodeCompleteArgs(CompleteArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

CompleteArgs _decodeCompleteArgs(dynamic raw) {
  final map = expectMap(raw, label: 'CompleteArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for CompleteArgs');
  }
  return (
    id: PartyChallengeId(expectString(map['id'], label: 'CompleteArgsId')),
  );
}

typedef CreateArgs = ({
  double durationMinutes,
  String instructions,
  double pointsUnits,
  SessionId sessionId,
  String title,
});

Map<String, dynamic> _encodeCreateArgs(CreateArgs value$) {
  final (
    durationMinutes: durationMinutes,
    instructions: instructions,
    pointsUnits: pointsUnits,
    sessionId: sessionId,
    title: title,
  ) = value$;
  return <String, dynamic>{
    'durationMinutes': durationMinutes,
    'instructions': instructions,
    'pointsUnits': pointsUnits,
    'sessionId': sessionId.value,
    'title': title,
  };
}

CreateArgs _decodeCreateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgs');
  if (!map.containsKey('durationMinutes')) {
    throw FormatException(
      'Missing required field "durationMinutes" for CreateArgs',
    );
  }
  if (!map.containsKey('instructions')) {
    throw FormatException(
      'Missing required field "instructions" for CreateArgs',
    );
  }
  if (!map.containsKey('pointsUnits')) {
    throw FormatException(
      'Missing required field "pointsUnits" for CreateArgs',
    );
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for CreateArgs');
  }
  if (!map.containsKey('title')) {
    throw FormatException('Missing required field "title" for CreateArgs');
  }
  return (
    durationMinutes: expectDouble(
      map['durationMinutes'],
      label: 'CreateArgsDurationMinutes',
    ),
    instructions: expectString(
      map['instructions'],
      label: 'CreateArgsInstructions',
    ),
    pointsUnits: expectDouble(
      map['pointsUnits'],
      label: 'CreateArgsPointsUnits',
    ),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'CreateArgsSessionId'),
    ),
    title: expectString(map['title'], label: 'CreateArgsTitle'),
  );
}

Map<String, dynamic> _encodePartyChallengeDocumentWinnersItem(
  PartyChallengeDocumentWinnersItem value$,
) {
  final (userId: userId, awardedAt: awardedAt) = value$;
  return <String, dynamic>{'userId': userId.value, 'awardedAt': awardedAt};
}

PartyChallengeDocumentWinnersItem _decodePartyChallengeDocumentWinnersItem(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'PartyChallengeDocumentWinnersItem');
  if (!map.containsKey('userId')) {
    throw FormatException(
      'Missing required field "userId" for PartyChallengeDocumentWinnersItem',
    );
  }
  if (!map.containsKey('awardedAt')) {
    throw FormatException(
      'Missing required field "awardedAt" for PartyChallengeDocumentWinnersItem',
    );
  }
  return (
    userId: UserId(
      expectString(
        map['userId'],
        label: 'PartyChallengeDocumentWinnersItemUserId',
      ),
    ),
    awardedAt: expectDouble(
      map['awardedAt'],
      label: 'PartyChallengeDocumentWinnersItemAwardedAt',
    ),
  );
}

Map<String, dynamic> _encodePartyChallengeDocument(
  PartyChallengeDocument value$,
) {
  final (
    sessionId: sessionId,
    title: title,
    instructions: instructions,
    pointsUnits: pointsUnits,
    startsAt: startsAt,
    endsAt: endsAt,
    status: status,
    createdByUserId: createdByUserId,
    updatedAt: updatedAt,
    winners: winners,
    id: id,
    creationTime: creationTime,
  ) = value$;
  return <String, dynamic>{
    'sessionId': sessionId.value,
    'title': title,
    'instructions': instructions,
    'pointsUnits': pointsUnits,
    'startsAt': startsAt,
    'endsAt': endsAt,
    'status': status.value,
    'createdByUserId': createdByUserId.value,
    'updatedAt': updatedAt,
    'winners': winners
        .map((item) => _encodePartyChallengeDocumentWinnersItem(item))
        .toList(),
    '_id': id.value,
    '_creationTime': creationTime,
  };
}

PartyChallengeDocument _decodePartyChallengeDocument(dynamic raw) {
  final map = expectMap(raw, label: 'PartyChallengeDocument');
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for PartyChallengeDocument',
    );
  }
  if (!map.containsKey('title')) {
    throw FormatException(
      'Missing required field "title" for PartyChallengeDocument',
    );
  }
  if (!map.containsKey('instructions')) {
    throw FormatException(
      'Missing required field "instructions" for PartyChallengeDocument',
    );
  }
  if (!map.containsKey('pointsUnits')) {
    throw FormatException(
      'Missing required field "pointsUnits" for PartyChallengeDocument',
    );
  }
  if (!map.containsKey('startsAt')) {
    throw FormatException(
      'Missing required field "startsAt" for PartyChallengeDocument',
    );
  }
  if (!map.containsKey('endsAt')) {
    throw FormatException(
      'Missing required field "endsAt" for PartyChallengeDocument',
    );
  }
  if (!map.containsKey('status')) {
    throw FormatException(
      'Missing required field "status" for PartyChallengeDocument',
    );
  }
  if (!map.containsKey('createdByUserId')) {
    throw FormatException(
      'Missing required field "createdByUserId" for PartyChallengeDocument',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for PartyChallengeDocument',
    );
  }
  if (!map.containsKey('winners')) {
    throw FormatException(
      'Missing required field "winners" for PartyChallengeDocument',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for PartyChallengeDocument',
    );
  }
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for PartyChallengeDocument',
    );
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'PartyChallengeDocumentSessionId'),
    ),
    title: expectString(map['title'], label: 'PartyChallengeDocumentTitle'),
    instructions: expectString(
      map['instructions'],
      label: 'PartyChallengeDocumentInstructions',
    ),
    pointsUnits: expectDouble(
      map['pointsUnits'],
      label: 'PartyChallengeDocumentPointsUnits',
    ),
    startsAt: expectDouble(
      map['startsAt'],
      label: 'PartyChallengeDocumentStartsAt',
    ),
    endsAt: expectDouble(map['endsAt'], label: 'PartyChallengeDocumentEndsAt'),
    status: PartyChallengeDocumentStatus.fromJson(map['status']),
    createdByUserId: UserId(
      expectString(
        map['createdByUserId'],
        label: 'PartyChallengeDocumentCreatedByUserId',
      ),
    ),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'PartyChallengeDocumentUpdatedAt',
    ),
    winners: expectList(
      map['winners'],
      label: 'PartyChallengeDocumentWinners',
    ).map((item) => _decodePartyChallengeDocumentWinnersItem(item)).toList(),
    id: PartyChallengeId(
      expectString(map['_id'], label: 'PartyChallengeDocumentId'),
    ),
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'PartyChallengeDocumentCreationTime',
    ),
  );
}

typedef GetTypeArgs = ({PartyChallengeId id});

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
    id: PartyChallengeId(expectString(map['id'], label: 'GetTypeArgsId')),
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

typedef RemoveWinnerArgs = ({PartyChallengeId id, UserId userId});

Map<String, dynamic> _encodeRemoveWinnerArgs(RemoveWinnerArgs value$) {
  final (id: id, userId: userId) = value$;
  return <String, dynamic>{'id': id.value, 'userId': userId.value};
}

RemoveWinnerArgs _decodeRemoveWinnerArgs(dynamic raw) {
  final map = expectMap(raw, label: 'RemoveWinnerArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for RemoveWinnerArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException(
      'Missing required field "userId" for RemoveWinnerArgs',
    );
  }
  return (
    id: PartyChallengeId(expectString(map['id'], label: 'RemoveWinnerArgsId')),
    userId: UserId(
      expectString(map['userId'], label: 'RemoveWinnerArgsUserId'),
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

typedef UpdateArgs = ({
  Optional<double> durationMinutes,
  PartyChallengeId id,
  Optional<String> instructions,
  Optional<double> pointsUnits,
  Optional<String> title,
});

Map<String, dynamic> _encodeUpdateArgs(UpdateArgs value$) {
  final (
    durationMinutes: durationMinutes,
    id: id,
    instructions: instructions,
    pointsUnits: pointsUnits,
    title: title,
  ) = value$;
  return <String, dynamic>{
    if (durationMinutes.isDefined) 'durationMinutes': durationMinutes.value,
    'id': id.value,
    if (instructions.isDefined) 'instructions': instructions.value,
    if (pointsUnits.isDefined) 'pointsUnits': pointsUnits.value,
    if (title.isDefined) 'title': title.value,
  };
}

UpdateArgs _decodeUpdateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for UpdateArgs');
  }
  return (
    durationMinutes: map.containsKey('durationMinutes')
        ? Optional.of(
            expectDouble(
              map['durationMinutes'],
              label: 'UpdateArgsDurationMinutes',
            ),
          )
        : const Optional.absent(),
    id: PartyChallengeId(expectString(map['id'], label: 'UpdateArgsId')),
    instructions: map.containsKey('instructions')
        ? Optional.of(
            expectString(map['instructions'], label: 'UpdateArgsInstructions'),
          )
        : const Optional.absent(),
    pointsUnits: map.containsKey('pointsUnits')
        ? Optional.of(
            expectDouble(map['pointsUnits'], label: 'UpdateArgsPointsUnits'),
          )
        : const Optional.absent(),
    title: map.containsKey('title')
        ? Optional.of(expectString(map['title'], label: 'UpdateArgsTitle'))
        : const Optional.absent(),
  );
}

final ConvexMutationReference<AddWinnerArgs, void> addWinnerMutationReference =
    ConvexMutationReference(
      name: 'partyChallenge:addWinner',
      encode: (args) => _encodeAddWinnerArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<CancelArgs, void> cancelMutationReference =
    ConvexMutationReference(
      name: 'partyChallenge:cancel',
      encode: (args) => _encodeCancelArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<CompleteArgs, void> completeMutationReference =
    ConvexMutationReference(
      name: 'partyChallenge:complete',
      encode: (args) => _encodeCompleteArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<CreateArgs, PartyChallengeId>
createMutationReference = ConvexMutationReference(
  name: 'partyChallenge:create',
  encode: (args) => _encodeCreateArgs(args),
  decode: (raw) => PartyChallengeId(expectString(raw, label: 'CreateResult')),
);

final ConvexQueryReference<GetTypeArgs, PartyChallengeDocument>
getValueQueryReference = ConvexQueryReference(
  name: 'partyChallenge:get',
  encode: (args) => _encodeGetTypeArgs(args),
  decodeArgs: (raw) => _decodeGetTypeArgs(raw),
  decode: (raw) => _decodePartyChallengeDocument(raw),
  encodeResult: (value) => _encodePartyChallengeDocument(value),
);

final ConvexQueryReference<ListForSessionArgs, List<PartyChallengeDocument>>
listForSessionQueryReference = ConvexQueryReference(
  name: 'partyChallenge:listForSession',
  encode: (args) => _encodeListForSessionArgs(args),
  decodeArgs: (raw) => _decodeListForSessionArgs(raw),
  decode: (raw) => expectList(
    raw,
    label: 'ListForSessionResult',
  ).map((item) => _decodePartyChallengeDocument(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodePartyChallengeDocument(item)).toList(),
);

final ConvexMutationReference<RemoveWinnerArgs, void>
removeWinnerMutationReference = ConvexMutationReference(
  name: 'partyChallenge:removeWinner',
  encode: (args) => _encodeRemoveWinnerArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<SetEnabledArgs, void>
setEnabledMutationReference = ConvexMutationReference(
  name: 'partyChallenge:setEnabled',
  encode: (args) => _encodeSetEnabledArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<UpdateArgs, void> updateMutationReference =
    ConvexMutationReference(
      name: 'partyChallenge:update',
      encode: (args) => _encodeUpdateArgs(args),
      decode: (raw) => null,
    );
