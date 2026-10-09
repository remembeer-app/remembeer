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

  Future<ListForDayResult> listForDay({
    required double at,
    Optional<String> date = const Optional.absent(),
  }) async {
    final raw$ = await _client.query(
      'drinkLog:listForDay',
      _encodeListForDayArgs((at: at, date: date)),
    );
    return _decodeListForDayResult(raw$);
  }

  TypedConvexSubscription<ListForDayResult> listForDaySubscribe({
    required double at,
    Optional<String> date = const Optional.absent(),
  }) {
    final subscription$ = _client.subscribe(
      'drinkLog:listForDay',
      _encodeListForDayArgs((at: at, date: date)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<ListForDayResult>(
            _decodeListForDayResult(value),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<ListForDayResult>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<ListForDayResult>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<ListForDayResult>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<ListForDayArgs, ListForDayResult> get listForDayQuery =>
      listForDayQueryReference;

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

typedef ListForDayResultLogsItemDrink = ({
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

Map<String, dynamic> _encodeListForDayResultLogsItemDrink(
  ListForDayResultLogsItemDrink value$,
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

ListForDayResultLogsItemDrink _decodeListForDayResultLogsItemDrink(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListForDayResultLogsItemDrink');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for ListForDayResultLogsItemDrink',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListForDayResultLogsItemDrink',
    );
  }
  if (!map.containsKey('alcoholPercentage')) {
    throw FormatException(
      'Missing required field "alcoholPercentage" for ListForDayResultLogsItemDrink',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for ListForDayResultLogsItemDrink',
    );
  }
  if (!map.containsKey('drinkCategory')) {
    throw FormatException(
      'Missing required field "drinkCategory" for ListForDayResultLogsItemDrink',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException(
      'Missing required field "name" for ListForDayResultLogsItemDrink',
    );
  }
  if (!map.containsKey('ownerId')) {
    throw FormatException(
      'Missing required field "ownerId" for ListForDayResultLogsItemDrink',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for ListForDayResultLogsItemDrink',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'ListForDayResultLogsItemDrinkCreationTime',
    ),
    id: DrinkId(
      expectString(map['_id'], label: 'ListForDayResultLogsItemDrinkId'),
    ),
    alcoholPercentage: expectDouble(
      map['alcoholPercentage'],
      label: 'ListForDayResultLogsItemDrinkAlcoholPercentage',
    ),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(
            map['deletedAt'],
            label: 'ListForDayResultLogsItemDrinkDeletedAt',
          ),
    drinkCategory: _decodeDrinkCategory(map['drinkCategory']),
    name: expectString(map['name'], label: 'ListForDayResultLogsItemDrinkName'),
    ownerId: map['ownerId'] == null
        ? null
        : UserId(
            expectString(
              map['ownerId'],
              label: 'ListForDayResultLogsItemDrinkOwnerId',
            ),
          ),
    seedKey: map.containsKey('seedKey')
        ? Optional.of(
            expectString(
              map['seedKey'],
              label: 'ListForDayResultLogsItemDrinkSeedKey',
            ),
          )
        : const Optional.absent(),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'ListForDayResultLogsItemDrinkUpdatedAt',
    ),
  );
}

typedef ListForDayResultLogsItemLocation = ({
  double? accuracy,
  double latitude,
  double longitude,
});

Map<String, dynamic> _encodeListForDayResultLogsItemLocation(
  ListForDayResultLogsItemLocation value$,
) {
  final (accuracy: accuracy, latitude: latitude, longitude: longitude) = value$;
  return <String, dynamic>{
    'accuracy': accuracy,
    'latitude': latitude,
    'longitude': longitude,
  };
}

ListForDayResultLogsItemLocation _decodeListForDayResultLogsItemLocation(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListForDayResultLogsItemLocation');
  if (!map.containsKey('accuracy')) {
    throw FormatException(
      'Missing required field "accuracy" for ListForDayResultLogsItemLocation',
    );
  }
  if (!map.containsKey('latitude')) {
    throw FormatException(
      'Missing required field "latitude" for ListForDayResultLogsItemLocation',
    );
  }
  if (!map.containsKey('longitude')) {
    throw FormatException(
      'Missing required field "longitude" for ListForDayResultLogsItemLocation',
    );
  }
  return (
    accuracy: map['accuracy'] == null
        ? null
        : expectDouble(
            map['accuracy'],
            label: 'ListForDayResultLogsItemLocationAccuracy',
          ),
    latitude: expectDouble(
      map['latitude'],
      label: 'ListForDayResultLogsItemLocationLatitude',
    ),
    longitude: expectDouble(
      map['longitude'],
      label: 'ListForDayResultLogsItemLocationLongitude',
    ),
  );
}

typedef ListForDayResultLogsItem = ({
  double creationTime,
  DrinkLogId id,
  double consumedAt,
  String consumedAtLocal,
  double? deletedAt,
  ListForDayResultLogsItemDrink? drink,
  DrinkId drinkId,
  ListForDayResultLogsItemLocation? location,
  SessionId? sessionId,
  double updatedAt,
  UserId userId,
  double volumeMl,
});

Map<String, dynamic> _encodeListForDayResultLogsItem(
  ListForDayResultLogsItem value$,
) {
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
      final v$ => _encodeListForDayResultLogsItemDrink(v$),
    },
    'drinkId': drinkId.value,
    'location': switch (location) {
      null => null,
      final v$ => _encodeListForDayResultLogsItemLocation(v$),
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

ListForDayResultLogsItem _decodeListForDayResultLogsItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListForDayResultLogsItem');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for ListForDayResultLogsItem',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListForDayResultLogsItem',
    );
  }
  if (!map.containsKey('consumedAt')) {
    throw FormatException(
      'Missing required field "consumedAt" for ListForDayResultLogsItem',
    );
  }
  if (!map.containsKey('consumedAtLocal')) {
    throw FormatException(
      'Missing required field "consumedAtLocal" for ListForDayResultLogsItem',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for ListForDayResultLogsItem',
    );
  }
  if (!map.containsKey('drink')) {
    throw FormatException(
      'Missing required field "drink" for ListForDayResultLogsItem',
    );
  }
  if (!map.containsKey('drinkId')) {
    throw FormatException(
      'Missing required field "drinkId" for ListForDayResultLogsItem',
    );
  }
  if (!map.containsKey('location')) {
    throw FormatException(
      'Missing required field "location" for ListForDayResultLogsItem',
    );
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for ListForDayResultLogsItem',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for ListForDayResultLogsItem',
    );
  }
  if (!map.containsKey('userId')) {
    throw FormatException(
      'Missing required field "userId" for ListForDayResultLogsItem',
    );
  }
  if (!map.containsKey('volumeMl')) {
    throw FormatException(
      'Missing required field "volumeMl" for ListForDayResultLogsItem',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'ListForDayResultLogsItemCreationTime',
    ),
    id: DrinkLogId(
      expectString(map['_id'], label: 'ListForDayResultLogsItemId'),
    ),
    consumedAt: expectDouble(
      map['consumedAt'],
      label: 'ListForDayResultLogsItemConsumedAt',
    ),
    consumedAtLocal: expectString(
      map['consumedAtLocal'],
      label: 'ListForDayResultLogsItemConsumedAtLocal',
    ),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(
            map['deletedAt'],
            label: 'ListForDayResultLogsItemDeletedAt',
          ),
    drink: map['drink'] == null
        ? null
        : _decodeListForDayResultLogsItemDrink(map['drink']),
    drinkId: DrinkId(
      expectString(map['drinkId'], label: 'ListForDayResultLogsItemDrinkId'),
    ),
    location: map['location'] == null
        ? null
        : _decodeListForDayResultLogsItemLocation(map['location']),
    sessionId: map['sessionId'] == null
        ? null
        : SessionId(
            expectString(
              map['sessionId'],
              label: 'ListForDayResultLogsItemSessionId',
            ),
          ),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'ListForDayResultLogsItemUpdatedAt',
    ),
    userId: UserId(
      expectString(map['userId'], label: 'ListForDayResultLogsItemUserId'),
    ),
    volumeMl: expectDouble(
      map['volumeMl'],
      label: 'ListForDayResultLogsItemVolumeMl',
    ),
  );
}

enum ListForDayResultSessionsItemKind {
  sessionValue('session'),
  partyValue('party');

  const ListForDayResultSessionsItemKind(this.value);
  final Object? value;

  static ListForDayResultSessionsItemKind fromJson(dynamic raw) {
    switch (raw) {
      case 'session':
        return ListForDayResultSessionsItemKind.sessionValue;
      case 'party':
        return ListForDayResultSessionsItemKind.partyValue;
      default:
        throw FormatException(
          'Expected one of session, party for ListForDayResultSessionsItemKind',
        );
    }
  }
}

typedef ListForDayResultSessionsItem = ({
  SessionId id,
  String description,
  String? endedAtLocal,
  ListForDayResultSessionsItemKind kind,
  String name,
  String startedAtLocal,
});

Map<String, dynamic> _encodeListForDayResultSessionsItem(
  ListForDayResultSessionsItem value$,
) {
  final (
    id: id,
    description: description,
    endedAtLocal: endedAtLocal,
    kind: kind,
    name: name,
    startedAtLocal: startedAtLocal,
  ) = value$;
  return <String, dynamic>{
    '_id': id.value,
    'description': description,
    'endedAtLocal': endedAtLocal,
    'kind': kind.value,
    'name': name,
    'startedAtLocal': startedAtLocal,
  };
}

ListForDayResultSessionsItem _decodeListForDayResultSessionsItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListForDayResultSessionsItem');
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListForDayResultSessionsItem',
    );
  }
  if (!map.containsKey('description')) {
    throw FormatException(
      'Missing required field "description" for ListForDayResultSessionsItem',
    );
  }
  if (!map.containsKey('endedAtLocal')) {
    throw FormatException(
      'Missing required field "endedAtLocal" for ListForDayResultSessionsItem',
    );
  }
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListForDayResultSessionsItem',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException(
      'Missing required field "name" for ListForDayResultSessionsItem',
    );
  }
  if (!map.containsKey('startedAtLocal')) {
    throw FormatException(
      'Missing required field "startedAtLocal" for ListForDayResultSessionsItem',
    );
  }
  return (
    id: SessionId(
      expectString(map['_id'], label: 'ListForDayResultSessionsItemId'),
    ),
    description: expectString(
      map['description'],
      label: 'ListForDayResultSessionsItemDescription',
    ),
    endedAtLocal: map['endedAtLocal'] == null
        ? null
        : expectString(
            map['endedAtLocal'],
            label: 'ListForDayResultSessionsItemEndedAtLocal',
          ),
    kind: ListForDayResultSessionsItemKind.fromJson(map['kind']),
    name: expectString(map['name'], label: 'ListForDayResultSessionsItemName'),
    startedAtLocal: expectString(
      map['startedAtLocal'],
      label: 'ListForDayResultSessionsItemStartedAtLocal',
    ),
  );
}

