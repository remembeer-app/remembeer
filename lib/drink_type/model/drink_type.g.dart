// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrinkType _$DrinkTypeFromJson(Map<String, dynamic> json) => _DrinkType(
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
  category: $enumDecode(_$DrinkCategoryEnumMap, json['category']),
  alcoholPercentage: (json['alcoholPercentage'] as num).toDouble(),
);

Map<String, dynamic> _$DrinkTypeToJson(
  _DrinkType instance,
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
  'category': _$DrinkCategoryEnumMap[instance.category]!,
  'alcoholPercentage': instance.alcoholPercentage,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$DrinkCategoryEnumMap = {
  DrinkCategory.beer: 'beer',
  DrinkCategory.cider: 'cider',
  DrinkCategory.cocktail: 'cocktail',
  DrinkCategory.spirit: 'spirit',
  DrinkCategory.wine: 'wine',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
