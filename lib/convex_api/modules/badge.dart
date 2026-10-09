// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class BadgeApi {
  const BadgeApi(this._client);

  final ConvexFunctionCaller _client;

  Future<List<BadgeDocument>> listCurrent() async {
    final raw$ = await _client.query(
      'badge:listCurrent',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListCurrentResult',
    ).map((item) => _decodeBadgeDocument(item)).toList();
  }

  TypedConvexSubscription<List<BadgeDocument>> listCurrentSubscribe() {
    final subscription$ = _client.subscribe(
      'badge:listCurrent',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<BadgeDocument>>(
            expectList(
              value,
              label: 'ListCurrentResult',
            ).map((item) => _decodeBadgeDocument(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<BadgeDocument>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<BadgeDocument>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<BadgeDocument>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<NoArgs, List<BadgeDocument>> get listCurrentQuery =>
      listCurrentQueryReference;

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

Map<String, dynamic> _encodeBadgeDocument(BadgeDocument value$) {
  final (
    userId: userId,
    badgeKey: badgeKey,
    unlockedAt: unlockedAt,
    isShown: isShown,
    id: id,
    creationTime: creationTime,
  ) = value$;
  return <String, dynamic>{
    'userId': userId.value,
    'badgeKey': badgeKey,
    'unlockedAt': unlockedAt,
    'isShown': isShown,
    '_id': id.value,
    '_creationTime': creationTime,
  };
}

BadgeDocument _decodeBadgeDocument(dynamic raw) {
  final map = expectMap(raw, label: 'BadgeDocument');
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for BadgeDocument');
  }
  if (!map.containsKey('badgeKey')) {
    throw FormatException(
      'Missing required field "badgeKey" for BadgeDocument',
    );
  }
  if (!map.containsKey('unlockedAt')) {
    throw FormatException(
      'Missing required field "unlockedAt" for BadgeDocument',
    );
  }
  if (!map.containsKey('isShown')) {
    throw FormatException('Missing required field "isShown" for BadgeDocument');
  }
  if (!map.containsKey('_id')) {
    throw FormatException('Missing required field "_id" for BadgeDocument');
  }
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for BadgeDocument',
    );
  }
  return (
    userId: UserId(expectString(map['userId'], label: 'BadgeDocumentUserId')),
    badgeKey: expectString(map['badgeKey'], label: 'BadgeDocumentBadgeKey'),
    unlockedAt: expectDouble(
      map['unlockedAt'],
      label: 'BadgeDocumentUnlockedAt',
    ),
    isShown: expectBool(map['isShown'], label: 'BadgeDocumentIsShown'),
    id: BadgeId(expectString(map['_id'], label: 'BadgeDocumentId')),
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'BadgeDocumentCreationTime',
    ),
  );
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

final ConvexQueryReference<NoArgs, List<BadgeDocument>>
listCurrentQueryReference = ConvexQueryReference(
  name: 'badge:listCurrent',
  encode: (args) => const <String, dynamic>{},
  decodeArgs: (raw) => const NoArgs(),
  decode: (raw) => expectList(
    raw,
    label: 'ListCurrentResult',
  ).map((item) => _decodeBadgeDocument(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeBadgeDocument(item)).toList(),
);

final ConvexMutationReference<SetVisibilityArgs, void>
setVisibilityMutationReference = ConvexMutationReference(
  name: 'badge:setVisibility',
  encode: (args) => _encodeSetVisibilityArgs(args),
  decode: (raw) => null,
);
