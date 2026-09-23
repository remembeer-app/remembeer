// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrinkSnapshot _$DrinkSnapshotFromJson(Map<String, dynamic> json) =>
    _DrinkSnapshot(
      name: json['name'] as String,
      category: $enumDecode(_$DrinkCategoryEnumMap, json['category']),
      alcoholPercentage: (json['alcoholPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$DrinkSnapshotToJson(_DrinkSnapshot instance) =>
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
