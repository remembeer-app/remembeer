// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint, unused_element, unused_import, unused_local_variable

import '../runtime.dart';
import '../schema.dart';

import 'package:dartvex/dartvex.dart';

class UserApi {
  const UserApi(this._client);

  final ConvexFunctionCaller _client;

  Future<CurrentResult> current() async {
    final raw$ = await _client.query('user:current', const <String, dynamic>{});
    return _decodeCurrentResult(raw$);
  }

  TypedConvexSubscription<CurrentResult> currentSubscribe() {
    final subscription$ = _client.subscribe(
      'user:current',
      const <String, dynamic>{},
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<CurrentResult>(_decodeCurrentResult(value));
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<CurrentResult>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<CurrentResult>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<CurrentResult>(subscription$, typedStream$);
  }

  ConvexQueryReference<NoArgs, CurrentResult> get currentQuery =>
      currentQueryReference;

  Future<UserId> ensureCurrent() async {
    final raw$ = await _client.mutate(
      'user:ensureCurrent',
      const <String, dynamic>{},
    );
    return UserId(expectString(raw$, label: 'EnsureCurrentResult'));
  }

  ConvexMutationReference<NoArgs, UserId> get ensureCurrentMutation =>
      ensureCurrentMutationReference;

  Future<Null> updateAccentColor({
    required UpdateAccentColorArgsAccentColor accentColor,
  }) async {
    await _client.mutate(
      'user:updateAccentColor',
      _encodeUpdateAccentColorArgs((accentColor: accentColor)),
    );
    return null;
  }

  ConvexMutationReference<UpdateAccentColorArgs, void>
  get updateAccentColorMutation => updateAccentColorMutationReference;

  Future<Null> updateAvatarUrl({required String? avatarUrl}) async {
    await _client.mutate(
      'user:updateAvatarUrl',
      _encodeUpdateAvatarUrlArgs((avatarUrl: avatarUrl)),
    );
    return null;
  }

  ConvexMutationReference<UpdateAvatarUrlArgs, void>
  get updateAvatarUrlMutation => updateAvatarUrlMutationReference;

  Future<Null> updateDefaultDrink({
    required DrinkId? defaultDrink,
    required double defaultDrinkVolumeMl,
  }) async {
    await _client.mutate(
      'user:updateDefaultDrink',
      _encodeUpdateDefaultDrinkArgs((
        defaultDrink: defaultDrink,
        defaultDrinkVolumeMl: defaultDrinkVolumeMl,
      )),
    );
    return null;
  }

  ConvexMutationReference<UpdateDefaultDrinkArgs, void>
  get updateDefaultDrinkMutation => updateDefaultDrinkMutationReference;

  Future<Null> updateDrinkLogSortOrder({
    required UpdateDrinkLogSortOrderArgsDrinkLogSortOrder drinkLogSortOrder,
  }) async {
    await _client.mutate(
      'user:updateDrinkLogSortOrder',
      _encodeUpdateDrinkLogSortOrderArgs((
        drinkLogSortOrder: drinkLogSortOrder,
      )),
    );
    return null;
  }

  ConvexMutationReference<UpdateDrinkLogSortOrderArgs, void>
  get updateDrinkLogSortOrderMutation =>
      updateDrinkLogSortOrderMutationReference;

  Future<Null> updateEndOfDayBoundary({
    required double endOfDayBoundary,
  }) async {
    await _client.mutate(
      'user:updateEndOfDayBoundary',
      _encodeUpdateEndOfDayBoundaryArgs((endOfDayBoundary: endOfDayBoundary)),
    );
    return null;
  }

  ConvexMutationReference<UpdateEndOfDayBoundaryArgs, void>
  get updateEndOfDayBoundaryMutation => updateEndOfDayBoundaryMutationReference;

  Future<Null> updateUsername({required String username}) async {
    await _client.mutate(
      'user:updateUsername',
      _encodeUpdateUsernameArgs((username: username)),
    );
    return null;
  }

  ConvexMutationReference<UpdateUsernameArgs, void>
  get updateUsernameMutation => updateUsernameMutationReference;
}

enum CurrentResultAccentColor {
  amberValue('amber'),
  roseValue('rose'),
  violetValue('violet'),
  skyValue('sky'),
  emeraldValue('emerald'),
  limeValue('lime'),
  orangeValue('orange'),
  fuchsiaValue('fuchsia');

