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

typedef ListAvailableResultItemCategory1 = ({String kind});

Map<String, dynamic> _encodeListAvailableResultItemCategory1(
  ListAvailableResultItemCategory1 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListAvailableResultItemCategory1 _decodeListAvailableResultItemCategory1(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListAvailableResultItemCategory1');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListAvailableResultItemCategory1',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'beer',
      label: 'ListAvailableResultItemCategory1Kind',
    ),
  );
}

typedef ListAvailableResultItemCategory2 = ({String kind});

Map<String, dynamic> _encodeListAvailableResultItemCategory2(
  ListAvailableResultItemCategory2 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListAvailableResultItemCategory2 _decodeListAvailableResultItemCategory2(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListAvailableResultItemCategory2');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListAvailableResultItemCategory2',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cider',
      label: 'ListAvailableResultItemCategory2Kind',
    ),
  );
}

typedef ListAvailableResultItemCategory3 = ({String kind});

Map<String, dynamic> _encodeListAvailableResultItemCategory3(
  ListAvailableResultItemCategory3 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListAvailableResultItemCategory3 _decodeListAvailableResultItemCategory3(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListAvailableResultItemCategory3');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListAvailableResultItemCategory3',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cocktail',
      label: 'ListAvailableResultItemCategory3Kind',
    ),
  );
}

typedef ListAvailableResultItemCategory4 = ({String kind});

Map<String, dynamic> _encodeListAvailableResultItemCategory4(
  ListAvailableResultItemCategory4 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListAvailableResultItemCategory4 _decodeListAvailableResultItemCategory4(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListAvailableResultItemCategory4');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListAvailableResultItemCategory4',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'spirit',
      label: 'ListAvailableResultItemCategory4Kind',
    ),
  );
}

typedef ListAvailableResultItemCategory5 = ({String kind});

Map<String, dynamic> _encodeListAvailableResultItemCategory5(
  ListAvailableResultItemCategory5 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListAvailableResultItemCategory5 _decodeListAvailableResultItemCategory5(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListAvailableResultItemCategory5');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListAvailableResultItemCategory5',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'wine',
      label: 'ListAvailableResultItemCategory5Kind',
    ),
  );
}

sealed class ListAvailableResultItemCategory {
  const ListAvailableResultItemCategory();
}

class ListAvailableResultItemCategory1Value
    extends ListAvailableResultItemCategory {
  const ListAvailableResultItemCategory1Value(this.value);
  final ListAvailableResultItemCategory1 value;
}

class ListAvailableResultItemCategory2Value
    extends ListAvailableResultItemCategory {
  const ListAvailableResultItemCategory2Value(this.value);
  final ListAvailableResultItemCategory2 value;
}

class ListAvailableResultItemCategory3Value
    extends ListAvailableResultItemCategory {
  const ListAvailableResultItemCategory3Value(this.value);
  final ListAvailableResultItemCategory3 value;
}

class ListAvailableResultItemCategory4Value
    extends ListAvailableResultItemCategory {
  const ListAvailableResultItemCategory4Value(this.value);
  final ListAvailableResultItemCategory4 value;
}

class ListAvailableResultItemCategory5Value
    extends ListAvailableResultItemCategory {
  const ListAvailableResultItemCategory5Value(this.value);
  final ListAvailableResultItemCategory5 value;
}

dynamic _encodeListAvailableResultItemCategory(
  ListAvailableResultItemCategory value,
) {
  switch (value) {
    case ListAvailableResultItemCategory1Value(value: final inner):
      return _encodeListAvailableResultItemCategory1(inner);
    case ListAvailableResultItemCategory2Value(value: final inner):
      return _encodeListAvailableResultItemCategory2(inner);
    case ListAvailableResultItemCategory3Value(value: final inner):
      return _encodeListAvailableResultItemCategory3(inner);
    case ListAvailableResultItemCategory4Value(value: final inner):
      return _encodeListAvailableResultItemCategory4(inner);
    case ListAvailableResultItemCategory5Value(value: final inner):
      return _encodeListAvailableResultItemCategory5(inner);
  }
}

