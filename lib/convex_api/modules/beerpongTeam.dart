// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class BeerpongTeamApi {
  const BeerpongTeamApi(this._client);

  final ConvexFunctionCaller _client;

  Future<Null> addMember({
    required BeerpongTeamId id,
    required UserId userId,
  }) async {
    await _client.mutate(
      'beerpongTeam:addMember',
      _encodeAddMemberArgs((id: id, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<AddMemberArgs, void> get addMemberMutation =>
      addMemberMutationReference;

  Future<Null> moveMember({
    required BeerpongTeamId id,
    required BeerpongTeamId targetTeamId,
    required UserId userId,
  }) async {
    await _client.mutate(
      'beerpongTeam:moveMember',
      _encodeMoveMemberArgs((
        id: id,
        targetTeamId: targetTeamId,
        userId: userId,
      )),
    );
    return null;
  }

  ConvexMutationReference<MoveMemberArgs, void> get moveMemberMutation =>
      moveMemberMutationReference;

  Future<Null> removeMember({
    required BeerpongTeamId id,
    required UserId userId,
  }) async {
    await _client.mutate(
      'beerpongTeam:removeMember',
      _encodeRemoveMemberArgs((id: id, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<RemoveMemberArgs, void> get removeMemberMutation =>
      removeMemberMutationReference;

  Future<Null> rename({
    required BeerpongTeamId id,
    required String name,
  }) async {
    await _client.mutate(
      'beerpongTeam:rename',
      _encodeRenameArgs((id: id, name: name)),
    );
    return null;
  }

  ConvexMutationReference<RenameArgs, void> get renameMutation =>
      renameMutationReference;
}

typedef AddMemberArgs = ({BeerpongTeamId id, UserId userId});

Map<String, dynamic> _encodeAddMemberArgs(AddMemberArgs value$) {
  final (id: id, userId: userId) = value$;
  return <String, dynamic>{'id': id.value, 'userId': userId.value};
}

AddMemberArgs _decodeAddMemberArgs(dynamic raw) {
  final map = expectMap(raw, label: 'AddMemberArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for AddMemberArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for AddMemberArgs');
  }
  return (
    id: BeerpongTeamId(expectString(map['id'], label: 'AddMemberArgsId')),
    userId: UserId(expectString(map['userId'], label: 'AddMemberArgsUserId')),
  );
}

typedef MoveMemberArgs = ({
  BeerpongTeamId id,
  BeerpongTeamId targetTeamId,
  UserId userId,
});

Map<String, dynamic> _encodeMoveMemberArgs(MoveMemberArgs value$) {
  final (id: id, targetTeamId: targetTeamId, userId: userId) = value$;
  return <String, dynamic>{
    'id': id.value,
    'targetTeamId': targetTeamId.value,
    'userId': userId.value,
  };
}

MoveMemberArgs _decodeMoveMemberArgs(dynamic raw) {
  final map = expectMap(raw, label: 'MoveMemberArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for MoveMemberArgs');
  }
  if (!map.containsKey('targetTeamId')) {
    throw FormatException(
      'Missing required field "targetTeamId" for MoveMemberArgs',
    );
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for MoveMemberArgs');
  }
  return (
    id: BeerpongTeamId(expectString(map['id'], label: 'MoveMemberArgsId')),
    targetTeamId: BeerpongTeamId(
      expectString(map['targetTeamId'], label: 'MoveMemberArgsTargetTeamId'),
    ),
    userId: UserId(expectString(map['userId'], label: 'MoveMemberArgsUserId')),
  );
}

typedef RemoveMemberArgs = ({BeerpongTeamId id, UserId userId});

Map<String, dynamic> _encodeRemoveMemberArgs(RemoveMemberArgs value$) {
  final (id: id, userId: userId) = value$;
  return <String, dynamic>{'id': id.value, 'userId': userId.value};
}

RemoveMemberArgs _decodeRemoveMemberArgs(dynamic raw) {
  final map = expectMap(raw, label: 'RemoveMemberArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for RemoveMemberArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException(
      'Missing required field "userId" for RemoveMemberArgs',
    );
  }
  return (
    id: BeerpongTeamId(expectString(map['id'], label: 'RemoveMemberArgsId')),
    userId: UserId(
      expectString(map['userId'], label: 'RemoveMemberArgsUserId'),
    ),
  );
}

typedef RenameArgs = ({BeerpongTeamId id, String name});

Map<String, dynamic> _encodeRenameArgs(RenameArgs value$) {
  final (id: id, name: name) = value$;
  return <String, dynamic>{'id': id.value, 'name': name};
}

RenameArgs _decodeRenameArgs(dynamic raw) {
  final map = expectMap(raw, label: 'RenameArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for RenameArgs');
  }
  if (!map.containsKey('name')) {
    throw FormatException('Missing required field "name" for RenameArgs');
  }
  return (
    id: BeerpongTeamId(expectString(map['id'], label: 'RenameArgsId')),
    name: expectString(map['name'], label: 'RenameArgsName'),
  );
}

final ConvexMutationReference<AddMemberArgs, void> addMemberMutationReference =
    ConvexMutationReference(
      name: 'beerpongTeam:addMember',
      encode: (args) => _encodeAddMemberArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<MoveMemberArgs, void>
moveMemberMutationReference = ConvexMutationReference(
  name: 'beerpongTeam:moveMember',
  encode: (args) => _encodeMoveMemberArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<RemoveMemberArgs, void>
removeMemberMutationReference = ConvexMutationReference(
  name: 'beerpongTeam:removeMember',
  encode: (args) => _encodeRemoveMemberArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<RenameArgs, void> renameMutationReference =
    ConvexMutationReference(
      name: 'beerpongTeam:rename',
      encode: (args) => _encodeRenameArgs(args),
      decode: (raw) => null,
    );