  const CurrentResultAccentColor(this.value);
  final Object? value;

  static CurrentResultAccentColor fromJson(dynamic raw) {
    switch (raw) {
      case 'amber':
        return CurrentResultAccentColor.amberValue;
      case 'rose':
        return CurrentResultAccentColor.roseValue;
      case 'violet':
        return CurrentResultAccentColor.violetValue;
      case 'sky':
        return CurrentResultAccentColor.skyValue;
      case 'emerald':
        return CurrentResultAccentColor.emeraldValue;
      case 'lime':
        return CurrentResultAccentColor.limeValue;
      case 'orange':
        return CurrentResultAccentColor.orangeValue;
      case 'fuchsia':
        return CurrentResultAccentColor.fuchsiaValue;
      default:
        throw FormatException(
          'Expected one of amber, rose, violet, sky, emerald, lime, orange, fuchsia for CurrentResultAccentColor',
        );
    }
  }
}

enum CurrentResultDrinkLogSortOrder {
  ascValue('asc'),
  descValue('desc');

  const CurrentResultDrinkLogSortOrder(this.value);
  final Object? value;

  static CurrentResultDrinkLogSortOrder fromJson(dynamic raw) {
    switch (raw) {
      case 'asc':
        return CurrentResultDrinkLogSortOrder.ascValue;
      case 'desc':
        return CurrentResultDrinkLogSortOrder.descValue;
      default:
        throw FormatException(
          'Expected one of asc, desc for CurrentResultDrinkLogSortOrder',
        );
    }
  }
}

typedef CurrentResult = ({
  double creationTime,
  UserId id,
  CurrentResultAccentColor accentColor,
  String authUserId,
  String? avatarUrl,
  DrinkId? defaultDrink,
  double defaultDrinkVolumeMl,
  CurrentResultDrinkLogSortOrder drinkLogSortOrder,
  double endOfDayBoundary,
  String normalizedUsername,
  String username,
});

Map<String, dynamic> _encodeCurrentResult(CurrentResult value$) {
  final (
    creationTime: creationTime,
    id: id,
    accentColor: accentColor,
    authUserId: authUserId,
    avatarUrl: avatarUrl,
    defaultDrink: defaultDrink,
    defaultDrinkVolumeMl: defaultDrinkVolumeMl,
    drinkLogSortOrder: drinkLogSortOrder,
    endOfDayBoundary: endOfDayBoundary,
    normalizedUsername: normalizedUsername,
    username: username,
  ) = value$;
  return <String, dynamic>{
    '_creationTime': creationTime,
    '_id': id.value,
    'accentColor': accentColor.value,
    'authUserId': authUserId,
    'avatarUrl': avatarUrl,
    'defaultDrink': switch (defaultDrink) {
      null => null,
      final v$ => v$.value,
    },
    'defaultDrinkVolumeMl': defaultDrinkVolumeMl,
    'drinkLogSortOrder': drinkLogSortOrder.value,
    'endOfDayBoundary': endOfDayBoundary,
    'normalizedUsername': normalizedUsername,
    'username': username,
  };
}

CurrentResult _decodeCurrentResult(dynamic raw) {
  final map = expectMap(raw, label: 'CurrentResult');
  if (!map.containsKey('_creationTime')) {
    throw FormatException(
      'Missing required field "_creationTime" for CurrentResult',
    );
  }
  if (!map.containsKey('_id')) {
    throw FormatException('Missing required field "_id" for CurrentResult');
  }
  if (!map.containsKey('accentColor')) {
    throw FormatException(
      'Missing required field "accentColor" for CurrentResult',
    );
  }
  if (!map.containsKey('authUserId')) {
    throw FormatException(
      'Missing required field "authUserId" for CurrentResult',
    );
  }
  if (!map.containsKey('avatarUrl')) {
    throw FormatException(
      'Missing required field "avatarUrl" for CurrentResult',
    );
  }
  if (!map.containsKey('defaultDrink')) {
    throw FormatException(
      'Missing required field "defaultDrink" for CurrentResult',
    );
  }
  if (!map.containsKey('defaultDrinkVolumeMl')) {
    throw FormatException(
      'Missing required field "defaultDrinkVolumeMl" for CurrentResult',
    );
  }
  if (!map.containsKey('drinkLogSortOrder')) {
    throw FormatException(
      'Missing required field "drinkLogSortOrder" for CurrentResult',
    );
  }
  if (!map.containsKey('endOfDayBoundary')) {
    throw FormatException(
      'Missing required field "endOfDayBoundary" for CurrentResult',
    );
  }
  if (!map.containsKey('normalizedUsername')) {
    throw FormatException(
      'Missing required field "normalizedUsername" for CurrentResult',
    );
  }
  if (!map.containsKey('username')) {
    throw FormatException(
      'Missing required field "username" for CurrentResult',
    );
  }
  return (
    creationTime: expectDouble(
      map['_creationTime'],
      label: 'CurrentResultCreationTime',
    ),
    id: UserId(expectString(map['_id'], label: 'CurrentResultId')),
    accentColor: CurrentResultAccentColor.fromJson(map['accentColor']),
    authUserId: expectString(
      map['authUserId'],
      label: 'CurrentResultAuthUserId',
    ),
    avatarUrl: map['avatarUrl'] == null
        ? null
        : expectString(map['avatarUrl'], label: 'CurrentResultAvatarUrl'),
    defaultDrink: map['defaultDrink'] == null
        ? null
        : DrinkId(
            expectString(
              map['defaultDrink'],
              label: 'CurrentResultDefaultDrink',
            ),
          ),
    defaultDrinkVolumeMl: expectDouble(
      map['defaultDrinkVolumeMl'],
      label: 'CurrentResultDefaultDrinkVolumeMl',
    ),
    drinkLogSortOrder: CurrentResultDrinkLogSortOrder.fromJson(
      map['drinkLogSortOrder'],
    ),
    endOfDayBoundary: expectDouble(
      map['endOfDayBoundary'],
      label: 'CurrentResultEndOfDayBoundary',
    ),
    normalizedUsername: expectString(
      map['normalizedUsername'],
      label: 'CurrentResultNormalizedUsername',
    ),
    username: expectString(map['username'], label: 'CurrentResultUsername'),
  );
}

enum UpdateAccentColorArgsAccentColor {
  amberValue('amber'),
  roseValue('rose'),
  violetValue('violet'),
  skyValue('sky'),
  emeraldValue('emerald'),
  limeValue('lime'),
  orangeValue('orange'),
  fuchsiaValue('fuchsia');

