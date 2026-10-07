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

  Future<List<ListForDayResultItem>> listForDay({required String date}) async {
    final raw$ = await _client.query(
      'drinkLog:listForDay',
      _encodeListForDayArgs((date: date)),
    );
    return expectList(
      raw$,
      label: 'ListForDayResult',
    ).map((item) => _decodeListForDayResultItem(item)).toList();
  }

  TypedConvexSubscription<List<ListForDayResultItem>> listForDaySubscribe({
    required String date,
  }) {
    final subscription$ = _client.subscribe(
      'drinkLog:listForDay',
      _encodeListForDayArgs((date: date)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<ListForDayResultItem>>(
            expectList(
              value,
              label: 'ListForDayResult',
            ).map((item) => _decodeListForDayResultItem(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<ListForDayResultItem>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<ListForDayResultItem>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<ListForDayResultItem>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<ListForDayArgs, List<ListForDayResultItem>>
  get listForDayQuery => listForDayQueryReference;

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

typedef ListForDayResultItemLocation = ({
  double? accuracy,
  double latitude,
  double longitude,
});

Map<String, dynamic> _encodeListForDayResultItemLocation(
  ListForDayResultItemLocation value$,
) {
  final (accuracy: accuracy, latitude: latitude, longitude: longitude) = value$;
  return <String, dynamic>{
    'accuracy': accuracy,
    'latitude': latitude,
    'longitude': longitude,
  };
}

ListForDayResultItemLocation _decodeListForDayResultItemLocation(dynamic raw) {
  final map = expectMap(raw, label: 'ListForDayResultItemLocation');
  if (!map.containsKey('accuracy')) {
    throw FormatException(
      'Missing required field "accuracy" for ListForDayResultItemLocation',
    );
  }
  if (!map.containsKey('latitude')) {
    throw FormatException(
      'Missing required field "latitude" for ListForDayResultItemLocation',
    );
  }
  if (!map.containsKey('longitude')) {
    throw FormatException(
      'Missing required field "longitude" for ListForDayResultItemLocation',
    );
  }
  return (
    accuracy: map['accuracy'] == null
        ? null
        : expectDouble(
            map['accuracy'],
            label: 'ListForDayResultItemLocationAccuracy',
          ),
    latitude: expectDouble(
      map['latitude'],
      label: 'ListForDayResultItemLocationLatitude',
    ),
    longitude: expectDouble(
      map['longitude'],
      label: 'ListForDayResultItemLocationLongitude',
    ),
  );
}

typedef ListForDayResultItem = ({
  double creationTime,
  DrinkLogId id,
  double consumedAt,
  double? deletedAt,
  DrinkId drinkId,
  ListForDayResultItemLocation? location,
  SessionId sessionId,
  double updatedAt,
  UserId userId,
  double volumeMl,
});

Map<String, dynamic> _encodeListForDayResultItem(ListForDayResultItem value$) {
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
      final v$ => _encodeListForDayResultItemLocation(v$),
    },
    'sessionId': sessionId.value,
    'updatedAt': updatedAt,
    'userId': userId.value,
    'volumeMl': volumeMl,
  };
}

ListForDayResultItem _decodeListForDayResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListForDayResultItem');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for ListForDayResultItem',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListForDayResultItem',
    );
  }
  if (!map.containsKey('consumedAt')) {
    throw FormatException(
      'Missing required field "consumedAt" for ListForDayResultItem',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for ListForDayResultItem',
    );
  }
  if (!map.containsKey('drinkId')) {
    throw FormatException(
      'Missing required field "drinkId" for ListForDayResultItem',
    );
  }
  if (!map.containsKey('location')) {
    throw FormatException(
      'Missing required field "location" for ListForDayResultItem',
    );
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for ListForDayResultItem',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for ListForDayResultItem',
    );
  }
  if (!map.containsKey('userId')) {
    throw FormatException(
      'Missing required field "userId" for ListForDayResultItem',
    );
  }
  if (!map.containsKey('volumeMl')) {
    throw FormatException(
      'Missing required field "volumeMl" for ListForDayResultItem',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'ListForDayResultItemCreationTime',
    ),
    id: DrinkLogId(expectString(map['_id'], label: 'ListForDayResultItemId')),
    consumedAt: expectDouble(
      map['consumedAt'],
      label: 'ListForDayResultItemConsumedAt',
    ),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(
            map['deletedAt'],
            label: 'ListForDayResultItemDeletedAt',
          ),
    drinkId: DrinkId(
      expectString(map['drinkId'], label: 'ListForDayResultItemDrinkId'),
    ),
    location: map['location'] == null
        ? null
        : _decodeListForDayResultItemLocation(map['location']),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'ListForDayResultItemSessionId'),
    ),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'ListForDayResultItemUpdatedAt',
    ),
    userId: UserId(
      expectString(map['userId'], label: 'ListForDayResultItemUserId'),
    ),
    volumeMl: expectDouble(
      map['volumeMl'],
      label: 'ListForDayResultItemVolumeMl',
    ),
  );
}

typedef ListForDayArgs = ({String date});

Map<String, dynamic> _encodeListForDayArgs(ListForDayArgs value$) {
  final (date: date) = value$;
  return <String, dynamic>{'date': date};
}

ListForDayArgs _decodeListForDayArgs(dynamic raw) {
  final map = expectMap(raw, label: 'ListForDayArgs');
  if (!map.containsKey('date')) {
    throw FormatException('Missing required field "date" for ListForDayArgs');
  }
  return (date: expectString(map['date'], label: 'ListForDayArgsDate'));
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

final ConvexQueryReference<ListForDayArgs, List<ListForDayResultItem>>
listForDayQueryReference = ConvexQueryReference(
  name: 'drinkLog:listForDay',
  encode: (args) => _encodeListForDayArgs(args),
  decodeArgs: (raw) => _decodeListForDayArgs(raw),
  decode: (raw) => expectList(
    raw,
    label: 'ListForDayResult',
  ).map((item) => _decodeListForDayResultItem(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeListForDayResultItem(item)).toList(),
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
