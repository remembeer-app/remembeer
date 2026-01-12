import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/model/document.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@freezed
abstract class UserSettings with _$UserSettings implements Document {
  const factory UserSettings({
    required String id,

    required DrinkType defaultDrinkType,
    required int defaultDrinkSize,
    @Default(DrinkListSortOrder.descending)
    DrinkListSortOrder drinkListSortOrder,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
