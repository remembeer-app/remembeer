import 'package:remembeer/common/controller/crud_controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/extension/query_firestore_helper.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_create.dart';

class LeaderboardController
    extends CrudController<Leaderboard, LeaderboardCreate> {
  LeaderboardController({required super.authService})
    : super(collectionPath: 'leaderboards', fromJson: Leaderboard.fromJson);

  Stream<List<Leaderboard>> get leaderboardsStreamWhereCurrentUserIsMember =>
      nonDeletedEntities
          .where('memberIds', arrayContains: authService.authenticatedUser.uid)
          .mapToStreamList();

  Future<Leaderboard> findById(String id) async {
    final doc = await readCollection.doc(id).get();
    final data = doc.data();
    if (data == null || data.deletedAt != null) {
      throw StateError('Leaderboard with id $id not found.');
    }
    return data;
  }

  Stream<Leaderboard> streamById(String id) {
    return readCollection.doc(id).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null || data.deletedAt != null) {
        throw StateError('Leaderboard with id $id not found.');
      }
      return data;
    });
  }

  Future<Leaderboard?> findByInviteCode(String inviteCode) async {
    final snapshot = await readCollection
        .where(deletedAtField, isNull: true)
        .where('inviteCode', isEqualTo: inviteCode)
        .get();

    if (snapshot.docs.length > 1) {
      throw StateError(
        'Found ${snapshot.docs.length} leaderboards with invite code $inviteCode. Expected at most 1.',
      );
    }

    if (snapshot.docs.isEmpty) {
      return null;
    }
    return snapshot.docs.first.data();
  }
}
