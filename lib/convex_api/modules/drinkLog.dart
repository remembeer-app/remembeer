// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class DrinkLogApi {
  const DrinkLogApi(this._client);

  final ConvexFunctionCaller _client;

  Future<DrinkLogId> create({
    required double consumedAt,
    required DrinkId drinkId,
    required CreateArgsLocation? location,
    required SessionId? sessionId,
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

  Future<DayContextResult> dayContext({required double at}) async {
    final raw$ = await _client.query(
      'drinkLog:dayContext',
      _encodeDayContextArgs((at: at)),
    );
    return _decodeDayContextResult(raw$);
  }

  TypedConvexSubscription<DayContextResult> dayContextSubscribe({
    required double at,
  }) {
    final subscription$ = _client.subscribe(
      'drinkLog:dayContext',
      _encodeDayContextArgs((at: at)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<DayContextResult>(
            _decodeDayContextResult(value),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<DayContextResult>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<DayContextResult>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<DayContextResult>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<DayContextArgs, DayContextResult> get dayContextQuery =>
      dayContextQueryReference;

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
    Optional<SessionId?> sessionId = const Optional.absent(),
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
  SessionId? sessionId,
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
    'sessionId': switch (sessionId) {
      null => null,
      final v$ => v$.value,
    },
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
    sessionId: map['sessionId'] == null
        ? null
        : SessionId(
            expectString(map['sessionId'], label: 'CreateArgsSessionId'),
          ),
    volumeMl: expectDouble(map['volumeMl'], label: 'CreateArgsVolumeMl'),
  );
}

typedef DayContextResult = ({double nextBoundary, String today});

Map<String, dynamic> _encodeDayContextResult(DayContextResult value$) {
  final (nextBoundary: nextBoundary, today: today) = value$;
  return <String, dynamic>{'nextBoundary': nextBoundary, 'today': today};
}

DayContextResult _decodeDayContextResult(dynamic raw) {
  final map = expectMap(raw, label: 'DayContextResult');
  if (!map.containsKey('nextBoundary')) {
    throw FormatException(
      'Missing required field "nextBoundary" for DayContextResult',
    );
  }
  if (!map.containsKey('today')) {
    throw FormatException(
      'Missing required field "today" for DayContextResult',
    );
  }
  return (
    nextBoundary: expectDouble(
      map['nextBoundary'],
      label: 'DayContextResultNextBoundary',
    ),
    today: expectString(map['today'], label: 'DayContextResultToday'),
  );
}

typedef DayContextArgs = ({double at});

Map<String, dynamic> _encodeDayContextArgs(DayContextArgs value$) {
  final (at: at) = value$;
  return <String, dynamic>{'at': at};
}

DayContextArgs _decodeDayContextArgs(dynamic raw) {
  final map = expectMap(raw, label: 'DayContextArgs');
  if (!map.containsKey('at')) {
    throw FormatException('Missing required field "at" for DayContextArgs');
  }
  return (at: expectDouble(map['at'], label: 'DayContextArgsAt'));
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

typedef ListForDayResultItemDrink = ({
  double creationTime,
  DrinkId id,
  double alcoholPercentage,
  double? deletedAt,
  DrinkCategory drinkCategory,
  String name,
  UserId? ownerId,
  Optional<String> seedKey,
  double updatedAt,
});

Map<String, dynamic> _encodeListForDayResultItemDrink(
  ListForDayResultItemDrink value$,
) {
  final (
    creationTime: creationTime,
    id: id,
    alcoholPercentage: alcoholPercentage,
    deletedAt: deletedAt,
    drinkCategory: drinkCategory,
    name: name,
    ownerId: ownerId,
    seedKey: seedKey,
    updatedAt: updatedAt,
  ) = value$;
  return <String, dynamic>{
    '_creationTime': creationTime,
    '_id': id.value,
    'alcoholPercentage': alcoholPercentage,
    'deletedAt': deletedAt,
    'drinkCategory': _encodeDrinkCategory(drinkCategory),
    'name': name,
    'ownerId': switch (ownerId) {
      null => null,
      final v$ => v$.value,
    },
    if (seedKey.isDefined) 'seedKey': seedKey.value,
    'updatedAt': updatedAt,
  };
}

ListForDayResultItemDrink _decodeListForDayResultItemDrink(dynamic raw) {
  final map = expectMap(raw, label: 'ListForDayResultItemDrink');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for ListForDayResultItemDrink',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListForDayResultItemDrink',
    );
  }
  if (!map.containsKey('alcoholPercentage')) {
    throw FormatException(
      'Missing required field "alcoholPercentage" for ListForDayResultItemDrink',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for ListForDayResultItemDrink',
    );
  }
  if (!map.containsKey('drinkCategory')) {
    throw FormatException(
      'Missing required field "drinkCategory" for ListForDayResultItemDrink',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException(
      'Missing required field "name" for ListForDayResultItemDrink',
    );
  }
  if (!map.containsKey('ownerId')) {
    throw FormatException(
      'Missing required field "ownerId" for ListForDayResultItemDrink',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for ListForDayResultItemDrink',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'ListForDayResultItemDrinkCreationTime',
    ),
    id: DrinkId(expectString(map['_id'], label: 'ListForDayResultItemDrinkId')),
    alcoholPercentage: expectDouble(
      map['alcoholPercentage'],
      label: 'ListForDayResultItemDrinkAlcoholPercentage',
    ),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(
            map['deletedAt'],
            label: 'ListForDayResultItemDrinkDeletedAt',
          ),
    drinkCategory: _decodeDrinkCategory(map['drinkCategory']),
    name: expectString(map['name'], label: 'ListForDayResultItemDrinkName'),
    ownerId: map['ownerId'] == null
        ? null
        : UserId(
            expectString(
              map['ownerId'],
              label: 'ListForDayResultItemDrinkOwnerId',
            ),
          ),
    seedKey: map.containsKey('seedKey')
        ? Optional.of(
            expectString(
              map['seedKey'],
              label: 'ListForDayResultItemDrinkSeedKey',
            ),
          )
        : const Optional.absent(),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'ListForDayResultItemDrinkUpdatedAt',
    ),
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
  String consumedAtLocal,
  double? deletedAt,
  ListForDayResultItemDrink? drink,
  DrinkId drinkId,
  ListForDayResultItemLocation? location,
  SessionId? sessionId,
  double updatedAt,
  UserId userId,
  double volumeMl,
});

Map<String, dynamic> _encodeListForDayResultItem(ListForDayResultItem value$) {
  final (
    creationTime: creationTime,
    id: id,
    consumedAt: consumedAt,
    consumedAtLocal: consumedAtLocal,
    deletedAt: deletedAt,
    drink: drink,
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
    'consumedAtLocal': consumedAtLocal,
    'deletedAt': deletedAt,
    'drink': switch (drink) {
      null => null,
      final v$ => _encodeListForDayResultItemDrink(v$),
    },
    'drinkId': drinkId.value,
    'location': switch (location) {
      null => null,
      final v$ => _encodeListForDayResultItemLocation(v$),
    },
    'sessionId': switch (sessionId) {
      null => null,
      final v$ => v$.value,
    },
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
  if (!map.containsKey('consumedAtLocal')) {
    throw FormatException(
      'Missing required field "consumedAtLocal" for ListForDayResultItem',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for ListForDayResultItem',
    );
  }
  if (!map.containsKey('drink')) {
    throw FormatException(
      'Missing required field "drink" for ListForDayResultItem',
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
    consumedAtLocal: expectString(
      map['consumedAtLocal'],
      label: 'ListForDayResultItemConsumedAtLocal',
    ),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(
            map['deletedAt'],
            label: 'ListForDayResultItemDeletedAt',
          ),
    drink: map['drink'] == null
        ? null
        : _decodeListForDayResultItemDrink(map['drink']),
    drinkId: DrinkId(
      expectString(map['drinkId'], label: 'ListForDayResultItemDrinkId'),
    ),
    location: map['location'] == null
        ? null
        : _decodeListForDayResultItemLocation(map['location']),
    sessionId: map['sessionId'] == null
        ? null
        : SessionId(
            expectString(
              map['sessionId'],
              label: 'ListForDayResultItemSessionId',
            ),
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
  Optional<SessionId?> sessionId,
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
    if (sessionId.isDefined)
      'sessionId': switch (sessionId.value) {
        null => null,
        final v$ => v$.value,
      },
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
            map['sessionId'] == null
                ? null
                : SessionId(
                    expectString(
                      map['sessionId'],
                      label: 'UpdateArgsSessionId',
                    ),
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

final ConvexQueryReference<DayContextArgs, DayContextResult>
dayContextQueryReference = ConvexQueryReference(
  name: 'drinkLog:dayContext',
  encode: (args) => _encodeDayContextArgs(args),
  decodeArgs: (raw) => _decodeDayContextArgs(raw),
  decode: (raw) => _decodeDayContextResult(raw),
  encodeResult: (value) => _encodeDayContextResult(value),
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
