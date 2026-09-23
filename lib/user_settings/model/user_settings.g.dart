// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) =>
    _UserSettings(
      id: json['id'] as String,
      defaultDrink: DrinkSnapshot.fromJson(
        json['defaultDrink'] as Map<String, dynamic>,
      ),
      defaultDrinkSize: (json['defaultDrinkSize'] as num).toInt(),
      drinkLogListSortOrder:
          $enumDecodeNullable(
            _$DrinkLogListSortOrderEnumMap,
            json['drinkLogListSortOrder'],
          ) ??
          DrinkLogListSortOrder.descending,
      notificationToken: json['notificationToken'] as String?,
    );

Map<String, dynamic> _$UserSettingsToJson(_UserSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'defaultDrink': instance.defaultDrink.toJson(),
      'defaultDrinkSize': instance.defaultDrinkSize,
      'drinkLogListSortOrder':
          _$DrinkLogListSortOrderEnumMap[instance.drinkLogListSortOrder]!,
      'notificationToken': instance.notificationToken,
    };

const _$DrinkLogListSortOrderEnumMap = {
  DrinkLogListSortOrder.descending: 'descending',
  DrinkLogListSortOrder.ascending: 'ascending',
};
