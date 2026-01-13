// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
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
  memberIds: (json['memberIds'] as List<dynamic>)
      .map((e) => e as String)
      .toSet(),
  bannedMemberIds: (json['bannedMemberIds'] as List<dynamic>)
      .map((e) => e as String)
      .toSet(),
  name: json['name'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  endedAt: json['endedAt'] == null
      ? null
      : DateTime.parse(json['endedAt'] as String),
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'createdAt': const TimestampConverterOptimistic().toJson(instance.createdAt),
  'updatedAt': const TimestampConverterOptimistic().toJson(instance.updatedAt),
  'deletedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.deletedAt,
    const TimestampConverter().toJson,
  ),
  'memberIds': instance.memberIds.toList(),
  'bannedMemberIds': instance.bannedMemberIds.toList(),
  'name': instance.name,
  'startedAt': instance.startedAt.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
