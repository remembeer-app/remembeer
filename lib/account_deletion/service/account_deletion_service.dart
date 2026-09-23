import 'package:flutter/foundation.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/avatar/service/avatar_service.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/friend_request/controller/friend_request_controller.dart';
import 'package:remembeer/leaderboard/controller/leaderboard_controller.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_picture_service.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';

class AccountDeletionService {
  final AuthService authService;
  final DrinkController drinkController;
  final SessionController sessionController;
  final LeaderboardController leaderboardController;
  final FriendRequestController friendRequestController;
  final UserController userController;
  final UserSettingsController userSettingsController;
  final AvatarService avatarService;
  final SessionPictureService sessionPictureService;
  final PartyController partyController;

  AccountDeletionService({
    required this.authService,
    required this.drinkController,
    required this.sessionController,
    required this.leaderboardController,
    required this.friendRequestController,
    required this.userController,
    required this.userSettingsController,
    required this.avatarService,
    required this.sessionPictureService,
    required this.partyController,
  });

  Future<void> deleteAccount() async {
    final userId = authService.authenticatedUser.uid;

    await _deleteOwnedDrinks(userId);
    await _detachFromSessions(userId);
    await _detachFromLeaderboards(userId);
    await _deleteFriendRequests(userId);
    await _removeFromFriendLists(userId);
    await avatarService.deleteAvatarFile();
    await userController.anonymizeCurrentUser();
    await userSettingsController.deleteCurrentUserSettings();
    await authService.deleteAuthUser();
  }

  /// Runs one per-entity step. A failing item is logged and skipped so a
  /// single poisoned document cannot block the whole deletion; the profile
  /// is anonymized regardless, so anything left behind is pseudonymous.
  Future<void> _tryStep(
    String description,
    Future<void> Function() step,
  ) async {
    try {
      await step();
    } on Exception catch (e) {
      debugPrint('Account deletion: $description failed: $e');
    }
  }

  Future<void> _deleteOwnedDrinks(String userId) async {
    final drinks = await drinkController.allOwnedBy(userId);
    for (final drink in drinks) {
      await _tryStep(
        'delete drink ${drink.id}',
        () => drinkController.hardDeleteSingle(drink),
      );
    }
  }

  Future<void> _detachFromSessions(String userId) async {
    final sessions = await sessionController.allWithMember(userId);
    for (final session in sessions) {
      await _tryStep(
        'detach from session ${session.id}',
        () => _detachFromSession(session, userId),
      );
    }
  }

  Future<void> _detachFromSession(Session session, String userId) async {
    final isOwner = session.userId == userId;

    if (session.isParty) {
      if (!isOwner) {
        await _leaveParty(session, userId);
      }
      // TODO(metju-ac): Deliberately kept now, other user data are removed either way.
      //                 Pass the ownership after codex rewrite.
      return;
    }

    final otherMembers = session.memberIds.where((id) => id != userId);
    if (isOwner && (session.deletedAt != null || otherMembers.isEmpty)) {
      for (final url in session.pictureUrls) {
        await _tryStep(
          'delete picture $url for session ${session.id}',
          () => sessionPictureService.deletePictureFile(url),
        );
      }
      await sessionController.hardDeleteSingle(session);
      return;
    }

    await sessionController.stripMemberAndHandOver(
      sessionId: session.id,
      userId: userId,
      newOwnerId: isOwner ? _pickNewSessionOwner(session, userId) : null,
    );
  }

  String _pickNewSessionOwner(Session session, String userId) {
    final remainingAdmins = session.adminIds.where(
      (id) =>
          id != userId &&
          session.memberIds.contains(id) &&
          !session.bannedMemberIds.contains(id),
    );
    if (remainingAdmins.isNotEmpty) {
      return remainingAdmins.first;
    }
    final remainingMembers = session.memberIds.where(
      (id) => id != userId && !session.bannedMemberIds.contains(id),
    );
    if (remainingMembers.isNotEmpty) {
      return remainingMembers.first;
    }
    return session.memberIds.firstWhere((id) => id != userId);
  }

  Future<void> _leaveParty(Session session, String userId) async {
    try {
      await partyController.syncMembership(
        sessionId: session.id,
        commandId: partyController.generateCommandId(),
        action: 'leave',
        memberId: userId,
      );
    } on Exception catch (e) {
      debugPrint('Leaving party ${session.id} during account deletion: $e');
    }
  }

  Future<void> _detachFromLeaderboards(String userId) async {
    final leaderboards = await leaderboardController.allWithMember(userId);
    for (final leaderboard in leaderboards) {
      await _tryStep(
        'detach from leaderboard ${leaderboard.id}',
        () => _detachFromLeaderboard(leaderboard, userId),
      );
    }
  }

  Future<void> _detachFromLeaderboard(
    Leaderboard leaderboard,
    String userId,
  ) async {
    if (leaderboard.userId != userId) {
      await leaderboardController.removeMemberAtomic(leaderboard.id, userId);
      return;
    }

    final otherMembers = leaderboard.memberIds.where((id) => id != userId);
    if (leaderboard.deletedAt != null || otherMembers.isEmpty) {
      await leaderboardController.hardDeleteSingle(leaderboard);
      return;
    }

    await leaderboardController.handOver(
      leaderboardId: leaderboard.id,
      userId: userId,
      newOwnerId: otherMembers.first,
    );
  }

  Future<void> _deleteFriendRequests(String userId) async {
    final requests = await friendRequestController.allInvolving(userId);
    for (final request in requests) {
      await _tryStep(
        'delete friend request ${request.id}',
        () => friendRequestController.hardDeleteSingle(request),
      );
    }
  }

  Future<void> _removeFromFriendLists(String userId) async {
    final users = await userController.usersWithFriend(userId);
    for (final user in users) {
      await _tryStep(
        'remove friend from ${user.id}',
        () =>
            userController.removeFriendFrom(userId: user.id, friendId: userId),
      );
    }
  }
}
