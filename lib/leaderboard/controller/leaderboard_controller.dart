import 'package:remembeer/common/controller/crud_controller.dart';
import 'package:remembeer/common/extension/query_firestore_helper.dart';
import 'package:remembeer/common/util/invariant.dart';
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

  Future<Leaderboard?> findByInviteCode(String inviteCode) async {
    final snapshot = await nonDeletedEntities
        .where('inviteCode', isEqualTo: inviteCode)
        .get();

    invariant(
      snapshot.docs.length <= 1,
      'Expected at most 1 leaderboard with invite code $inviteCode, found ${snapshot.docs.length}.',
    );

    if (snapshot.docs.isEmpty) {
      return null;
    }
    return snapshot.docs.first.data();
  }
}
