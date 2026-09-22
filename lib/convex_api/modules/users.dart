// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class UsersApi {
  const UsersApi(this._client);

  final ConvexFunctionCaller _client;

  Future<UsersId> ensureCurrent() async {
    final raw$ = await _client.mutate(
      'users:ensureCurrent',
      const <String, dynamic>{},
    );
    return UsersId(expectString(raw$, label: 'EnsureCurrentResult'));
  }
}
