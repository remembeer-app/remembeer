// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class SessionMemberApi {
  const SessionMemberApi(this._client);

  final ConvexFunctionCaller _client;

  Future<Null> accept({required SessionId sessionId}) async {
    await _client.mutate(
      'sessionMember:accept',
      _encodeAcceptArgs((sessionId: sessionId)),
    );
    return null;
  }

  ConvexMutationReference<AcceptArgs, void> get acceptMutation =>
      acceptMutationReference;

  Future<Null> ban({
    required SessionId sessionId,
    required UserId userId,
  }) async {
    await _client.mutate(
      'sessionMember:ban',
      _encodeBanArgs((sessionId: sessionId, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<BanArgs, void> get banMutation =>
      banMutationReference;

  Future<Null> decline({required SessionId sessionId}) async {
    await _client.mutate(
      'sessionMember:decline',
      _encodeDeclineArgs((sessionId: sessionId)),
    );
    return null;
  }

  ConvexMutationReference<DeclineArgs, void> get declineMutation =>
      declineMutationReference;

  Future<List<FindInviteeResultItem>> findInvitee({
    required SessionId sessionId,
    required String username,
  }) async {
    final raw$ = await _client.query(
      'sessionMember:findInvitee',
      _encodeFindInviteeArgs((sessionId: sessionId, username: username)),
    );
    return expectList(
      raw$,
      label: 'FindInviteeResult',
    ).map((item) => _decodeFindInviteeResultItem(item)).toList();
  }

  TypedConvexSubscription<List<FindInviteeResultItem>> findInviteeSubscribe({
    required SessionId sessionId,
    required String username,
  }) {
    final subscription$ = _client.subscribe(
      'sessionMember:findInvitee',
      _encodeFindInviteeArgs((sessionId: sessionId, username: username)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<FindInviteeResultItem>>(
            expectList(
              value,
              label: 'FindInviteeResult',
            ).map((item) => _decodeFindInviteeResultItem(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<FindInviteeResultItem>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<FindInviteeResultItem>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<FindInviteeResultItem>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<FindInviteeArgs, List<FindInviteeResultItem>>
  get findInviteeQuery => findInviteeQueryReference;

  Future<Null> invite({
    required SessionId sessionId,
    required UserId userId,
  }) async {
    await _client.mutate(
      'sessionMember:invite',
      _encodeInviteArgs((sessionId: sessionId, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<InviteArgs, void> get inviteMutation =>
      inviteMutationReference;

  Future<Null> leave({required SessionId sessionId}) async {
    await _client.mutate(
      'sessionMember:leave',
      _encodeLeaveArgs((sessionId: sessionId)),
    );
    return null;
  }

  ConvexMutationReference<LeaveArgs, void> get leaveMutation =>
      leaveMutationReference;

  Future<List<ListForSessionResultItem>> listForSession({
    required SessionId sessionId,
  }) async {
    final raw$ = await _client.query(
      'sessionMember:listForSession',
      _encodeListForSessionArgs((sessionId: sessionId)),
    );
    return expectList(
      raw$,
      label: 'ListForSessionResult',
    ).map((item) => _decodeListForSessionResultItem(item)).toList();
  }

  TypedConvexSubscription<List<ListForSessionResultItem>>
  listForSessionSubscribe({required SessionId sessionId}) {
    final subscription$ = _client.subscribe(
      'sessionMember:listForSession',
      _encodeListForSessionArgs((sessionId: sessionId)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<ListForSessionResultItem>>(
            expectList(
              value,
              label: 'ListForSessionResult',
            ).map((item) => _decodeListForSessionResultItem(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<ListForSessionResultItem>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<ListForSessionResultItem>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<ListForSessionResultItem>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<ListForSessionArgs, List<ListForSessionResultItem>>
  get listForSessionQuery => listForSessionQueryReference;

  Future<List<ListInvitationsResultItem>> listInvitations() async {
    final raw$ = await _client.query(
      'sessionMember:listInvitations',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListInvitationsResult',
    ).map((item) => _decodeListInvitationsResultItem(item)).toList();
  }

  TypedConvexSubscription<List<ListInvitationsResultItem>>
  listInvitationsSubscribe() {
    final subscription$ = _client.subscribe(
      'sessionMember:listInvitations',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<ListInvitationsResultItem>>(
            expectList(
              value,
              label: 'ListInvitationsResult',
            ).map((item) => _decodeListInvitationsResultItem(item)).toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<ListInvitationsResultItem>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<ListInvitationsResultItem>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<ListInvitationsResultItem>>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<NoArgs, List<ListInvitationsResultItem>>
  get listInvitationsQuery => listInvitationsQueryReference;

  Future<Null> remove({
    required SessionId sessionId,
    required UserId userId,
  }) async {
    await _client.mutate(
      'sessionMember:remove',
      _encodeRemoveArgs((sessionId: sessionId, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<RemoveArgs, void> get removeMutation =>
      removeMutationReference;

  Future<Null> setRole({
    required SessionMemberRole role,
    required SessionId sessionId,
    required UserId userId,
  }) async {
    await _client.mutate(
      'sessionMember:setRole',
      _encodeSetRoleArgs((role: role, sessionId: sessionId, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<SetRoleArgs, void> get setRoleMutation =>
      setRoleMutationReference;

  Future<Null> unban({
    required SessionId sessionId,
    required UserId userId,
  }) async {
    await _client.mutate(
      'sessionMember:unban',
      _encodeUnbanArgs((sessionId: sessionId, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<UnbanArgs, void> get unbanMutation =>
      unbanMutationReference;
}

typedef AcceptArgs = ({SessionId sessionId});

Map<String, dynamic> _encodeAcceptArgs(AcceptArgs value$) {
  final (sessionId: sessionId) = value$;
  return <String, dynamic>{'sessionId': sessionId.value};
}

AcceptArgs _decodeAcceptArgs(dynamic raw) {
  final map = expectMap(raw, label: 'AcceptArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for AcceptArgs');
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'AcceptArgsSessionId'),
    ),
  );
}

typedef BanArgs = ({SessionId sessionId, UserId userId});

Map<String, dynamic> _encodeBanArgs(BanArgs value$) {
  final (sessionId: sessionId, userId: userId) = value$;
  return <String, dynamic>{
    'sessionId': sessionId.value,
    'userId': userId.value,
  };
}

BanArgs _decodeBanArgs(dynamic raw) {
  final map = expectMap(raw, label: 'BanArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for BanArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for BanArgs');
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'BanArgsSessionId'),
    ),
    userId: UserId(expectString(map['userId'], label: 'BanArgsUserId')),
  );
}

typedef DeclineArgs = ({SessionId sessionId});

Map<String, dynamic> _encodeDeclineArgs(DeclineArgs value$) {
  final (sessionId: sessionId) = value$;
  return <String, dynamic>{'sessionId': sessionId.value};
}

DeclineArgs _decodeDeclineArgs(dynamic raw) {
  final map = expectMap(raw, label: 'DeclineArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for DeclineArgs');
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'DeclineArgsSessionId'),
    ),
  );
}

typedef FindInviteeResultItem = ({UserId id, String username});

Map<String, dynamic> _encodeFindInviteeResultItem(
  FindInviteeResultItem value$,
) {
  final (id: id, username: username) = value$;
  return <String, dynamic>{'_id': id.value, 'username': username};
}

FindInviteeResultItem _decodeFindInviteeResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'FindInviteeResultItem');
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for FindInviteeResultItem',
    );
  }
  if (!map.containsKey('username')) {
    throw FormatException(
      'Missing required field "username" for FindInviteeResultItem',
    );
  }
  return (
    id: UserId(expectString(map['_id'], label: 'FindInviteeResultItemId')),
    username: expectString(
      map['username'],
      label: 'FindInviteeResultItemUsername',
    ),
  );
}

typedef FindInviteeArgs = ({SessionId sessionId, String username});

Map<String, dynamic> _encodeFindInviteeArgs(FindInviteeArgs value$) {
  final (sessionId: sessionId, username: username) = value$;
  return <String, dynamic>{'sessionId': sessionId.value, 'username': username};
}

FindInviteeArgs _decodeFindInviteeArgs(dynamic raw) {
  final map = expectMap(raw, label: 'FindInviteeArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for FindInviteeArgs',
    );
  }
  if (!map.containsKey('username')) {
    throw FormatException(
      'Missing required field "username" for FindInviteeArgs',
    );
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'FindInviteeArgsSessionId'),
    ),
    username: expectString(map['username'], label: 'FindInviteeArgsUsername'),
  );
}

typedef InviteArgs = ({SessionId sessionId, UserId userId});

Map<String, dynamic> _encodeInviteArgs(InviteArgs value$) {
  final (sessionId: sessionId, userId: userId) = value$;
  return <String, dynamic>{
    'sessionId': sessionId.value,
    'userId': userId.value,
  };
}

InviteArgs _decodeInviteArgs(dynamic raw) {
  final map = expectMap(raw, label: 'InviteArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for InviteArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for InviteArgs');
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'InviteArgsSessionId'),
    ),
    userId: UserId(expectString(map['userId'], label: 'InviteArgsUserId')),
  );
}

typedef LeaveArgs = ({SessionId sessionId});

Map<String, dynamic> _encodeLeaveArgs(LeaveArgs value$) {
  final (sessionId: sessionId) = value$;
  return <String, dynamic>{'sessionId': sessionId.value};
}

LeaveArgs _decodeLeaveArgs(dynamic raw) {
  final map = expectMap(raw, label: 'LeaveArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for LeaveArgs');
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'LeaveArgsSessionId'),
    ),
  );
}

Map<String, dynamic> _encodeSessionMemberRole(SessionMemberRole value) {
  switch (value) {
    case Member():
      return <String, dynamic>{'kind': 'member'};
    case Admin():
      return <String, dynamic>{'kind': 'admin'};
  }
}

SessionMemberRole _decodeSessionMemberRole(dynamic raw) {
  final map = expectMap(raw, label: 'SessionMemberRole');
  if (!map.containsKey('kind')) {
    throw FormatException('Missing discriminator "kind" for SessionMemberRole');
  }
  final discriminator = expectString(
    map['kind'],
    label: 'SessionMemberRoleKind',
  );
  switch (discriminator) {
    case 'member':
      return const Member();
    case 'admin':
      return const Admin();
    default:
      throw FormatException(
        'Unknown SessionMemberRole discriminator: $discriminator',
      );
  }
}

Map<String, dynamic> _encodeSessionMemberStatus(SessionMemberStatus value) {
  switch (value) {
    case Invited():
      return <String, dynamic>{'kind': 'invited'};
    case Joined():
      return <String, dynamic>{'kind': 'joined'};
    case Left():
      return <String, dynamic>{'kind': 'left'};
    case Banned():
      return <String, dynamic>{'kind': 'banned'};
    case Declined():
      return <String, dynamic>{'kind': 'declined'};
  }
}

SessionMemberStatus _decodeSessionMemberStatus(dynamic raw) {
  final map = expectMap(raw, label: 'SessionMemberStatus');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing discriminator "kind" for SessionMemberStatus',
    );
  }
  final discriminator = expectString(
    map['kind'],
    label: 'SessionMemberStatusKind',
  );
  switch (discriminator) {
    case 'invited':
      return const Invited();
    case 'joined':
      return const Joined();
    case 'left':
      return const Left();
    case 'banned':
      return const Banned();
    case 'declined':
      return const Declined();
    default:
      throw FormatException(
        'Unknown SessionMemberStatus discriminator: $discriminator',
      );
  }
}

typedef ListForSessionResultItem = ({
  double creationTime,
  SessionMemberId id,
  double? sessionDeletedAt,
  double? sessionEndedAt,
  SessionId sessionId,
  SessionMemberRole sessionMemberRole,
  SessionMemberStatus sessionMemberStatus,
  double updatedAt,
  UserId userId,
  String username,
});

Map<String, dynamic> _encodeListForSessionResultItem(
  ListForSessionResultItem value$,
) {
  final (
    creationTime: creationTime,
    id: id,
    sessionDeletedAt: sessionDeletedAt,
    sessionEndedAt: sessionEndedAt,
    sessionId: sessionId,
    sessionMemberRole: sessionMemberRole,
    sessionMemberStatus: sessionMemberStatus,
    updatedAt: updatedAt,
    userId: userId,
    username: username,
  ) = value$;
  return <String, dynamic>{
    '_creationTime': creationTime,
    '_id': id.value,
    'sessionDeletedAt': sessionDeletedAt,
    'sessionEndedAt': sessionEndedAt,
    'sessionId': sessionId.value,
    'sessionMemberRole': _encodeSessionMemberRole(sessionMemberRole),
    'sessionMemberStatus': _encodeSessionMemberStatus(sessionMemberStatus),
    'updatedAt': updatedAt,
    'userId': userId.value,
    'username': username,
  };
}

ListForSessionResultItem _decodeListForSessionResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListForSessionResultItem');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for ListForSessionResultItem',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ListForSessionResultItem',
    );
  }
  if (!map.containsKey('sessionDeletedAt')) {
    throw FormatException(
      'Missing required field "sessionDeletedAt" for ListForSessionResultItem',
    );
  }
  if (!map.containsKey('sessionEndedAt')) {
    throw FormatException(
      'Missing required field "sessionEndedAt" for ListForSessionResultItem',
    );
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for ListForSessionResultItem',
    );
  }
  if (!map.containsKey('sessionMemberRole')) {
    throw FormatException(
      'Missing required field "sessionMemberRole" for ListForSessionResultItem',
    );
  }
  if (!map.containsKey('sessionMemberStatus')) {
    throw FormatException(
      'Missing required field "sessionMemberStatus" for ListForSessionResultItem',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for ListForSessionResultItem',
    );
  }
  if (!map.containsKey('userId')) {
    throw FormatException(
      'Missing required field "userId" for ListForSessionResultItem',
    );
  }
  if (!map.containsKey('username')) {
    throw FormatException(
      'Missing required field "username" for ListForSessionResultItem',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'ListForSessionResultItemCreationTime',
    ),
    id: SessionMemberId(
      expectString(map['_id'], label: 'ListForSessionResultItemId'),
    ),
    sessionDeletedAt: map['sessionDeletedAt'] == null
        ? null
        : expectDouble(
            map['sessionDeletedAt'],
            label: 'ListForSessionResultItemSessionDeletedAt',
          ),
    sessionEndedAt: map['sessionEndedAt'] == null
        ? null
        : expectDouble(
            map['sessionEndedAt'],
            label: 'ListForSessionResultItemSessionEndedAt',
          ),
    sessionId: SessionId(
      expectString(
        map['sessionId'],
        label: 'ListForSessionResultItemSessionId',
      ),
    ),
    sessionMemberRole: _decodeSessionMemberRole(map['sessionMemberRole']),
    sessionMemberStatus: _decodeSessionMemberStatus(map['sessionMemberStatus']),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'ListForSessionResultItemUpdatedAt',
    ),
    userId: UserId(
      expectString(map['userId'], label: 'ListForSessionResultItemUserId'),
    ),
    username: expectString(
      map['username'],
      label: 'ListForSessionResultItemUsername',
    ),
  );
}

typedef ListForSessionArgs = ({SessionId sessionId});

Map<String, dynamic> _encodeListForSessionArgs(ListForSessionArgs value$) {
  final (sessionId: sessionId) = value$;
  return <String, dynamic>{'sessionId': sessionId.value};
}

ListForSessionArgs _decodeListForSessionArgs(dynamic raw) {
  final map = expectMap(raw, label: 'ListForSessionArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for ListForSessionArgs',
    );
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'ListForSessionArgsSessionId'),
    ),
  );
}

Map<String, dynamic> _encodeSessionMemberDocument(
  SessionMemberDocument value$,
) {
  final (
    sessionId: sessionId,
    userId: userId,
    sessionMemberStatus: sessionMemberStatus,
    sessionMemberRole: sessionMemberRole,
    updatedAt: updatedAt,
    sessionEndedAt: sessionEndedAt,
    sessionDeletedAt: sessionDeletedAt,
    id: id,
    creationTime: creationTime,
  ) = value$;
  return <String, dynamic>{
    'sessionId': sessionId.value,
    'userId': userId.value,
    'sessionMemberStatus': _encodeSessionMemberStatus(sessionMemberStatus),
    'sessionMemberRole': _encodeSessionMemberRole(sessionMemberRole),
    'updatedAt': updatedAt,
    'sessionEndedAt': sessionEndedAt,
    'sessionDeletedAt': sessionDeletedAt,
    '_id': id.value,
    '_creationTime': creationTime,
  };
}

SessionMemberDocument _decodeSessionMemberDocument(dynamic raw) {
  final map = expectMap(raw, label: 'SessionMemberDocument');
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for SessionMemberDocument',
    );
  }
  if (!map.containsKey('userId')) {
    throw FormatException(
      'Missing required field "userId" for SessionMemberDocument',
    );
  }
  if (!map.containsKey('sessionMemberStatus')) {
    throw FormatException(
      'Missing required field "sessionMemberStatus" for SessionMemberDocument',
    );
  }
  if (!map.containsKey('sessionMemberRole')) {
    throw FormatException(
      'Missing required field "sessionMemberRole" for SessionMemberDocument',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for SessionMemberDocument',
    );
  }
  if (!map.containsKey('sessionEndedAt')) {
    throw FormatException(
      'Missing required field "sessionEndedAt" for SessionMemberDocument',
    );
  }
  if (!map.containsKey('sessionDeletedAt')) {
    throw FormatException(
      'Missing required field "sessionDeletedAt" for SessionMemberDocument',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for SessionMemberDocument',
    );
  }
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for SessionMemberDocument',
    );
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'SessionMemberDocumentSessionId'),
    ),
    userId: UserId(
      expectString(map['userId'], label: 'SessionMemberDocumentUserId'),
    ),
    sessionMemberStatus: _decodeSessionMemberStatus(map['sessionMemberStatus']),
    sessionMemberRole: _decodeSessionMemberRole(map['sessionMemberRole']),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'SessionMemberDocumentUpdatedAt',
    ),
    sessionEndedAt: map['sessionEndedAt'] == null
        ? null
        : expectDouble(
            map['sessionEndedAt'],
            label: 'SessionMemberDocumentSessionEndedAt',
          ),
    sessionDeletedAt: map['sessionDeletedAt'] == null
        ? null
        : expectDouble(
            map['sessionDeletedAt'],
            label: 'SessionMemberDocumentSessionDeletedAt',
          ),
    id: SessionMemberId(
      expectString(map['_id'], label: 'SessionMemberDocumentId'),
    ),
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'SessionMemberDocumentCreationTime',
    ),
  );
}

