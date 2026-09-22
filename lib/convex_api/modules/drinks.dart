// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class DrinksApi {
  const DrinksApi(this._client);

  final ConvexFunctionCaller _client;

  Future<DrinksId> create({
    required double alcoholPercentage,
    required CreateArgsCategory category,
    required String name,
  }) async {
    final raw$ = await _client.mutate(
      'drinks:create',
      _encodeCreateArgs((
        alcoholPercentage: alcoholPercentage,
        category: category,
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

  Future<List<ListMineResultItem>> listMine() async {
    final raw$ = await _client.query(
      'drinks:listMine',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListMineResult',
    ).map((item) => _decodeListMineResultItem(item)).toList();
  }

  TypedConvexSubscription<List<ListMineResultItem>> listMineSubscribe() {
    final subscription$ = _client.subscribe(
      'drinks:listMine',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<ListMineResultItem>>(
            expectList(
              value,
              label: 'ListMineResult',
            ).map((item) => _decodeListMineResultItem(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<ListMineResultItem>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<ListMineResultItem>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<ListMineResultItem>>(
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
    Optional<UpdateArgsCategory> category = const Optional.absent(),
    required DrinksId id,
    Optional<String> name = const Optional.absent(),
  }) async {
    await _client.mutate(
      'drinks:update',
      _encodeUpdateArgs((
        alcoholPercentage: alcoholPercentage,
        category: category,
        id: id,
        name: name,
      )),
    );
    return null;
  }
}

typedef CreateArgsCategory1 = ({String kind});

Map<String, dynamic> _encodeCreateArgsCategory1(CreateArgsCategory1 value$) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

CreateArgsCategory1 _decodeCreateArgsCategory1(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgsCategory1');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for CreateArgsCategory1',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'beer',
      label: 'CreateArgsCategory1Kind',
    ),
  );
}

typedef CreateArgsCategory2 = ({String kind});

Map<String, dynamic> _encodeCreateArgsCategory2(CreateArgsCategory2 value$) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

CreateArgsCategory2 _decodeCreateArgsCategory2(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgsCategory2');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for CreateArgsCategory2',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cider',
      label: 'CreateArgsCategory2Kind',
    ),
  );
}

typedef CreateArgsCategory3 = ({String kind});

Map<String, dynamic> _encodeCreateArgsCategory3(CreateArgsCategory3 value$) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

CreateArgsCategory3 _decodeCreateArgsCategory3(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgsCategory3');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for CreateArgsCategory3',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cocktail',
      label: 'CreateArgsCategory3Kind',
    ),
  );
}

typedef CreateArgsCategory4 = ({String kind});

Map<String, dynamic> _encodeCreateArgsCategory4(CreateArgsCategory4 value$) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

CreateArgsCategory4 _decodeCreateArgsCategory4(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgsCategory4');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for CreateArgsCategory4',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'spirit',
      label: 'CreateArgsCategory4Kind',
    ),
  );
}

typedef CreateArgsCategory5 = ({String kind});

Map<String, dynamic> _encodeCreateArgsCategory5(CreateArgsCategory5 value$) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

CreateArgsCategory5 _decodeCreateArgsCategory5(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgsCategory5');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for CreateArgsCategory5',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'wine',
      label: 'CreateArgsCategory5Kind',
    ),
  );
}

sealed class CreateArgsCategory {
  const CreateArgsCategory();
}

class CreateArgsCategory1Value extends CreateArgsCategory {
  const CreateArgsCategory1Value(this.value);
  final CreateArgsCategory1 value;
}

class CreateArgsCategory2Value extends CreateArgsCategory {
  const CreateArgsCategory2Value(this.value);
  final CreateArgsCategory2 value;
}

class CreateArgsCategory3Value extends CreateArgsCategory {
  const CreateArgsCategory3Value(this.value);
  final CreateArgsCategory3 value;
}

class CreateArgsCategory4Value extends CreateArgsCategory {
  const CreateArgsCategory4Value(this.value);
  final CreateArgsCategory4 value;
}

class CreateArgsCategory5Value extends CreateArgsCategory {
  const CreateArgsCategory5Value(this.value);
  final CreateArgsCategory5 value;
}

