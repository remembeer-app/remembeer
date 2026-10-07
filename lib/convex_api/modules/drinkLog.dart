// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class DrinkLogApi {
  const DrinkLogApi(this._client);

  final ConvexFunctionCaller _client;

  Future<DrinkLogId> create({
    required double consumedAt,
    required DrinkId drinkId,
    required CreateArgsLocation? location,
    required SessionId sessionId,
    required double volumeMl,
  }) async {
    final raw$ = await _client.mutate(
      'drinkLog:create',
      _encodeCreateArgs((
        consumedAt: consumedAt,
        drinkId: drinkId,
        location: location,
        sessionId: sessionId,
        volumeMl: volumeMl,
      )),
    );
    return DrinkLogId(expectString(raw$, label: 'CreateResult'));
  }

  ConvexMutationReference<CreateArgs, DrinkLogId> get createMutation =>
      createMutationReference;

  Future<GetTypeResult> getValue({required DrinkLogId id}) async {
    final raw$ = await _client.query(
      'drinkLog:get',
      _encodeGetTypeArgs((id: id)),
    );
    return _decodeGetTypeResult(raw$);
  }

  TypedConvexSubscription<GetTypeResult> getValueSubscribe({
    required DrinkLogId id,
  }) {
    final subscription$ = _client.subscribe(
      'drinkLog:get',
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

  Future<List<ListResultItem>> list() async {
    final raw$ = await _client.query(
      'drinkLog:list',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListResult',
    ).map((item) => _decodeListResultItem(item)).toList();
  }

  TypedConvexSubscription<List<ListResultItem>> listSubscribe() {
    final subscription$ = _client.subscribe(
      'drinkLog:list',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<ListResultItem>>(
            expectList(
              value,
              label: 'ListResult',
            ).map((item) => _decodeListResultItem(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<ListResultItem>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<ListResultItem>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<ListResultItem>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<NoArgs, List<ListResultItem>> get listQuery =>
      listQueryReference;

  Future<Null> softDelete({required DrinkLogId id}) async {
    await _client.mutate(
      'drinkLog:softDelete',
      _encodeSoftDeleteArgs((id: id)),
    );
    return null;
  }

  ConvexMutationReference<SoftDeleteArgs, void> get softDeleteMutation =>
      softDeleteMutationReference;

  Future<Null> update({
    Optional<double> consumedAt = const Optional.absent(),
    Optional<DrinkId> drinkId = const Optional.absent(),
    required DrinkLogId id,
    Optional<UpdateArgsLocation?> location = const Optional.absent(),
    Optional<SessionId> sessionId = const Optional.absent(),
    Optional<double> volumeMl = const Optional.absent(),
  }) async {
    await _client.mutate(
      'drinkLog:update',
      _encodeUpdateArgs((
        consumedAt: consumedAt,
        drinkId: drinkId,
        id: id,
        location: location,
        sessionId: sessionId,
        volumeMl: volumeMl,
      )),
    );
    return null;
  }

  ConvexMutationReference<UpdateArgs, void> get updateMutation =>
      updateMutationReference;
}

typedef CreateArgsLocation = ({
  double? accuracy,
  double latitude,
  double longitude,
});

Map<String, dynamic> _encodeCreateArgsLocation(CreateArgsLocation value$) {
  final (accuracy: accuracy, latitude: latitude, longitude: longitude) = value$;
  return <String, dynamic>{
    'accuracy': accuracy,
    'latitude': latitude,
    'longitude': longitude,
  };
}

CreateArgsLocation _decodeCreateArgsLocation(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgsLocation');
  if (!map.containsKey('accuracy')) {
    throw FormatException(
      'Missing required field "accuracy" for CreateArgsLocation',
    );
  }
  if (!map.containsKey('latitude')) {
    throw FormatException(
      'Missing required field "latitude" for CreateArgsLocation',
    );
  }
  if (!map.containsKey('longitude')) {
    throw FormatException(
      'Missing required field "longitude" for CreateArgsLocation',
    );
  }
  return (
    accuracy: map['accuracy'] == null
        ? null
        : expectDouble(map['accuracy'], label: 'CreateArgsLocationAccuracy'),
    latitude: expectDouble(
      map['latitude'],
      label: 'CreateArgsLocationLatitude',
    ),
    longitude: expectDouble(
      map['longitude'],
      label: 'CreateArgsLocationLongitude',
    ),
  );
}

typedef CreateArgs = ({
  double consumedAt,
  DrinkId drinkId,
  CreateArgsLocation? location,
  SessionId sessionId,
  double volumeMl,
});

Map<String, dynamic> _encodeCreateArgs(CreateArgs value$) {
  final (
    consumedAt: consumedAt,
    drinkId: drinkId,
    location: location,
    sessionId: sessionId,
    volumeMl: volumeMl,
  ) = value$;
  return <String, dynamic>{
    'consumedAt': consumedAt,
    'drinkId': drinkId.value,
    'location': switch (location) {
      null => null,
      final v$ => _encodeCreateArgsLocation(v$),
    },
    'sessionId': sessionId.value,
    'volumeMl': volumeMl,
  };
}

CreateArgs _decodeCreateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgs');
  if (!map.containsKey('consumedAt')) {
    throw FormatException('Missing required field "consumedAt" for CreateArgs');
  }
  if (!map.containsKey('drinkId')) {
    throw FormatException('Missing required field "drinkId" for CreateArgs');
  }
  if (!map.containsKey('location')) {
    throw FormatException('Missing required field "location" for CreateArgs');
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for CreateArgs');
  }
  if (!map.containsKey('volumeMl')) {
    throw FormatException('Missing required field "volumeMl" for CreateArgs');
  }
  return (
    consumedAt: expectDouble(map['consumedAt'], label: 'CreateArgsConsumedAt'),
    drinkId: DrinkId(expectString(map['drinkId'], label: 'CreateArgsDrinkId')),
    location: map['location'] == null
        ? null
        : _decodeCreateArgsLocation(map['location']),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'CreateArgsSessionId'),
    ),
    volumeMl: expectDouble(map['volumeMl'], label: 'CreateArgsVolumeMl'),
  );
}

typedef GetTypeResultLocation = ({
  double? accuracy,
  double latitude,
  double longitude,
});

Map<String, dynamic> _encodeGetTypeResultLocation(
  GetTypeResultLocation value$,
) {
  final (accuracy: accuracy, latitude: latitude, longitude: longitude) = value$;
  return <String, dynamic>{
    'accuracy': accuracy,
    'latitude': latitude,
    'longitude': longitude,
  };
}

GetTypeResultLocation _decodeGetTypeResultLocation(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResultLocation');
  if (!map.containsKey('accuracy')) {
    throw FormatException(
      'Missing required field "accuracy" for GetTypeResultLocation',
    );
  }
  if (!map.containsKey('latitude')) {
    throw FormatException(
      'Missing required field "latitude" for GetTypeResultLocation',
    );
  }
  if (!map.containsKey('longitude')) {
    throw FormatException(
      'Missing required field "longitude" for GetTypeResultLocation',
    );
  }
  return (
    accuracy: map['accuracy'] == null
        ? null
        : expectDouble(map['accuracy'], label: 'GetTypeResultLocationAccuracy'),
    latitude: expectDouble(
      map['latitude'],
      label: 'GetTypeResultLocationLatitude',
    ),
    longitude: expectDouble(
      map['longitude'],
      label: 'GetTypeResultLocationLongitude',
    ),
  );
}

typedef GetTypeResult = ({
  double creationTime,
  DrinkLogId id,
  double consumedAt,
  double? deletedAt,
  DrinkId drinkId,
  GetTypeResultLocation? location,
  SessionId sessionId,
  double updatedAt,
  UserId userId,
  double volumeMl,
});

Map<String, dynamic> _encodeGetTypeResult(GetTypeResult value$) {
  final (
    creationTime: creationTime,
    id: id,
    consumedAt: consumedAt,
    deletedAt: deletedAt,
    drinkId: drinkId,
    location: location,
    sessionId: sessionId,
    updatedAt: updatedAt,
    userId: userId,
    volumeMl: volumeMl,
  ) = value$;
  return <String, dynamic>{
    '_creationTime': creationTime,
    '_id': id.value,
    'consumedAt': consumedAt,
    'deletedAt': deletedAt,
    'drinkId': drinkId.value,
    'location': switch (location) {
      null => null,
      final v$ => _encodeGetTypeResultLocation(v$),
    },
    'sessionId': sessionId.value,
    'updatedAt': updatedAt,
    'userId': userId.value,
    'volumeMl': volumeMl,
  };
}

GetTypeResult _decodeGetTypeResult(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResult');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for GetTypeResult',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException('Missing required field "_id" for GetTypeResult');
  }
  if (!map.containsKey('consumedAt')) {
    throw FormatException(
      'Missing required field "consumedAt" for GetTypeResult',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for GetTypeResult',
    );
  }
  if (!map.containsKey('drinkId')) {
    throw FormatException('Missing required field "drinkId" for GetTypeResult');
  }
  if (!map.containsKey('location')) {
    throw FormatException(
      'Missing required field "location" for GetTypeResult',
    );
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for GetTypeResult',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for GetTypeResult',
    );
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for GetTypeResult');
  }
  if (!map.containsKey('volumeMl')) {
    throw FormatException(
      'Missing required field "volumeMl" for GetTypeResult',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'GetTypeResultCreationTime',
    ),
    id: DrinkLogId(expectString(map['_id'], label: 'GetTypeResultId')),
    consumedAt: expectDouble(
      map['consumedAt'],
      label: 'GetTypeResultConsumedAt',
    ),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(map['deletedAt'], label: 'GetTypeResultDeletedAt'),
    drinkId: DrinkId(
      expectString(map['drinkId'], label: 'GetTypeResultDrinkId'),
    ),
    location: map['location'] == null
        ? null
        : _decodeGetTypeResultLocation(map['location']),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'GetTypeResultSessionId'),
    ),
    updatedAt: expectDouble(map['updatedAt'], label: 'GetTypeResultUpdatedAt'),
    userId: UserId(expectString(map['userId'], label: 'GetTypeResultUserId')),
    volumeMl: expectDouble(map['volumeMl'], label: 'GetTypeResultVolumeMl'),
  );
}

