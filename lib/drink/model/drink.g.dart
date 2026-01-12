// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Drink _$DrinkFromJson(Map<String, dynamic> json) => _Drink(
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
  consumedAt: DateTime.parse(json['consumedAt'] as String),
  drinkType: DrinkTypeCore.fromJson(json['drinkType'] as Map<String, dynamic>),
  volumeInMilliliters: (json['volumeInMilliliters'] as num).toInt(),
  location: _$JsonConverterFromJson<GeoPoint, GeoPoint>(
    json['location'],
    const GeoPointConverter().fromJson,
  ),
  sessionId: json['sessionId'] as String?,
);

Map<String, dynamic> _$DrinkToJson(_Drink instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'createdAt': const TimestampConverterOptimistic().toJson(instance.createdAt),
  'updatedAt': const TimestampConverterOptimistic().toJson(instance.updatedAt),
  'deletedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.deletedAt,
    const TimestampConverter().toJson,
  ),
  'consumedAt': instance.consumedAt.toIso8601String(),
  'drinkType': instance.drinkType.toJson(),
  'volumeInMilliliters': instance.volumeInMilliliters,
  'location': _$JsonConverterToJson<GeoPoint, GeoPoint>(
    instance.location,
    const GeoPointConverter().toJson,
  ),
  'sessionId': instance.sessionId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
