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

  Future<Null> deleteCurrent({required String password}) async {
    await _client.mutate(
      'user:deleteCurrent',
      _encodeDeleteCurrentArgs((password: password)),
    );
    return null;
  }

  ConvexMutationReference<DeleteCurrentArgs, void> get deleteCurrentMutation =>
      deleteCurrentMutationReference;

  Future<UserId> ensureCurrent({
    Optional<String> timeZone = const Optional.absent(),
  }) async {
    final raw$ = await _client.mutate(
      'user:ensureCurrent',
      _encodeEnsureCurrentArgs((timeZone: timeZone)),
    );
    return UserId(expectString(raw$, label: 'EnsureCurrentResult'));
  }

  ConvexMutationReference<EnsureCurrentArgs, UserId>
  get ensureCurrentMutation => ensureCurrentMutationReference;

  Future<String> generateAvatarUploadUrl() async {
    final raw$ = await _client.mutate(
      'user:generateAvatarUploadUrl',
      const <String, dynamic>{},
    );
    return expectString(raw$, label: 'GenerateAvatarUploadUrlResult');
  }

  ConvexMutationReference<NoArgs, String> get generateAvatarUploadUrlMutation =>
      generateAvatarUploadUrlMutationReference;

  Future<List<String>> searchTimeZones({required String search}) async {
    final raw$ = await _client.query(
      'user:searchTimeZones',
      _encodeSearchTimeZonesArgs((search: search)),
    );
    return expectList(raw$, label: 'SearchTimeZonesResult')
        .map((item) => expectString(item, label: 'SearchTimeZonesResultItem'))
        .toList();
  }

  TypedConvexSubscription<List<String>> searchTimeZonesSubscribe({
    required String search,
  }) {
    final subscription$ = _client.subscribe(
      'user:searchTimeZones',
      _encodeSearchTimeZonesArgs((search: search)),
    );
    final typedStream$ = subscription$.stream.map((event) {
      switch (event) {
        case QuerySuccess(:final value):
          return TypedQuerySuccess<List<String>>(
            expectList(value, label: 'SearchTimeZonesResult')
                .map(
                  (item) =>
                      expectString(item, label: 'SearchTimeZonesResultItem'),
                )
                .toList(),
          );
        case QueryLoading(:final hasPendingWrites):
          return TypedQueryLoading<List<String>>(
            hasPendingWrites: hasPendingWrites,
          );
        case QueryError(:final message, :final data, :final logLines):
          return TypedQueryError<List<String>>(
            message,
            data: data,
            logLines: logLines,
          );
      }
    });
    return TypedConvexSubscription<List<String>>(subscription$, typedStream$);
  }

  ConvexQueryReference<SearchTimeZonesArgs, List<String>>
  get searchTimeZonesQuery => searchTimeZonesQueryReference;

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

  Future<String?> updateAvatar({required StorageId? storageId}) async {
    final raw$ = await _client.mutate(
      'user:updateAvatar',
      _encodeUpdateAvatarArgs((storageId: storageId)),
    );
    return raw$ == null
        ? null
        : expectString(raw$, label: 'UpdateAvatarResult');
  }

  ConvexMutationReference<UpdateAvatarArgs, String?> get updateAvatarMutation =>
      updateAvatarMutationReference;

  Future<Null> updateDefaultDrink({required DrinkId? defaultDrink}) async {
    await _client.mutate(
      'user:updateDefaultDrink',
      _encodeUpdateDefaultDrinkArgs((defaultDrink: defaultDrink)),
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

  Future<Null> updateTimeZone({required String timeZone}) async {
    await _client.mutate(
      'user:updateTimeZone',
      _encodeUpdateTimeZoneArgs((timeZone: timeZone)),
    );
    return null;
  }

  ConvexMutationReference<UpdateTimeZoneArgs, void>
  get updateTimeZoneMutation => updateTimeZoneMutationReference;

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
  CurrentResultDrinkLogSortOrder drinkLogSortOrder,
  double endOfDayBoundary,
  String normalizedUsername,
  String timeZone,
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
    drinkLogSortOrder: drinkLogSortOrder,
    endOfDayBoundary: endOfDayBoundary,
    normalizedUsername: normalizedUsername,
    timeZone: timeZone,
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
    'drinkLogSortOrder': drinkLogSortOrder.value,
    'endOfDayBoundary': endOfDayBoundary,
    'normalizedUsername': normalizedUsername,
    'timeZone': timeZone,
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
  if (!map.containsKey('timeZone')) {
    throw FormatException(
      'Missing required field "timeZone" for CurrentResult',
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
    timeZone: expectString(map['timeZone'], label: 'CurrentResultTimeZone'),
    username: expectString(map['username'], label: 'CurrentResultUsername'),
  );
}

typedef DeleteCurrentArgs = ({String password});

Map<String, dynamic> _encodeDeleteCurrentArgs(DeleteCurrentArgs value$) {
  final (password: password) = value$;
  return <String, dynamic>{'password': password};
}

DeleteCurrentArgs _decodeDeleteCurrentArgs(dynamic raw) {
  final map = expectMap(raw, label: 'DeleteCurrentArgs');
  if (!map.containsKey('password')) {
    throw FormatException(
      'Missing required field "password" for DeleteCurrentArgs',
    );
  }
  return (
    password: expectString(map['password'], label: 'DeleteCurrentArgsPassword'),
  );
}

typedef EnsureCurrentArgs = ({Optional<String> timeZone});

Map<String, dynamic> _encodeEnsureCurrentArgs(EnsureCurrentArgs value$) {
  final (timeZone: timeZone) = value$;
  return <String, dynamic>{if (timeZone.isDefined) 'timeZone': timeZone.value};
}

EnsureCurrentArgs _decodeEnsureCurrentArgs(dynamic raw) {
  final map = expectMap(raw, label: 'EnsureCurrentArgs');
  return (
    timeZone: map.containsKey('timeZone')
        ? Optional.of(
            expectString(map['timeZone'], label: 'EnsureCurrentArgsTimeZone'),
          )
        : const Optional.absent(),
  );
}

typedef SearchTimeZonesArgs = ({String search});

Map<String, dynamic> _encodeSearchTimeZonesArgs(SearchTimeZonesArgs value$) {
  final (search: search) = value$;
  return <String, dynamic>{'search': search};
}

SearchTimeZonesArgs _decodeSearchTimeZonesArgs(dynamic raw) {
  final map = expectMap(raw, label: 'SearchTimeZonesArgs');
  if (!map.containsKey('search')) {
    throw FormatException(
      'Missing required field "search" for SearchTimeZonesArgs',
    );
  }
  return (
    search: expectString(map['search'], label: 'SearchTimeZonesArgsSearch'),
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

typedef UpdateAvatarArgs = ({StorageId? storageId});

Map<String, dynamic> _encodeUpdateAvatarArgs(UpdateAvatarArgs value$) {
  final (storageId: storageId) = value$;
  return <String, dynamic>{
    'storageId': switch (storageId) {
      null => null,
      final v$ => v$.value,
    },
  };
}

UpdateAvatarArgs _decodeUpdateAvatarArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateAvatarArgs');
  if (!map.containsKey('storageId')) {
    throw FormatException(
      'Missing required field "storageId" for UpdateAvatarArgs',
    );
  }
  return (
    storageId: map['storageId'] == null
        ? null
        : StorageId(
            expectString(map['storageId'], label: 'UpdateAvatarArgsStorageId'),
          ),
  );
}

typedef UpdateDefaultDrinkArgs = ({DrinkId? defaultDrink});

Map<String, dynamic> _encodeUpdateDefaultDrinkArgs(
  UpdateDefaultDrinkArgs value$,
) {
  final (defaultDrink: defaultDrink) = value$;
  return <String, dynamic>{
    'defaultDrink': switch (defaultDrink) {
      null => null,
      final v$ => v$.value,
    },
  };
}

UpdateDefaultDrinkArgs _decodeUpdateDefaultDrinkArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateDefaultDrinkArgs');
  if (!map.containsKey('defaultDrink')) {
    throw FormatException(
      'Missing required field "defaultDrink" for UpdateDefaultDrinkArgs',
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

typedef UpdateTimeZoneArgs = ({String timeZone});

Map<String, dynamic> _encodeUpdateTimeZoneArgs(UpdateTimeZoneArgs value$) {
  final (timeZone: timeZone) = value$;
  return <String, dynamic>{'timeZone': timeZone};
}

UpdateTimeZoneArgs _decodeUpdateTimeZoneArgs(dynamic raw) {
  final map = expectMap(raw, label: 'UpdateTimeZoneArgs');
  if (!map.containsKey('timeZone')) {
    throw FormatException(
      'Missing required field "timeZone" for UpdateTimeZoneArgs',
    );
  }
  return (
    timeZone: expectString(
      map['timeZone'],
      label: 'UpdateTimeZoneArgsTimeZone',
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

final ConvexMutationReference<DeleteCurrentArgs, void>
deleteCurrentMutationReference = ConvexMutationReference(
  name: 'user:deleteCurrent',
  encode: (args) => _encodeDeleteCurrentArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<EnsureCurrentArgs, UserId>
ensureCurrentMutationReference = ConvexMutationReference(
  name: 'user:ensureCurrent',
  encode: (args) => _encodeEnsureCurrentArgs(args),
  decode: (raw) => UserId(expectString(raw, label: 'EnsureCurrentResult')),
);

final ConvexMutationReference<NoArgs, String>
generateAvatarUploadUrlMutationReference = ConvexMutationReference(
  name: 'user:generateAvatarUploadUrl',
  encode: (args) => const <String, dynamic>{},
  decode: (raw) => expectString(raw, label: 'GenerateAvatarUploadUrlResult'),
);

final ConvexQueryReference<SearchTimeZonesArgs, List<String>>
searchTimeZonesQueryReference = ConvexQueryReference(
  name: 'user:searchTimeZones',
  encode: (args) => _encodeSearchTimeZonesArgs(args),
  decodeArgs: (raw) => _decodeSearchTimeZonesArgs(raw),
  decode: (raw) => expectList(raw, label: 'SearchTimeZonesResult')
      .map((item) => expectString(item, label: 'SearchTimeZonesResultItem'))
      .toList(),
  encodeResult: (value) => value.map((item) => item).toList(),
);

final ConvexMutationReference<UpdateAccentColorArgs, void>
updateAccentColorMutationReference = ConvexMutationReference(
  name: 'user:updateAccentColor',
  encode: (args) => _encodeUpdateAccentColorArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<UpdateAvatarArgs, String?>
updateAvatarMutationReference = ConvexMutationReference(
  name: 'user:updateAvatar',
  encode: (args) => _encodeUpdateAvatarArgs(args),
  decode: (raw) =>
      raw == null ? null : expectString(raw, label: 'UpdateAvatarResult'),
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

final ConvexMutationReference<UpdateTimeZoneArgs, void>
updateTimeZoneMutationReference = ConvexMutationReference(
  name: 'user:updateTimeZone',
  encode: (args) => _encodeUpdateTimeZoneArgs(args),
  decode: (raw) => null,
);

final ConvexMutationReference<UpdateUsernameArgs, void>
updateUsernameMutationReference = ConvexMutationReference(
  name: 'user:updateUsername',
  encode: (args) => _encodeUpdateUsernameArgs(args),
  decode: (raw) => null,
);
