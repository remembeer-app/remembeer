// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class DrinkApi {
  const DrinkApi(this._client);

  final ConvexFunctionCaller _client;

  Future<DrinkId> create({
    required double alcoholPercentage,
    required DrinkCategory drinkCategory,
    required String name,
  }) async {
    final raw$ = await _client.mutate(
      'drink:create',
      _encodeCreateArgs((
        alcoholPercentage: alcoholPercentage,
        drinkCategory: drinkCategory,
        name: name,
      )),
    );
    return DrinkId(expectString(raw$, label: 'CreateResult'));
  }

  ConvexMutationReference<CreateArgs, DrinkId> get createMutation =>
      createMutationReference;

  Future<DrinkDocument> getValue({required DrinkId id}) async {
    final raw$ = await _client.query('drink:get', _encodeGetTypeArgs((id: id)));
    return _decodeDrinkDocument(raw$);
  }

  TypedConvexSubscription<DrinkDocument> getValueSubscribe({
    required DrinkId id,
  }) {
    final subscription$ = _client.subscribe(
      'drink:get',
      _encodeGetTypeArgs((id: id)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<DrinkDocument>(_decodeDrinkDocument(value));
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<DrinkDocument>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<DrinkDocument>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<DrinkDocument>(subscription$, typedStream$);
  }

  ConvexQueryReference<GetTypeArgs, DrinkDocument> get getValueQuery =>
      getValueQueryReference;

  Future<List<DrinkDocument>> listAvailable() async {
    final raw$ = await _client.query(
      'drink:listAvailable',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListAvailableResult',
    ).map((item) => _decodeDrinkDocument(item)).toList();
  }

  TypedConvexSubscription<List<DrinkDocument>> listAvailableSubscribe() {
    final subscription$ = _client.subscribe(
      'drink:listAvailable',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<DrinkDocument>>(
            expectList(
              value,
              label: 'ListAvailableResult',
            ).map((item) => _decodeDrinkDocument(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<DrinkDocument>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<DrinkDocument>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<DrinkDocument>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<NoArgs, List<DrinkDocument>> get listAvailableQuery =>
      listAvailableQueryReference;

  Future<List<DrinkDocument>> listCustom() async {
    final raw$ = await _client.query(
      'drink:listCustom',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListCustomResult',
    ).map((item) => _decodeDrinkDocument(item)).toList();
  }

  TypedConvexSubscription<List<DrinkDocument>> listCustomSubscribe() {
    final subscription$ = _client.subscribe(
      'drink:listCustom',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<DrinkDocument>>(
            expectList(
              value,
              label: 'ListCustomResult',
            ).map((item) => _decodeDrinkDocument(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<DrinkDocument>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<DrinkDocument>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<DrinkDocument>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<NoArgs, List<DrinkDocument>> get listCustomQuery =>
      listCustomQueryReference;

  Future<Null> softDelete({required DrinkId id}) async {
    await _client.mutate('drink:softDelete', _encodeSoftDeleteArgs((id: id)));
    return null;
  }

  ConvexMutationReference<SoftDeleteArgs, void> get softDeleteMutation =>
      softDeleteMutationReference;

  Future<Null> update({
    Optional<double> alcoholPercentage = const Optional.absent(),
    Optional<DrinkCategory> drinkCategory = const Optional.absent(),
    required DrinkId id,
    Optional<String> name = const Optional.absent(),
  }) async {
    await _client.mutate(
      'drink:update',
      _encodeUpdateArgs((
        alcoholPercentage: alcoholPercentage,
        drinkCategory: drinkCategory,
        id: id,
        name: name,
      )),
    );
    return null;
  }

  ConvexMutationReference<UpdateArgs, void> get updateMutation =>
      updateMutationReference;
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

Map<String, dynamic> _encodeDrinkDocument(DrinkDocument value$) {
  final (
    ownerId: ownerId,
    seedKey: seedKey,
    name: name,
    drinkCategory: drinkCategory,
    alcoholPercentage: alcoholPercentage,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    id: id,
    creationTime: creationTime,
  ) = value$;
  return <String, dynamic>{
    'ownerId': switch (ownerId) {
      null => null,
      final v$ => v$.value,
    },
    if (seedKey.isDefined) 'seedKey': seedKey.value,
    'name': name,
    'drinkCategory': _encodeDrinkCategory(drinkCategory),
    'alcoholPercentage': alcoholPercentage,
    'updatedAt': updatedAt,
    'deletedAt': deletedAt,
    '_id': id.value,
    '_creationTime': creationTime,
  };
}

DrinkDocument _decodeDrinkDocument(dynamic raw) {
  final map = expectMap(raw, label: 'DrinkDocument');
  if (!map.containsKey('ownerId')) {
    throw FormatException('Missing required field "ownerId" for DrinkDocument');
  }
  if (!map.containsKey('name')) {
    throw FormatException('Missing required field "name" for DrinkDocument');
  }
  if (!map.containsKey('drinkCategory')) {
    throw FormatException(
      'Missing required field "drinkCategory" for DrinkDocument',
    );
  }
  if (!map.containsKey('alcoholPercentage')) {
    throw FormatException(
      'Missing required field "alcoholPercentage" for DrinkDocument',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for DrinkDocument',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for DrinkDocument',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException('Missing required field "_id" for DrinkDocument');
  }
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for DrinkDocument',
    );
  }
  return (
    ownerId: map['ownerId'] == null
        ? null
        : UserId(expectString(map['ownerId'], label: 'DrinkDocumentOwnerId')),
    seedKey: map.containsKey('seedKey')
        ? Optional.of(
            expectString(map['seedKey'], label: 'DrinkDocumentSeedKey'),
          )
        : const Optional.absent(),
    name: expectString(map['name'], label: 'DrinkDocumentName'),
    drinkCategory: _decodeDrinkCategory(map['drinkCategory']),
    alcoholPercentage: expectDouble(
      map['alcoholPercentage'],
      label: 'DrinkDocumentAlcoholPercentage',
    ),
    updatedAt: expectDouble(map['updatedAt'], label: 'DrinkDocumentUpdatedAt'),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(map['deletedAt'], label: 'DrinkDocumentDeletedAt'),
    id: DrinkId(expectString(map['_id'], label: 'DrinkDocumentId')),
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'DrinkDocumentCreationTime',
    ),
  );
}

typedef GetTypeArgs = ({DrinkId id});

Map<String, dynamic> _encodeGetTypeArgs(GetTypeArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

GetTypeArgs _decodeGetTypeArgs(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for GetTypeArgs');
  }
  return (id: DrinkId(expectString(map['id'], label: 'GetTypeArgsId')));
}

typedef SoftDeleteArgs = ({DrinkId id});

Map<String, dynamic> _encodeSoftDeleteArgs(SoftDeleteArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

SoftDeleteArgs _decodeSoftDeleteArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SoftDeleteArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for SoftDeleteArgs');
  }
  return (id: DrinkId(expectString(map['id'], label: 'SoftDeleteArgsId')));
}

typedef UpdateArgs = ({
  Optional<double> alcoholPercentage,
  Optional<DrinkCategory> drinkCategory,
  DrinkId id,
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
    id: DrinkId(expectString(map['id'], label: 'UpdateArgsId')),
    name: map.containsKey('name')
        ? Optional.of(expectString(map['name'], label: 'UpdateArgsName'))
        : const Optional.absent(),
  );
}

final ConvexMutationReference<CreateArgs, DrinkId> createMutationReference =
    ConvexMutationReference(
      name: 'drink:create',
      encode: (args) => _encodeCreateArgs(args),
      decode: (raw) => DrinkId(expectString(raw, label: 'CreateResult')),
    );

final ConvexQueryReference<GetTypeArgs, DrinkDocument> getValueQueryReference =
    ConvexQueryReference(
      name: 'drink:get',
      encode: (args) => _encodeGetTypeArgs(args),
      decodeArgs: (raw) => _decodeGetTypeArgs(raw),
      decode: (raw) => _decodeDrinkDocument(raw),
      encodeResult: (value) => _encodeDrinkDocument(value),
    );

final ConvexQueryReference<NoArgs, List<DrinkDocument>>
listAvailableQueryReference = ConvexQueryReference(
  name: 'drink:listAvailable',
  encode: (args) => const <String, dynamic>{},
  decodeArgs: (raw) => const NoArgs(),
  decode: (raw) => expectList(
    raw,
    label: 'ListAvailableResult',
  ).map((item) => _decodeDrinkDocument(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeDrinkDocument(item)).toList(),
);

final ConvexQueryReference<NoArgs, List<DrinkDocument>>
listCustomQueryReference = ConvexQueryReference(
  name: 'drink:listCustom',
  encode: (args) => const <String, dynamic>{},
  decodeArgs: (raw) => const NoArgs(),
  decode: (raw) => expectList(
    raw,
    label: 'ListCustomResult',
  ).map((item) => _decodeDrinkDocument(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeDrinkDocument(item)).toList(),
);

final ConvexMutationReference<SoftDeleteArgs, void>
softDeleteMutationReference = ConvexMutationReference(
  name: 'drink:softDelete',
  encode: (args) => _encodeSoftDeleteArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<UpdateArgs, void> updateMutationReference =
    ConvexMutationReference(
      name: 'drink:update',
      encode: (args) => _encodeUpdateArgs(args),
      decode: (raw) => null,
    );
