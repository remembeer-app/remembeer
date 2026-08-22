// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_type_core.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrinkTypeCore _$DrinkTypeCoreFromJson(Map<String, dynamic> json) =>
    _DrinkTypeCore(
      name: json['name'] as String,
      category: $enumDecode(_$DrinkCategoryEnumMap, json['category']),
      alcoholPercentage: (json['alcoholPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$DrinkTypeCoreToJson(_DrinkTypeCore instance) =>
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
