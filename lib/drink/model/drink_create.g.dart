// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrinkCreate _$DrinkCreateFromJson(Map<String, dynamic> json) => _DrinkCreate(
  consumedAt: DateTime.parse(json['consumedAt'] as String),
  drinkType: DrinkTypeCore.fromJson(json['drinkType'] as Map<String, dynamic>),
  volumeInMilliliters: (json['volumeInMilliliters'] as num).toInt(),
  location: _$JsonConverterFromJson<GeoPoint, GeoPoint>(
    json['location'],
    const GeoPointConverter().fromJson,
  ),
  sessionId: json['sessionId'] as String?,
);

Map<String, dynamic> _$DrinkCreateToJson(_DrinkCreate instance) =>
    <String, dynamic>{
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
