import 'package:remembeer/common/controller/members_crud_controller.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_create.dart';

class LeaderboardController
    extends MembersCrudController<Leaderboard, LeaderboardCreate> {
  LeaderboardController({required super.authService})
    : super(collectionPath: 'leaderboards', fromJson: Leaderboard.fromJson);

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