Map<String, dynamic> _encodeSessionDocument(SessionDocument value) {
  switch (value) {
    case Session(
      ownerId: final ownerId,
      name: final name,
      description: final description,
      startedAt: final startedAt,
      endedAt: final endedAt,
      updatedAt: final updatedAt,
      deletedAt: final deletedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'session',
        'ownerId': ownerId.value,
        'name': name,
        'description': description,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
    case Party(
      ownerId: final ownerId,
      name: final name,
      description: final description,
      startedAt: final startedAt,
      endedAt: final endedAt,
      updatedAt: final updatedAt,
      deletedAt: final deletedAt,
      id: final id,
      creationTime: final creationTime,
    ):
      return <String, dynamic>{
        'kind': 'party',
        'ownerId': ownerId.value,
        'name': name,
        'description': description,
        'startedAt': startedAt,
        'endedAt': endedAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
        '_id': id.value,
        '_creationTime': creationTime,
      };
  }
}

SessionDocument _decodeSessionDocument(dynamic raw) {
  final map = expectMap(raw, label: 'SessionDocument');
  if (!map.containsKey('kind')) {
    throw FormatException('Missing discriminator "kind" for SessionDocument');
  }
  final discriminator = expectString(map['kind'], label: 'SessionDocumentKind');
  switch (discriminator) {
    case 'session':
      if (!map.containsKey('ownerId')) {
        throw FormatException('Missing required field "ownerId" for Session');
      }
      if (!map.containsKey('name')) {
        throw FormatException('Missing required field "name" for Session');
      }
      if (!map.containsKey('description')) {
        throw FormatException(
          'Missing required field "description" for Session',
        );
      }
      if (!map.containsKey('startedAt')) {
        throw FormatException('Missing required field "startedAt" for Session');
      }
      if (!map.containsKey('endedAt')) {
        throw FormatException('Missing required field "endedAt" for Session');
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException('Missing required field "updatedAt" for Session');
      }
      if (!map.containsKey('deletedAt')) {
        throw FormatException('Missing required field "deletedAt" for Session');
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for Session');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for Session',
        );
      }
      return Session(
        ownerId: UserId(
          expectString(map['ownerId'], label: 'SessionDocumentOwnerId'),
        ),
        name: expectString(map['name'], label: 'SessionDocumentName'),
        description: expectString(
          map['description'],
          label: 'SessionDocumentDescription',
        ),
        startedAt: expectDouble(
          map['startedAt'],
          label: 'SessionDocumentStartedAt',
        ),
        endedAt: map['endedAt'] == null
            ? null
            : expectDouble(map['endedAt'], label: 'SessionDocumentEndedAt'),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'SessionDocumentUpdatedAt',
        ),
        deletedAt: map['deletedAt'] == null
            ? null
            : expectDouble(map['deletedAt'], label: 'SessionDocumentDeletedAt'),
        id: SessionId(expectString(map['_id'], label: 'SessionDocumentId')),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'SessionDocumentCreationTime',
        ),
      );
    case 'party':
      if (!map.containsKey('ownerId')) {
        throw FormatException('Missing required field "ownerId" for Party');
      }
      if (!map.containsKey('name')) {
        throw FormatException('Missing required field "name" for Party');
      }
      if (!map.containsKey('description')) {
        throw FormatException('Missing required field "description" for Party');
      }
      if (!map.containsKey('startedAt')) {
        throw FormatException('Missing required field "startedAt" for Party');
      }
      if (!map.containsKey('endedAt')) {
        throw FormatException('Missing required field "endedAt" for Party');
      }
      if (!map.containsKey('updatedAt')) {
        throw FormatException('Missing required field "updatedAt" for Party');
      }
      if (!map.containsKey('deletedAt')) {
        throw FormatException('Missing required field "deletedAt" for Party');
      }
      if (!map.containsKey('_id')) {
        throw FormatException('Missing required field "_id" for Party');
      }
      if (!map.containsKey('_creationTime')) {
        throw FormatException(
          'Missing required field "_creationTime" for Party',
        );
      }
      return Party(
        ownerId: UserId(
          expectString(map['ownerId'], label: 'SessionDocumentOwnerId'),
        ),
        name: expectString(map['name'], label: 'SessionDocumentName'),
        description: expectString(
          map['description'],
          label: 'SessionDocumentDescription',
        ),
        startedAt: expectDouble(
          map['startedAt'],
          label: 'SessionDocumentStartedAt',
        ),
        endedAt: map['endedAt'] == null
            ? null
            : expectDouble(map['endedAt'], label: 'SessionDocumentEndedAt'),
        updatedAt: expectDouble(
          map['updatedAt'],
          label: 'SessionDocumentUpdatedAt',
        ),
        deletedAt: map['deletedAt'] == null
            ? null
            : expectDouble(map['deletedAt'], label: 'SessionDocumentDeletedAt'),
        id: SessionId(expectString(map['_id'], label: 'SessionDocumentId')),
        creationTime: expectDouble(
          map['_creationTime'],
          label: 'SessionDocumentCreationTime',
        ),
      );
    default:
      throw FormatException(
        'Unknown SessionDocument discriminator: $discriminator',
      );
  }
}