dynamic _encodeCreateArgsCategory(CreateArgsCategory value) {
  switch (value) {
    case CreateArgsCategory1Value(value: final inner):
      return _encodeCreateArgsCategory1(inner);
    case CreateArgsCategory2Value(value: final inner):
      return _encodeCreateArgsCategory2(inner);
    case CreateArgsCategory3Value(value: final inner):
      return _encodeCreateArgsCategory3(inner);
    case CreateArgsCategory4Value(value: final inner):
      return _encodeCreateArgsCategory4(inner);
    case CreateArgsCategory5Value(value: final inner):
      return _encodeCreateArgsCategory5(inner);
  }
}

CreateArgsCategory _decodeCreateArgsCategory(dynamic raw) {
  final errors = <String>[];
  try {
    return CreateArgsCategory1Value(_decodeCreateArgsCategory1(raw));
  } catch (e) {
    errors.add('CreateArgsCategory1Value: $e');
  }
  try {
    return CreateArgsCategory2Value(_decodeCreateArgsCategory2(raw));
  } catch (e) {
    errors.add('CreateArgsCategory2Value: $e');
  }
  try {
    return CreateArgsCategory3Value(_decodeCreateArgsCategory3(raw));
  } catch (e) {
    errors.add('CreateArgsCategory3Value: $e');
  }
  try {
    return CreateArgsCategory4Value(_decodeCreateArgsCategory4(raw));
  } catch (e) {
    errors.add('CreateArgsCategory4Value: $e');
  }
  try {
    return CreateArgsCategory5Value(_decodeCreateArgsCategory5(raw));
  } catch (e) {
    errors.add('CreateArgsCategory5Value: $e');
  }
  throw FormatException(
    'Expected CreateArgsCategory but received ${describeType(raw)}.\n'
    'Tried: ${errors.join(", ")}',
  );
}

typedef CreateArgs = ({
  double alcoholPercentage,
  CreateArgsCategory category,
  String name,
});

Map<String, dynamic> _encodeCreateArgs(CreateArgs value$) {
  final (alcoholPercentage: alcoholPercentage, category: category, name: name) =
      value$;
  return <String, dynamic>{
    'alcoholPercentage': alcoholPercentage,
    'category': _encodeCreateArgsCategory(category),
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
  if (!map.containsKey('category')) {
    throw FormatException('Missing required field "category" for CreateArgs');
  }
  if (!map.containsKey('name')) {
    throw FormatException('Missing required field "name" for CreateArgs');
  }
  return (
    alcoholPercentage: expectDouble(
      map['alcoholPercentage'],
      label: 'CreateArgsAlcoholPercentage',
    ),
    category: _decodeCreateArgsCategory(map['category']),
    name: expectString(map['name'], label: 'CreateArgsName'),
  );
}

typedef GetTypeResultCategory1 = ({String kind});

Map<String, dynamic> _encodeGetTypeResultCategory1(
  GetTypeResultCategory1 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

GetTypeResultCategory1 _decodeGetTypeResultCategory1(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResultCategory1');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for GetTypeResultCategory1',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'beer',
      label: 'GetTypeResultCategory1Kind',
    ),
  );
}

typedef GetTypeResultCategory2 = ({String kind});

Map<String, dynamic> _encodeGetTypeResultCategory2(
  GetTypeResultCategory2 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

GetTypeResultCategory2 _decodeGetTypeResultCategory2(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResultCategory2');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for GetTypeResultCategory2',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cider',
      label: 'GetTypeResultCategory2Kind',
    ),
  );
}

typedef GetTypeResultCategory3 = ({String kind});

Map<String, dynamic> _encodeGetTypeResultCategory3(
  GetTypeResultCategory3 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

GetTypeResultCategory3 _decodeGetTypeResultCategory3(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResultCategory3');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for GetTypeResultCategory3',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cocktail',
      label: 'GetTypeResultCategory3Kind',
    ),
  );
}

typedef GetTypeResultCategory4 = ({String kind});

Map<String, dynamic> _encodeGetTypeResultCategory4(
  GetTypeResultCategory4 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

GetTypeResultCategory4 _decodeGetTypeResultCategory4(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResultCategory4');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for GetTypeResultCategory4',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'spirit',
      label: 'GetTypeResultCategory4Kind',
    ),
  );
}

typedef GetTypeResultCategory5 = ({String kind});

Map<String, dynamic> _encodeGetTypeResultCategory5(
  GetTypeResultCategory5 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

GetTypeResultCategory5 _decodeGetTypeResultCategory5(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResultCategory5');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for GetTypeResultCategory5',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'wine',
      label: 'GetTypeResultCategory5Kind',
    ),
  );
}

