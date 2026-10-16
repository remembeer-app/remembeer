// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';
import '../types.dart';

import 'package:dartvex/dartvex.dart';

class PartyApi {
  const PartyApi(this._client);

  final ConvexFunctionCaller _client;

  Future<StandingsResult> standings({
    Optional<double> refreshAt = const Optional.absent(),
    required SessionId sessionId,
  }) async {
    final raw$ = await _client.query(
      'party:standings',
      _encodeStandingsArgs((refreshAt: refreshAt, sessionId: sessionId)),
    );
    return _decodeStandingsResult(raw$);
  }

  TypedConvexSubscription<StandingsResult> standingsSubscribe({
    Optional<double> refreshAt = const Optional.absent(),
    required SessionId sessionId,
  }) {
    final subscription$ = _client.subscribe(
      'party:standings',
      _encodeStandingsArgs((refreshAt: refreshAt, sessionId: sessionId)),
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

typedef StandingsResult = ({
  List<StandingsResultEntriesItem> entries,
  double? nextRefreshAt,
});

Map<String, dynamic> _encodeStandingsResult(StandingsResult value$) {
  final (entries: entries, nextRefreshAt: nextRefreshAt) = value$;
  return <String, dynamic>{
    'entries': entries
        .map((item) => _encodeStandingsResultEntriesItem(item))
        .toList(),
    'nextRefreshAt': nextRefreshAt,
  };
}

StandingsResult _decodeStandingsResult(dynamic raw) {
  final map = expectMap(raw, label: 'StandingsResult');
  if (!map.containsKey('entries')) {
    throw FormatException(
      'Missing required field "entries" for StandingsResult',
    );
  }
  if (!map.containsKey('nextRefreshAt')) {
    throw FormatException(
      'Missing required field "nextRefreshAt" for StandingsResult',
    );
  }
  return (
    entries: expectList(
      map['entries'],
      label: 'StandingsResultEntries',
    ).map((item) => _decodeStandingsResultEntriesItem(item)).toList(),
    nextRefreshAt: map['nextRefreshAt'] == null
        ? null
        : expectDouble(
            map['nextRefreshAt'],
            label: 'StandingsResultNextRefreshAt',
          ),
  );
}

typedef StandingsArgs = ({Optional<double> refreshAt, SessionId sessionId});

Map<String, dynamic> _encodeStandingsArgs(StandingsArgs value$) {
  final (refreshAt: refreshAt, sessionId: sessionId) = value$;
  return <String, dynamic>{
    if (refreshAt.isDefined) 'refreshAt': refreshAt.value,
    'sessionId': sessionId.value,
  };
}

StandingsArgs _decodeStandingsArgs(dynamic raw) {
  final map = expectMap(raw, label: 'StandingsArgs');
  if (!map.containsKey('sessionId')) {
    throw FormatException(
      'Missing required field "sessionId" for StandingsArgs',
    );
  }
  return (
    refreshAt: map.containsKey('refreshAt')
        ? Optional.of(
            expectDouble(map['refreshAt'], label: 'StandingsArgsRefreshAt'),
          )
        : const Optional.absent(),
    sessionId: SessionId(
      expectString(map['sessionId'], label: 'StandingsArgsSessionId'),
    ),
  );
}

final ConvexQueryReference<StandingsArgs, StandingsResult>
standingsQueryReference = ConvexQueryReference(
  name: 'party:standings',
  encode: (args) => _encodeStandingsArgs(args),
  decodeArgs: (raw) => _decodeStandingsArgs(raw),
  decode: (raw) => _decodeStandingsResult(raw),
  encodeResult: (value) => _encodeStandingsResult(value),
);
