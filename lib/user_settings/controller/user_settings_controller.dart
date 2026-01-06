import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/user_settings/model/user_settings.dart';

// TODO(ohtenkay): refactor
class UserSettingsController {
  final AuthService authService;

  UserSettingsController({required this.authService});

  final _userSettingsCollection = FirebaseFirestore.instance
      .collection('user_settings')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final json = snapshot.data() ?? {};
          return UserSettings.fromJson(json.withId(snapshot.id));
        },
        toFirestore: (value, _) => value.toJson().withoutId(),
      );

  Stream<UserSettings> get userSettingsStream => _userSettingsCollection
      .doc(authService.authenticatedUser.uid)
      .snapshots()
      .map((docSnapshot) {
        final data = docSnapshot.data();
        if (data == null) {
          throw StateError(
            'User settings not found for user ${authService.authenticatedUser.uid}',
          );
        }
        return data;
      });

  Future<UserSettings> get currentUserSettings async {
    final doc = await _userSettingsCollection
        .doc(authService.authenticatedUser.uid)
        .get();

    final data = doc.data();
    if (data == null) {
      throw StateError(
        'User settings not found for user ${authService.authenticatedUser.uid}',
      );
    }

    return data;
  }

  Future<void> createOrUpdateUserSettings(UserSettings userSettings) {
    if (userSettings.id != authService.authenticatedUser.uid) {
      throw StateError(
        'UserSettings id (${userSettings.id}) does not match authenticated user id '
        '(${authService.authenticatedUser.uid}).',
      );
    }

    return _userSettingsCollection.doc(userSettings.id).set(userSettings);
  }
}
