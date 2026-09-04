// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  searchableUsername: json['searchableUsername'] as String,
  accentColorKey: $enumDecodeNullable(
    _$AccentColorKeyEnumMap,
    json['accentColorKey'],
  ),
  avatarUrl: json['avatarUrl'] as String?,
  friends:
      (json['friends'] as List<dynamic>?)?.map((e) => e as String).toSet() ??
      const {},
  monthlyStats:
      (json['monthlyStats'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, MonthlyStats.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  unlockedBadges:
      (json['unlockedBadges'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, UnlockedBadge.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  endOfDayBoundary: json['endOfDayBoundary'] == null
      ? defaultEndOfDayBoundary
      : const TimeOfDayConverter().fromJson(
          json['endOfDayBoundary'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UserModelToJson(
  _UserModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'searchableUsername': instance.searchableUsername,
  'accentColorKey': _$AccentColorKeyEnumMap[instance.accentColorKey],
  'avatarUrl': instance.avatarUrl,
  'friends': instance.friends.toList(),
  'monthlyStats': instance.monthlyStats.map((k, e) => MapEntry(k, e.toJson())),
  'unlockedBadges': instance.unlockedBadges.map(
    (k, e) => MapEntry(k, e.toJson()),
  ),
  'endOfDayBoundary': const TimeOfDayConverter().toJson(
    instance.endOfDayBoundary,
  ),
};

const _$AccentColorKeyEnumMap = {
  AccentColorKey.amber: 'amber',
  AccentColorKey.rose: 'rose',
  AccentColorKey.violet: 'violet',
  AccentColorKey.sky: 'sky',
  AccentColorKey.emerald: 'emerald',
  AccentColorKey.lime: 'lime',
  AccentColorKey.orange: 'orange',
  AccentColorKey.fuchsia: 'fuchsia',
};
