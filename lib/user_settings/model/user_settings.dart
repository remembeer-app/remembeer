import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/document.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';

part 'user_settings.g.dart';

@JsonSerializable(explicitToJson: true)
class UserSettings extends Document {
  final DrinkType defaultDrinkType;
  final int defaultDrinkSize;
  final DrinkListSortOrder drinkListSort;

  const UserSettings({
    required super.id,
    required this.defaultDrinkType,
    required this.defaultDrinkSize,
    this.drinkListSort = DrinkListSortOrder.descending,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  UserSettings copyWith({
    DrinkType? defaultDrinkType,
    int? defaultDrinkSize,
    DrinkListSortOrder? drinkListSort,
  }) {
    return UserSettings(
      id: id,
      defaultDrinkType: defaultDrinkType ?? this.defaultDrinkType,
      defaultDrinkSize: defaultDrinkSize ?? this.defaultDrinkSize,
      drinkListSort: drinkListSort ?? this.drinkListSort,
    );
  }
}