  const UpdateAccentColorArgsAccentColor(this.value);
  final Object? value;

  static UpdateAccentColorArgsAccentColor fromJson(dynamic raw) {
    switch (raw) {
      case 'amber':
        return UpdateAccentColorArgsAccentColor.amberValue;
      case 'rose':
        return UpdateAccentColorArgsAccentColor.roseValue;
      case 'violet':
        return UpdateAccentColorArgsAccentColor.violetValue;
      case 'sky':
        return UpdateAccentColorArgsAccentColor.skyValue;
      case 'emerald':
        return UpdateAccentColorArgsAccentColor.emeraldValue;
      case 'lime':
        return UpdateAccentColorArgsAccentColor.limeValue;
      case 'orange':
        return UpdateAccentColorArgsAccentColor.orangeValue;
      case 'fuchsia':
        return UpdateAccentColorArgsAccentColor.fuchsiaValue;
      default:
        throw FormatException(
          'Expected one of amber, rose, violet, sky, emerald, lime, orange, fuchsia for UpdateAccentColorArgsAccentColor',
        );
    }
  }
}

typedef UpdateAccentColorArgs = ({
  UpdateAccentColorArgsAccentColor accentColor,
});

Map<String, dynamic> _encodeUpdateAccentColorArgs(
  UpdateAccentColorArgs value$,
) {
  final (accentColor: accentColor) = value$;
  return <String, dynamic>{'accentColor': accentColor.value};
}

UpdateAccentColorArgs _decodeUpdateAccentColorArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateAccentColorArgs');
  if (!map.containsKey('accentColor')) {
    throw FormatException(
      'Missing required field "accentColor" for UpdateAccentColorArgs',
    );
  }
  return (
    accentColor: UpdateAccentColorArgsAccentColor.fromJson(map['accentColor']),
  );
}

