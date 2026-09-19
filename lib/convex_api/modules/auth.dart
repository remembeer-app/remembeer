// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class AuthApi {
  const AuthApi(this._client);

  final ConvexFunctionCaller _client;

  Future<dynamic> getCurrentUser() async {
    final raw$ = await _client.query(
      'auth:getCurrentUser',
      const <String, dynamic>{},
    );
    return raw$;
  }

  TypedConvexSubscription<dynamic> getCurrentUserSubscribe() {
    final subscription$ = _client.subscribe(
      'auth:getCurrentUser',
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
}
