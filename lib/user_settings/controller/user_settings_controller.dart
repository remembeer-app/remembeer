import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/user_settings/model/user_settings.dart';

class UserSettingsController extends Controller<UserSettings> {
  final AuthService authService;

  UserSettingsController({required this.authService})
    : super(collectionPath: 'user_settings', fromJson: UserSettings.fromJson);

  Future<UserSettings> get currentUserSettings async =>
      findById(authService.authenticatedUser.uid);

  Stream<UserSettings> get currentUserSettingsStream =>
      streamById(authService.authenticatedUser.uid);

  Future<void> createOrUpdateUserSettings(UserSettings userSettings) {
    final userSettingsId = userSettings.id;
    final authenticatedUserId = authService.authenticatedUser.uid;
    invariant(
      userSettingsId == authenticatedUserId,
      'UserSettings id $userSettingsId must match authenticated user id $authenticatedUserId.',
    );

    return writeCollection.doc(userSettingsId).set(userSettings.toJson());
  }
}
