// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_type_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrinkTypeCreate _$DrinkTypeCreateFromJson(Map<String, dynamic> json) =>
    _DrinkTypeCreate(
      name: json['name'] as String,
      category: $enumDecode(_$DrinkCategoryEnumMap, json['category']),
      alcoholPercentage: (json['alcoholPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$DrinkTypeCreateToJson(_DrinkTypeCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': _$DrinkCategoryEnumMap[instance.category]!,
      'alcoholPercentage': instance.alcoholPercentage,
    };

const _$DrinkCategoryEnumMap = {
  DrinkCategory.beer: 'beer',
  DrinkCategory.cider: 'cider',
  DrinkCategory.cocktail: 'cocktail',
  DrinkCategory.spirit: 'spirit',
  DrinkCategory.wine: 'wine',
};