typedef GetTypeArgs = ({DrinkLogId id});

Map<String, dynamic> _encodeGetTypeArgs(GetTypeArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

GetTypeArgs _decodeGetTypeArgs(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for GetTypeArgs');
  }
  return (id: DrinkLogId(expectString(map['id'], label: 'GetTypeArgsId')));
}

typedef ListResultItemLocation = ({
  double? accuracy,
  double latitude,
  double longitude,
});

Map<String, dynamic> _encodeListResultItemLocation(
  ListResultItemLocation value$,
) {
  final (accuracy: accuracy, latitude: latitude, longitude: longitude) = value$;
  return <String, dynamic>{
    'accuracy': accuracy,
    'latitude': latitude,
    'longitude': longitude,
  };
}

ListResultItemLocation _decodeListResultItemLocation(dynamic raw) {
  final map = expectMap(raw, label: 'ListResultItemLocation');
  if (!map.containsKey('accuracy')) {
    throw FormatException(
      'Missing required field "accuracy" for ListResultItemLocation',
    );
  }
  if (!map.containsKey('latitude')) {
    throw FormatException(
      'Missing required field "latitude" for ListResultItemLocation',
    );
  }
  if (!map.containsKey('longitude')) {
    throw FormatException(
      'Missing required field "longitude" for ListResultItemLocation',
    );
  }
  return (
    accuracy: map['accuracy'] == null
        ? null
        : expectDouble(
            map['accuracy'],
            label: 'ListResultItemLocationAccuracy',
          ),
    latitude: expectDouble(
      map['latitude'],
      label: 'ListResultItemLocationLatitude',
    ),
    longitude: expectDouble(
      map['longitude'],
      label: 'ListResultItemLocationLongitude',
    ),
  );
}

