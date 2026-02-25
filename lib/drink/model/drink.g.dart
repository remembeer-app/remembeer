// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Drink _$DrinkFromJson(Map<String, dynamic> json) => _Drink(
  id: json['id'] as String,
  consumedByUserId: json['consumedByUserId'] as String,
  consumedAt: DateTime.parse(json['consumedAt'] as String),
  drinkType: DrinkTypeCore.fromJson(json['drinkType'] as Map<String, dynamic>),
  volumeInMilliliters: (json['volumeInMilliliters'] as num).toInt(),
  location: _$JsonConverterFromJson<GeoPoint, GeoPoint>(
    json['location'],
    const GeoPointConverter().fromJson,
  ),
);

Map<String, dynamic> _$DrinkToJson(_Drink instance) => <String, dynamic>{
  'id': instance.id,
  'consumedByUserId': instance.consumedByUserId,
  'consumedAt': instance.consumedAt.toIso8601String(),
  'drinkType': instance.drinkType.toJson(),
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