typedef ListForDayResult = ({
  String date,
  List<ListForDayResultLogsItem> logs,
  List<ListForDayResultSessionsItem> sessions,
  String today,
});

Map<String, dynamic> _encodeListForDayResult(ListForDayResult value$) {
  final (date: date, logs: logs, sessions: sessions, today: today) = value$;
  return <String, dynamic>{
    'date': date,
    'logs': logs.map((item) => _encodeListForDayResultLogsItem(item)).toList(),
    'sessions': sessions
        .map((item) => _encodeListForDayResultSessionsItem(item))
        .toList(),
    'today': today,
  };
}

ListForDayResult _decodeListForDayResult(dynamic raw) {
  final map = expectMap(raw, label: 'ListForDayResult');
  if (!map.containsKey('date')) {
    throw FormatException('Missing required field "date" for ListForDayResult');
  }
  if (!map.containsKey('logs')) {
    throw FormatException('Missing required field "logs" for ListForDayResult');
  }
  if (!map.containsKey('sessions')) {
    throw FormatException(
      'Missing required field "sessions" for ListForDayResult',
    );
  }
  if (!map.containsKey('today')) {
    throw FormatException(
      'Missing required field "today" for ListForDayResult',
    );
  }
  return (
    date: expectString(map['date'], label: 'ListForDayResultDate'),
    logs: expectList(
      map['logs'],
      label: 'ListForDayResultLogs',
    ).map((item) => _decodeListForDayResultLogsItem(item)).toList(),
    sessions: expectList(
      map['sessions'],
      label: 'ListForDayResultSessions',
    ).map((item) => _decodeListForDayResultSessionsItem(item)).toList(),
    today: expectString(map['today'], label: 'ListForDayResultToday'),
  );
}

typedef ListForDayArgs = ({double at, Optional<String> date});

Map<String, dynamic> _encodeListForDayArgs(ListForDayArgs value$) {
  final (at: at, date: date) = value$;
  return <String, dynamic>{'at': at, if (date.isDefined) 'date': date.value};
}

ListForDayArgs _decodeListForDayArgs(dynamic raw) {
  final map = expectMap(raw, label: 'ListForDayArgs');
  if (!map.containsKey('at')) {
    throw FormatException('Missing required field "at" for ListForDayArgs');
  }
  return (
    at: expectDouble(map['at'], label: 'ListForDayArgsAt'),
    date: map.containsKey('date')
        ? Optional.of(expectString(map['date'], label: 'ListForDayArgsDate'))
        : const Optional.absent(),
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

final ConvexQueryReference<ListForDayArgs, ListForDayResult>
listForDayQueryReference = ConvexQueryReference(
  name: 'drinkLog:listForDay',
  encode: (args) => _encodeListForDayArgs(args),
  decodeArgs: (raw) => _decodeListForDayArgs(raw),
  decode: (raw) => _decodeListForDayResult(raw),
  encodeResult: (value) => _encodeListForDayResult(value),
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
