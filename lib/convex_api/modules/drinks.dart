// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class DrinksApi {
  const DrinksApi(this._client);

  final ConvexFunctionCaller _client;

  Future<DrinksId> create({
    required double alcoholPercentage,
    required DrinkCategory drinkCategory,
    required String name,
  }) async {
    final raw$ = await _client.mutate(
      'drinks:create',
      _encodeCreateArgs((
        alcoholPercentage: alcoholPercentage,
        drinkCategory: drinkCategory,
        name: name,
      )),
    );
    return DrinksId(expectString(raw$, label: 'CreateResult'));
  }

  Future<GetTypeResult> getValue({required DrinksId id}) async {
    final raw$ = await _client.query(
      'drinks:get',
      _encodeGetTypeArgs((id: id)),
    );
    return _decodeGetTypeResult(raw$);
  }

  TypedConvexSubscription<GetTypeResult> getValueSubscribe({
    required DrinksId id,
  }) {
    final subscription$ = _client.subscribe(
      'drinks:get',
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

  Future<List<ListAvailableResultItem>> listAvailable() async {
    final raw$ = await _client.query(
      'drinks:listAvailable',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListAvailableResult',
    ).map((item) => _decodeListAvailableResultItem(item)).toList();
  }

  TypedConvexSubscription<List<ListAvailableResultItem>>
  listAvailableSubscribe() {
    final subscription$ = _client.subscribe(
      'drinks:listAvailable',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<ListAvailableResultItem>>(
            expectList(
              value,
              label: 'ListAvailableResult',
            ).map((item) => _decodeListAvailableResultItem(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<ListAvailableResultItem>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<ListAvailableResultItem>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<ListAvailableResultItem>>(
      subscription$,
      typedStream$,
    );
  }

  Future<List<ListCustomResultItem>> listCustom() async {
    final raw$ = await _client.query(
      'drinks:listCustom',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListCustomResult',
    ).map((item) => _decodeListCustomResultItem(item)).toList();
  }

  TypedConvexSubscription<List<ListCustomResultItem>> listCustomSubscribe() {
    final subscription$ = _client.subscribe(
      'drinks:listCustom',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<ListCustomResultItem>>(
            expectList(
              value,
              label: 'ListCustomResult',
            ).map((item) => _decodeListCustomResultItem(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<ListCustomResultItem>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<ListCustomResultItem>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<ListCustomResultItem>>(
      subscription$,
      typedStream$,
    );
  }

  Future<Null> softDelete({required DrinksId id}) async {
    await _client.mutate('drinks:softDelete', _encodeSoftDeleteArgs((id: id)));
    return null;
  }

  Future<Null> update({
    Optional<double> alcoholPercentage = const Optional.absent(),
    Optional<DrinkCategory> drinkCategory = const Optional.absent(),
    required DrinksId id,
    Optional<String> name = const Optional.absent(),
  }) async {
    await _client.mutate(
      'drinks:update',
      _encodeUpdateArgs((
        alcoholPercentage: alcoholPercentage,
        drinkCategory: drinkCategory,
        id: id,
        name: name,
      )),
    );
    return null;
  }
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

typedef CreateArgs = ({
  double alcoholPercentage,
  DrinkCategory drinkCategory,
  String name,
});

Map<String, dynamic> _encodeCreateArgs(CreateArgs value$) {
  final (
    alcoholPercentage: alcoholPercentage,
    drinkCategory: drinkCategory,
    name: name,
  ) = value$;
  return <String, dynamic>{
    'alcoholPercentage': alcoholPercentage,
    'drinkCategory': _encodeDrinkCategory(drinkCategory),
    'name': name,
  };
}

CreateArgs _decodeCreateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgs');
  if (!map.containsKey('alcoholPercentage')) {
    throw FormatException(
      'Missing required field "alcoholPercentage" for CreateArgs',
    );
  }
  if (!map.containsKey('drinkCategory')) {
    throw FormatException(
      'Missing required field "drinkCategory" for CreateArgs',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException('Missing required field "name" for CreateArgs');
  }
  return (
    alcoholPercentage: expectDouble(
      map['alcoholPercentage'],
      label: 'CreateArgsAlcoholPercentage',
    ),
    drinkCategory: _decodeDrinkCategory(map['drinkCategory']),
    name: expectString(map['name'], label: 'CreateArgsName'),
  );
}

typedef GetTypeResult = ({
  double creationTime,
  DrinksId id,
  double alcoholPercentage,
  double? deletedAt,
  DrinkCategory drinkCategory,
  String name,
  UsersId? ownerId,
  double updatedAt,
});

Map<String, dynamic> _encodeGetTypeResult(GetTypeResult value$) {
  final (
    creationTime: creationTime,
    id: id,
    alcoholPercentage: alcoholPercentage,
    deletedAt: deletedAt,
    drinkCategory: drinkCategory,
    name: name,
    ownerId: ownerId,
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
    'updatedAt': updatedAt,
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
  if (!map.containsKey('alcoholPercentage')) {
    throw FormatException(
      'Missing required field "alcoholPercentage" for GetTypeResult',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for GetTypeResult',
    );
  }
  if (!map.containsKey('drinkCategory')) {
    throw FormatException(
      'Missing required field "drinkCategory" for GetTypeResult',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException('Missing required field "name" for GetTypeResult');
  }
  if (!map.containsKey('ownerId')) {
    throw FormatException('Missing required field "ownerId" for GetTypeResult');
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for GetTypeResult',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'GetTypeResultCreationTime',
    ),
    id: DrinksId(expectString(map['_id'], label: 'GetTypeResultId')),
    alcoholPercentage: expectDouble(
      map['alcoholPercentage'],
      label: 'GetTypeResultAlcoholPercentage',
    ),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(map['deletedAt'], label: 'GetTypeResultDeletedAt'),
    drinkCategory: _decodeDrinkCategory(map['drinkCategory']),
    name: expectString(map['name'], label: 'GetTypeResultName'),
    ownerId: map['ownerId'] == null
        ? null
        : UsersId(expectString(map['ownerId'], label: 'GetTypeResultOwnerId')),
    updatedAt: expectDouble(map['updatedAt'], label: 'GetTypeResultUpdatedAt'),
  );
}

typedef GetTypeArgs = ({DrinksId id});

Map<String, dynamic> _encodeGetTypeArgs(GetTypeArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

GetTypeArgs _decodeGetTypeArgs(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for GetTypeArgs');
  }
  return (id: DrinksId(expectString(map['id'], label: 'GetTypeArgsId')));
}

typedef ListAvailableResultItem = ({
  double creationTime,
  DrinksId id,
  double alcoholPercentage,
  double? deletedAt,
  DrinkCategory drinkCategory,
  String name,
  UsersId? ownerId,
  double updatedAt,
});

Map<String, dynamic> _encodeListAvailableResultItem(
  ListAvailableResultItem value$,
) {
  final (
    creationTime: creationTime,
    id: id,
    alcoholPercentage: alcoholPercentage,
    deletedAt: deletedAt,
    drinkCategory: drinkCategory,
    name: name,
    ownerId: ownerId,
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
    'updatedAt': updatedAt,
  };
}

ListAvailableResultItem _decodeListAvailableResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListAvailableResultItem');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for ListAvailableResultItem',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListAvailableResultItem',
    );
  }
  if (!map.containsKey('alcoholPercentage')) {
    throw FormatException(
      'Missing required field "alcoholPercentage" for ListAvailableResultItem',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for ListAvailableResultItem',
    );
  }
  if (!map.containsKey('drinkCategory')) {
    throw FormatException(
      'Missing required field "drinkCategory" for ListAvailableResultItem',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException(
      'Missing required field "name" for ListAvailableResultItem',
    );
  }
  if (!map.containsKey('ownerId')) {
    throw FormatException(
      'Missing required field "ownerId" for ListAvailableResultItem',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for ListAvailableResultItem',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'ListAvailableResultItemCreationTime',
    ),
    id: DrinksId(expectString(map['_id'], label: 'ListAvailableResultItemId')),
    alcoholPercentage: expectDouble(
      map['alcoholPercentage'],
      label: 'ListAvailableResultItemAlcoholPercentage',
    ),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(
            map['deletedAt'],
            label: 'ListAvailableResultItemDeletedAt',
          ),
    drinkCategory: _decodeDrinkCategory(map['drinkCategory']),
    name: expectString(map['name'], label: 'ListAvailableResultItemName'),
    ownerId: map['ownerId'] == null
        ? null
        : UsersId(
            expectString(
              map['ownerId'],
              label: 'ListAvailableResultItemOwnerId',
            ),
          ),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'ListAvailableResultItemUpdatedAt',
    ),
  );
}

typedef ListCustomResultItem = ({
  double creationTime,
  DrinksId id,
  double alcoholPercentage,
  double? deletedAt,
  DrinkCategory drinkCategory,
  String name,
  UsersId? ownerId,
  double updatedAt,
});

Map<String, dynamic> _encodeListCustomResultItem(ListCustomResultItem value$) {
  final (
    creationTime: creationTime,
    id: id,
    alcoholPercentage: alcoholPercentage,
    deletedAt: deletedAt,
    drinkCategory: drinkCategory,
    name: name,
    ownerId: ownerId,
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
    'updatedAt': updatedAt,
  };
}

ListCustomResultItem _decodeListCustomResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListCustomResultItem');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for ListCustomResultItem',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListCustomResultItem',
    );
  }
  if (!map.containsKey('alcoholPercentage')) {
    throw FormatException(
      'Missing required field "alcoholPercentage" for ListCustomResultItem',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for ListCustomResultItem',
    );
  }
  if (!map.containsKey('drinkCategory')) {
    throw FormatException(
      'Missing required field "drinkCategory" for ListCustomResultItem',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException(
      'Missing required field "name" for ListCustomResultItem',
    );
  }
  if (!map.containsKey('ownerId')) {
    throw FormatException(
      'Missing required field "ownerId" for ListCustomResultItem',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for ListCustomResultItem',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'ListCustomResultItemCreationTime',
    ),
    id: DrinksId(expectString(map['_id'], label: 'ListCustomResultItemId')),
    alcoholPercentage: expectDouble(
      map['alcoholPercentage'],
      label: 'ListCustomResultItemAlcoholPercentage',
    ),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(
            map['deletedAt'],
            label: 'ListCustomResultItemDeletedAt',
          ),
    drinkCategory: _decodeDrinkCategory(map['drinkCategory']),
    name: expectString(map['name'], label: 'ListCustomResultItemName'),
    ownerId: map['ownerId'] == null
        ? null
        : UsersId(
            expectString(map['ownerId'], label: 'ListCustomResultItemOwnerId'),
          ),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'ListCustomResultItemUpdatedAt',
    ),
  );
}

typedef SoftDeleteArgs = ({DrinksId id});

Map<String, dynamic> _encodeSoftDeleteArgs(SoftDeleteArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

SoftDeleteArgs _decodeSoftDeleteArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SoftDeleteArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for SoftDeleteArgs');
  }
  return (id: DrinksId(expectString(map['id'], label: 'SoftDeleteArgsId')));
}

typedef UpdateArgs = ({
  Optional<double> alcoholPercentage,
  Optional<DrinkCategory> drinkCategory,
  DrinksId id,
  Optional<String> name,
});

Map<String, dynamic> _encodeUpdateArgs(UpdateArgs value$) {
  final (
    alcoholPercentage: alcoholPercentage,
    drinkCategory: drinkCategory,
    id: id,
    name: name,
  ) = value$;
  return <String, dynamic>{
    if (alcoholPercentage.isDefined)
      'alcoholPercentage': alcoholPercentage.value,
    if (drinkCategory.isDefined)
      'drinkCategory': _encodeDrinkCategory(drinkCategory.value),
    'id': id.value,
    if (name.isDefined) 'name': name.value,
  };
}

UpdateArgs _decodeUpdateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for UpdateArgs');
  }
  return (
    alcoholPercentage: map.containsKey('alcoholPercentage')
        ? Optional.of(
            expectDouble(
              map['alcoholPercentage'],
              label: 'UpdateArgsAlcoholPercentage',
            ),
          )
        : const Optional.absent(),
    drinkCategory: map.containsKey('drinkCategory')
        ? Optional.of(_decodeDrinkCategory(map['drinkCategory']))
        : const Optional.absent(),
    id: DrinksId(expectString(map['id'], label: 'UpdateArgsId')),
    name: map.containsKey('name')
        ? Optional.of(expectString(map['name'], label: 'UpdateArgsName'))
        : const Optional.absent(),
  );
}