ListAvailableResultItemCategory _decodeListAvailableResultItemCategory(
  dynamic raw,
) {
  final errors = <String>[];
  try {
    return ListAvailableResultItemCategory1Value(
      _decodeListAvailableResultItemCategory1(raw),
    );
  } catch (e) {
    errors.add('ListAvailableResultItemCategory1Value: $e');
  }
  try {
    return ListAvailableResultItemCategory2Value(
      _decodeListAvailableResultItemCategory2(raw),
    );
  } catch (e) {
    errors.add('ListAvailableResultItemCategory2Value: $e');
  }
  try {
    return ListAvailableResultItemCategory3Value(
      _decodeListAvailableResultItemCategory3(raw),
    );
  } catch (e) {
    errors.add('ListAvailableResultItemCategory3Value: $e');
  }
  try {
    return ListAvailableResultItemCategory4Value(
      _decodeListAvailableResultItemCategory4(raw),
    );
  } catch (e) {
    errors.add('ListAvailableResultItemCategory4Value: $e');
  }
  try {
    return ListAvailableResultItemCategory5Value(
      _decodeListAvailableResultItemCategory5(raw),
    );
  } catch (e) {
    errors.add('ListAvailableResultItemCategory5Value: $e');
  }
  throw FormatException(
    'Expected ListAvailableResultItemCategory but received ${describeType(raw)}.\n'
    'Tried: ${errors.join(", ")}',
  );
}

typedef ListAvailableResultItem = ({
  double creationTime,
  DrinksId id,
  double alcoholPercentage,
  ListAvailableResultItemCategory category,
  double? deletedAt,
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
    'category': _encodeListAvailableResultItemCategory(category),
    'deletedAt': deletedAt,
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
  if (!map.containsKey('category')) {
    throw FormatException(
      'Missing required field "category" for ListAvailableResultItem',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for ListAvailableResultItem',
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
    category: _decodeListAvailableResultItemCategory(map['category']),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(
            map['deletedAt'],
            label: 'ListAvailableResultItemDeletedAt',
          ),
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

typedef ListCustomResultItemCategory1 = ({String kind});

Map<String, dynamic> _encodeListCustomResultItemCategory1(
  ListCustomResultItemCategory1 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListCustomResultItemCategory1 _decodeListCustomResultItemCategory1(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListCustomResultItemCategory1');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListCustomResultItemCategory1',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'beer',
      label: 'ListCustomResultItemCategory1Kind',
    ),
  );
}

typedef ListCustomResultItemCategory2 = ({String kind});

Map<String, dynamic> _encodeListCustomResultItemCategory2(
  ListCustomResultItemCategory2 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListCustomResultItemCategory2 _decodeListCustomResultItemCategory2(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListCustomResultItemCategory2');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListCustomResultItemCategory2',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cider',
      label: 'ListCustomResultItemCategory2Kind',
    ),
  );
}

typedef ListCustomResultItemCategory3 = ({String kind});

Map<String, dynamic> _encodeListCustomResultItemCategory3(
  ListCustomResultItemCategory3 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListCustomResultItemCategory3 _decodeListCustomResultItemCategory3(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListCustomResultItemCategory3');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListCustomResultItemCategory3',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'cocktail',
      label: 'ListCustomResultItemCategory3Kind',
    ),
  );
}

typedef ListCustomResultItemCategory4 = ({String kind});

Map<String, dynamic> _encodeListCustomResultItemCategory4(
  ListCustomResultItemCategory4 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListCustomResultItemCategory4 _decodeListCustomResultItemCategory4(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListCustomResultItemCategory4');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListCustomResultItemCategory4',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'spirit',
      label: 'ListCustomResultItemCategory4Kind',
    ),
  );
}

typedef ListCustomResultItemCategory5 = ({String kind});

Map<String, dynamic> _encodeListCustomResultItemCategory5(
  ListCustomResultItemCategory5 value$,
) {
  final (kind: kind) = value$;
  return <String, dynamic>{'kind': kind};
}

