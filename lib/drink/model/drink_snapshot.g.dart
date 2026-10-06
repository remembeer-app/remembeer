// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrinkSnapshot _$DrinkSnapshotFromJson(Map<String, dynamic> json) =>
    _DrinkSnapshot(
      name: json['name'] as String,
      category: const DrinkCategoryConverter().fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      alcoholPercentage: (json['alcoholPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$DrinkSnapshotToJson(_DrinkSnapshot instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': const DrinkCategoryConverter().toJson(instance.category),
      'alcoholPercentage': instance.alcoholPercentage,
    };