sealed class GetTypeResultCategory {
  const GetTypeResultCategory();
}

class GetTypeResultCategory1Value extends GetTypeResultCategory {
  const GetTypeResultCategory1Value(this.value);
  final GetTypeResultCategory1 value;
}

class GetTypeResultCategory2Value extends GetTypeResultCategory {
  const GetTypeResultCategory2Value(this.value);
  final GetTypeResultCategory2 value;
}

class GetTypeResultCategory3Value extends GetTypeResultCategory {
  const GetTypeResultCategory3Value(this.value);
  final GetTypeResultCategory3 value;
}

class GetTypeResultCategory4Value extends GetTypeResultCategory {
  const GetTypeResultCategory4Value(this.value);
  final GetTypeResultCategory4 value;
}

class GetTypeResultCategory5Value extends GetTypeResultCategory {
  const GetTypeResultCategory5Value(this.value);
  final GetTypeResultCategory5 value;
}

dynamic _encodeGetTypeResultCategory(GetTypeResultCategory value) {
  switch (value) {
    case GetTypeResultCategory1Value(value: final inner):
      return _encodeGetTypeResultCategory1(inner);
    case GetTypeResultCategory2Value(value: final inner):
      return _encodeGetTypeResultCategory2(inner);
    case GetTypeResultCategory3Value(value: final inner):
      return _encodeGetTypeResultCategory3(inner);
    case GetTypeResultCategory4Value(value: final inner):
      return _encodeGetTypeResultCategory4(inner);
    case GetTypeResultCategory5Value(value: final inner):
      return _encodeGetTypeResultCategory5(inner);
  }
}

GetTypeResultCategory _decodeGetTypeResultCategory(dynamic raw) {
  final errors = <String>[];
  try {
    return GetTypeResultCategory1Value(_decodeGetTypeResultCategory1(raw));
  } catch (e) {
    errors.add('GetTypeResultCategory1Value: $e');
  }
  try {
    return GetTypeResultCategory2Value(_decodeGetTypeResultCategory2(raw));
  } catch (e) {
    errors.add('GetTypeResultCategory2Value: $e');
  }
  try {
    return GetTypeResultCategory3Value(_decodeGetTypeResultCategory3(raw));
  } catch (e) {
    errors.add('GetTypeResultCategory3Value: $e');
  }
  try {
    return GetTypeResultCategory4Value(_decodeGetTypeResultCategory4(raw));
  } catch (e) {
    errors.add('GetTypeResultCategory4Value: $e');
  }
  try {
    return GetTypeResultCategory5Value(_decodeGetTypeResultCategory5(raw));
  } catch (e) {
    errors.add('GetTypeResultCategory5Value: $e');
  }
  throw FormatException(
    'Expected GetTypeResultCategory but received ${describeType(raw)}.\n'
    'Tried: ${errors.join(", ")}',
  );
}

typedef GetTypeResult = ({
  double creationTime,
  DrinksId id,
  double alcoholPercentage,
  GetTypeResultCategory category,
  double? deletedAt,
  String name,
  UsersId? ownerId,
  double updatedAt,
});

