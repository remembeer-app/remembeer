// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class BadgeApi {
  const BadgeApi(this._client);

  final ConvexFunctionCaller _client;

  Future<List<ListCurrentResultItem>> listCurrent() async {
    final raw$ = await _client.query(
      'badge:listCurrent',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListCurrentResult',
    ).map((item) => _decodeListCurrentResultItem(item)).toList();
  }

  TypedConvexSubscription<List<ListCurrentResultItem>> listCurrentSubscribe() {
    final subscription$ = _client.subscribe(
      'badge:listCurrent',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<ListCurrentResultItem>>(
            expectList(
              value,
              label: 'ListCurrentResult',
            ).map((item) => _decodeListCurrentResultItem(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<ListCurrentResultItem>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<ListCurrentResultItem>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<ListCurrentResultItem>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<NoArgs, List<ListCurrentResultItem>>
  get listCurrentQuery => listCurrentQueryReference;

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

typedef ListCurrentResultItem = ({
  double creationTime,
  BadgeId id,
  String badgeKey,
  bool isShown,
  double unlockedAt,
  UserId userId,
});

Map<String, dynamic> _encodeListCurrentResultItem(
  ListCurrentResultItem value$,
) {
  final (
    creationTime: creationTime,
    id: id,
    badgeKey: badgeKey,
    isShown: isShown,
    unlockedAt: unlockedAt,
    userId: userId,
  ) = value$;
  return <String, dynamic>{
    '_creationTime': creationTime,
    '_id': id.value,
    'badgeKey': badgeKey,
    'isShown': isShown,
    'unlockedAt': unlockedAt,
    'userId': userId.value,
  };
}

ListCurrentResultItem _decodeListCurrentResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListCurrentResultItem');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for ListCurrentResultItem',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListCurrentResultItem',
    );
  }
  if (!map.containsKey('badgeKey')) {
    throw FormatException(
      'Missing required field "badgeKey" for ListCurrentResultItem',
    );
  }
  if (!map.containsKey('isShown')) {
    throw FormatException(
      'Missing required field "isShown" for ListCurrentResultItem',
    );
  }
  if (!map.containsKey('unlockedAt')) {
    throw FormatException(
      'Missing required field "unlockedAt" for ListCurrentResultItem',
    );
  }
  if (!map.containsKey('userId')) {
    throw FormatException(
      'Missing required field "userId" for ListCurrentResultItem',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'ListCurrentResultItemCreationTime',
    ),
    id: BadgeId(expectString(map['_id'], label: 'ListCurrentResultItemId')),
    badgeKey: expectString(
      map['badgeKey'],
      label: 'ListCurrentResultItemBadgeKey',
    ),
    isShown: expectBool(map['isShown'], label: 'ListCurrentResultItemIsShown'),
    unlockedAt: expectDouble(
      map['unlockedAt'],
      label: 'ListCurrentResultItemUnlockedAt',
    ),
    userId: UserId(
      expectString(map['userId'], label: 'ListCurrentResultItemUserId'),
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

final ConvexQueryReference<NoArgs, List<ListCurrentResultItem>>
listCurrentQueryReference = ConvexQueryReference(
  name: 'badge:listCurrent',
  encode: (args) => const <String, dynamic>{},
  decodeArgs: (raw) => const NoArgs(),
  decode: (raw) => expectList(
    raw,
    label: 'ListCurrentResult',
  ).map((item) => _decodeListCurrentResultItem(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeListCurrentResultItem(item)).toList(),
);

final ConvexMutationReference<SetVisibilityArgs, void>
setVisibilityMutationReference = ConvexMutationReference(
  name: 'badge:setVisibility',
  encode: (args) => _encodeSetVisibilityArgs(args),
  decode: (raw) => null,
);
