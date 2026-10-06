// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrinkCreate _$DrinkCreateFromJson(Map<String, dynamic> json) => _DrinkCreate(
  name: json['name'] as String,
  category: const DrinkCategoryConverter().fromJson(
    json['category'] as Map<String, dynamic>,
  ),
  alcoholPercentage: (json['alcoholPercentage'] as num).toDouble(),
);

Map<String, dynamic> _$DrinkCreateToJson(_DrinkCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': const DrinkCategoryConverter().toJson(instance.category),
      'alcoholPercentage': instance.alcoholPercentage,
    };