Map<String, dynamic> _encodeGetTypeResult(GetTypeResult value$) {
  final (
    creationTime: creationTime,
    id: id,
    alcoholPercentage: alcoholPercentage,
    category: category,
    deletedAt: deletedAt,
    name: name,
    ownerId: ownerId,
    updatedAt: updatedAt,
  ) = value$;
  return <String, dynamic>{
    '_creationTime': creationTime,
    '_id': id.value,
    'alcoholPercentage': alcoholPercentage,
    'category': _encodeGetTypeResultCategory(category),
    'deletedAt': deletedAt,
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
  if (!map.containsKey('category')) {
    throw FormatException(
      'Missing required field "category" for GetTypeResult',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for GetTypeResult',
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
    category: _decodeGetTypeResultCategory(map['category']),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(map['deletedAt'], label: 'GetTypeResultDeletedAt'),
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

typedef ListMineResultItemCategory1 = ({String kind});

Map<String, dynamic> _encodeListMineResultItemCategory1(
  ListMineResultItemCategory1 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListMineResultItemCategory1 _decodeListMineResultItemCategory1(dynamic raw) {
  final map = expectMap(raw, label: 'ListMineResultItemCategory1');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListMineResultItemCategory1',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'beer',
      label: 'ListMineResultItemCategory1Kind',
    ),
  );
}

typedef ListMineResultItemCategory2 = ({String kind});

Map<String, dynamic> _encodeListMineResultItemCategory2(
  ListMineResultItemCategory2 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListMineResultItemCategory2 _decodeListMineResultItemCategory2(dynamic raw) {
  final map = expectMap(raw, label: 'ListMineResultItemCategory2');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListMineResultItemCategory2',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cider',
      label: 'ListMineResultItemCategory2Kind',
    ),
  );
}

typedef ListMineResultItemCategory3 = ({String kind});

Map<String, dynamic> _encodeListMineResultItemCategory3(
  ListMineResultItemCategory3 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListMineResultItemCategory3 _decodeListMineResultItemCategory3(dynamic raw) {
  final map = expectMap(raw, label: 'ListMineResultItemCategory3');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListMineResultItemCategory3',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cocktail',
      label: 'ListMineResultItemCategory3Kind',
    ),
  );
}

typedef ListMineResultItemCategory4 = ({String kind});

Map<String, dynamic> _encodeListMineResultItemCategory4(
  ListMineResultItemCategory4 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListMineResultItemCategory4 _decodeListMineResultItemCategory4(dynamic raw) {
  final map = expectMap(raw, label: 'ListMineResultItemCategory4');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListMineResultItemCategory4',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'spirit',
      label: 'ListMineResultItemCategory4Kind',
    ),
  );
}

typedef ListMineResultItemCategory5 = ({String kind});

Map<String, dynamic> _encodeListMineResultItemCategory5(
  ListMineResultItemCategory5 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListMineResultItemCategory5 _decodeListMineResultItemCategory5(dynamic raw) {
  final map = expectMap(raw, label: 'ListMineResultItemCategory5');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListMineResultItemCategory5',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'wine',
      label: 'ListMineResultItemCategory5Kind',
    ),
  );
}

sealed class ListMineResultItemCategory {
  const ListMineResultItemCategory();
}

class ListMineResultItemCategory1Value extends ListMineResultItemCategory {
  const ListMineResultItemCategory1Value(this.value);
  final ListMineResultItemCategory1 value;
}

class ListMineResultItemCategory2Value extends ListMineResultItemCategory {
  const ListMineResultItemCategory2Value(this.value);
  final ListMineResultItemCategory2 value;
}

class ListMineResultItemCategory3Value extends ListMineResultItemCategory {
  const ListMineResultItemCategory3Value(this.value);
  final ListMineResultItemCategory3 value;
}

class ListMineResultItemCategory4Value extends ListMineResultItemCategory {
  const ListMineResultItemCategory4Value(this.value);
  final ListMineResultItemCategory4 value;
}

class ListMineResultItemCategory5Value extends ListMineResultItemCategory {
  const ListMineResultItemCategory5Value(this.value);
  final ListMineResultItemCategory5 value;
}

dynamic _encodeListMineResultItemCategory(ListMineResultItemCategory value) {
  switch (value) {
    case ListMineResultItemCategory1Value(value: final inner):
      return _encodeListMineResultItemCategory1(inner);
    case ListMineResultItemCategory2Value(value: final inner):
      return _encodeListMineResultItemCategory2(inner);
    case ListMineResultItemCategory3Value(value: final inner):
      return _encodeListMineResultItemCategory3(inner);
    case ListMineResultItemCategory4Value(value: final inner):
      return _encodeListMineResultItemCategory4(inner);
    case ListMineResultItemCategory5Value(value: final inner):
      return _encodeListMineResultItemCategory5(inner);
  }
}

ListMineResultItemCategory _decodeListMineResultItemCategory(dynamic raw) {
  final errors = <String>[];
  try {
    return ListMineResultItemCategory1Value(
      _decodeListMineResultItemCategory1(raw),
    );
  } catch (e) {
    errors.add('ListMineResultItemCategory1Value: $e');
  }
  try {
    return ListMineResultItemCategory2Value(
      _decodeListMineResultItemCategory2(raw),
    );
  } catch (e) {
    errors.add('ListMineResultItemCategory2Value: $e');
  }
  try {
    return ListMineResultItemCategory3Value(
      _decodeListMineResultItemCategory3(raw),
    );
  } catch (e) {
    errors.add('ListMineResultItemCategory3Value: $e');
  }
  try {
    return ListMineResultItemCategory4Value(
      _decodeListMineResultItemCategory4(raw),
    );
  } catch (e) {
    errors.add('ListMineResultItemCategory4Value: $e');
  }
  try {
    return ListMineResultItemCategory5Value(
      _decodeListMineResultItemCategory5(raw),
    );
  } catch (e) {
    errors.add('ListMineResultItemCategory5Value: $e');
  }
  throw FormatException(
    'Expected ListMineResultItemCategory but received ${describeType(raw)}.\n'
    'Tried: ${errors.join(", ")}',
  );
}

