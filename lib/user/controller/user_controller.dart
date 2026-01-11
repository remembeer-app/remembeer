import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/common/extension/searchable.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/user/model/user_model.dart';

class UserController extends Controller<UserModel> {
  final AuthService authService;

  UserController({required this.authService})
    : super(collectionPath: 'users', fromJson: UserModel.fromJson);

  Future<UserModel> get currentUser async =>
      findById(authService.authenticatedUser.uid);

  Stream<UserModel> get currentUserStream =>
      streamById(authService.authenticatedUser.uid);

  Future<List<UserModel>> searchUsersByUsernameOrEmail(String query) async {
    final searchableQuery = query.toSearchable();

    final usernameQuery = readCollection
        .where('searchableUsername', isGreaterThanOrEqualTo: searchableQuery)
        .where(
          'searchableUsername',
          isLessThanOrEqualTo: '$searchableQuery\uf8ff',
        )
        .limit(10)
        .get();

    final emailQueryLower = query.toLowerCase();
    final emailQuery = readCollection
        .where('email', isGreaterThanOrEqualTo: emailQueryLower)
        .where('email', isLessThanOrEqualTo: '$emailQueryLower\uf8ff')
        .limit(10)
        .get();

    final results = await Future.wait([usernameQuery, emailQuery]);

    final userMap = <String, UserModel>{};
    for (final snapshot in results) {
      for (final doc in snapshot.docs) {
        final user = doc.data();
        if (user.id != authService.authenticatedUser.uid) {
          userMap[user.id] = user;
        }
      }
    }

    return userMap.values.toList();
  }

  Future<void> createOrUpdateUser(UserModel user) {
    final userId = user.id;
    final authenticatedUserId = authService.authenticatedUser.uid;
    invariant(
      userId == authenticatedUserId,
      'User id $userId must match authenticated user id $authenticatedUserId.',
    );

    return writeCollection.doc(userId).set(user.toJson());
  }

  void createOrUpdateUserInBatch({
    required UserModel user,
    required WriteBatch batch,
  }) {
    final docRef = writeCollection.doc(user.id);
    batch.set(docRef, user.toJson());
  }
}