typedef ListResultItem = ({
  double creationTime,
  DrinkLogId id,
  double consumedAt,
  double? deletedAt,
  DrinkId drinkId,
  ListResultItemLocation? location,
  SessionId sessionId,
  double updatedAt,
  UserId userId,
  double volumeMl,
});

Map<String, dynamic> _encodeListResultItem(ListResultItem value$) {
  final (
    creationTime: creationTime,
    id: id,
    consumedAt: consumedAt,
    deletedAt: deletedAt,
    drinkId: drinkId,
    location: location,
    sessionId: sessionId,
    updatedAt: updatedAt,
    userId: userId,
    volumeMl: volumeMl,
  ) = value$;
  return <String, dynamic>{
    '_creationTime': creationTime,
    '_id': id.value,
    'consumedAt': consumedAt,
    'deletedAt': deletedAt,
    'drinkId': drinkId.value,
    'location': switch (location) {
      null => null,
      final v$ => _encodeListResultItemLocation(v$),
    },
    'sessionId': sessionId.value,
    'updatedAt': updatedAt,
    'userId': userId.value,
    'volumeMl': volumeMl,
  };
}

ListResultItem _decodeListResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListResultItem');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for ListResultItem',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException('Missing required field "_id" for ListResultItem');
  }
  if (!map.containsKey('consumedAt')) {
    throw FormatException(
      'Missing required field "consumedAt" for ListResultItem',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for ListResultItem',
    );
  }
  if (!map.containsKey('drinkId')) {
    throw FormatException(
      'Missing required field "drinkId" for ListResultItem',
    );
  }
  if (!map.containsKey('location')) {
    throw FormatException(
      'Missing required field "location" for ListResultItem',
    );
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for ListResultItem',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for ListResultItem',
    );
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for ListResultItem');
  }
  if (!map.containsKey('volumeMl')) {
    throw FormatException(
      'Missing required field "volumeMl" for ListResultItem',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'ListResultItemCreationTime',
    ),
    id: DrinkLogId(expectString(map['_id'], label: 'ListResultItemId')),
    consumedAt: expectDouble(
      map['consumedAt'],
      label: 'ListResultItemConsumedAt',
    ),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(map['deletedAt'], label: 'ListResultItemDeletedAt'),
    drinkId: DrinkId(
      expectString(map['drinkId'], label: 'ListResultItemDrinkId'),
    ),
    location: map['location'] == null
        ? null
        : _decodeListResultItemLocation(map['location']),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'ListResultItemSessionId'),
    ),
    updatedAt: expectDouble(map['updatedAt'], label: 'ListResultItemUpdatedAt'),
    userId: UserId(expectString(map['userId'], label: 'ListResultItemUserId')),
    volumeMl: expectDouble(map['volumeMl'], label: 'ListResultItemVolumeMl'),
  );
}

