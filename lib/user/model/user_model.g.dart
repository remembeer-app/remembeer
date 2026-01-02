// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  searchableUsername: json['searchableUsername'] as String?,
  avatarName: json['avatarName'] as String? ?? 'jirka_kara.png',
  friends:
      (json['friends'] as List<dynamic>?)?.map((e) => e as String).toSet() ??
      const {},
  monthlyStats:
      (json['monthlyStats'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, MonthlyStats.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  badgeProgress:
      (json['badgeProgress'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, BadgeProgress.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'searchableUsername': instance.searchableUsername,
  'avatarName': instance.avatarName,
  'friends': instance.friends.toList(),
  'monthlyStats': instance.monthlyStats.map((k, e) => MapEntry(k, e.toJson())),
  'badgeProgress': instance.badgeProgress.map(
    (k, e) => MapEntry(k, e.toJson()),
  ),
};
