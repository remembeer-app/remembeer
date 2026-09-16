import 'dart:async';

import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';
import 'package:remembeer/notification/service/notification_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';
import 'package:remembeer/user_settings/model/user_settings.dart';

const _defaultDrinkType = DrinkTypeCore(
  name: 'Beer',
  category: DrinkCategory.beer,
  alcoholPercentage: 4.5,
);
const _defaultDrinkSize = 500;

class UserSettingsService {
  final AuthService authService;
  final UserSettingsController userSettingsController;
  final NotificationService notificationService;

  UserSettingsService({
    required this.authService,
    required this.userSettingsController,
    required this.notificationService,
  }) {
    _initializeListeners();
  }

  void _initializeListeners() {
    authService.authStateChanges.listen((user) async {
      if (user != null) {
        await _syncToken();
      }
    });

    notificationService.onTokenRefresh.listen((token) async {
      if (authService.isAuthenticated) {
        await _updateToken(token);
      }
    });
  }

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

  Future<void> updateDefaultDrinkType(DrinkTypeCore drinkType) async {
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

  Future<void> updateDrinkListSort(
    DrinkListSortOrder drinkListSortOrder,
  ) async {
    final currentUserSettings =
        await userSettingsController.currentUserSettings;
    if (currentUserSettings.drinkListSortOrder == drinkListSortOrder) {
      return;
    }

    final updatedUserSettings = currentUserSettings.copyWith(
      drinkListSortOrder: drinkListSortOrder,
    );

    await userSettingsController.createOrUpdateUserSettings(
      updatedUserSettings,
    );
  }

  Future<void> _syncToken() async {
    final token = await notificationService.getToken();

    if (token != null) {
      await _updateToken(token);
    }
  }

  Future<void> _updateToken(String token) async {
    final currentUserSettings =
        await userSettingsController.currentUserSettings;
    if (currentUserSettings.notificationToken == token) {
      return;
    }

    final updatedUserSettings = currentUserSettings.copyWith(
      notificationToken: token,
    );

    await userSettingsController.createOrUpdateUserSettings(
      updatedUserSettings,
    );
  }
}
