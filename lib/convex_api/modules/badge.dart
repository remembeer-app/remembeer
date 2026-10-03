// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class BadgeApi {
  const BadgeApi(this._client);

  final ConvexFunctionCaller _client;

  Future<Null> setVisibility({
    required String badgeKey,
    required bool isShown,
  }) async {
    await _client.mutate(
      'badge:setVisibility',
      _encodeSetVisibilityArgs((badgeKey: badgeKey, isShown: isShown)),
    );
    return null;
  }

  ConvexMutationReference<SetVisibilityArgs, void> get setVisibilityMutation =>
      setVisibilityMutationReference;
}

typedef SetVisibilityArgs = ({String badgeKey, bool isShown});

Map<String, dynamic> _encodeSetVisibilityArgs(SetVisibilityArgs value$) {
  final (badgeKey: badgeKey, isShown: isShown) = value$;
  return <String, dynamic>{'badgeKey': badgeKey, 'isShown': isShown};
}

SetVisibilityArgs _decodeSetVisibilityArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SetVisibilityArgs');
  if (!map.containsKey('badgeKey')) {
    throw FormatException(
      'Missing required field "badgeKey" for SetVisibilityArgs',
    );
  }
  if (!map.containsKey('isShown')) {
    throw FormatException(
      'Missing required field "isShown" for SetVisibilityArgs',
    );
  }
  return (
    badgeKey: expectString(map['badgeKey'], label: 'SetVisibilityArgsBadgeKey'),
    isShown: expectBool(map['isShown'], label: 'SetVisibilityArgsIsShown'),
  );
}

final ConvexMutationReference<SetVisibilityArgs, void>
setVisibilityMutationReference = ConvexMutationReference(
  name: 'badge:setVisibility',
  encode: (args) => _encodeSetVisibilityArgs(args),
  decode: (raw) => null,
);