ListCustomResultItemCategory5 _decodeListCustomResultItemCategory5(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'ListCustomResultItemCategory5');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing required field "kind" for ListCustomResultItemCategory5',
    );
  }
  return (
    kind: expectLiteral<String>(
      map['kind'],
      'wine',
      label: 'ListCustomResultItemCategory5Kind',
    ),
  );
}

sealed class ListCustomResultItemCategory {
  const ListCustomResultItemCategory();
}

class ListCustomResultItemCategory1Value extends ListCustomResultItemCategory {
  const ListCustomResultItemCategory1Value(this.value);
  final ListCustomResultItemCategory1 value;
}

class ListCustomResultItemCategory2Value extends ListCustomResultItemCategory {
  const ListCustomResultItemCategory2Value(this.value);
  final ListCustomResultItemCategory2 value;
}

class ListCustomResultItemCategory3Value extends ListCustomResultItemCategory {
  const ListCustomResultItemCategory3Value(this.value);
  final ListCustomResultItemCategory3 value;
}

class ListCustomResultItemCategory4Value extends ListCustomResultItemCategory {
  const ListCustomResultItemCategory4Value(this.value);
  final ListCustomResultItemCategory4 value;
}

class ListCustomResultItemCategory5Value extends ListCustomResultItemCategory {
  const ListCustomResultItemCategory5Value(this.value);
  final ListCustomResultItemCategory5 value;
}

dynamic _encodeListCustomResultItemCategory(
  ListCustomResultItemCategory value,
) {
  switch (value) {
    case ListCustomResultItemCategory1Value(value: final inner):
      return _encodeListCustomResultItemCategory1(inner);
    case ListCustomResultItemCategory2Value(value: final inner):
      return _encodeListCustomResultItemCategory2(inner);
    case ListCustomResultItemCategory3Value(value: final inner):
      return _encodeListCustomResultItemCategory3(inner);
    case ListCustomResultItemCategory4Value(value: final inner):
      return _encodeListCustomResultItemCategory4(inner);
    case ListCustomResultItemCategory5Value(value: final inner):
      return _encodeListCustomResultItemCategory5(inner);
  }
}

ListCustomResultItemCategory _decodeListCustomResultItemCategory(dynamic raw) {
  final errors = <String>[];
  try {
    return ListCustomResultItemCategory1Value(
      _decodeListCustomResultItemCategory1(raw),
    );
  } catch (e) {
    errors.add('ListCustomResultItemCategory1Value: $e');
  }
  try {
    return ListCustomResultItemCategory2Value(
      _decodeListCustomResultItemCategory2(raw),
    );
  } catch (e) {
    errors.add('ListCustomResultItemCategory2Value: $e');
  }
  try {
    return ListCustomResultItemCategory3Value(
      _decodeListCustomResultItemCategory3(raw),
    );
  } catch (e) {
    errors.add('ListCustomResultItemCategory3Value: $e');
  }
  try {
    return ListCustomResultItemCategory4Value(
      _decodeListCustomResultItemCategory4(raw),
    );
  } catch (e) {
    errors.add('ListCustomResultItemCategory4Value: $e');
  }
  try {
    return ListCustomResultItemCategory5Value(
      _decodeListCustomResultItemCategory5(raw),
    );
  } catch (e) {
    errors.add('ListCustomResultItemCategory5Value: $e');
  }
  throw FormatException(
    'Expected ListCustomResultItemCategory but received ${describeType(raw)}.\n'
    'Tried: ${errors.join(", ")}',
  );
}

typedef ListCustomResultItem = ({
  double creationTime,
  DrinksId id,
  double alcoholPercentage,
  ListCustomResultItemCategory category,
  double? deletedAt,
  String name,
  UsersId? ownerId,
  double updatedAt,
});

Map<String, dynamic> _encodeListCustomResultItem(ListCustomResultItem value$) {
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
    'category': _encodeListCustomResultItemCategory(category),
    'deletedAt': deletedAt,
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
  if (!map.containsKey('category')) {
    throw FormatException(
      'Missing required field "category" for ListCustomResultItem',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for ListCustomResultItem',
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
    category: _decodeListCustomResultItemCategory(map['category']),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(
            map['deletedAt'],
            label: 'ListCustomResultItemDeletedAt',
          ),
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
