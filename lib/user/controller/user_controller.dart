import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/model/user_model.dart';

class UserController extends Controller<UserModel> {
  final AuthService authService;

  UserController({required this.authService})
    : super(collectionPath: 'users', fromJson: UserModel.fromJson);

  Future<UserModel> get currentUser async =>
      findById(authService.authenticatedUser.uid);

  Stream<UserModel> get currentUserStream =>
      streamById(authService.authenticatedUser.uid);

  Future<void> createOrUpdateUser(UserModel user) {
    final userId = user.id;
    final authenticatedUserId = authService.authenticatedUser.uid;
    invariant(
      userId == authenticatedUserId,
      'User id $userId must match authenticated user id $authenticatedUserId.',
    );

    return writeCollection.doc(userId).set(user.toJson());
  }

  Future<void> updateCurrentUserAccentColor(AccentColorKey accentColorKey) {
    final userId = authService.authenticatedUser.uid;
    return writeCollection.doc(userId).update({
      accentColorKeyField: accentColorKey.name,
    });
  }

  void createOrUpdateUserInBatch({
    required UserModel user,
    required WriteBatch batch,
  }) {
    final docRef = writeCollection.doc(user.id);
    batch.set(docRef, user.toJson());
  }

  Future<void> anonymizeCurrentUser() async {
    final current = await currentUser;
    final placeholder = UserModel(
      id: current.id,
      email: '',
      username: deletedUserUsername,
      searchableUsername: '',
      accentColorKey: current.accentColorKey,
    );
    await writeCollection
        .doc(current.id)
        .set(placeholder.toJson().withServerDeleteTimestamps());
  }
}
