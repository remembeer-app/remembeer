// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrinkLog _$DrinkLogFromJson(Map<String, dynamic> json) => _DrinkLog(
  id: json['id'] as String,
  consumedByUserId: json['consumedByUserId'] as String,
  consumedAt: const LocalDateTimeConverter().fromJson(
    json['consumedAt'] as String,
  ),
  drink: DrinkSnapshot.fromJson(json['drink'] as Map<String, dynamic>),
  catalogDrinkId: json['drinkId'] as String?,
  volumeInMilliliters: (json['volumeInMilliliters'] as num).toInt(),
  location: _$JsonConverterFromJson<GeoPoint, GeoPoint>(
    json['location'],
    const GeoPointConverter().fromJson,
  ),
  partyRevision: (json['partyRevision'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$DrinkLogToJson(_DrinkLog instance) => <String, dynamic>{
  'id': instance.id,
  'consumedByUserId': instance.consumedByUserId,
  'consumedAt': const LocalDateTimeConverter().toJson(instance.consumedAt),
  'drink': instance.drink.toJson(),
  'drinkId': ?instance.catalogDrinkId,
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
