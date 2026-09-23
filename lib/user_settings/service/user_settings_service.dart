import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/drink/model/drink_category.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';
import 'package:remembeer/notification/service/notification_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/model/drink_log_list_sort.dart';
import 'package:remembeer/user_settings/model/user_settings.dart';

const _defaultDrink = DrinkSnapshot(
  name: 'Beer',
  category: DrinkCategory.beer,
  alcoholPercentage: 4.5,
);
const _defaultDrinkSize = 500;
const _apnsTokenNotSetCode = 'apns-token-not-set';

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
      defaultDrink: _defaultDrink,
      defaultDrinkSize: _defaultDrinkSize,
    );

    await userSettingsController.createOrUpdateUserSettings(
      defaultUserSettings,
    );
  }

  Future<void> updateDefaultDrink(DrinkSnapshot drink) async {
    final currentUserSettings =
        await userSettingsController.currentUserSettings;
    if (currentUserSettings.defaultDrink == drink) {
      return;
    }

    final updatedUserSettings = currentUserSettings.copyWith(
      defaultDrink: drink,
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

  Future<void> updateDrinkLogListSort(
    DrinkLogListSortOrder drinkLogListSortOrder,
  ) async {
    final currentUserSettings =
        await userSettingsController.currentUserSettings;
    if (currentUserSettings.drinkLogListSortOrder == drinkLogListSortOrder) {
      return;
    }

    final updatedUserSettings = currentUserSettings.copyWith(
      drinkLogListSortOrder: drinkLogListSortOrder,
    );

    await userSettingsController.createOrUpdateUserSettings(
      updatedUserSettings,
    );
  }

  Future<void> _syncToken() async {
    final String? token;
    try {
      token = await notificationService.getToken();
    } on FirebaseException catch (e) {
      // On iOS the FCM token cannot be fetched until Apple has delivered the
      // APNs token. `onTokenRefresh` writes it once it arrives.
      if (e.code == _apnsTokenNotSetCode) {
        return;
      }
      rethrow;
    }

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
