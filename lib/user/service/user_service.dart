import 'package:flutter/material.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/extension/searchable.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/model/user_model.dart';

class UserService {
  final AuthService authService;
  final UserController userController;

  const UserService({required this.authService, required this.userController});

  Future<UserModel> get currentUser => userController.currentUser;

  Stream<UserModel> get currentUserStream => userController.currentUserStream;

  Future<UserModel> userById(String userId) => userController.findById(userId);

  Stream<UserModel> userStreamFor(String userId) =>
      userController.streamById(userId);

  Future<void> createDefaultUser({String? username}) async {
    final authenticatedUser = authService.authenticatedUser;
    final email =
        authenticatedUser.email ?? never('User does not have an email.');
    final resolvedUsername = username ?? authenticatedUser.displayName ?? email;

    final defaultUser = UserModel(
      id: authenticatedUser.uid,
      email: email,
      username: resolvedUsername,
      searchableUsername: resolvedUsername.toSearchable(),
      accentColorKey: defaultAccentColorFor(authenticatedUser.uid),
    );

    await userController.createOrUpdateUser(defaultUser);
  }

  Future<void> updateAccentColor(AccentColorKey accentColorKey) =>
      userController.updateCurrentUserAccentColor(accentColorKey);

  Future<void> updateUsername({required String newUsername}) async {
    final trimmedUsername = newUsername.trim();
    assert(
      trimmedUsername.length >= minUsernameLength &&
          trimmedUsername.length <= maxUsernameLength,
      'Username passed to updateUsername with invalid length: "$trimmedUsername" is of length ${trimmedUsername.length}',
    );

    final currentUser = await userController.currentUser;
    if (currentUser.username == trimmedUsername) {
      return;
    }

    final updatedUser = currentUser.copyWith(
      username: trimmedUsername,
      searchableUsername: trimmedUsername.toSearchable(),
    );

    await userController.createOrUpdateUser(updatedUser);
  }

  Future<void> updateBadgeVisibility(String badgeId, bool isShown) async {
    final currentUser = await userController.currentUser;
    final updatedUser = currentUser.updateBadgeVisibility(badgeId, isShown);
    await userController.createOrUpdateUser(updatedUser);
  }

  Future<void> updateEndOfDayBoundary(TimeOfDay endOfDayBoundary) async {
    final currentUser = await userController.currentUser;
    if (currentUser.endOfDayBoundary == endOfDayBoundary) {
      return;
    }

    final updatedUser = currentUser.copyWith(
      endOfDayBoundary: endOfDayBoundary,
    );

    await userController.createOrUpdateUser(updatedUser);
  }
}
