// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
  id: json['id'] as String,
  defaultDrinkType: DrinkType.fromJson(
    json['defaultDrinkType'] as Map<String, dynamic>,
  ),
  defaultDrinkSize: (json['defaultDrinkSize'] as num).toInt(),
  drinkListSort:
      $enumDecodeNullable(_$DrinkListSortEnumMap, json['drinkListSort']) ??
      DrinkListSort.descending,
  notificationToken: json['notificationToken'] as String?,
);

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'defaultDrinkType': instance.defaultDrinkType.toJson(),
      'defaultDrinkSize': instance.defaultDrinkSize,
      'drinkListSort': _$DrinkListSortEnumMap[instance.drinkListSort]!,
      'notificationToken': instance.notificationToken,
    };

const _$DrinkListSortEnumMap = {
  DrinkListSort.descending: 'descending',
  DrinkListSort.ascending: 'ascending',
};
