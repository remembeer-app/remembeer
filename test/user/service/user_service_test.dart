import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/friend_request/controller/friend_request_controller.dart';
import 'package:remembeer/notification/service/notification_service.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/model/gender.dart';
import 'package:remembeer/user/service/user_service.dart';

void main() {
  test('profile update delegates a validated owned-field update', () async {
    final userController = _FakeUserController();
    final service = UserService(
      authService: _FakeAuthService(),
      notificationService: _FakeNotificationService(),
      friendRequestController: _FakeFriendRequestController(),
      userController: userController,
    );

    await service.updateProfile(
      gender: Gender.male,
      accentColorKey: AccentColorKey.emerald,
    );

    expect(userController.updatedGender, Gender.male);
    expect(userController.updatedAccentColorKey, AccentColorKey.emerald);
    expect(userController.fullDocumentWriteCalled, isFalse);
  });
}

class _FakeUserController implements UserController {
  Gender? updatedGender;
  AccentColorKey? updatedAccentColorKey;
  var fullDocumentWriteCalled = false;

  @override
  Future<void> updateCurrentUserProfile({
    required Gender gender,
    required AccentColorKey accentColorKey,
  }) async {
    updatedGender = gender;
    updatedAccentColorKey = accentColorKey;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #createOrUpdateUser) {
      fullDocumentWriteCalled = true;
    }
    return super.noSuchMethod(invocation);
  }
}

class _FakeAuthService implements AuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeNotificationService implements NotificationService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFriendRequestController implements FriendRequestController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