typedef SoftDeleteArgs = ({DrinkLogId id});

Map<String, dynamic> _encodeSoftDeleteArgs(SoftDeleteArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

SoftDeleteArgs _decodeSoftDeleteArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SoftDeleteArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for SoftDeleteArgs');
  }
  return (id: DrinkLogId(expectString(map['id'], label: 'SoftDeleteArgsId')));
}

typedef UpdateArgsLocation = ({
  double? accuracy,
  double latitude,
  double longitude,
});

Map<String, dynamic> _encodeUpdateArgsLocation(UpdateArgsLocation value$) {
  final (accuracy: accuracy, latitude: latitude, longitude: longitude) = value$;
  return <String, dynamic>{
    'accuracy': accuracy,
    'latitude': latitude,
    'longitude': longitude,
  };
}

UpdateArgsLocation _decodeUpdateArgsLocation(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateArgsLocation');
  if (!map.containsKey('accuracy')) {
    throw FormatException(
      'Missing required field "accuracy" for UpdateArgsLocation',
    );
  }
  if (!map.containsKey('latitude')) {
    throw FormatException(
      'Missing required field "latitude" for UpdateArgsLocation',
    );
  }
  if (!map.containsKey('longitude')) {
    throw FormatException(
      'Missing required field "longitude" for UpdateArgsLocation',
    );
  }
  return (
    accuracy: map['accuracy'] == null
        ? null
        : expectDouble(map['accuracy'], label: 'UpdateArgsLocationAccuracy'),
    latitude: expectDouble(
      map['latitude'],
      label: 'UpdateArgsLocationLatitude',
    ),
    longitude: expectDouble(
      map['longitude'],
      label: 'UpdateArgsLocationLongitude',
    ),
  );
}

