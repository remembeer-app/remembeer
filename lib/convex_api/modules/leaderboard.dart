// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class LeaderboardApi {
  const LeaderboardApi(this._client);

  final ConvexFunctionCaller _client;

  Future<Null> ban({required LeaderboardId id, required UserId userId}) async {
    await _client.mutate(
      'leaderboard:ban',
      _encodeBanArgs((id: id, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<BanArgs, void> get banMutation =>
      banMutationReference;

  Future<LeaderboardId> create({
    required CreateArgsIconName iconName,
    required String name,
  }) async {
    final raw$ = await _client.mutate(
      'leaderboard:create',
      _encodeCreateArgs((iconName: iconName, name: name)),
    );
    return LeaderboardId(expectString(raw$, label: 'CreateResult'));
  }

  ConvexMutationReference<CreateArgs, LeaderboardId> get createMutation =>
      createMutationReference;

  Future<FindByInviteCodeResult?> findByInviteCode({
    required String inviteCode,
  }) async {
    final raw$ = await _client.query(
      'leaderboard:findByInviteCode',
      _encodeFindByInviteCodeArgs((inviteCode: inviteCode)),
    );
    return raw$ == null ? null : _decodeFindByInviteCodeResult(raw$);
  }

  TypedConvexSubscription<FindByInviteCodeResult?> findByInviteCodeSubscribe({
    required String inviteCode,
  }) {
    final subscription$ = _client.subscribe(
      'leaderboard:findByInviteCode',
      _encodeFindByInviteCodeArgs((inviteCode: inviteCode)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<FindByInviteCodeResult?>(
            value == null ? null : _decodeFindByInviteCodeResult(value),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<FindByInviteCodeResult?>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<FindByInviteCodeResult?>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<FindByInviteCodeResult?>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<FindByInviteCodeArgs, FindByInviteCodeResult?>
  get findByInviteCodeQuery => findByInviteCodeQueryReference;

  Future<GetTypeResult> getValue({required LeaderboardId id}) async {
    final raw$ = await _client.query(
      'leaderboard:get',
      _encodeGetTypeArgs((id: id)),
    );
    return _decodeGetTypeResult(raw$);
  }

  TypedConvexSubscription<GetTypeResult> getValueSubscribe({
    required LeaderboardId id,
  }) {
    final subscription$ = _client.subscribe(
      'leaderboard:get',
      _encodeGetTypeArgs((id: id)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<GetTypeResult>(_decodeGetTypeResult(value));
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<GetTypeResult>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<GetTypeResult>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<GetTypeResult>(subscription$, typedStream$);
  }

  ConvexQueryReference<GetTypeArgs, GetTypeResult> get getValueQuery =>
      getValueQueryReference;

  Future<JoinResult> join({required LeaderboardId id}) async {
    final raw$ = await _client.mutate(
      'leaderboard:join',
      _encodeJoinArgs((id: id)),
    );
    return JoinResult.fromJson(raw$);
  }

  ConvexMutationReference<JoinArgs, JoinResult> get joinMutation =>
      joinMutationReference;

  Future<Null> leave({required LeaderboardId id}) async {
    await _client.mutate('leaderboard:leave', _encodeLeaveArgs((id: id)));
    return null;
  }

  ConvexMutationReference<LeaveArgs, void> get leaveMutation =>
      leaveMutationReference;

  Future<List<ListCurrentResultItem>> listCurrent() async {
    final raw$ = await _client.query(
      'leaderboard:listCurrent',
      const <String, dynamic>{},
    );
    return expectList(
      raw$,
      label: 'ListCurrentResult',
    ).map((item) => _decodeListCurrentResultItem(item)).toList();
  }

  TypedConvexSubscription<List<ListCurrentResultItem>> listCurrentSubscribe() {
    final subscription$ = _client.subscribe(
      'leaderboard:listCurrent',
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

  Future<Null> remove({
    required LeaderboardId id,
    required UserId userId,
  }) async {
    await _client.mutate(
      'leaderboard:remove',
      _encodeRemoveArgs((id: id, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<RemoveArgs, void> get removeMutation =>
      removeMutationReference;

  Future<Null> softDelete({required LeaderboardId id}) async {
    await _client.mutate(
      'leaderboard:softDelete',
      _encodeSoftDeleteArgs((id: id)),
    );
    return null;
  }

  ConvexMutationReference<SoftDeleteArgs, void> get softDeleteMutation =>
      softDeleteMutationReference;

  Future<StandingsResult> standings({
    required LeaderboardId id,
    Optional<String> month = const Optional.absent(),
    Optional<double> refreshAt = const Optional.absent(),
  }) async {
    final raw$ = await _client.query(
      'leaderboard:standings',
      _encodeStandingsArgs((id: id, month: month, refreshAt: refreshAt)),
    );
    return _decodeStandingsResult(raw$);
  }

  TypedConvexSubscription<StandingsResult> standingsSubscribe({
    required LeaderboardId id,
    Optional<String> month = const Optional.absent(),
    Optional<double> refreshAt = const Optional.absent(),
  }) {
    final subscription$ = _client.subscribe(
      'leaderboard:standings',
      _encodeStandingsArgs((id: id, month: month, refreshAt: refreshAt)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<StandingsResult>(
            _decodeStandingsResult(value),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<StandingsResult>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<StandingsResult>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<StandingsResult>(
      subscription$,
      typedStream$,
    );
  }

  ConvexQueryReference<StandingsArgs, StandingsResult> get standingsQuery =>
      standingsQueryReference;

  Future<Null> unban({
    required LeaderboardId id,
    required UserId userId,
  }) async {
    await _client.mutate(
      'leaderboard:unban',
      _encodeUnbanArgs((id: id, userId: userId)),
    );
    return null;
  }

  ConvexMutationReference<UnbanArgs, void> get unbanMutation =>
      unbanMutationReference;

  Future<Null> update({
    Optional<UpdateArgsIconName> iconName = const Optional.absent(),
    required LeaderboardId id,
    Optional<String> name = const Optional.absent(),
  }) async {
    await _client.mutate(
      'leaderboard:update',
      _encodeUpdateArgs((iconName: iconName, id: id, name: name)),
    );
    return null;
  }

  ConvexMutationReference<UpdateArgs, void> get updateMutation =>
      updateMutationReference;
}

typedef BanArgs = ({LeaderboardId id, UserId userId});

Map<String, dynamic> _encodeBanArgs(BanArgs value$) {
  final (id: id, userId: userId) = value$;
  return <String, dynamic>{'id': id.value, 'userId': userId.value};
}

BanArgs _decodeBanArgs(dynamic raw) {
  final map = expectMap(raw, label: 'BanArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for BanArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for BanArgs');
  }
  return (
    id: LeaderboardId(expectString(map['id'], label: 'BanArgsId')),
    userId: UserId(expectString(map['userId'], label: 'BanArgsUserId')),
  );
}

enum CreateArgsIconName {
  trophyValue('trophy'),
  medalValue('medal'),
  starValue('star'),
  diamondValue('diamond'),
  flameValue('flame'),
  boltValue('bolt'),
  rocketValue('rocket'),
  targetValue('target'),
  beerValue('beer'),
  wineValue('wine'),
  cocktailValue('cocktail'),
  coffeeValue('coffee'),
  heartValue('heart'),
  sadValue('sad'),
  partyValue('party'),
  musicValue('music'),
  gamepadValue('gamepad'),
  petValue('pet'),
  natureValue('nature'),
  sunValue('sun'),
  moonValue('moon'),
  flagValue('flag'),
  shieldValue('shield'),
  lightbulbValue('lightbulb');

  const CreateArgsIconName(this.value);
  final Object? value;

  static CreateArgsIconName fromJson(dynamic raw) {
    switch (raw) {
      case 'trophy':
        return CreateArgsIconName.trophyValue;
      case 'medal':
        return CreateArgsIconName.medalValue;
      case 'star':
        return CreateArgsIconName.starValue;
      case 'diamond':
        return CreateArgsIconName.diamondValue;
      case 'flame':
        return CreateArgsIconName.flameValue;
      case 'bolt':
        return CreateArgsIconName.boltValue;
      case 'rocket':
        return CreateArgsIconName.rocketValue;
      case 'target':
        return CreateArgsIconName.targetValue;
      case 'beer':
        return CreateArgsIconName.beerValue;
      case 'wine':
        return CreateArgsIconName.wineValue;
      case 'cocktail':
        return CreateArgsIconName.cocktailValue;
      case 'coffee':
        return CreateArgsIconName.coffeeValue;
      case 'heart':
        return CreateArgsIconName.heartValue;
      case 'sad':
        return CreateArgsIconName.sadValue;
      case 'party':
        return CreateArgsIconName.partyValue;
      case 'music':
        return CreateArgsIconName.musicValue;
      case 'gamepad':
        return CreateArgsIconName.gamepadValue;
      case 'pet':
        return CreateArgsIconName.petValue;
      case 'nature':
        return CreateArgsIconName.natureValue;
      case 'sun':
        return CreateArgsIconName.sunValue;
      case 'moon':
        return CreateArgsIconName.moonValue;
      case 'flag':
        return CreateArgsIconName.flagValue;
      case 'shield':
        return CreateArgsIconName.shieldValue;
      case 'lightbulb':
        return CreateArgsIconName.lightbulbValue;
      default:
        throw FormatException(
          'Expected one of trophy, medal, star, diamond, flame, bolt, rocket, target, beer, wine, cocktail, coffee, heart, sad, party, music, gamepad, pet, nature, sun, moon, flag, shield, lightbulb for CreateArgsIconName',
        );
    }
  }
}

typedef CreateArgs = ({CreateArgsIconName iconName, String name});

Map<String, dynamic> _encodeCreateArgs(CreateArgs value$) {
  final (iconName: iconName, name: name) = value$;
  return <String, dynamic>{'iconName': iconName.value, 'name': name};
}

CreateArgs _decodeCreateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'CreateArgs');
  if (!map.containsKey('iconName')) {
    throw FormatException('Missing required field "iconName" for CreateArgs');
  }
  if (!map.containsKey('name')) {
    throw FormatException('Missing required field "name" for CreateArgs');
  }
  return (
    iconName: CreateArgsIconName.fromJson(map['iconName']),
    name: expectString(map['name'], label: 'CreateArgsName'),
  );
}

typedef FindByInviteCodeResult = ({
  String iconName,
  LeaderboardId id,
  double memberCount,
  String name,
});

Map<String, dynamic> _encodeFindByInviteCodeResult(
  FindByInviteCodeResult value$,
) {
  final (iconName: iconName, id: id, memberCount: memberCount, name: name) =
      value$;
  return <String, dynamic>{
    'iconName': iconName,
    'id': id.value,
    'memberCount': memberCount,
    'name': name,
  };
}

FindByInviteCodeResult _decodeFindByInviteCodeResult(dynamic raw) {
  final map = expectMap(raw, label: 'FindByInviteCodeResult');
  if (!map.containsKey('iconName')) {
    throw FormatException(
      'Missing required field "iconName" for FindByInviteCodeResult',
    );
  }
  if (!map.containsKey('id')) {
    throw FormatException(
      'Missing required field "id" for FindByInviteCodeResult',
    );
  }
  if (!map.containsKey('memberCount')) {
    throw FormatException(
      'Missing required field "memberCount" for FindByInviteCodeResult',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException(
      'Missing required field "name" for FindByInviteCodeResult',
    );
  }
  return (
    iconName: expectString(
      map['iconName'],
      label: 'FindByInviteCodeResultIconName',
    ),
    id: LeaderboardId(
      expectString(map['id'], label: 'FindByInviteCodeResultId'),
    ),
    memberCount: expectDouble(
      map['memberCount'],
      label: 'FindByInviteCodeResultMemberCount',
    ),
    name: expectString(map['name'], label: 'FindByInviteCodeResultName'),
  );
}

typedef FindByInviteCodeArgs = ({String inviteCode});

Map<String, dynamic> _encodeFindByInviteCodeArgs(FindByInviteCodeArgs value$) {
  final (inviteCode: inviteCode) = value$;
  return <String, dynamic>{'inviteCode': inviteCode};
}

FindByInviteCodeArgs _decodeFindByInviteCodeArgs(dynamic raw) {
  final map = expectMap(raw, label: 'FindByInviteCodeArgs');
  if (!map.containsKey('inviteCode')) {
    throw FormatException(
      'Missing required field "inviteCode" for FindByInviteCodeArgs',
    );
  }
  return (
    inviteCode: expectString(
      map['inviteCode'],
      label: 'FindByInviteCodeArgsInviteCode',
    ),
  );
}

enum GetTypeResultBannedMembersItemAccentColor {
  amberValue('amber'),
  roseValue('rose'),
  violetValue('violet'),
  skyValue('sky'),
  emeraldValue('emerald'),
  limeValue('lime'),
  orangeValue('orange'),
  fuchsiaValue('fuchsia');

  const GetTypeResultBannedMembersItemAccentColor(this.value);
  final Object? value;

  static GetTypeResultBannedMembersItemAccentColor fromJson(dynamic raw) {
    switch (raw) {
      case 'amber':
        return GetTypeResultBannedMembersItemAccentColor.amberValue;
      case 'rose':
        return GetTypeResultBannedMembersItemAccentColor.roseValue;
      case 'violet':
        return GetTypeResultBannedMembersItemAccentColor.violetValue;
      case 'sky':
        return GetTypeResultBannedMembersItemAccentColor.skyValue;
      case 'emerald':
        return GetTypeResultBannedMembersItemAccentColor.emeraldValue;
      case 'lime':
        return GetTypeResultBannedMembersItemAccentColor.limeValue;
      case 'orange':
        return GetTypeResultBannedMembersItemAccentColor.orangeValue;
      case 'fuchsia':
        return GetTypeResultBannedMembersItemAccentColor.fuchsiaValue;
      default:
        throw FormatException(
          'Expected one of amber, rose, violet, sky, emerald, lime, orange, fuchsia for GetTypeResultBannedMembersItemAccentColor',
        );
    }
  }
}

typedef GetTypeResultBannedMembersItem = ({
  UserId id,
  GetTypeResultBannedMembersItemAccentColor accentColor,
  String? avatarUrl,
  String username,
});

Map<String, dynamic> _encodeGetTypeResultBannedMembersItem(
  GetTypeResultBannedMembersItem value$,
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

GetTypeResultBannedMembersItem _decodeGetTypeResultBannedMembersItem(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'GetTypeResultBannedMembersItem');
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for GetTypeResultBannedMembersItem',
    );
  }
  if (!map.containsKey('accentColor')) {
    throw FormatException(
      'Missing required field "accentColor" for GetTypeResultBannedMembersItem',
    );
  }
  if (!map.containsKey('avatarUrl')) {
    throw FormatException(
      'Missing required field "avatarUrl" for GetTypeResultBannedMembersItem',
    );
  }
  if (!map.containsKey('username')) {
    throw FormatException(
      'Missing required field "username" for GetTypeResultBannedMembersItem',
    );
  }
  return (
    id: UserId(
      expectString(map['_id'], label: 'GetTypeResultBannedMembersItemId'),
    ),
    accentColor: GetTypeResultBannedMembersItemAccentColor.fromJson(
      map['accentColor'],
    ),
    avatarUrl: map['avatarUrl'] == null
        ? null
        : expectString(
            map['avatarUrl'],
            label: 'GetTypeResultBannedMembersItemAvatarUrl',
          ),
    username: expectString(
      map['username'],
      label: 'GetTypeResultBannedMembersItemUsername',
    ),
  );
}

Map<String, dynamic> _encodeLeaderboardDocument(LeaderboardDocument value$) {
  final (
    ownerId: ownerId,
    name: name,
    iconName: iconName,
    inviteCode: inviteCode,
    timeZone: timeZone,
    endOfDayBoundary: endOfDayBoundary,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    id: id,
    creationTime: creationTime,
  ) = value$;
  return <String, dynamic>{
    'ownerId': ownerId.value,
    'name': name,
    'iconName': iconName,
    'inviteCode': inviteCode,
    'timeZone': timeZone,
    'endOfDayBoundary': endOfDayBoundary,
    'updatedAt': updatedAt,
    'deletedAt': deletedAt,
    '_id': id.value,
    '_creationTime': creationTime,
  };
}

LeaderboardDocument _decodeLeaderboardDocument(dynamic raw) {
  final map = expectMap(raw, label: 'LeaderboardDocument');
  if (!map.containsKey('ownerId')) {
    throw FormatException(
      'Missing required field "ownerId" for LeaderboardDocument',
    );
  }
  if (!map.containsKey('name')) {
    throw FormatException(
      'Missing required field "name" for LeaderboardDocument',
    );
  }
  if (!map.containsKey('iconName')) {
    throw FormatException(
      'Missing required field "iconName" for LeaderboardDocument',
    );
  }
  if (!map.containsKey('inviteCode')) {
    throw FormatException(
      'Missing required field "inviteCode" for LeaderboardDocument',
    );
  }
  if (!map.containsKey('timeZone')) {
    throw FormatException(
      'Missing required field "timeZone" for LeaderboardDocument',
    );
  }
  if (!map.containsKey('endOfDayBoundary')) {
    throw FormatException(
      'Missing required field "endOfDayBoundary" for LeaderboardDocument',
    );
  }
  if (!map.containsKey('updatedAt')) {
    throw FormatException(
      'Missing required field "updatedAt" for LeaderboardDocument',
    );
  }
  if (!map.containsKey('deletedAt')) {
    throw FormatException(
      'Missing required field "deletedAt" for LeaderboardDocument',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for LeaderboardDocument',
    );
  }
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for LeaderboardDocument',
    );
  }
  return (
    ownerId: UserId(
      expectString(map['ownerId'], label: 'LeaderboardDocumentOwnerId'),
    ),
    name: expectString(map['name'], label: 'LeaderboardDocumentName'),
    iconName: expectString(
      map['iconName'],
      label: 'LeaderboardDocumentIconName',
    ),
    inviteCode: expectString(
      map['inviteCode'],
      label: 'LeaderboardDocumentInviteCode',
    ),
    timeZone: expectString(
      map['timeZone'],
      label: 'LeaderboardDocumentTimeZone',
    ),
    endOfDayBoundary: expectDouble(
      map['endOfDayBoundary'],
      label: 'LeaderboardDocumentEndOfDayBoundary',
    ),
    updatedAt: expectDouble(
      map['updatedAt'],
      label: 'LeaderboardDocumentUpdatedAt',
    ),
    deletedAt: map['deletedAt'] == null
        ? null
        : expectDouble(map['deletedAt'], label: 'LeaderboardDocumentDeletedAt'),
    id: LeaderboardId(expectString(map['_id'], label: 'LeaderboardDocumentId')),
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'LeaderboardDocumentCreationTime',
    ),
  );
}

enum GetTypeResultMembersItemAccentColor {
  amberValue('amber'),
  roseValue('rose'),
  violetValue('violet'),
  skyValue('sky'),
  emeraldValue('emerald'),
  limeValue('lime'),
  orangeValue('orange'),
  fuchsiaValue('fuchsia');

  const GetTypeResultMembersItemAccentColor(this.value);
  final Object? value;

  static GetTypeResultMembersItemAccentColor fromJson(dynamic raw) {
    switch (raw) {
      case 'amber':
        return GetTypeResultMembersItemAccentColor.amberValue;
      case 'rose':
        return GetTypeResultMembersItemAccentColor.roseValue;
      case 'violet':
        return GetTypeResultMembersItemAccentColor.violetValue;
      case 'sky':
        return GetTypeResultMembersItemAccentColor.skyValue;
      case 'emerald':
        return GetTypeResultMembersItemAccentColor.emeraldValue;
      case 'lime':
        return GetTypeResultMembersItemAccentColor.limeValue;
      case 'orange':
        return GetTypeResultMembersItemAccentColor.orangeValue;
      case 'fuchsia':
        return GetTypeResultMembersItemAccentColor.fuchsiaValue;
      default:
        throw FormatException(
          'Expected one of amber, rose, violet, sky, emerald, lime, orange, fuchsia for GetTypeResultMembersItemAccentColor',
        );
    }
  }
}

typedef GetTypeResultMembersItem = ({
  UserId id,
  GetTypeResultMembersItemAccentColor accentColor,
  String? avatarUrl,
  String username,
});

Map<String, dynamic> _encodeGetTypeResultMembersItem(
  GetTypeResultMembersItem value$,
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

GetTypeResultMembersItem _decodeGetTypeResultMembersItem(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResultMembersItem');
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for GetTypeResultMembersItem',
    );
  }
  if (!map.containsKey('accentColor')) {
    throw FormatException(
      'Missing required field "accentColor" for GetTypeResultMembersItem',
    );
  }
  if (!map.containsKey('avatarUrl')) {
    throw FormatException(
      'Missing required field "avatarUrl" for GetTypeResultMembersItem',
    );
  }
  if (!map.containsKey('username')) {
    throw FormatException(
      'Missing required field "username" for GetTypeResultMembersItem',
    );
  }
  return (
    id: UserId(expectString(map['_id'], label: 'GetTypeResultMembersItemId')),
    accentColor: GetTypeResultMembersItemAccentColor.fromJson(
      map['accentColor'],
    ),
    avatarUrl: map['avatarUrl'] == null
        ? null
        : expectString(
            map['avatarUrl'],
            label: 'GetTypeResultMembersItemAvatarUrl',
          ),
    username: expectString(
      map['username'],
      label: 'GetTypeResultMembersItemUsername',
    ),
  );
}

typedef GetTypeResult = ({
  List<GetTypeResultBannedMembersItem> bannedMembers,
  LeaderboardDocument leaderboard,
  List<GetTypeResultMembersItem> members,
});

Map<String, dynamic> _encodeGetTypeResult(GetTypeResult value$) {
  final (
    bannedMembers: bannedMembers,
    leaderboard: leaderboard,
    members: members,
  ) = value$;
  return <String, dynamic>{
    'bannedMembers': bannedMembers
        .map((item) => _encodeGetTypeResultBannedMembersItem(item))
        .toList(),
    'leaderboard': _encodeLeaderboardDocument(leaderboard),
    'members': members
        .map((item) => _encodeGetTypeResultMembersItem(item))
        .toList(),
  };
}

GetTypeResult _decodeGetTypeResult(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeResult');
  if (!map.containsKey('bannedMembers')) {
    throw FormatException(
      'Missing required field "bannedMembers" for GetTypeResult',
    );
  }
  if (!map.containsKey('leaderboard')) {
    throw FormatException(
      'Missing required field "leaderboard" for GetTypeResult',
    );
  }
  if (!map.containsKey('members')) {
    throw FormatException('Missing required field "members" for GetTypeResult');
  }
  return (
    bannedMembers: expectList(
      map['bannedMembers'],
      label: 'GetTypeResultBannedMembers',
    ).map((item) => _decodeGetTypeResultBannedMembersItem(item)).toList(),
    leaderboard: _decodeLeaderboardDocument(map['leaderboard']),
    members: expectList(
      map['members'],
      label: 'GetTypeResultMembers',
    ).map((item) => _decodeGetTypeResultMembersItem(item)).toList(),
  );
}

typedef GetTypeArgs = ({LeaderboardId id});

Map<String, dynamic> _encodeGetTypeArgs(GetTypeArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

GetTypeArgs _decodeGetTypeArgs(dynamic raw) {
  final map = expectMap(raw, label: 'GetTypeArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for GetTypeArgs');
  }
  return (id: LeaderboardId(expectString(map['id'], label: 'GetTypeArgsId')));
}

enum JoinResult {
  successValue('success'),
  alreadyMemberValue('alreadyMember'),
  bannedValue('banned'),
  fullValue('full');

  const JoinResult(this.value);
  final Object? value;

  static JoinResult fromJson(dynamic raw) {
    switch (raw) {
      case 'success':
        return JoinResult.successValue;
      case 'alreadyMember':
        return JoinResult.alreadyMemberValue;
      case 'banned':
        return JoinResult.bannedValue;
      case 'full':
        return JoinResult.fullValue;
      default:
        throw FormatException(
          'Expected one of success, alreadyMember, banned, full for JoinResult',
        );
    }
  }
}

typedef JoinArgs = ({LeaderboardId id});

Map<String, dynamic> _encodeJoinArgs(JoinArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

JoinArgs _decodeJoinArgs(dynamic raw) {
  final map = expectMap(raw, label: 'JoinArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for JoinArgs');
  }
  return (id: LeaderboardId(expectString(map['id'], label: 'JoinArgsId')));
}

typedef LeaveArgs = ({LeaderboardId id});

Map<String, dynamic> _encodeLeaveArgs(LeaveArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

LeaveArgs _decodeLeaveArgs(dynamic raw) {
  final map = expectMap(raw, label: 'LeaveArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for LeaveArgs');
  }
  return (id: LeaderboardId(expectString(map['id'], label: 'LeaveArgsId')));
}

typedef ListCurrentResultItem = ({
  LeaderboardDocument leaderboard,
  double memberCount,
});

Map<String, dynamic> _encodeListCurrentResultItem(
  ListCurrentResultItem value$,
) {
  final (leaderboard: leaderboard, memberCount: memberCount) = value$;
  return <String, dynamic>{
    'leaderboard': _encodeLeaderboardDocument(leaderboard),
    'memberCount': memberCount,
  };
}

ListCurrentResultItem _decodeListCurrentResultItem(dynamic raw) {
  final map = expectMap(raw, label: 'ListCurrentResultItem');
  if (!map.containsKey('leaderboard')) {
    throw FormatException(
      'Missing required field "leaderboard" for ListCurrentResultItem',
    );
  }
  if (!map.containsKey('memberCount')) {
    throw FormatException(
      'Missing required field "memberCount" for ListCurrentResultItem',
    );
  }
  return (
    leaderboard: _decodeLeaderboardDocument(map['leaderboard']),
    memberCount: expectDouble(
      map['memberCount'],
      label: 'ListCurrentResultItemMemberCount',
    ),
  );
}

typedef RemoveArgs = ({LeaderboardId id, UserId userId});

Map<String, dynamic> _encodeRemoveArgs(RemoveArgs value$) {
  final (id: id, userId: userId) = value$;
  return <String, dynamic>{'id': id.value, 'userId': userId.value};
}

RemoveArgs _decodeRemoveArgs(dynamic raw) {
  final map = expectMap(raw, label: 'RemoveArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for RemoveArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for RemoveArgs');
  }
  return (
    id: LeaderboardId(expectString(map['id'], label: 'RemoveArgsId')),
    userId: UserId(expectString(map['userId'], label: 'RemoveArgsUserId')),
  );
}

typedef SoftDeleteArgs = ({LeaderboardId id});

Map<String, dynamic> _encodeSoftDeleteArgs(SoftDeleteArgs value$) {
  final (id: id) = value$;
  return <String, dynamic>{'id': id.value};
}

SoftDeleteArgs _decodeSoftDeleteArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SoftDeleteArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for SoftDeleteArgs');
  }
  return (
    id: LeaderboardId(expectString(map['id'], label: 'SoftDeleteArgsId')),
  );
}

enum StandingsResultEntriesItemUserAccentColor {
  amberValue('amber'),
  roseValue('rose'),
  violetValue('violet'),
  skyValue('sky'),
  emeraldValue('emerald'),
  limeValue('lime'),
  orangeValue('orange'),
  fuchsiaValue('fuchsia');

  const StandingsResultEntriesItemUserAccentColor(this.value);
  final Object? value;

  static StandingsResultEntriesItemUserAccentColor fromJson(dynamic raw) {
    switch (raw) {
      case 'amber':
        return StandingsResultEntriesItemUserAccentColor.amberValue;
      case 'rose':
        return StandingsResultEntriesItemUserAccentColor.roseValue;
      case 'violet':
        return StandingsResultEntriesItemUserAccentColor.violetValue;
      case 'sky':
        return StandingsResultEntriesItemUserAccentColor.skyValue;
      case 'emerald':
        return StandingsResultEntriesItemUserAccentColor.emeraldValue;
      case 'lime':
        return StandingsResultEntriesItemUserAccentColor.limeValue;
      case 'orange':
        return StandingsResultEntriesItemUserAccentColor.orangeValue;
      case 'fuchsia':
        return StandingsResultEntriesItemUserAccentColor.fuchsiaValue;
      default:
        throw FormatException(
          'Expected one of amber, rose, violet, sky, emerald, lime, orange, fuchsia for StandingsResultEntriesItemUserAccentColor',
        );
    }
  }
}

typedef StandingsResultEntriesItemUser = ({
  UserId id,
  StandingsResultEntriesItemUserAccentColor accentColor,
  String? avatarUrl,
  String username,
});

Map<String, dynamic> _encodeStandingsResultEntriesItemUser(
  StandingsResultEntriesItemUser value$,
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

StandingsResultEntriesItemUser _decodeStandingsResultEntriesItemUser(
  dynamic raw,
) {
  final map = expectMap(raw, label: 'StandingsResultEntriesItemUser');
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for StandingsResultEntriesItemUser',
    );
  }
  if (!map.containsKey('accentColor')) {
    throw FormatException(
      'Missing required field "accentColor" for StandingsResultEntriesItemUser',
    );
  }
  if (!map.containsKey('avatarUrl')) {
    throw FormatException(
      'Missing required field "avatarUrl" for StandingsResultEntriesItemUser',
    );
  }
  if (!map.containsKey('username')) {
    throw FormatException(
      'Missing required field "username" for StandingsResultEntriesItemUser',
    );
  }
  return (
    id: UserId(
      expectString(map['_id'], label: 'StandingsResultEntriesItemUserId'),
    ),
    accentColor: StandingsResultEntriesItemUserAccentColor.fromJson(
      map['accentColor'],
    ),
    avatarUrl: map['avatarUrl'] == null
        ? null
        : expectString(
            map['avatarUrl'],
            label: 'StandingsResultEntriesItemUserAvatarUrl',
          ),
    username: expectString(
      map['username'],
      label: 'StandingsResultEntriesItemUserUsername',
    ),
  );
}

typedef StandingsResultEntriesItem = ({
  double alcoholConsumedMl,
  double beersConsumed,
  double rankByAlcohol,
  double rankByBeers,
  StandingsResultEntriesItemUser user,
});

Map<String, dynamic> _encodeStandingsResultEntriesItem(
  StandingsResultEntriesItem value$,
) {
  final (
    alcoholConsumedMl: alcoholConsumedMl,
    beersConsumed: beersConsumed,
    rankByAlcohol: rankByAlcohol,
    rankByBeers: rankByBeers,
    user: user,
  ) = value$;
  return <String, dynamic>{
    'alcoholConsumedMl': alcoholConsumedMl,
    'beersConsumed': beersConsumed,
    'rankByAlcohol': rankByAlcohol,
    'rankByBeers': rankByBeers,
    'user': _encodeStandingsResultEntriesItemUser(user),
  };
}

StandingsResultEntriesItem _decodeStandingsResultEntriesItem(dynamic raw) {
  final map = expectMap(raw, label: 'StandingsResultEntriesItem');
  if (!map.containsKey('alcoholConsumedMl')) {
    throw FormatException(
      'Missing required field "alcoholConsumedMl" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('beersConsumed')) {
    throw FormatException(
      'Missing required field "beersConsumed" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('rankByAlcohol')) {
    throw FormatException(
      'Missing required field "rankByAlcohol" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('rankByBeers')) {
    throw FormatException(
      'Missing required field "rankByBeers" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('user')) {
    throw FormatException(
      'Missing required field "user" for StandingsResultEntriesItem',
    );
  }
  return (
    alcoholConsumedMl: expectDouble(
      map['alcoholConsumedMl'],
      label: 'StandingsResultEntriesItemAlcoholConsumedMl',
    ),
    beersConsumed: expectDouble(
      map['beersConsumed'],
      label: 'StandingsResultEntriesItemBeersConsumed',
    ),
    rankByAlcohol: expectDouble(
      map['rankByAlcohol'],
      label: 'StandingsResultEntriesItemRankByAlcohol',
    ),
    rankByBeers: expectDouble(
      map['rankByBeers'],
      label: 'StandingsResultEntriesItemRankByBeers',
    ),
    user: _decodeStandingsResultEntriesItemUser(map['user']),
  );
}

typedef StandingsResult = ({
  String currentMonth,
  List<StandingsResultEntriesItem> entries,
  String month,
  double nextMonthAt,
});

Map<String, dynamic> _encodeStandingsResult(StandingsResult value$) {
  final (
    currentMonth: currentMonth,
    entries: entries,
    month: month,
    nextMonthAt: nextMonthAt,
  ) = value$;
  return <String, dynamic>{
    'currentMonth': currentMonth,
    'entries': entries
        .map((item) => _encodeStandingsResultEntriesItem(item))
        .toList(),
    'month': month,
    'nextMonthAt': nextMonthAt,
  };
}

StandingsResult _decodeStandingsResult(dynamic raw) {
  final map = expectMap(raw, label: 'StandingsResult');
  if (!map.containsKey('currentMonth')) {
    throw FormatException(
      'Missing required field "currentMonth" for StandingsResult',
    );
  }
  if (!map.containsKey('entries')) {
    throw FormatException(
      'Missing required field "entries" for StandingsResult',
    );
  }
  if (!map.containsKey('month')) {
    throw FormatException('Missing required field "month" for StandingsResult');
  }
  if (!map.containsKey('nextMonthAt')) {
    throw FormatException(
      'Missing required field "nextMonthAt" for StandingsResult',
    );
  }
  return (
    currentMonth: expectString(
      map['currentMonth'],
      label: 'StandingsResultCurrentMonth',
    ),
    entries: expectList(
      map['entries'],
      label: 'StandingsResultEntries',
    ).map((item) => _decodeStandingsResultEntriesItem(item)).toList(),
    month: expectString(map['month'], label: 'StandingsResultMonth'),
    nextMonthAt: expectDouble(
      map['nextMonthAt'],
      label: 'StandingsResultNextMonthAt',
    ),
  );
}

typedef StandingsArgs = ({
  LeaderboardId id,
  Optional<String> month,
  Optional<double> refreshAt,
});

Map<String, dynamic> _encodeStandingsArgs(StandingsArgs value$) {
  final (id: id, month: month, refreshAt: refreshAt) = value$;
  return <String, dynamic>{
    'id': id.value,
    if (month.isDefined) 'month': month.value,
    if (refreshAt.isDefined) 'refreshAt': refreshAt.value,
  };
}

StandingsArgs _decodeStandingsArgs(dynamic raw) {
  final map = expectMap(raw, label: 'StandingsArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for StandingsArgs');
  }
  return (
    id: LeaderboardId(expectString(map['id'], label: 'StandingsArgsId')),
    month: map.containsKey('month')
        ? Optional.of(expectString(map['month'], label: 'StandingsArgsMonth'))
        : const Optional.absent(),
    refreshAt: map.containsKey('refreshAt')
        ? Optional.of(
            expectDouble(map['refreshAt'], label: 'StandingsArgsRefreshAt'),
          )
        : const Optional.absent(),
  );
}

typedef UnbanArgs = ({LeaderboardId id, UserId userId});

Map<String, dynamic> _encodeUnbanArgs(UnbanArgs value$) {
  final (id: id, userId: userId) = value$;
  return <String, dynamic>{'id': id.value, 'userId': userId.value};
}

UnbanArgs _decodeUnbanArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UnbanArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for UnbanArgs');
  }
  if (!map.containsKey('userId')) {
    throw FormatException('Missing required field "userId" for UnbanArgs');
  }
  return (
    id: LeaderboardId(expectString(map['id'], label: 'UnbanArgsId')),
    userId: UserId(expectString(map['userId'], label: 'UnbanArgsUserId')),
  );
}

enum UpdateArgsIconName {
  trophyValue('trophy'),
  medalValue('medal'),
  starValue('star'),
  diamondValue('diamond'),
  flameValue('flame'),
  boltValue('bolt'),
  rocketValue('rocket'),
  targetValue('target'),
  beerValue('beer'),
  wineValue('wine'),
  cocktailValue('cocktail'),
  coffeeValue('coffee'),
  heartValue('heart'),
  sadValue('sad'),
  partyValue('party'),
  musicValue('music'),
  gamepadValue('gamepad'),
  petValue('pet'),
  natureValue('nature'),
  sunValue('sun'),
  moonValue('moon'),
  flagValue('flag'),
  shieldValue('shield'),
  lightbulbValue('lightbulb');

  const UpdateArgsIconName(this.value);
  final Object? value;

  static UpdateArgsIconName fromJson(dynamic raw) {
    switch (raw) {
      case 'trophy':
        return UpdateArgsIconName.trophyValue;
      case 'medal':
        return UpdateArgsIconName.medalValue;
      case 'star':
        return UpdateArgsIconName.starValue;
      case 'diamond':
        return UpdateArgsIconName.diamondValue;
      case 'flame':
        return UpdateArgsIconName.flameValue;
      case 'bolt':
        return UpdateArgsIconName.boltValue;
      case 'rocket':
        return UpdateArgsIconName.rocketValue;
      case 'target':
        return UpdateArgsIconName.targetValue;
      case 'beer':
        return UpdateArgsIconName.beerValue;
      case 'wine':
        return UpdateArgsIconName.wineValue;
      case 'cocktail':
        return UpdateArgsIconName.cocktailValue;
      case 'coffee':
        return UpdateArgsIconName.coffeeValue;
      case 'heart':
        return UpdateArgsIconName.heartValue;
      case 'sad':
        return UpdateArgsIconName.sadValue;
      case 'party':
        return UpdateArgsIconName.partyValue;
      case 'music':
        return UpdateArgsIconName.musicValue;
      case 'gamepad':
        return UpdateArgsIconName.gamepadValue;
      case 'pet':
        return UpdateArgsIconName.petValue;
      case 'nature':
        return UpdateArgsIconName.natureValue;
      case 'sun':
        return UpdateArgsIconName.sunValue;
      case 'moon':
        return UpdateArgsIconName.moonValue;
      case 'flag':
        return UpdateArgsIconName.flagValue;
      case 'shield':
        return UpdateArgsIconName.shieldValue;
      case 'lightbulb':
        return UpdateArgsIconName.lightbulbValue;
      default:
        throw FormatException(
          'Expected one of trophy, medal, star, diamond, flame, bolt, rocket, target, beer, wine, cocktail, coffee, heart, sad, party, music, gamepad, pet, nature, sun, moon, flag, shield, lightbulb for UpdateArgsIconName',
        );
    }
  }
}

typedef UpdateArgs = ({
  Optional<UpdateArgsIconName> iconName,
  LeaderboardId id,
  Optional<String> name,
});

Map<String, dynamic> _encodeUpdateArgs(UpdateArgs value$) {
  final (iconName: iconName, id: id, name: name) = value$;
  return <String, dynamic>{
    if (iconName.isDefined) 'iconName': iconName.value.value,
    'id': id.value,
    if (name.isDefined) 'name': name.value,
  };
}

UpdateArgs _decodeUpdateArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateArgs');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for UpdateArgs');
  }
  return (
    iconName: map.containsKey('iconName')
        ? Optional.of(UpdateArgsIconName.fromJson(map['iconName']))
        : const Optional.absent(),
    id: LeaderboardId(expectString(map['id'], label: 'UpdateArgsId')),
    name: map.containsKey('name')
        ? Optional.of(expectString(map['name'], label: 'UpdateArgsName'))
        : const Optional.absent(),
  );
}

final ConvexMutationReference<BanArgs, void> banMutationReference =
    ConvexMutationReference(
      name: 'leaderboard:ban',
      encode: (args) => _encodeBanArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<CreateArgs, LeaderboardId>
createMutationReference = ConvexMutationReference(
  name: 'leaderboard:create',
  encode: (args) => _encodeCreateArgs(args),
  decode: (raw) => LeaderboardId(expectString(raw, label: 'CreateResult')),
);

final ConvexQueryReference<FindByInviteCodeArgs, FindByInviteCodeResult?>
findByInviteCodeQueryReference = ConvexQueryReference(
  name: 'leaderboard:findByInviteCode',
  encode: (args) => _encodeFindByInviteCodeArgs(args),
  decodeArgs: (raw) => _decodeFindByInviteCodeArgs(raw),
  decode: (raw) => raw == null ? null : _decodeFindByInviteCodeResult(raw),
  encodeResult: (value) => switch (value) {
    null => null,
    final v$ => _encodeFindByInviteCodeResult(v$),
  },
);

final ConvexQueryReference<GetTypeArgs, GetTypeResult> getValueQueryReference =
    ConvexQueryReference(
      name: 'leaderboard:get',
      encode: (args) => _encodeGetTypeArgs(args),
      decodeArgs: (raw) => _decodeGetTypeArgs(raw),
      decode: (raw) => _decodeGetTypeResult(raw),
      encodeResult: (value) => _encodeGetTypeResult(value),
    );

final ConvexMutationReference<JoinArgs, JoinResult> joinMutationReference =
    ConvexMutationReference(
      name: 'leaderboard:join',
      encode: (args) => _encodeJoinArgs(args),
      decode: (raw) => JoinResult.fromJson(raw),
    );

final ConvexMutationReference<LeaveArgs, void> leaveMutationReference =
    ConvexMutationReference(
      name: 'leaderboard:leave',
      encode: (args) => _encodeLeaveArgs(args),
      decode: (raw) => null,
    );

final ConvexQueryReference<NoArgs, List<ListCurrentResultItem>>
listCurrentQueryReference = ConvexQueryReference(
  name: 'leaderboard:listCurrent',
  encode: (args) => const <String, dynamic>{},
  decodeArgs: (raw) => const NoArgs(),
  decode: (raw) => expectList(
    raw,
    label: 'ListCurrentResult',
  ).map((item) => _decodeListCurrentResultItem(item)).toList(),
  encodeResult: (value) =>
      value.map((item) => _encodeListCurrentResultItem(item)).toList(),
);

final ConvexMutationReference<RemoveArgs, void> removeMutationReference =
    ConvexMutationReference(
      name: 'leaderboard:remove',
      encode: (args) => _encodeRemoveArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<SoftDeleteArgs, void>
softDeleteMutationReference = ConvexMutationReference(
  name: 'leaderboard:softDelete',
  encode: (args) => _encodeSoftDeleteArgs(args),
  decode: (raw) => null,
);

final ConvexQueryReference<StandingsArgs, StandingsResult>
standingsQueryReference = ConvexQueryReference(
  name: 'leaderboard:standings',
  encode: (args) => _encodeStandingsArgs(args),
  decodeArgs: (raw) => _decodeStandingsArgs(raw),
  decode: (raw) => _decodeStandingsResult(raw),
  encodeResult: (value) => _encodeStandingsResult(value),
);

final ConvexMutationReference<UnbanArgs, void> unbanMutationReference =
    ConvexMutationReference(
      name: 'leaderboard:unban',
      encode: (args) => _encodeUnbanArgs(args),
      decode: (raw) => null,
    );

final ConvexMutationReference<UpdateArgs, void> updateMutationReference =
    ConvexMutationReference(
      name: 'leaderboard:update',
      encode: (args) => _encodeUpdateArgs(args),
      decode: (raw) => null,
    );
