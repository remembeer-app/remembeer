// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_type_core.dart';

// **************************************************************************
// InterfaceGenerator
// **************************************************************************

/// Generated interface for [DrinkTypeCore].
///
/// This interface is automatically generated from the constructor parameters
/// of the Freezed class. Any class implementing this interface must provide
/// all the getters defined below.
abstract interface class DrinkTypeFields {
  String get name;
  DrinkCategory get category;
  double get alcoholPercentage;
}

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
