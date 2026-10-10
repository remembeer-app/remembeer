// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class FriendshipApi {
  const FriendshipApi(this._client);

  final ConvexFunctionCaller _client;

  Future<Null> accept({required UserId userId}) async {
    await _client.mutate(
      'friendship:accept',
      _encodeAcceptArgs((userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<AcceptArgs, void> get acceptMutation =>
      acceptMutationReference;

  Future<Null> cancel({required UserId userId}) async {
    await _client.mutate(
      'friendship:cancel',
      _encodeCancelArgs((userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<CancelArgs, void> get cancelMutation =>
      cancelMutationReference;

  Future<Null> decline({required UserId userId}) async {
    await _client.mutate(
      'friendship:decline',
      _encodeDeclineArgs((userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<DeclineArgs, void> get declineMutation =>
      declineMutationReference;

  Future<GetStatusResult> getStatus({required UserId userId}) async {
    final raw$ = await _client.query(
      'friendship:getStatus',
      _encodeGetStatusArgs((userId: userId)),
    );
    return GetStatusResult.fromJson(raw$);
  }

  TypedConvexSubscription<GetStatusResult> getStatusSubscribe({
    required UserId userId,
  }) {
    final subscription$ = _client.subscribe(
      'friendship:getStatus',
      _encodeGetStatusArgs((userId: userId)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<GetStatusResult>(
            GetStatusResult.fromJson(value),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<GetStatusResult>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<GetStatusResult>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<GetStatusResult>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<GetStatusArgs, GetStatusResult> get getStatusQuery =>
      getStatusQueryReference;

  Future<List<ListCurrentResultItem>> listCurrent() async {
    final raw$ = await _client.query(
      'friendship:listCurrent',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListCurrentResult',
    ).map((item) => _decodeListCurrentResultItem(item)).toList();
  }

  TypedConvexSubscription<List<ListCurrentResultItem>> listCurrentSubscribe() {
    final subscription$ = _client.subscribe(
      'friendship:listCurrent',
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

  Future<List<ListRequestsResultItem>> listRequests() async {
    final raw$ = await _client.query(
      'friendship:listRequests',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListRequestsResult',
    ).map((item) => _decodeListRequestsResultItem(item)).toList();
  }

  TypedConvexSubscription<List<ListRequestsResultItem>>
  listRequestsSubscribe() {
    final subscription$ = _client.subscribe(
      'friendship:listRequests',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<ListRequestsResultItem>>(
            expectList(
              value,
              label: 'ListRequestsResult',
            ).map((item) => _decodeListRequestsResultItem(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<ListRequestsResultItem>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<ListRequestsResultItem>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<ListRequestsResultItem>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<NoArgs, List<ListRequestsResultItem>>
  get listRequestsQuery => listRequestsQueryReference;

  Future<Null> remove({required UserId userId}) async {
    await _client.mutate(
      'friendship:remove',
      _encodeRemoveArgs((userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<RemoveArgs, void> get removeMutation =>
      removeMutationReference;

  Future<Null> sendRequest({required UserId userId}) async {
    await _client.mutate(
      'friendship:sendRequest',
      _encodeSendRequestArgs((userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<SendRequestArgs, void> get sendRequestMutation =>
      sendRequestMutationReference;
}

typedef AcceptArgs = ({UserId userId});

Map<String, dynamic> _encodeAcceptArgs(AcceptArgs value$) {
  final (userId: userId) = value$;
  return <String, dynamic>{'userId': userId.value};
}

AcceptArgs _decodeAcceptArgs(dynamic raw) {
  final map = expectMap(raw, label: 'AcceptArgs');
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for AcceptArgs');
  }
  return (
    userId: UserId(expectString(map['userId'], label: 'AcceptArgsUserId')),
  );
}

typedef CancelArgs = ({UserId userId});

Map<String, dynamic> _encodeCancelArgs(CancelArgs value$) {
  final (userId: userId) = value$;
  return <String, dynamic>{'userId': userId.value};
}

CancelArgs _decodeCancelArgs(dynamic raw) {
  final map = expectMap(raw, label: 'CancelArgs');
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for CancelArgs');
  }
  return (
    userId: UserId(expectString(map['userId'], label: 'CancelArgsUserId')),
  );
}

typedef DeclineArgs = ({UserId userId});

Map<String, dynamic> _encodeDeclineArgs(DeclineArgs value$) {
  final (userId: userId) = value$;
  return <String, dynamic>{'userId': userId.value};
}

DeclineArgs _decodeDeclineArgs(dynamic raw) {
  final map = expectMap(raw, label: 'DeclineArgs');
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for DeclineArgs');
  }
  return (
    userId: UserId(expectString(map['userId'], label: 'DeclineArgsUserId')),
  );
}

enum GetStatusResult {
  friendsValue('friends'),
  requestSentValue('requestSent'),
  requestReceivedValue('requestReceived'),
  notFriendsValue('notFriends');

  const GetStatusResult(this.value);
  final Object? value;

  static GetStatusResult fromJson(dynamic raw) {
    switch (raw) {
      case 'friends':
        return GetStatusResult.friendsValue;
      case 'requestSent':
        return GetStatusResult.requestSentValue;
      case 'requestReceived':
        return GetStatusResult.requestReceivedValue;
      case 'notFriends':
        return GetStatusResult.notFriendsValue;
      default:
        throw FormatException(
          'Expected one of friends, requestSent, requestReceived, notFriends for GetStatusResult',
        );
    }
  }
}

typedef GetStatusArgs = ({UserId userId});

Map<String, dynamic> _encodeGetStatusArgs(GetStatusArgs value$) {
  final (userId: userId) = value$;
  return <String, dynamic>{'userId': userId.value};
}

GetStatusArgs _decodeGetStatusArgs(dynamic raw) {
  final map = expectMap(raw, label: 'GetStatusArgs');
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for GetStatusArgs');
  }
  return (
    userId: UserId(expectString(map['userId'], label: 'GetStatusArgsUserId')),
  );
}

enum ListCurrentResultItemAccentColor {
  amberValue('amber'),
  roseValue('rose'),
  violetValue('violet'),
  skyValue('sky'),
  emeraldValue('emerald'),
  limeValue('lime'),
  orangeValue('orange'),
  fuchsiaValue('fuchsia');

  const ListCurrentResultItemAccentColor(this.value);
  final Object? value;

  static ListCurrentResultItemAccentColor fromJson(dynamic raw) {
    switch (raw) {
      case 'amber':
        return ListCurrentResultItemAccentColor.amberValue;
      case 'rose':
        return ListCurrentResultItemAccentColor.roseValue;
      case 'violet':
        return ListCurrentResultItemAccentColor.violetValue;
      case 'sky':
        return ListCurrentResultItemAccentColor.skyValue;
      case 'emerald':
        return ListCurrentResultItemAccentColor.emeraldValue;
      case 'lime':
        return ListCurrentResultItemAccentColor.limeValue;
      case 'orange':
        return ListCurrentResultItemAccentColor.orangeValue;
      case 'fuchsia':
        return ListCurrentResultItemAccentColor.fuchsiaValue;
      default:
        throw FormatException(
          'Expected one of amber, rose, violet, sky, emerald, lime, orange, fuchsia for ListCurrentResultItemAccentColor',
        );
    }
  }
}

typedef ListCurrentResultItem = ({
  UserId id,
  ListCurrentResultItemAccentColor accentColor,
  String? avatarUrl,
  String username,
});

Map<String, dynamic> _encodeListCurrentResultItem(
  ListCurrentResultItem value$,
) {
  final (
    id: id,
    accentColor: accentColor,
    avatarUrl: avatarUrl,
    username: username,
  ) = value$;
  return <String, dynamic>{
    '_id': id.value,
    'accentColor': accentColor.value,
    'avatarUrl': avatarUrl,
    'username': username,
  };
}

ListCurrentResultItem _decodeListCurrentResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListCurrentResultItem');
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListCurrentResultItem',
    );
  }
  if (!map.containsKey('accentColor')) {
    throw FormatException(
      'Missing required field "accentColor" for ListCurrentResultItem',
    );
  }
  if (!map.containsKey('avatarUrl')) {
    throw FormatException(
      'Missing required field "avatarUrl" for ListCurrentResultItem',
    );
  }
  if (!map.containsKey('username')) {
    throw FormatException(
      'Missing required field "username" for ListCurrentResultItem',
    );
  }
  return (
    id: UserId(expectString(map['_id'], label: 'ListCurrentResultItemId')),
    accentColor: ListCurrentResultItemAccentColor.fromJson(map['accentColor']),
    avatarUrl: map['avatarUrl'] == null
        ? null
        : expectString(
            map['avatarUrl'],
            label: 'ListCurrentResultItemAvatarUrl',
          ),
    username: expectString(
      map['username'],
      label: 'ListCurrentResultItemUsername',
    ),
  );
}

Map<String, dynamic> _encodeFriendshipDocument(FriendshipDocument value$) {
  final (
    userAId: userAId,
    userBId: userBId,
    requestedById: requestedById,
    status: status,
    updatedAt: updatedAt,
    id: id,
    creationTime: creationTime,
  ) = value$;
  return <String, dynamic>{
    'userAId': userAId.value,
    'userBId': userBId.value,
    'requestedById': requestedById.value,
    'status': status.value,
    'updatedAt': updatedAt,
    '_id': id.value,
    '_creationTime': creationTime,
  };
}

FriendshipDocument _decodeFriendshipDocument(dynamic raw) {
  final map = expectMap(raw, label: 'FriendshipDocument');
  if (!map.containsKey('userAId')) {
    throw FormatException(
      'Missing required field "userAId" for FriendshipDocument',
    );
  }
  if (!map.containsKey('userBId')) {
    throw FormatException(
      'Missing required field "userBId" for FriendshipDocument',
    );
  }
  if (!map.containsKey('requestedById')) {
    throw FormatException(
      'Missing required field "requestedById" for FriendshipDocument',
    );
  }
  if (!map.containsKey('status')) {
    throw FormatException(
      'Missing required field "status" for FriendshipDocument',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for FriendshipDocument',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for FriendshipDocument',
    );
  }
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for FriendshipDocument',
    );
  }
  return (
    userAId: UserId(
      expectString(map['userAId'], label: 'FriendshipDocumentUserAId'),
    ),
    userBId: UserId(
      expectString(map['userBId'], label: 'FriendshipDocumentUserBId'),
    ),
    requestedById: UserId(
      expectString(
        map['requestedById'],
        label: 'FriendshipDocumentRequestedById',
      ),
    ),
    status: FriendshipDocumentStatus.fromJson(map['status']),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'FriendshipDocumentUpdatedAt',
    ),
    id: FriendshipId(expectString(map['_id'], label: 'FriendshipDocumentId')),
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'FriendshipDocumentCreationTime',
    ),
  );
}

enum ListRequestsResultItemUserAccentColor {
  amberValue('amber'),
  roseValue('rose'),
  violetValue('violet'),
  skyValue('sky'),
  emeraldValue('emerald'),
  limeValue('lime'),
  orangeValue('orange'),
  fuchsiaValue('fuchsia');

  const ListRequestsResultItemUserAccentColor(this.value);
  final Object? value;

  static ListRequestsResultItemUserAccentColor fromJson(dynamic raw) {
    switch (raw) {
      case 'amber':
        return ListRequestsResultItemUserAccentColor.amberValue;
      case 'rose':
        return ListRequestsResultItemUserAccentColor.roseValue;
      case 'violet':
        return ListRequestsResultItemUserAccentColor.violetValue;
      case 'sky':
        return ListRequestsResultItemUserAccentColor.skyValue;
      case 'emerald':
        return ListRequestsResultItemUserAccentColor.emeraldValue;
      case 'lime':
        return ListRequestsResultItemUserAccentColor.limeValue;
      case 'orange':
        return ListRequestsResultItemUserAccentColor.orangeValue;
      case 'fuchsia':
        return ListRequestsResultItemUserAccentColor.fuchsiaValue;
      default:
        throw FormatException(
          'Expected one of amber, rose, violet, sky, emerald, lime, orange, fuchsia for ListRequestsResultItemUserAccentColor',
        );
    }
  }
}

typedef ListRequestsResultItemUser = ({
  UserId id,
  ListRequestsResultItemUserAccentColor accentColor,
  String? avatarUrl,
  String username,
});

Map<String, dynamic> _encodeListRequestsResultItemUser(
  ListRequestsResultItemUser value$,
) {
  final (
    id: id,
    accentColor: accentColor,
    avatarUrl: avatarUrl,
    username: username,
  ) = value$;
  return <String, dynamic>{
    '_id': id.value,
    'accentColor': accentColor.value,
    'avatarUrl': avatarUrl,
    'username': username,
  };
}

ListRequestsResultItemUser _decodeListRequestsResultItemUser(dynamic raw) {
  final map = expectMap(raw, label: 'ListRequestsResultItemUser');
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListRequestsResultItemUser',
    );
  }
  if (!map.containsKey('accentColor')) {
    throw FormatException(
      'Missing required field "accentColor" for ListRequestsResultItemUser',
    );
  }
  if (!map.containsKey('avatarUrl')) {
    throw FormatException(
      'Missing required field "avatarUrl" for ListRequestsResultItemUser',
    );
  }
  if (!map.containsKey('username')) {
    throw FormatException(
      'Missing required field "username" for ListRequestsResultItemUser',
    );
  }
  return (
    id: UserId(expectString(map['_id'], label: 'ListRequestsResultItemUserId')),
    accentColor: ListRequestsResultItemUserAccentColor.fromJson(
      map['accentColor'],
    ),
    avatarUrl: map['avatarUrl'] == null
        ? null
        : expectString(
            map['avatarUrl'],
            label: 'ListRequestsResultItemUserAvatarUrl',
          ),
    username: expectString(
      map['username'],
      label: 'ListRequestsResultItemUserUsername',
    ),
  );
}

typedef ListRequestsResultItem = ({
  FriendshipDocument friendship,
  ListRequestsResultItemUser user,
});

Map<String, dynamic> _encodeListRequestsResultItem(
  ListRequestsResultItem value$,
) {
  final (friendship: friendship, user: user) = value$;
  return <String, dynamic>{
    'friendship': _encodeFriendshipDocument(friendship),
    'user': _encodeListRequestsResultItemUser(user),
  };
}

ListRequestsResultItem _decodeListRequestsResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListRequestsResultItem');
  if (!map.containsKey('friendship')) {
    throw FormatException(
      'Missing required field "friendship" for ListRequestsResultItem',
    );
  }
  if (!map.containsKey('user')) {
    throw FormatException(
      'Missing required field "user" for ListRequestsResultItem',
    );
  }
  return (
    friendship: _decodeFriendshipDocument(map['friendship']),
    user: _decodeListRequestsResultItemUser(map['user']),
  );
}

typedef RemoveArgs = ({UserId userId});

Map<String, dynamic> _encodeRemoveArgs(RemoveArgs value$) {
  final (userId: userId) = value$;
  return <String, dynamic>{'userId': userId.value};
}

RemoveArgs _decodeRemoveArgs(dynamic raw) {
  final map = expectMap(raw, label: 'RemoveArgs');
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for RemoveArgs');
  }
  return (
    userId: UserId(expectString(map['userId'], label: 'RemoveArgsUserId')),
  );
}

typedef SendRequestArgs = ({UserId userId});

Map<String, dynamic> _encodeSendRequestArgs(SendRequestArgs value$) {
  final (userId: userId) = value$;
  return <String, dynamic>{'userId': userId.value};
}

SendRequestArgs _decodeSendRequestArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SendRequestArgs');
  if (!map.containsKey('userId')) {
    throw FormatException(
      'Missing required field "userId" for SendRequestArgs',
    );
  }
  return (
    userId: UserId(expectString(map['userId'], label: 'SendRequestArgsUserId')),
  );
}

final ConvexMutationReference<AcceptArgs, void> acceptMutationReference =
    ConvexMutationReference(
      name: 'friendship:accept',
      encode: (args) => _encodeAcceptArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<CancelArgs, void> cancelMutationReference =
    ConvexMutationReference(
      name: 'friendship:cancel',
      encode: (args) => _encodeCancelArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<DeclineArgs, void> declineMutationReference =
    ConvexMutationReference(
      name: 'friendship:decline',
      encode: (args) => _encodeDeclineArgs(args),
      decode: (raw) => null,
    );

final ConvexQueryReference<GetStatusArgs, GetStatusResult>
getStatusQueryReference = ConvexQueryReference(
  name: 'friendship:getStatus',
  encode: (args) => _encodeGetStatusArgs(args),
  decodeArgs: (raw) => _decodeGetStatusArgs(raw),
  decode: (raw) => GetStatusResult.fromJson(raw),
  encodeResult: (value) => value.value,
);

final ConvexQueryReference<NoArgs, List<ListCurrentResultItem>>
listCurrentQueryReference = ConvexQueryReference(
  name: 'friendship:listCurrent',
  encode: (args) => const <String, dynamic>{},
  decodeArgs: (raw) => const NoArgs(),
  decode: (raw) => expectList(
    raw,
    label: 'ListCurrentResult',
  ).map((item) => _decodeListCurrentResultItem(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeListCurrentResultItem(item)).toList(),
);

final ConvexQueryReference<NoArgs, List<ListRequestsResultItem>>
listRequestsQueryReference = ConvexQueryReference(
  name: 'friendship:listRequests',
  encode: (args) => const <String, dynamic>{},
  decodeArgs: (raw) => const NoArgs(),
  decode: (raw) => expectList(
    raw,
    label: 'ListRequestsResult',
  ).map((item) => _decodeListRequestsResultItem(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeListRequestsResultItem(item)).toList(),
);

final ConvexMutationReference<RemoveArgs, void> removeMutationReference =
    ConvexMutationReference(
      name: 'friendship:remove',
      encode: (args) => _encodeRemoveArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<SendRequestArgs, void>
sendRequestMutationReference = ConvexMutationReference(
  name: 'friendship:sendRequest',
  encode: (args) => _encodeSendRequestArgs(args),
  decode: (raw) => null,
);
