// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    _FriendRequest(
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
      toUserId: json['toUserId'] as String,
    );

Map<String, dynamic> _$FriendRequestToJson(
  _FriendRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'createdAt': const TimestampConverterOptimistic().toJson(instance.createdAt),
  'updatedAt': const TimestampConverterOptimistic().toJson(instance.updatedAt),
  'deletedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.deletedAt,
    const TimestampConverter().toJson,
  ),
  'toUserId': instance.toUserId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
