// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_log_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrinkLogCreate _$DrinkLogCreateFromJson(Map<String, dynamic> json) =>
    _DrinkLogCreate(
      consumedAt: DateTime.parse(json['consumedAt'] as String),
      drink: DrinkSnapshot.fromJson(json['drink'] as Map<String, dynamic>),
      volumeInMilliliters: (json['volumeInMilliliters'] as num).toInt(),
      location: _$JsonConverterFromJson<GeoPoint, GeoPoint>(
        json['location'],
        const GeoPointConverter().fromJson,
      ),
    );

Map<String, dynamic> _$DrinkLogCreateToJson(_DrinkLogCreate instance) =>
    <String, dynamic>{
      'consumedAt': instance.consumedAt.toIso8601String(),
      'drink': instance.drink.toJson(),
      'volumeInMilliliters': instance.volumeInMilliliters,
      'location': _$JsonConverterToJson<GeoPoint, GeoPoint>(
        instance.location,
        const GeoPointConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