typedef UpdateAvatarUrlArgs = ({String? avatarUrl});

Map<String, dynamic> _encodeUpdateAvatarUrlArgs(UpdateAvatarUrlArgs value$) {
  final (avatarUrl: avatarUrl) = value$;
  return <String, dynamic>{'avatarUrl': avatarUrl};
}

UpdateAvatarUrlArgs _decodeUpdateAvatarUrlArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateAvatarUrlArgs');
  if (!map.containsKey('avatarUrl')) {
    throw FormatException(
      'Missing required field "avatarUrl" for UpdateAvatarUrlArgs',
    );
  }
  return (
    avatarUrl: map['avatarUrl'] == null
        ? null
        : expectString(map['avatarUrl'], label: 'UpdateAvatarUrlArgsAvatarUrl'),
  );
}

typedef UpdateDefaultDrinkArgs = ({
  DrinkId? defaultDrink,
  double defaultDrinkVolumeMl,
});

Map<String, dynamic> _encodeUpdateDefaultDrinkArgs(
  UpdateDefaultDrinkArgs value$,
) {
  final (
    defaultDrink: defaultDrink,
    defaultDrinkVolumeMl: defaultDrinkVolumeMl,
  ) = value$;
  return <String, dynamic>{
    'defaultDrink': switch (defaultDrink) {
      null => null,
      final v$ => v$.value,
    },
    'defaultDrinkVolumeMl': defaultDrinkVolumeMl,
  };
}

UpdateDefaultDrinkArgs _decodeUpdateDefaultDrinkArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateDefaultDrinkArgs');
  if (!map.containsKey('defaultDrink')) {
    throw FormatException(
      'Missing required field "defaultDrink" for UpdateDefaultDrinkArgs',
    );
  }
  if (!map.containsKey('defaultDrinkVolumeMl')) {
    throw FormatException(
      'Missing required field "defaultDrinkVolumeMl" for UpdateDefaultDrinkArgs',
    );
  }
  return (
    defaultDrink: map['defaultDrink'] == null
        ? null
        : DrinkId(
            expectString(
              map['defaultDrink'],
              label: 'UpdateDefaultDrinkArgsDefaultDrink',
            ),
          ),
    defaultDrinkVolumeMl: expectDouble(
      map['defaultDrinkVolumeMl'],
      label: 'UpdateDefaultDrinkArgsDefaultDrinkVolumeMl',
    ),
  );
}

enum UpdateDrinkLogSortOrderArgsDrinkLogSortOrder {
  ascValue('asc'),
  descValue('desc');

  const UpdateDrinkLogSortOrderArgsDrinkLogSortOrder(this.value);
  final Object? value;

  static UpdateDrinkLogSortOrderArgsDrinkLogSortOrder fromJson(dynamic raw) {
    switch (raw) {
      case 'asc':
        return UpdateDrinkLogSortOrderArgsDrinkLogSortOrder.ascValue;
      case 'desc':
        return UpdateDrinkLogSortOrderArgsDrinkLogSortOrder.descValue;
      default:
        throw FormatException(
          'Expected one of asc, desc for UpdateDrinkLogSortOrderArgsDrinkLogSortOrder',
        );
    }
  }
}

typedef UpdateDrinkLogSortOrderArgs = ({
  UpdateDrinkLogSortOrderArgsDrinkLogSortOrder drinkLogSortOrder,
});

Map<String, dynamic> _encodeUpdateDrinkLogSortOrderArgs(
  UpdateDrinkLogSortOrderArgs value$,
) {
  final (drinkLogSortOrder: drinkLogSortOrder) = value$;
  return <String, dynamic>{'drinkLogSortOrder': drinkLogSortOrder.value};
}

