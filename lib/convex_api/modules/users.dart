// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class UsersApi {
  const UsersApi(this._client);

  final ConvexFunctionCaller _client;

  Future<CurrentResult?> current() async {
    final raw$ = await _client.query(
      'users:current',
      const <String, dynamic>{},
    );
    return raw$ == null ? null : _decodeCurrentResult(raw$);
  }

  TypedConvexSubscription<CurrentResult?> currentSubscribe() {
    final subscription$ = _client.subscribe(
      'users:current',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<CurrentResult?>(
            value == null ? null : _decodeCurrentResult(value),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<CurrentResult?>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<CurrentResult?>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<CurrentResult?>(subscription$, typedStream$);
  }

  Future<UsersId> ensureCurrent() async {
    final raw$ = await _client.mutate(
      'users:ensureCurrent',
      const <String, dynamic>{},
    );
    return UsersId(expectString(raw$, label: 'EnsureCurrentResult'));
  }
}

typedef CurrentResult = ({double creationTime, UsersId id, String authUserId});

Map<String, dynamic> _encodeCurrentResult(CurrentResult value$) {
  final (creationTime: creationTime, id: id, authUserId: authUserId) = value$;
  return <String, dynamic>{
    '_creationTime': creationTime,
    '_id': id.value,
    'authUserId': authUserId,
  };
}

CurrentResult _decodeCurrentResult(dynamic raw) {
  final map = expectMap(raw, label: 'CurrentResult');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for CurrentResult',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException('Missing required field "_id" for CurrentResult');
  }
  if (!map.containsKey('authUserId')) {
    throw FormatException(
      'Missing required field "authUserId" for CurrentResult',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'CurrentResultCreationTime',
    ),
    id: UsersId(expectString(map['_id'], label: 'CurrentResultId')),
    authUserId: expectString(
      map['authUserId'],
      label: 'CurrentResultAuthUserId',
    ),
  );
}