typedef ListInvitationsResultItem = ({
  SessionMemberDocument member,
  SessionDocument session,
});

Map<String, dynamic> _encodeListInvitationsResultItem(
  ListInvitationsResultItem value$,
) {
  final (member: member, session: session) = value$;
  return <String, dynamic>{
    'member': _encodeSessionMemberDocument(member),
    'session': _encodeSessionDocument(session),
  };
}

ListInvitationsResultItem _decodeListInvitationsResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListInvitationsResultItem');
  if (!map.containsKey('member')) {
    throw FormatException(
      'Missing required field "member" for ListInvitationsResultItem',
    );
  }
  if (!map.containsKey('session')) {
    throw FormatException(
      'Missing required field "session" for ListInvitationsResultItem',
    );
  }
  return (
    member: _decodeSessionMemberDocument(map['member']),
    session: _decodeSessionDocument(map['session']),
  );
}

typedef RemoveArgs = ({SessionId sessionId, UserId userId});

Map<String, dynamic> _encodeRemoveArgs(RemoveArgs value$) {
  final (sessionId: sessionId, userId: userId) = value$;
  return <String, dynamic>{
    'sessionId': sessionId.value,
    'userId': userId.value,
  };
}

RemoveArgs _decodeRemoveArgs(dynamic raw) {
  final map = expectMap(raw, label: 'RemoveArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for RemoveArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for RemoveArgs');
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'RemoveArgsSessionId'),
    ),
    userId: UserId(expectString(map['userId'], label: 'RemoveArgsUserId')),
  );
}

