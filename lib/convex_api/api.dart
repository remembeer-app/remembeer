// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import './modules/drink.dart';
import './modules/user.dart';
import './runtime.dart';
import './schema.dart';

import 'package:dartvex/dartvex.dart';

export 'runtime.dart';
export 'schema.dart';
export 'types.dart';

class ConvexApi {
  const ConvexApi(this._client);

  final ConvexFunctionCaller _client;

  DrinkApi get drink => DrinkApi(_client);
  UserApi get user => UserApi(_client);
}
