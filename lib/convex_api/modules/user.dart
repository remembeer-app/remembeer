// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class UserApi {
  const UserApi(this._client);

  final ConvexFunctionCaller _client;

  Future<UserId> ensureCurrent() async {
    final raw$ = await _client.mutate(
      'user:ensureCurrent',
      const <String, dynamic>{},
    );
    return UserId(expectString(raw$, label: 'EnsureCurrentResult'));
  }
}
