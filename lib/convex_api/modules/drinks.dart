// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class DrinksApi {
  const DrinksApi(this._client);

  final ConvexFunctionCaller _client;

  Future<dynamic> create({
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
    return raw$;
  }

  Future<dynamic> getValue({required DrinksId id}) async {
    final raw$ = await _client.query(
      'drinks:get',
      _encodeGetTypeArgs((id: id)),
    );
    return raw$;
  }

  TypedConvexSubscription<dynamic> getValueSubscribe({required DrinksId id}) {
    final subscription$ = _client.subscribe(
      'drinks:get',
      _encodeGetTypeArgs((id: id)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<dynamic>(value);
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<dynamic>(hasPendingWrites: hasPendingWrites);
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<dynamic>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<dynamic>(subscription$, typedStream$);
  }

  Future<dynamic> listMine() async {
    final raw$ = await _client.query(
      'drinks:listMine',
      const <String, dynamic>{},
    );
    return raw$;
  }

  TypedConvexSubscription<dynamic> listMineSubscribe() {
    final subscription$ = _client.subscribe(
      'drinks:listMine',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<dynamic>(value);
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<dynamic>(hasPendingWrites: hasPendingWrites);
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<dynamic>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<dynamic>(subscription$, typedStream$);
  }

  Future<dynamic> softDelete({required DrinksId id}) async {
    final raw$ = await _client.mutate(
      'drinks:softDelete',
      _encodeSoftDeleteArgs((id: id)),
    );
    return raw$;
  }

  Future<dynamic> update({
    Optional<double> alcoholPercentage = const Optional.absent(),
    Optional<UpdateArgsCategory> category = const Optional.absent(),
    required DrinksId id,
    Optional<String> name = const Optional.absent(),
  }) async {
    final raw$ = await _client.mutate(
      'drinks:update',
      _encodeUpdateArgs((
        alcoholPercentage: alcoholPercentage,
        category: category,
        id: id,
        name: name,
      )),
    );
    return raw$;
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