typedef UpdateArgs = ({
  Optional<double> consumedAt,
  Optional<DrinkId> drinkId,
  DrinkLogId id,
  Optional<UpdateArgsLocation?> location,
  Optional<SessionId> sessionId,
  Optional<double> volumeMl,
});

Map<String, dynamic> _encodeUpdateArgs(UpdateArgs value$) {
  final (
    consumedAt: consumedAt,
    drinkId: drinkId,
    id: id,
    location: location,
    sessionId: sessionId,
    volumeMl: volumeMl,
  ) = value$;
  return <String, dynamic>{
    if (consumedAt.isDefined) 'consumedAt': consumedAt.value,
    if (drinkId.isDefined) 'drinkId': drinkId.value.value,
    'id': id.value,
    if (location.isDefined)
      'location': switch (location.value) {
        null => null,
        final v$ => _encodeUpdateArgsLocation(v$),
      },
    if (sessionId.isDefined) 'sessionId': sessionId.value.value,
    if (volumeMl.isDefined) 'volumeMl': volumeMl.value,
  };
}

UpdateArgs _decodeUpdateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for UpdateArgs');
  }
  return (
    consumedAt: map.containsKey('consumedAt')
        ? Optional.of(
            expectDouble(map['consumedAt'], label: 'UpdateArgsConsumedAt'),
          )
        : const Optional.absent(),
    drinkId: map.containsKey('drinkId')
        ? Optional.of(
            DrinkId(expectString(map['drinkId'], label: 'UpdateArgsDrinkId')),
          )
        : const Optional.absent(),
    id: DrinkLogId(expectString(map['id'], label: 'UpdateArgsId')),
    location: map.containsKey('location')
        ? Optional.of(
            map['location'] == null
                ? null
                : _decodeUpdateArgsLocation(map['location']),
          )
        : const Optional.absent(),
    sessionId: map.containsKey('sessionId')
        ? Optional.of(
            SessionId(
              expectString(map['sessionId'], label: 'UpdateArgsSessionId'),
            ),
          )
        : const Optional.absent(),
    volumeMl: map.containsKey('volumeMl')
        ? Optional.of(
            expectDouble(map['volumeMl'], label: 'UpdateArgsVolumeMl'),
          )
        : const Optional.absent(),
  );
}

final ConvexMutationReference<CreateArgs, DrinkLogId> createMutationReference =
    ConvexMutationReference(
      name: 'drinkLog:create',
      encode: (args) => _encodeCreateArgs(args),
      decode: (raw) => DrinkLogId(expectString(raw, label: 'CreateResult')),
    );

final ConvexQueryReference<GetTypeArgs, GetTypeResult> getValueQueryReference =
    ConvexQueryReference(
      name: 'drinkLog:get',
      encode: (args) => _encodeGetTypeArgs(args),
      decodeArgs: (raw) => _decodeGetTypeArgs(raw),
      decode: (raw) => _decodeGetTypeResult(raw),
      encodeResult: (value) => _encodeGetTypeResult(value),
    );

final ConvexQueryReference<NoArgs, List<ListResultItem>> listQueryReference =
    ConvexQueryReference(
      name: 'drinkLog:list',
      encode: (args) => const <String, dynamic>{},
      decodeArgs: (raw) => const NoArgs(),
      decode: (raw) => expectList(
        raw,
        label: 'ListResult',
      ).map((item) => _decodeListResultItem(item)).toList(),
      encodeResult: (value) =>
          value.map((item) => _encodeListResultItem(item)).toList(),
    );

final ConvexMutationReference<SoftDeleteArgs, void>
softDeleteMutationReference = ConvexMutationReference(
  name: 'drinkLog:softDelete',
  encode: (args) => _encodeSoftDeleteArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<UpdateArgs, void> updateMutationReference =
    ConvexMutationReference(
      name: 'drinkLog:update',
      encode: (args) => _encodeUpdateArgs(args),
      decode: (raw) => null,
    );
