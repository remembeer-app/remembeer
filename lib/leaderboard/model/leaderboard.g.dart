// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Leaderboard _$LeaderboardFromJson(Map<String, dynamic> json) => _Leaderboard(
  id: json['id'] as String,
  userId: json['userId'] as String,
  createdAt: const TimestampConverterOptimistic().fromJson(
    json['createdAt'] as Timestamp?,
  ),
  updatedAt: const TimestampConverterOptimistic().fromJson(
    json['updatedAt'] as Timestamp?,
  ),
  deletedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['deletedAt'],
    const TimestampConverter().fromJson,
  ),
  name: json['name'] as String,
  iconName: json['iconName'] as String,
  memberIds: (json['memberIds'] as List<dynamic>)
      .map((e) => e as String)
      .toSet(),
  bannedMemberIds: (json['bannedMemberIds'] as List<dynamic>)
      .map((e) => e as String)
      .toSet(),
  inviteCode: json['inviteCode'] as String,
);

Map<String, dynamic> _$LeaderboardToJson(
  _Leaderboard instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'createdAt': const TimestampConverterOptimistic().toJson(instance.createdAt),
  'updatedAt': const TimestampConverterOptimistic().toJson(instance.updatedAt),
  'deletedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.deletedAt,
    const TimestampConverter().toJson,
  ),
  'name': instance.name,
  'iconName': instance.iconName,
  'memberIds': instance.memberIds.toList(),
  'bannedMemberIds': instance.bannedMemberIds.toList(),
  'inviteCode': instance.inviteCode,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
