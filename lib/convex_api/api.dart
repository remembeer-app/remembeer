// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import './modules/auth.dart';
import './runtime.dart';
import './schema.dart';

import 'package:dartvex/dartvex.dart';

export 'runtime.dart';
export 'schema.dart';

class ConvexApi {
  const ConvexApi(this._client);

  final ConvexFunctionCaller _client;

  AuthApi get auth => AuthApi(_client);
}
