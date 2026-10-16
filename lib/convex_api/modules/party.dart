// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class PartyApi {
  const PartyApi(this._client);

  final ConvexFunctionCaller _client;

  Future<ActivityResult> activity({
    Optional<ActivityArgsCursor> cursor = const Optional.absent(),
    Optional<List<ActivityArgsKindsItem>> kinds = const Optional.absent(),
    Optional<double> pageSize = const Optional.absent(),
    Optional<List<UserId>> participantIds = const Optional.absent(),
    required SessionId sessionId,
  }) async {
    final raw$ = await _client.query(
      'party:activity',
      _encodeActivityArgs((
        cursor: cursor,
        kinds: kinds,
        pageSize: pageSize,
        participantIds: participantIds,
        sessionId: sessionId,
      )),
    );
    return _decodeActivityResult(raw$);
  }

  TypedConvexSubscription<ActivityResult> activitySubscribe({
    Optional<ActivityArgsCursor> cursor = const Optional.absent(),
    Optional<List<ActivityArgsKindsItem>> kinds = const Optional.absent(),
    Optional<double> pageSize = const Optional.absent(),
    Optional<List<UserId>> participantIds = const Optional.absent(),
    required SessionId sessionId,
  }) {
    final subscription$ = _client.subscribe(
      'party:activity',
      _encodeActivityArgs((
        cursor: cursor,
        kinds: kinds,
        pageSize: pageSize,
        participantIds: participantIds,
        sessionId: sessionId,
      )),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<ActivityResult>(
            _decodeActivityResult(value),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<ActivityResult>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<ActivityResult>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<ActivityResult>(subscription$, typedStream$);
  }

  ConvexQueryReference<ActivityArgs, ActivityResult> get activityQuery =>
      activityQueryReference;

  Future<StandingsResult> standings({required SessionId sessionId}) async {
    final raw$ = await _client.query(
      'party:standings',
      _encodeStandingsArgs((sessionId: sessionId)),
    );
    return _decodeStandingsResult(raw$);
  }

  TypedConvexSubscription<StandingsResult> standingsSubscribe({
    required SessionId sessionId,
  }) {
    final subscription$ = _client.subscribe(
      'party:standings',
      _encodeStandingsArgs((sessionId: sessionId)),
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
}

Map<String, dynamic> _encodeDrinkCategory(DrinkCategory value) {
  switch (value) {
    case Beer():
      return <String, dynamic>{'kind': 'beer'};
    case Cider():
      return <String, dynamic>{'kind': 'cider'};
    case Cocktail():
      return <String, dynamic>{'kind': 'cocktail'};
    case Spirit():
      return <String, dynamic>{'kind': 'spirit'};
    case Wine():
      return <String, dynamic>{'kind': 'wine'};
  }
}

DrinkCategory _decodeDrinkCategory(dynamic raw) {
  final map = expectMap(raw, label: 'DrinkCategory');
  if (!map.containsKey('kind')) {
    throw FormatException('Missing discriminator "kind" for DrinkCategory');
  }
  final discriminator = expectString(map['kind'], label: 'DrinkCategoryKind');
  switch (discriminator) {
    case 'beer':
      return const Beer();
    case 'cider':
      return const Cider();
    case 'cocktail':
      return const Cocktail();
    case 'spirit':
      return const Spirit();
    case 'wine':
      return const Wine();
    default:
      throw FormatException(
        'Unknown DrinkCategory discriminator: $discriminator',
      );
  }
}

sealed class ActivityResultEntriesItem {
  const ActivityResultEntriesItem();
  String get id;
  double get occurredAt;
  List<UserId> get participantIds;
  double get scoreUnits;
  bool get isDrinkLog => this is DrinkLog;
  bool get isSocialQuest => this is SocialQuest;
}

final class DrinkLog extends ActivityResultEntriesItem {
  const DrinkLog({
    required this.alcoholMl,
    required this.baseDrinkScoreUnits,
    required this.classBonusScoreUnits,
    required this.drinkCategory,
    required this.drinkId,
    required this.drinkLogId,
    required this.drinkName,
    required this.id,
    required this.occurredAt,
    required this.participantIds,
    required this.scoreUnits,
    required this.userId,
    required this.volumeMl,
  });

  final double alcoholMl;

  final double baseDrinkScoreUnits;

  final double classBonusScoreUnits;

  final DrinkCategory drinkCategory;

  final DrinkId drinkId;

  final DrinkLogId drinkLogId;

  final String drinkName;

  final String id;

  final double occurredAt;

  final List<UserId> participantIds;

  final double scoreUnits;

  final UserId userId;

  final double volumeMl;
}

final class SocialQuest extends ActivityResultEntriesItem {
  const SocialQuest({
    required this.firstUserId,
    required this.id,
    required this.occurredAt,
    required this.participantIds,
    required this.questId,
    required this.questTitle,
    required this.scoreUnits,
    required this.secondUserId,
  });

  final UserId firstUserId;

  final String id;

  final double occurredAt;

  final List<UserId> participantIds;

  final PartyQuestId questId;

  final String questTitle;

  final double scoreUnits;

  final UserId secondUserId;
}

Map<String, dynamic> _encodeActivityResultEntriesItem(
  ActivityResultEntriesItem value,
) {
  switch (value) {
    case DrinkLog(
      alcoholMl: final alcoholMl,
      baseDrinkScoreUnits: final baseDrinkScoreUnits,
      classBonusScoreUnits: final classBonusScoreUnits,
      drinkCategory: final drinkCategory,
      drinkId: final drinkId,
      drinkLogId: final drinkLogId,
      drinkName: final drinkName,
      id: final id,
      occurredAt: final occurredAt,
      participantIds: final participantIds,
      scoreUnits: final scoreUnits,
      userId: final userId,
      volumeMl: final volumeMl,
    ):
      return <String, dynamic>{
        'kind': 'drinkLog',
        'alcoholMl': alcoholMl,
        'baseDrinkScoreUnits': baseDrinkScoreUnits,
        'classBonusScoreUnits': classBonusScoreUnits,
        'drinkCategory': _encodeDrinkCategory(drinkCategory),
        'drinkId': drinkId.value,
        'drinkLogId': drinkLogId.value,
        'drinkName': drinkName,
        'id': id,
        'occurredAt': occurredAt,
        'participantIds': participantIds.map((item) => item.value).toList(),
        'scoreUnits': scoreUnits,
        'userId': userId.value,
        'volumeMl': volumeMl,
      };
    case SocialQuest(
      firstUserId: final firstUserId,
      id: final id,
      occurredAt: final occurredAt,
      participantIds: final participantIds,
      questId: final questId,
      questTitle: final questTitle,
      scoreUnits: final scoreUnits,
      secondUserId: final secondUserId,
    ):
      return <String, dynamic>{
        'kind': 'socialQuest',
        'firstUserId': firstUserId.value,
        'id': id,
        'occurredAt': occurredAt,
        'participantIds': participantIds.map((item) => item.value).toList(),
        'questId': questId.value,
        'questTitle': questTitle,
        'scoreUnits': scoreUnits,
        'secondUserId': secondUserId.value,
      };
  }
}

ActivityResultEntriesItem _decodeActivityResultEntriesItem(dynamic raw) {
  final map = expectMap(raw, label: 'ActivityResultEntriesItem');
  if (!map.containsKey('kind')) {
    throw FormatException(
      'Missing discriminator "kind" for ActivityResultEntriesItem',
    );
  }
  final discriminator = expectString(
    map['kind'],
    label: 'ActivityResultEntriesItemKind',
  );
  switch (discriminator) {
    case 'drinkLog':
      if (!map.containsKey('alcoholMl')) {
        throw FormatException(
          'Missing required field "alcoholMl" for DrinkLog',
        );
      }
      if (!map.containsKey('baseDrinkScoreUnits')) {
        throw FormatException(
          'Missing required field "baseDrinkScoreUnits" for DrinkLog',
        );
      }
      if (!map.containsKey('classBonusScoreUnits')) {
        throw FormatException(
          'Missing required field "classBonusScoreUnits" for DrinkLog',
        );
      }
      if (!map.containsKey('drinkCategory')) {
        throw FormatException(
          'Missing required field "drinkCategory" for DrinkLog',
        );
      }
      if (!map.containsKey('drinkId')) {
        throw FormatException('Missing required field "drinkId" for DrinkLog');
      }
      if (!map.containsKey('drinkLogId')) {
        throw FormatException(
          'Missing required field "drinkLogId" for DrinkLog',
        );
      }
      if (!map.containsKey('drinkName')) {
        throw FormatException(
          'Missing required field "drinkName" for DrinkLog',
        );
      }
      if (!map.containsKey('id')) {
        throw FormatException('Missing required field "id" for DrinkLog');
      }
      if (!map.containsKey('occurredAt')) {
        throw FormatException(
          'Missing required field "occurredAt" for DrinkLog',
        );
      }
      if (!map.containsKey('participantIds')) {
        throw FormatException(
          'Missing required field "participantIds" for DrinkLog',
        );
      }
      if (!map.containsKey('scoreUnits')) {
        throw FormatException(
          'Missing required field "scoreUnits" for DrinkLog',
        );
      }
      if (!map.containsKey('userId')) {
        throw FormatException('Missing required field "userId" for DrinkLog');
      }
      if (!map.containsKey('volumeMl')) {
        throw FormatException('Missing required field "volumeMl" for DrinkLog');
      }
      return DrinkLog(
        alcoholMl: expectDouble(map['alcoholMl'], label: 'DrinkLogAlcoholMl'),
        baseDrinkScoreUnits: expectDouble(
          map['baseDrinkScoreUnits'],
          label: 'DrinkLogBaseDrinkScoreUnits',
        ),
        classBonusScoreUnits: expectDouble(
          map['classBonusScoreUnits'],
          label: 'DrinkLogClassBonusScoreUnits',
        ),
        drinkCategory: _decodeDrinkCategory(map['drinkCategory']),
        drinkId: DrinkId(
          expectString(map['drinkId'], label: 'DrinkLogDrinkId'),
        ),
        drinkLogId: DrinkLogId(
          expectString(map['drinkLogId'], label: 'DrinkLogDrinkLogId'),
        ),
        drinkName: expectString(map['drinkName'], label: 'DrinkLogDrinkName'),
        id: expectString(map['id'], label: 'ActivityResultEntriesItemId'),
        occurredAt: expectDouble(
          map['occurredAt'],
          label: 'ActivityResultEntriesItemOccurredAt',
        ),
        participantIds:
            expectList(
                  map['participantIds'],
                  label: 'ActivityResultEntriesItemParticipantIds',
                )
                .map(
                  (item) => UserId(
                    expectString(
                      item,
                      label: 'ActivityResultEntriesItemParticipantIdsItem',
                    ),
                  ),
                )
                .toList(),
        scoreUnits: expectDouble(
          map['scoreUnits'],
          label: 'ActivityResultEntriesItemScoreUnits',
        ),
        userId: UserId(expectString(map['userId'], label: 'DrinkLogUserId')),
        volumeMl: expectDouble(map['volumeMl'], label: 'DrinkLogVolumeMl'),
      );
    case 'socialQuest':
      if (!map.containsKey('firstUserId')) {
        throw FormatException(
          'Missing required field "firstUserId" for SocialQuest',
        );
      }
      if (!map.containsKey('id')) {
        throw FormatException('Missing required field "id" for SocialQuest');
      }
      if (!map.containsKey('occurredAt')) {
        throw FormatException(
          'Missing required field "occurredAt" for SocialQuest',
        );
      }
      if (!map.containsKey('participantIds')) {
        throw FormatException(
          'Missing required field "participantIds" for SocialQuest',
        );
      }
      if (!map.containsKey('questId')) {
        throw FormatException(
          'Missing required field "questId" for SocialQuest',
        );
      }
      if (!map.containsKey('questTitle')) {
        throw FormatException(
          'Missing required field "questTitle" for SocialQuest',
        );
      }
      if (!map.containsKey('scoreUnits')) {
        throw FormatException(
          'Missing required field "scoreUnits" for SocialQuest',
        );
      }
      if (!map.containsKey('secondUserId')) {
        throw FormatException(
          'Missing required field "secondUserId" for SocialQuest',
        );
      }
      return SocialQuest(
        firstUserId: UserId(
          expectString(map['firstUserId'], label: 'SocialQuestFirstUserId'),
        ),
        id: expectString(map['id'], label: 'ActivityResultEntriesItemId'),
        occurredAt: expectDouble(
          map['occurredAt'],
          label: 'ActivityResultEntriesItemOccurredAt',
        ),
        participantIds:
            expectList(
                  map['participantIds'],
                  label: 'ActivityResultEntriesItemParticipantIds',
                )
                .map(
                  (item) => UserId(
                    expectString(
                      item,
                      label: 'ActivityResultEntriesItemParticipantIdsItem',
                    ),
                  ),
                )
                .toList(),
        questId: PartyQuestId(
          expectString(map['questId'], label: 'SocialQuestQuestId'),
        ),
        questTitle: expectString(
          map['questTitle'],
          label: 'SocialQuestQuestTitle',
        ),
        scoreUnits: expectDouble(
          map['scoreUnits'],
          label: 'ActivityResultEntriesItemScoreUnits',
        ),
        secondUserId: UserId(
          expectString(map['secondUserId'], label: 'SocialQuestSecondUserId'),
        ),
      );
    default:
      throw FormatException(
        'Unknown ActivityResultEntriesItem discriminator: $discriminator',
      );
  }
}

typedef ActivityResultNextCursor = ({String id, double occurredAt});

Map<String, dynamic> _encodeActivityResultNextCursor(
  ActivityResultNextCursor value$,
) {
  final (id: id, occurredAt: occurredAt) = value$;
  return <String, dynamic>{'id': id, 'occurredAt': occurredAt};
}

ActivityResultNextCursor _decodeActivityResultNextCursor(dynamic raw) {
  final map = expectMap(raw, label: 'ActivityResultNextCursor');
  if (!map.containsKey('id')) {
    throw FormatException(
      'Missing required field "id" for ActivityResultNextCursor',
    );
  }
  if (!map.containsKey('occurredAt')) {
    throw FormatException(
      'Missing required field "occurredAt" for ActivityResultNextCursor',
    );
  }
  return (
    id: expectString(map['id'], label: 'ActivityResultNextCursorId'),
    occurredAt: expectDouble(
      map['occurredAt'],
      label: 'ActivityResultNextCursorOccurredAt',
    ),
  );
}

enum ActivityResultUsersItemAccentColor {
  amberValue('amber'),
  roseValue('rose'),
  violetValue('violet'),
  skyValue('sky'),
  emeraldValue('emerald'),
  limeValue('lime'),
  orangeValue('orange'),
  fuchsiaValue('fuchsia');

  const ActivityResultUsersItemAccentColor(this.value);
  final Object? value;

  static ActivityResultUsersItemAccentColor fromJson(dynamic raw) {
    switch (raw) {
      case 'amber':
        return ActivityResultUsersItemAccentColor.amberValue;
      case 'rose':
        return ActivityResultUsersItemAccentColor.roseValue;
      case 'violet':
        return ActivityResultUsersItemAccentColor.violetValue;
      case 'sky':
        return ActivityResultUsersItemAccentColor.skyValue;
      case 'emerald':
        return ActivityResultUsersItemAccentColor.emeraldValue;
      case 'lime':
        return ActivityResultUsersItemAccentColor.limeValue;
      case 'orange':
        return ActivityResultUsersItemAccentColor.orangeValue;
      case 'fuchsia':
        return ActivityResultUsersItemAccentColor.fuchsiaValue;
      default:
        throw FormatException(
          'Expected one of amber, rose, violet, sky, emerald, lime, orange, fuchsia for ActivityResultUsersItemAccentColor',
        );
    }
  }
}

typedef ActivityResultUsersItem = ({
  UserId id,
  ActivityResultUsersItemAccentColor accentColor,
  String? avatarUrl,
  String username,
});

Map<String, dynamic> _encodeActivityResultUsersItem(
  ActivityResultUsersItem value$,
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

ActivityResultUsersItem _decodeActivityResultUsersItem(dynamic raw) {
  final map = expectMap(raw, label: 'ActivityResultUsersItem');
  if (!map.containsKey('_id')) {
    throw FormatException(
      'Missing required field "_id" for ActivityResultUsersItem',
    );
  }
  if (!map.containsKey('accentColor')) {
    throw FormatException(
      'Missing required field "accentColor" for ActivityResultUsersItem',
    );
  }
  if (!map.containsKey('avatarUrl')) {
    throw FormatException(
      'Missing required field "avatarUrl" for ActivityResultUsersItem',
    );
  }
  if (!map.containsKey('username')) {
    throw FormatException(
      'Missing required field "username" for ActivityResultUsersItem',
    );
  }
  return (
    id: UserId(expectString(map['_id'], label: 'ActivityResultUsersItemId')),
    accentColor: ActivityResultUsersItemAccentColor.fromJson(
      map['accentColor'],
    ),
    avatarUrl: map['avatarUrl'] == null
        ? null
        : expectString(
            map['avatarUrl'],
            label: 'ActivityResultUsersItemAvatarUrl',
          ),
    username: expectString(
      map['username'],
      label: 'ActivityResultUsersItemUsername',
    ),
  );
}

typedef ActivityResult = ({
  List<ActivityResultEntriesItem> entries,
  bool hasMore,
  ActivityResultNextCursor? nextCursor,
  List<ActivityResultUsersItem> users,
});

Map<String, dynamic> _encodeActivityResult(ActivityResult value$) {
  final (
    entries: entries,
    hasMore: hasMore,
    nextCursor: nextCursor,
    users: users,
  ) = value$;
  return <String, dynamic>{
    'entries': entries
        .map((item) => _encodeActivityResultEntriesItem(item))
        .toList(),
    'hasMore': hasMore,
    'nextCursor': switch (nextCursor) {
      null => null,
      final v$ => _encodeActivityResultNextCursor(v$),
    },
    'users': users.map((item) => _encodeActivityResultUsersItem(item)).toList(),
  };
}

ActivityResult _decodeActivityResult(dynamic raw) {
  final map = expectMap(raw, label: 'ActivityResult');
  if (!map.containsKey('entries')) {
    throw FormatException(
      'Missing required field "entries" for ActivityResult',
    );
  }
  if (!map.containsKey('hasMore')) {
    throw FormatException(
      'Missing required field "hasMore" for ActivityResult',
    );
  }
  if (!map.containsKey('nextCursor')) {
    throw FormatException(
      'Missing required field "nextCursor" for ActivityResult',
    );
  }
  if (!map.containsKey('users')) {
    throw FormatException('Missing required field "users" for ActivityResult');
  }
  return (
    entries: expectList(
      map['entries'],
      label: 'ActivityResultEntries',
    ).map((item) => _decodeActivityResultEntriesItem(item)).toList(),
    hasMore: expectBool(map['hasMore'], label: 'ActivityResultHasMore'),
    nextCursor: map['nextCursor'] == null
        ? null
        : _decodeActivityResultNextCursor(map['nextCursor']),
    users: expectList(
      map['users'],
      label: 'ActivityResultUsers',
    ).map((item) => _decodeActivityResultUsersItem(item)).toList(),
  );
}

typedef ActivityArgsCursor = ({String id, double occurredAt});

Map<String, dynamic> _encodeActivityArgsCursor(ActivityArgsCursor value$) {
  final (id: id, occurredAt: occurredAt) = value$;
  return <String, dynamic>{'id': id, 'occurredAt': occurredAt};
}

ActivityArgsCursor _decodeActivityArgsCursor(dynamic raw) {
  final map = expectMap(raw, label: 'ActivityArgsCursor');
  if (!map.containsKey('id')) {
    throw FormatException('Missing required field "id" for ActivityArgsCursor');
  }
  if (!map.containsKey('occurredAt')) {
    throw FormatException(
      'Missing required field "occurredAt" for ActivityArgsCursor',
    );
  }
  return (
    id: expectString(map['id'], label: 'ActivityArgsCursorId'),
    occurredAt: expectDouble(
      map['occurredAt'],
      label: 'ActivityArgsCursorOccurredAt',
    ),
  );
}

enum ActivityArgsKindsItem {
  drinkLogValue('drinkLog'),
  socialQuestValue('socialQuest');

  const ActivityArgsKindsItem(this.value);
  final Object? value;

  static ActivityArgsKindsItem fromJson(dynamic raw) {
    switch (raw) {
      case 'drinkLog':
        return ActivityArgsKindsItem.drinkLogValue;
      case 'socialQuest':
        return ActivityArgsKindsItem.socialQuestValue;
      default:
        throw FormatException(
          'Expected one of drinkLog, socialQuest for ActivityArgsKindsItem',
        );
    }
  }
}

typedef ActivityArgs = ({
  Optional<ActivityArgsCursor> cursor,
  Optional<List<ActivityArgsKindsItem>> kinds,
  Optional<double> pageSize,
  Optional<List<UserId>> participantIds,
  SessionId sessionId,
});

Map<String, dynamic> _encodeActivityArgs(ActivityArgs value$) {
  final (
    cursor: cursor,
    kinds: kinds,
    pageSize: pageSize,
    participantIds: participantIds,
    sessionId: sessionId,
  ) = value$;
  return <String, dynamic>{
    if (cursor.isDefined) 'cursor': _encodeActivityArgsCursor(cursor.value),
    if (kinds.isDefined)
      'kinds': kinds.value.map((item) => item.value).toList(),
    if (pageSize.isDefined) 'pageSize': pageSize.value,
    if (participantIds.isDefined)
      'participantIds': participantIds.value.map((item) => item.value).toList(),
    'sessionId': sessionId.value,
  };
}

ActivityArgs _decodeActivityArgs(dynamic raw) {
  final map = expectMap(raw, label: 'ActivityArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for ActivityArgs',
    );
  }
  return (
    cursor: map.containsKey('cursor')
        ? Optional.of(_decodeActivityArgsCursor(map['cursor']))
        : const Optional.absent(),
    kinds: map.containsKey('kinds')
        ? Optional.of(
            expectList(
              map['kinds'],
              label: 'ActivityArgsKinds',
            ).map((item) => ActivityArgsKindsItem.fromJson(item)).toList(),
          )
        : const Optional.absent(),
    pageSize: map.containsKey('pageSize')
        ? Optional.of(
            expectDouble(map['pageSize'], label: 'ActivityArgsPageSize'),
          )
        : const Optional.absent(),
    participantIds: map.containsKey('participantIds')
        ? Optional.of(
            expectList(
                  map['participantIds'],
                  label: 'ActivityArgsParticipantIds',
                )
                .map(
                  (item) => UserId(
                    expectString(item, label: 'ActivityArgsParticipantIdsItem'),
                  ),
                )
                .toList(),
          )
        : const Optional.absent(),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'ActivityArgsSessionId'),
    ),
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
  double alcoholMl,
  double baseDrinkScoreUnits,
  double classBonusScoreUnits,
  double completedQuestCount,
  double drinkCount,
  double questScoreUnits,
  double rank,
  double scoreUnits,
  DrinkCategory? selectedClass,
  StandingsResultEntriesItemUser? user,
  UserId userId,
  double volumeMl,
});

Map<String, dynamic> _encodeStandingsResultEntriesItem(
  StandingsResultEntriesItem value$,
) {
  final (
    alcoholMl: alcoholMl,
    baseDrinkScoreUnits: baseDrinkScoreUnits,
    classBonusScoreUnits: classBonusScoreUnits,
    completedQuestCount: completedQuestCount,
    drinkCount: drinkCount,
    questScoreUnits: questScoreUnits,
    rank: rank,
    scoreUnits: scoreUnits,
    selectedClass: selectedClass,
    user: user,
    userId: userId,
    volumeMl: volumeMl,
  ) = value$;
  return <String, dynamic>{
    'alcoholMl': alcoholMl,
    'baseDrinkScoreUnits': baseDrinkScoreUnits,
    'classBonusScoreUnits': classBonusScoreUnits,
    'completedQuestCount': completedQuestCount,
    'drinkCount': drinkCount,
    'questScoreUnits': questScoreUnits,
    'rank': rank,
    'scoreUnits': scoreUnits,
    'selectedClass': switch (selectedClass) {
      null => null,
      final v$ => _encodeDrinkCategory(v$),
    },
    'user': switch (user) {
      null => null,
      final v$ => _encodeStandingsResultEntriesItemUser(v$),
    },
    'userId': userId.value,
    'volumeMl': volumeMl,
  };
}

StandingsResultEntriesItem _decodeStandingsResultEntriesItem(dynamic raw) {
  final map = expectMap(raw, label: 'StandingsResultEntriesItem');
  if (!map.containsKey('alcoholMl')) {
    throw FormatException(
      'Missing required field "alcoholMl" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('baseDrinkScoreUnits')) {
    throw FormatException(
      'Missing required field "baseDrinkScoreUnits" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('classBonusScoreUnits')) {
    throw FormatException(
      'Missing required field "classBonusScoreUnits" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('completedQuestCount')) {
    throw FormatException(
      'Missing required field "completedQuestCount" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('drinkCount')) {
    throw FormatException(
      'Missing required field "drinkCount" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('questScoreUnits')) {
    throw FormatException(
      'Missing required field "questScoreUnits" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('rank')) {
    throw FormatException(
      'Missing required field "rank" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('scoreUnits')) {
    throw FormatException(
      'Missing required field "scoreUnits" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('selectedClass')) {
    throw FormatException(
      'Missing required field "selectedClass" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('user')) {
    throw FormatException(
      'Missing required field "user" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('userId')) {
    throw FormatException(
      'Missing required field "userId" for StandingsResultEntriesItem',
    );
  }
  if (!map.containsKey('volumeMl')) {
    throw FormatException(
      'Missing required field "volumeMl" for StandingsResultEntriesItem',
    );
  }
  return (
    alcoholMl: expectDouble(
      map['alcoholMl'],
      label: 'StandingsResultEntriesItemAlcoholMl',
    ),
    baseDrinkScoreUnits: expectDouble(
      map['baseDrinkScoreUnits'],
      label: 'StandingsResultEntriesItemBaseDrinkScoreUnits',
    ),
    classBonusScoreUnits: expectDouble(
      map['classBonusScoreUnits'],
      label: 'StandingsResultEntriesItemClassBonusScoreUnits',
    ),
    completedQuestCount: expectDouble(
      map['completedQuestCount'],
      label: 'StandingsResultEntriesItemCompletedQuestCount',
    ),
    drinkCount: expectDouble(
      map['drinkCount'],
      label: 'StandingsResultEntriesItemDrinkCount',
    ),
    questScoreUnits: expectDouble(
      map['questScoreUnits'],
      label: 'StandingsResultEntriesItemQuestScoreUnits',
    ),
    rank: expectDouble(map['rank'], label: 'StandingsResultEntriesItemRank'),
    scoreUnits: expectDouble(
      map['scoreUnits'],
      label: 'StandingsResultEntriesItemScoreUnits',
    ),
    selectedClass: map['selectedClass'] == null
        ? null
        : _decodeDrinkCategory(map['selectedClass']),
    user: map['user'] == null
        ? null
        : _decodeStandingsResultEntriesItemUser(map['user']),
    userId: UserId(
      expectString(map['userId'], label: 'StandingsResultEntriesItemUserId'),
    ),
    volumeMl: expectDouble(
      map['volumeMl'],
      label: 'StandingsResultEntriesItemVolumeMl',
    ),
  );
}

typedef StandingsResult = ({List<StandingsResultEntriesItem> entries});

Map<String, dynamic> _encodeStandingsResult(StandingsResult value$) {
  final (entries: entries) = value$;
  return <String, dynamic>{
    'entries': entries
        .map((item) => _encodeStandingsResultEntriesItem(item))
        .toList(),
  };
}

StandingsResult _decodeStandingsResult(dynamic raw) {
  final map = expectMap(raw, label: 'StandingsResult');
  if (!map.containsKey('entries')) {
    throw FormatException(
      'Missing required field "entries" for StandingsResult',
    );
  }
  return (
    entries: expectList(
      map['entries'],
      label: 'StandingsResultEntries',
    ).map((item) => _decodeStandingsResultEntriesItem(item)).toList(),
  );
}

typedef StandingsArgs = ({SessionId sessionId});

Map<String, dynamic> _encodeStandingsArgs(StandingsArgs value$) {
  final (sessionId: sessionId) = value$;
  return <String, dynamic>{'sessionId': sessionId.value};
}

StandingsArgs _decodeStandingsArgs(dynamic raw) {
  final map = expectMap(raw, label: 'StandingsArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for StandingsArgs',
    );
  }
  return (
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'StandingsArgsSessionId'),
    ),
  );
}

final ConvexQueryReference<ActivityArgs, ActivityResult>
activityQueryReference = ConvexQueryReference(
  name: 'party:activity',
  encode: (args) => _encodeActivityArgs(args),
  decodeArgs: (raw) => _decodeActivityArgs(raw),
  decode: (raw) => _decodeActivityResult(raw),
  encodeResult: (value) => _encodeActivityResult(value),
);

final ConvexQueryReference<StandingsArgs, StandingsResult>
standingsQueryReference = ConvexQueryReference(
  name: 'party:standings',
  encode: (args) => _encodeStandingsArgs(args),
  decodeArgs: (raw) => _decodeStandingsArgs(raw),
  decode: (raw) => _decodeStandingsResult(raw),
  encodeResult: (value) => _encodeStandingsResult(value),
);
