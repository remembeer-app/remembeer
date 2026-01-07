import 'package:flutter/material.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';
import 'package:remembeer/user_settings/model/user_settings.dart';

const _defaultDrinkType = DrinkType(
  id: 'global-beer',
  userId: 'global',
  name: 'Beer',
  category: DrinkCategory.beer,
  alcoholPercentage: 4.5,
);
const _defaultDrinkSize = 500;

class UserSettingsService {
  final AuthService authService;
  final UserSettingsController userSettingsController;

  const UserSettingsService({
    required this.authService,
    required this.userSettingsController,
  });

  Stream<UserSettings> get userSettingsStream =>
      userSettingsController.currentUserSettingsStream;

  Future<UserSettings> get currentUserSettings =>
      userSettingsController.currentUserSettings;

  Future<void> createDefaultUserSettings() async {
    final defaultUserSettings = UserSettings(
      id: authService.authenticatedUser.uid,
      defaultDrinkType: _defaultDrinkType,
      defaultDrinkSize: _defaultDrinkSize,
    );

    await userSettingsController.createOrUpdateUserSettings(
      defaultUserSettings,
    );
  }

  Future<void> updateDefaultDrinkType(DrinkType drinkType) async {
    final currentUserSettings =
        await userSettingsController.currentUserSettings;
    if (currentUserSettings.defaultDrinkType == drinkType) {
      return;
    }

    final updatedUserSettings = currentUserSettings.copyWith(
      defaultDrinkType: drinkType,
    );

    await userSettingsController.createOrUpdateUserSettings(
      updatedUserSettings,
    );
  }

  Future<void> updateDefaultDrinkSize(int drinkSize) async {
    final currentUserSettings =
        await userSettingsController.currentUserSettings;
    if (currentUserSettings.defaultDrinkSize == drinkSize) {
      return;
    }

    final updatedUserSettings = currentUserSettings.copyWith(
      defaultDrinkSize: drinkSize,
    );

    await userSettingsController.createOrUpdateUserSettings(
      updatedUserSettings,
    );
  }

  Future<void> updateEndOfDayBoundary(TimeOfDay endOfDayBoundary) async {
    final currentUserSettings =
        await userSettingsController.currentUserSettings;
    if (currentUserSettings.endOfDayBoundary == endOfDayBoundary) {
      return;
    }

    final updatedUserSettings = currentUserSettings.copyWith(
      endOfDayBoundary: endOfDayBoundary,
    );

    await userSettingsController.createOrUpdateUserSettings(
      updatedUserSettings,
    );
  }

  Future<void> updateDrinkListSort(DrinkListSort drinkListSort) async {
    final currentUserSettings =
        await userSettingsController.currentUserSettings;
    if (currentUserSettings.drinkListSort == drinkListSort) {
      return;
    }

    final updatedUserSettings = currentUserSettings.copyWith(
      drinkListSort: drinkListSort,
    );

    await userSettingsController.createOrUpdateUserSettings(
      updatedUserSettings,
    );
  }
}