typedef ListMineResultItem = ({
  double creationTime,
  DrinksId id,
  double alcoholPercentage,
  ListMineResultItemCategory category,
  double? deletedAt,
  String name,
  UsersId? ownerId,
  double updatedAt,
});

Map<String, dynamic> _encodeListMineResultItem(ListMineResultItem value$) {
  final (
    creationTime: creationTime,
    id: id,
    alcoholPercentage: alcoholPercentage,
    category: category,
    deletedAt: deletedAt,
    name: name,
    ownerId: ownerId,
    updatedAt: updatedAt,
  ) = value$;
  return <String, dynamic>{
    '_creationTime': creationTime,
    '_id': id.value,
    'alcoholPercentage': alcoholPercentage,
    'category': _encodeListMineResultItemCategory(category),
    'deletedAt': deletedAt,
    'name': name,
    'ownerId': switch (ownerId) {
      null => null,
      final v$ => v$.value,
    },
    'updatedAt': updatedAt,
  };
}

ListMineResultItem _decodeListMineResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListMineResultItem');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for ListMineResultItem',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListMineResultItem',
    );
  }
  if (!map.containsKey('alcoholPercentage')) {
    throw FormatException(
      'Missing required field "alcoholPercentage" for ListMineResultItem',
    );
  }
  if (!map.containsKey('category')) {
    throw FormatException(
      'Missing required field "category" for ListMineResultItem',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for ListMineResultItem',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException(
      'Missing required field "name" for ListMineResultItem',
    );
  }
  if (!map.containsKey('ownerId')) {
    throw FormatException(
      'Missing required field "ownerId" for ListMineResultItem',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for ListMineResultItem',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'ListMineResultItemCreationTime',
    ),
    id: DrinksId(expectString(map['_id'], label: 'ListMineResultItemId')),
    alcoholPercentage: expectDouble(
      map['alcoholPercentage'],
      label: 'ListMineResultItemAlcoholPercentage',
    ),
    category: _decodeListMineResultItemCategory(map['category']),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(map['deletedAt'], label: 'ListMineResultItemDeletedAt'),
    name: expectString(map['name'], label: 'ListMineResultItemName'),
    ownerId: map['ownerId'] == null
        ? null
        : UsersId(
            expectString(map['ownerId'], label: 'ListMineResultItemOwnerId'),
          ),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'ListMineResultItemUpdatedAt',
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

typedef UpdateArgsCategory1 = ({String kind});

Map<String, dynamic> _encodeUpdateArgsCategory1(UpdateArgsCategory1 value$) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

UpdateArgsCategory1 _decodeUpdateArgsCategory1(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateArgsCategory1');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for UpdateArgsCategory1',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'beer',
      label: 'UpdateArgsCategory1Kind',
    ),
  );
}

typedef UpdateArgsCategory2 = ({String kind});

Map<String, dynamic> _encodeUpdateArgsCategory2(UpdateArgsCategory2 value$) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

UpdateArgsCategory2 _decodeUpdateArgsCategory2(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateArgsCategory2');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for UpdateArgsCategory2',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cider',
      label: 'UpdateArgsCategory2Kind',
    ),
  );
}

typedef UpdateArgsCategory3 = ({String kind});

Map<String, dynamic> _encodeUpdateArgsCategory3(UpdateArgsCategory3 value$) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

UpdateArgsCategory3 _decodeUpdateArgsCategory3(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateArgsCategory3');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for UpdateArgsCategory3',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cocktail',
      label: 'UpdateArgsCategory3Kind',
    ),
  );
}

typedef UpdateArgsCategory4 = ({String kind});

Map<String, dynamic> _encodeUpdateArgsCategory4(UpdateArgsCategory4 value$) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