typedef SetRoleArgs = ({
  SessionMemberRole role,
  SessionId sessionId,
  UserId userId,
});

Map<String, dynamic> _encodeSetRoleArgs(SetRoleArgs value$) {
  final (role: role, sessionId: sessionId, userId: userId) = value$;
  return <String, dynamic>{
    'role': _encodeSessionMemberRole(role),
    'sessionId': sessionId.value,
    'userId': userId.value,
  };
}

SetRoleArgs _decodeSetRoleArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SetRoleArgs');
  if (!map.containsKey('role')) {
    throw FormatException('Missing required field "role" for SetRoleArgs');
  }
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for SetRoleArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for SetRoleArgs');
  }
  return (
    role: _decodeSessionMemberRole(map['role']),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'SetRoleArgsSessionId'),
    ),
    userId: UserId(expectString(map['userId'], label: 'SetRoleArgsUserId')),
  );
}

typedef UnbanArgs = ({SessionId sessionId, UserId userId});

Map<String, dynamic> _encodeUnbanArgs(UnbanArgs value$) {
  final (sessionId: sessionId, userId: userId) = value$;
  return <String, dynamic>{
    'sessionId': sessionId.value,
    'userId': userId.value,
  };
}

UnbanArgs _decodeUnbanArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UnbanArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException('Missing required field "sessionId" for UnbanArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for UnbanArgs');
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'UnbanArgsSessionId'),
    ),
    userId: UserId(expectString(map['userId'], label: 'UnbanArgsUserId')),
  );
}