UpdateDrinkLogSortOrderArgs _decodeUpdateDrinkLogSortOrderArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateDrinkLogSortOrderArgs');
  if (!map.containsKey('drinkLogSortOrder')) {
    throw FormatException(
      'Missing required field "drinkLogSortOrder" for UpdateDrinkLogSortOrderArgs',
    );
  }
  return (
    drinkLogSortOrder: UpdateDrinkLogSortOrderArgsDrinkLogSortOrder.fromJson(
      map['drinkLogSortOrder'],
    ),
  );
}

typedef UpdateEndOfDayBoundaryArgs = ({double endOfDayBoundary});

Map<String, dynamic> _encodeUpdateEndOfDayBoundaryArgs(
  UpdateEndOfDayBoundaryArgs value$,
) {
  final (endOfDayBoundary: endOfDayBoundary) = value$;
  return <String, dynamic>{'endOfDayBoundary': endOfDayBoundary};
}

UpdateEndOfDayBoundaryArgs _decodeUpdateEndOfDayBoundaryArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateEndOfDayBoundaryArgs');
  if (!map.containsKey('endOfDayBoundary')) {
    throw FormatException(
      'Missing required field "endOfDayBoundary" for UpdateEndOfDayBoundaryArgs',
    );
  }
  return (
    endOfDayBoundary: expectDouble(
      map['endOfDayBoundary'],
      label: 'UpdateEndOfDayBoundaryArgsEndOfDayBoundary',
    ),
  );
}

typedef UpdateUsernameArgs = ({String username});

Map<String, dynamic> _encodeUpdateUsernameArgs(UpdateUsernameArgs value$) {
  final (username: username) = value$;
  return <String, dynamic>{'username': username};
}

UpdateUsernameArgs _decodeUpdateUsernameArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateUsernameArgs');
  if (!map.containsKey('username')) {
    throw FormatException(
      'Missing required field "username" for UpdateUsernameArgs',
    );
  }
  return (
    username: expectString(
      map['username'],
      label: 'UpdateUsernameArgsUsername',
    ),
  );
}

final ConvexQueryReference<NoArgs, CurrentResult> currentQueryReference =
    ConvexQueryReference(
      name: 'user:current',
      encode: (args) => const <String, dynamic>{},
      decodeArgs: (raw) => const NoArgs(),
      decode: (raw) => _decodeCurrentResult(raw),
      encodeResult: (value) => _encodeCurrentResult(value),
    );

final ConvexMutationReference<NoArgs, UserId> ensureCurrentMutationReference =
    ConvexMutationReference(
      name: 'user:ensureCurrent',
      encode: (args) => const <String, dynamic>{},
      decode: (raw) => UserId(expectString(raw, label: 'EnsureCurrentResult')),
    );

final ConvexMutationReference<UpdateAccentColorArgs, void>
updateAccentColorMutationReference = ConvexMutationReference(
  name: 'user:updateAccentColor',
  encode: (args) => _encodeUpdateAccentColorArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<UpdateAvatarUrlArgs, void>
updateAvatarUrlMutationReference = ConvexMutationReference(
  name: 'user:updateAvatarUrl',
  encode: (args) => _encodeUpdateAvatarUrlArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<UpdateDefaultDrinkArgs, void>
updateDefaultDrinkMutationReference = ConvexMutationReference(
  name: 'user:updateDefaultDrink',
  encode: (args) => _encodeUpdateDefaultDrinkArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<UpdateDrinkLogSortOrderArgs, void>
updateDrinkLogSortOrderMutationReference = ConvexMutationReference(
  name: 'user:updateDrinkLogSortOrder',
  encode: (args) => _encodeUpdateDrinkLogSortOrderArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<UpdateEndOfDayBoundaryArgs, void>
updateEndOfDayBoundaryMutationReference = ConvexMutationReference(
  name: 'user:updateEndOfDayBoundary',
  encode: (args) => _encodeUpdateEndOfDayBoundaryArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<UpdateUsernameArgs, void>
updateUsernameMutationReference = ConvexMutationReference(
  name: 'user:updateUsername',
  encode: (args) => _encodeUpdateUsernameArgs(args),
  decode: (raw) => null,
);
