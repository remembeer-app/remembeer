// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) =>
    _UserSettings(
      id: json['id'] as String,
      defaultDrinkType: DrinkType.fromJson(
        json['defaultDrinkType'] as Map<String, dynamic>,
      ),
      defaultDrinkSize: (json['defaultDrinkSize'] as num).toInt(),
      drinkListSortOrder:
          $enumDecodeNullable(
            _$DrinkListSortOrderEnumMap,
            json['drinkListSortOrder'],
          ) ??
          DrinkListSortOrder.descending,
      notificationToken: json['notificationToken'] as String?,
    );

Map<String, dynamic> _$UserSettingsToJson(_UserSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'defaultDrinkType': instance.defaultDrinkType.toJson(),
      'defaultDrinkSize': instance.defaultDrinkSize,
      'drinkListSortOrder':
          _$DrinkListSortOrderEnumMap[instance.drinkListSortOrder]!,
      'notificationToken': instance.notificationToken,
    };

const _$DrinkListSortOrderEnumMap = {
  DrinkListSortOrder.descending: 'descending',
  DrinkListSortOrder.ascending: 'ascending',
};
