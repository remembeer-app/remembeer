// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class SessionApi {
  const SessionApi(this._client);

  final ConvexFunctionCaller _client;

  Future<SessionId> create({
    required String description,
    required String name,
    required double startedAt,
  }) async {
    final raw$ = await _client.mutate(
      'session:create',
      _encodeCreateArgs((
        description: description,
        name: name,
        startedAt: startedAt,
      )),
    );
    return SessionId(expectString(raw$, label: 'CreateResult'));
  }

  ConvexMutationReference<CreateArgs, SessionId> get createMutation =>
      createMutationReference;

  Future<SessionDocument> getValue({required SessionId id}) async {
    final raw$ = await _client.query(
      'session:get',
      _encodeGetTypeArgs((id: id)),
    );
    return _decodeSessionDocument(raw$);
  }

  TypedConvexSubscription<SessionDocument> getValueSubscribe({
    required SessionId id,
  }) {
    final subscription$ = _client.subscribe(
      'session:get',
      _encodeGetTypeArgs((id: id)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<SessionDocument>(
            _decodeSessionDocument(value),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<SessionDocument>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<SessionDocument>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<SessionDocument>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<GetTypeArgs, SessionDocument> get getValueQuery =>
      getValueQueryReference;

  Future<List<SessionDocument>> listCurrent() async {
    final raw$ = await _client.query(
      'session:listCurrent',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListCurrentResult',
    ).map((item) => _decodeSessionDocument(item)).toList();
  }

  TypedConvexSubscription<List<SessionDocument>> listCurrentSubscribe() {
    final subscription$ = _client.subscribe(
      'session:listCurrent',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<SessionDocument>>(
            expectList(
              value,
              label: 'ListCurrentResult',
            ).map((item) => _decodeSessionDocument(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<SessionDocument>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<SessionDocument>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<SessionDocument>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<NoArgs, List<SessionDocument>> get listCurrentQuery =>
      listCurrentQueryReference;

  Future<Null> promoteToParty({required SessionId id}) async {
    await _client.mutate(
      'session:promoteToParty',
      _encodePromoteToPartyArgs((id: id)),
    );
    return null;
  }

  ConvexMutationReference<PromoteToPartyArgs, void>
  get promoteToPartyMutation => promoteToPartyMutationReference;

  Future<Null> softDelete({required SessionId id}) async {
    await _client.mutate('session:softDelete', _encodeSoftDeleteArgs((id: id)));
    return null;
  }

  ConvexMutationReference<SoftDeleteArgs, void> get softDeleteMutation =>
      softDeleteMutationReference;

  Future<Null> update({
    Optional<String> description = const Optional.absent(),
    Optional<double?> endedAt = const Optional.absent(),
    required SessionId id,
    Optional<String> name = const Optional.absent(),
    Optional<double> startedAt = const Optional.absent(),
  }) async {
    await _client.mutate(
      'session:update',
      _encodeUpdateArgs((
        description: description,
        endedAt: endedAt,
        id: id,
        name: name,
        startedAt: startedAt,
      )),
    );
    return null;
  }

  ConvexMutationReference<UpdateArgs, void> get updateMutation =>
      updateMutationReference;
}

typedef CreateArgs = ({String description, String name, double startedAt});

Map<String, dynamic> _encodeCreateArgs(CreateArgs value$) {
  final (description: description, name: name, startedAt: startedAt) = value$;
  return <String, dynamic>{
    'description': description,
    'name': name,
    'startedAt': startedAt,
  };
}

CreateArgs _decodeCreateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgs');
  if (!map.containsKey('description')) {
    throw FormatException(
      'Missing required field "description" for CreateArgs',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException('Missing required field "name" for CreateArgs');
  }
  if (!map.containsKey('startedAt')) {
    throw FormatException('Missing required field "startedAt" for CreateArgs');
  }
  return (
    description: expectString(
      map['description'],
      label: 'CreateArgsDescription',
    ),
    name: expectString(map['name'], label: 'CreateArgsName'),
    startedAt: expectDouble(map['startedAt'], label: 'CreateArgsStartedAt'),
  );
}

Map<String, dynamic> _encodeSessionDocument(SessionDocument value) {
  switch (value) {
    case Session(
      ownerId: final ownerId,
      name: final name,
      description: final description,
      startedAt: final startedAt,
      endedAt: final endedAt,
      updatedAt: final updatedAt,
      deletedAt: final deletedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'session',
        'ownerId': ownerId.value,
        'name': name,
        'description': description,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case Party(
      ownerId: final ownerId,
      name: final name,
      description: final description,
      startedAt: final startedAt,
      endedAt: final endedAt,
      updatedAt: final updatedAt,
      deletedAt: final deletedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'party',
        'ownerId': ownerId.value,
        'name': name,
        'description': description,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
  }
}

SessionDocument _decodeSessionDocument(dynamic raw) {
  final map = expectMap(raw, label: 'SessionDocument');
  if (!map.containsKey('kind')) {
    throw FormatException('Missing discriminator "kind" for SessionDocument');
  }
  final discriminator = expectString(map['kind'], label: 'SessionDocumentKind');
  switch (discriminator) {
    case 'session':
      if (!map.containsKey('ownerId')) {
        throw FormatException('Missing required field "ownerId" for Session');
      }
      if (!map.containsKey('name')) {
        throw FormatException('Missing required field "name" for Session');
      }
      if (!map.containsKey('description')) {
        throw FormatException(
          'Missing required field "description" for Session',
        );
      }
      if (!map.containsKey('startedAt')) {
        throw FormatException('Missing required field "startedAt" for Session');
      }
      if (!map.containsKey('endedAt')) {
        throw FormatException('Missing required field "endedAt" for Session');
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException('Missing required field "updatedAt" for Session');
      }
      if (!map.containsKey('deletedAt')) {
        throw FormatException('Missing required field "deletedAt" for Session');
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for Session');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for Session',
        );
      }
      return Session(
        ownerId: UserId(expectString(map['ownerId'], label: 'SessionOwnerId')),
        name: expectString(map['name'], label: 'SessionName'),
        description: expectString(
          map['description'],
          label: 'SessionDescription',
        ),
        startedAt: expectDouble(map['startedAt'], label: 'SessionStartedAt'),
        endedAt: map['endedAt'] == null
            ? null
            : expectDouble(map['endedAt'], label: 'SessionEndedAt'),
        updatedAt: expectDouble(map['updatedAt'], label: 'SessionUpdatedAt'),
        deletedAt: map['deletedAt'] == null
            ? null
            : expectDouble(map['deletedAt'], label: 'SessionDeletedAt'),
        id: SessionId(expectString(map['_id'], label: 'SessionId')),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'SessionCreationTime',
        ),
      );
    case 'party':
      if (!map.containsKey('ownerId')) {
        throw FormatException('Missing required field "ownerId" for Party');
      }
      if (!map.containsKey('name')) {
        throw FormatException('Missing required field "name" for Party');
      }
      if (!map.containsKey('description')) {
        throw FormatException('Missing required field "description" for Party');
      }
      if (!map.containsKey('startedAt')) {
        throw FormatException('Missing required field "startedAt" for Party');
      }
      if (!map.containsKey('endedAt')) {
        throw FormatException('Missing required field "endedAt" for Party');
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException('Missing required field "updatedAt" for Party');
      }
      if (!map.containsKey('deletedAt')) {
        throw FormatException('Missing required field "deletedAt" for Party');
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for Party');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for Party',
        );
      }
      return Party(
        ownerId: UserId(expectString(map['ownerId'], label: 'PartyOwnerId')),
        name: expectString(map['name'], label: 'PartyName'),
        description: expectString(
          map['description'],
          label: 'PartyDescription',
        ),
        startedAt: expectDouble(map['startedAt'], label: 'PartyStartedAt'),
        endedAt: map['endedAt'] == null
            ? null
            : expectDouble(map['endedAt'], label: 'PartyEndedAt'),
        updatedAt: expectDouble(map['updatedAt'], label: 'PartyUpdatedAt'),
        deletedAt: map['deletedAt'] == null
            ? null
            : expectDouble(map['deletedAt'], label: 'PartyDeletedAt'),
        id: SessionId(expectString(map['_id'], label: 'PartyId')),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'PartyCreationTime',
        ),
      );
    default:
      throw FormatException(
        'Unknown SessionDocument discriminator: $discriminator',
      );
  }
}

typedef GetTypeArgs = ({SessionId id});

Map<String, dynamic> _encodeGetTypeArgs(GetTypeArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

GetTypeArgs _decodeGetTypeArgs(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for GetTypeArgs');
  }
  return (id: SessionId(expectString(map['id'], label: 'GetTypeArgsId')));
}

typedef PromoteToPartyArgs = ({SessionId id});

Map<String, dynamic> _encodePromoteToPartyArgs(PromoteToPartyArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

PromoteToPartyArgs _decodePromoteToPartyArgs(dynamic raw) {
  final map = expectMap(raw, label: 'PromoteToPartyArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for PromoteToPartyArgs');
  }
  return (
    id: SessionId(expectString(map['id'], label: 'PromoteToPartyArgsId')),
  );
}

typedef SoftDeleteArgs = ({SessionId id});

Map<String, dynamic> _encodeSoftDeleteArgs(SoftDeleteArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

SoftDeleteArgs _decodeSoftDeleteArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SoftDeleteArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for SoftDeleteArgs');
  }
  return (id: SessionId(expectString(map['id'], label: 'SoftDeleteArgsId')));
}

typedef UpdateArgs = ({
  Optional<String> description,
  Optional<double?> endedAt,
  SessionId id,
  Optional<String> name,
  Optional<double> startedAt,
});

Map<String, dynamic> _encodeUpdateArgs(UpdateArgs value$) {
  final (
    description: description,
    endedAt: endedAt,
    id: id,
    name: name,
    startedAt: startedAt,
  ) = value$;
  return <String, dynamic>{
    if (description.isDefined) 'description': description.value,
    if (endedAt.isDefined) 'endedAt': endedAt.value,
    'id': id.value,
    if (name.isDefined) 'name': name.value,
    if (startedAt.isDefined) 'startedAt': startedAt.value,
  };
}

UpdateArgs _decodeUpdateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for UpdateArgs');
  }
  return (
    description: map.containsKey('description')
        ? Optional.of(
            expectString(map['description'], label: 'UpdateArgsDescription'),
          )
        : const Optional.absent(),
    endedAt: map.containsKey('endedAt')
        ? Optional.of(
            map['endedAt'] == null
                ? null
                : expectDouble(map['endedAt'], label: 'UpdateArgsEndedAt'),
          )
        : const Optional.absent(),
    id: SessionId(expectString(map['id'], label: 'UpdateArgsId')),
    name: map.containsKey('name')
        ? Optional.of(expectString(map['name'], label: 'UpdateArgsName'))
        : const Optional.absent(),
    startedAt: map.containsKey('startedAt')
        ? Optional.of(
            expectDouble(map['startedAt'], label: 'UpdateArgsStartedAt'),
          )
        : const Optional.absent(),
  );
}

final ConvexMutationReference<CreateArgs, SessionId> createMutationReference =
    ConvexMutationReference(
      name: 'session:create',
      encode: (args) => _encodeCreateArgs(args),
      decode: (raw) => SessionId(expectString(raw, label: 'CreateResult')),
    );

final ConvexQueryReference<GetTypeArgs, SessionDocument>
getValueQueryReference = ConvexQueryReference(
  name: 'session:get',
  encode: (args) => _encodeGetTypeArgs(args),
  decodeArgs: (raw) => _decodeGetTypeArgs(raw),
  decode: (raw) => _decodeSessionDocument(raw),
  encodeResult: (value) => _encodeSessionDocument(value),
);

final ConvexQueryReference<NoArgs, List<SessionDocument>>
listCurrentQueryReference = ConvexQueryReference(
  name: 'session:listCurrent',
  encode: (args) => const <String, dynamic>{},
  decodeArgs: (raw) => const NoArgs(),
  decode: (raw) => expectList(
    raw,
    label: 'ListCurrentResult',
  ).map((item) => _decodeSessionDocument(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeSessionDocument(item)).toList(),
);

final ConvexMutationReference<PromoteToPartyArgs, void>
promoteToPartyMutationReference = ConvexMutationReference(
  name: 'session:promoteToParty',
  encode: (args) => _encodePromoteToPartyArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<SoftDeleteArgs, void>
softDeleteMutationReference = ConvexMutationReference(
  name: 'session:softDelete',
  encode: (args) => _encodeSoftDeleteArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<UpdateArgs, void> updateMutationReference =
    ConvexMutationReference(
      name: 'session:update',
      encode: (args) => _encodeUpdateArgs(args),
      decode: (raw) => null,
    );