UpdateArgsCategory4 _decodeUpdateArgsCategory4(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateArgsCategory4');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for UpdateArgsCategory4',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'spirit',
      label: 'UpdateArgsCategory4Kind',
    ),
  );
}

typedef UpdateArgsCategory5 = ({String kind});

Map<String, dynamic> _encodeUpdateArgsCategory5(UpdateArgsCategory5 value$) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

UpdateArgsCategory5 _decodeUpdateArgsCategory5(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateArgsCategory5');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for UpdateArgsCategory5',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'wine',
      label: 'UpdateArgsCategory5Kind',
    ),
  );
}

sealed class UpdateArgsCategory {
  const UpdateArgsCategory();
}

class UpdateArgsCategory1Value extends UpdateArgsCategory {
  const UpdateArgsCategory1Value(this.value);
  final UpdateArgsCategory1 value;
}

class UpdateArgsCategory2Value extends UpdateArgsCategory {
  const UpdateArgsCategory2Value(this.value);
  final UpdateArgsCategory2 value;
}

class UpdateArgsCategory3Value extends UpdateArgsCategory {
  const UpdateArgsCategory3Value(this.value);
  final UpdateArgsCategory3 value;
}

class UpdateArgsCategory4Value extends UpdateArgsCategory {
  const UpdateArgsCategory4Value(this.value);
  final UpdateArgsCategory4 value;
}

class UpdateArgsCategory5Value extends UpdateArgsCategory {
  const UpdateArgsCategory5Value(this.value);
  final UpdateArgsCategory5 value;
}

dynamic _encodeUpdateArgsCategory(UpdateArgsCategory value) {
  switch (value) {
    case UpdateArgsCategory1Value(value: final inner):
      return _encodeUpdateArgsCategory1(inner);
    case UpdateArgsCategory2Value(value: final inner):
      return _encodeUpdateArgsCategory2(inner);
    case UpdateArgsCategory3Value(value: final inner):
      return _encodeUpdateArgsCategory3(inner);
    case UpdateArgsCategory4Value(value: final inner):
      return _encodeUpdateArgsCategory4(inner);
    case UpdateArgsCategory5Value(value: final inner):
      return _encodeUpdateArgsCategory5(inner);
  }
}

UpdateArgsCategory _decodeUpdateArgsCategory(dynamic raw) {
  final errors = <String>[];
  try {
    return UpdateArgsCategory1Value(_decodeUpdateArgsCategory1(raw));
  } catch (e) {
    errors.add('UpdateArgsCategory1Value: $e');
  }
  try {
    return UpdateArgsCategory2Value(_decodeUpdateArgsCategory2(raw));
  } catch (e) {
    errors.add('UpdateArgsCategory2Value: $e');
  }
  try {
    return UpdateArgsCategory3Value(_decodeUpdateArgsCategory3(raw));
  } catch (e) {
    errors.add('UpdateArgsCategory3Value: $e');
  }
  try {
    return UpdateArgsCategory4Value(_decodeUpdateArgsCategory4(raw));
  } catch (e) {
    errors.add('UpdateArgsCategory4Value: $e');
  }
  try {
    return UpdateArgsCategory5Value(_decodeUpdateArgsCategory5(raw));
  } catch (e) {
    errors.add('UpdateArgsCategory5Value: $e');
  }
  throw FormatException(
    'Expected UpdateArgsCategory but received ${describeType(raw)}.\n'
    'Tried: ${errors.join(", ")}',
  );
}

typedef UpdateArgs = ({
  Optional<double> alcoholPercentage,
  Optional<UpdateArgsCategory> category,
  DrinksId id,
  Optional<String> name,
});

Map<String, dynamic> _encodeUpdateArgs(UpdateArgs value$) {
  final (
    alcoholPercentage: alcoholPercentage,
    category: category,
    id: id,
    name: name,
  ) = value$;
  return <String, dynamic>{
    if (alcoholPercentage.isDefined)
      'alcoholPercentage': alcoholPercentage.value,
    if (category.isDefined)
      'category': _encodeUpdateArgsCategory(category.value),
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
    category: map.containsKey('category')
        ? Optional.of(_decodeUpdateArgsCategory(map['category']))
        : const Optional.absent(),
    id: DrinksId(expectString(map['id'], label: 'UpdateArgsId')),
    name: map.containsKey('name')
        ? Optional.of(expectString(map['name'], label: 'UpdateArgsName'))
        : const Optional.absent(),
  );
}