final ConvexMutationReference<AcceptArgs, void> acceptMutationReference =
    ConvexMutationReference(
      name: 'sessionMember:accept',
      encode: (args) => _encodeAcceptArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<BanArgs, void> banMutationReference =
    ConvexMutationReference(
      name: 'sessionMember:ban',
      encode: (args) => _encodeBanArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<DeclineArgs, void> declineMutationReference =
    ConvexMutationReference(
      name: 'sessionMember:decline',
      encode: (args) => _encodeDeclineArgs(args),
      decode: (raw) => null,
    );

final ConvexQueryReference<FindInviteeArgs, List<FindInviteeResultItem>>
findInviteeQueryReference = ConvexQueryReference(
  name: 'sessionMember:findInvitee',
  encode: (args) => _encodeFindInviteeArgs(args),
  decodeArgs: (raw) => _decodeFindInviteeArgs(raw),
  decode: (raw) => expectList(
    raw,
    label: 'FindInviteeResult',
  ).map((item) => _decodeFindInviteeResultItem(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeFindInviteeResultItem(item)).toList(),
);

final ConvexMutationReference<InviteArgs, void> inviteMutationReference =
    ConvexMutationReference(
      name: 'sessionMember:invite',
      encode: (args) => _encodeInviteArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<LeaveArgs, void> leaveMutationReference =
    ConvexMutationReference(
      name: 'sessionMember:leave',
      encode: (args) => _encodeLeaveArgs(args),
      decode: (raw) => null,
    );

final ConvexQueryReference<ListForSessionArgs, List<ListForSessionResultItem>>
listForSessionQueryReference = ConvexQueryReference(
  name: 'sessionMember:listForSession',
  encode: (args) => _encodeListForSessionArgs(args),
  decodeArgs: (raw) => _decodeListForSessionArgs(raw),
  decode: (raw) => expectList(
    raw,
    label: 'ListForSessionResult',
  ).map((item) => _decodeListForSessionResultItem(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeListForSessionResultItem(item)).toList(),
);

final ConvexQueryReference<NoArgs, List<ListInvitationsResultItem>>
listInvitationsQueryReference = ConvexQueryReference(
  name: 'sessionMember:listInvitations',
  encode: (args) => const <String, dynamic>{},
  decodeArgs: (raw) => const NoArgs(),
  decode: (raw) => expectList(
    raw,
    label: 'ListInvitationsResult',
  ).map((item) => _decodeListInvitationsResultItem(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeListInvitationsResultItem(item)).toList(),
);

final ConvexMutationReference<RemoveArgs, void> removeMutationReference =
    ConvexMutationReference(
      name: 'sessionMember:remove',
      encode: (args) => _encodeRemoveArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<SetRoleArgs, void> setRoleMutationReference =
    ConvexMutationReference(
      name: 'sessionMember:setRole',
      encode: (args) => _encodeSetRoleArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<UnbanArgs, void> unbanMutationReference =
    ConvexMutationReference(
      name: 'sessionMember:unban',
      encode: (args) => _encodeUnbanArgs(args),
      decode: (raw) => null,
    );
