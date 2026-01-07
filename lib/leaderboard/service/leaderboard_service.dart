import 'dart:math';

import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/leaderboard/constants.dart';
import 'package:remembeer/leaderboard/controller/leaderboard_controller.dart';
import 'package:remembeer/leaderboard/model/join_leaderboard_result.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_create.dart';
import 'package:remembeer/leaderboard/model/leaderboard_entry.dart';
import 'package:remembeer/leaderboard/service/month_service.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:rxdart/rxdart.dart';

const _inviteCodeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

class LeaderboardService {
  final AuthService authService;
  final MonthService monthService;

  final LeaderboardController leaderboardController;
  final UserController userController;

  final _random = Random.secure();

  LeaderboardService({
    required this.authService,
    required this.monthService,
    required this.leaderboardController,
    required this.userController,
  });

  Future<Leaderboard?> findByInviteCode(String inviteCode) =>
      leaderboardController.findByInviteCode(inviteCode);

  Stream<Leaderboard> streamById(String id) =>
      leaderboardController.streamById(id);

  Future<void> createLeaderboard({
    required String name,
    required String iconName,
  }) async {
    final inviteCode = await _generateUniqueInviteCode();
    final currentUserId = authService.authenticatedUser.uid;

    await leaderboardController.createSingle(
      LeaderboardCreate(
        name: name,
        iconName: iconName,
        memberIds: {currentUserId},
        inviteCode: inviteCode,
      ),
    );
  }

  Future<void> updateLeaderboardName({
    required String leaderboardId,
    required String newName,
  }) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);

    if (leaderboard.userId != authService.authenticatedUser.uid) {
      throw StateError('Only the owner can update the leaderboard name.');
    }

    if (leaderboard.name == newName) {
      return;
    }

    final updatedLeaderboard = leaderboard.copyWith(name: newName);

    await leaderboardController.updateSingle(updatedLeaderboard);
  }

  Future<void> updateLeaderboardIcon({
    required String leaderboardId,
    required String newIconName,
  }) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);

    if (leaderboard.userId != authService.authenticatedUser.uid) {
      throw StateError('Only the owner can update the leaderboard icon.');
    }

    if (leaderboard.iconName == newIconName) {
      return;
    }

    final updatedLeaderboard = leaderboard.copyWith(iconName: newIconName);

    await leaderboardController.updateSingle(updatedLeaderboard);
  }

  Future<void> deleteLeaderboard(String leaderboardId) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);

    if (leaderboard.userId != authService.authenticatedUser.uid) {
      throw StateError('Only the owner can delete the leaderboard.');
    }

    await leaderboardController.deleteSingle(leaderboard);
  }

  Future<void> removeMember({
    required String leaderboardId,
    required String memberId,
  }) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);
    final currentUserId = authService.authenticatedUser.uid;

    if (leaderboard.userId != currentUserId) {
      throw StateError(
        'Only the owner can remove members from the leaderboard.',
      );
    }

    if (memberId == currentUserId) {
      throw StateError(
        'The owner cannot remove themselves from the leaderboard.',
      );
    }

    final updatedMemberIds = Set<String>.from(leaderboard.memberIds)
      ..remove(memberId);

    final updatedLeaderboard = leaderboard.copyWith(
      memberIds: updatedMemberIds,
    );

    await leaderboardController.updateSingle(updatedLeaderboard);
  }

  Future<void> banMember({
    required String leaderboardId,
    required String memberId,
  }) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);
    final currentUserId = authService.authenticatedUser.uid;

    if (leaderboard.userId != currentUserId) {
      throw StateError('Only the owner can ban members from the leaderboard.');
    }

    if (memberId == currentUserId) {
      throw StateError('The owner cannot ban themselves from the leaderboard.');
    }

    final updatedMemberIds = Set<String>.from(leaderboard.memberIds)
      ..remove(memberId);
    final updatedBannedMemberIds = Set<String>.from(leaderboard.bannedMemberIds)
      ..add(memberId);

    final updatedLeaderboard = leaderboard.copyWith(
      memberIds: updatedMemberIds,
      bannedMemberIds: updatedBannedMemberIds,
    );

    await leaderboardController.updateSingle(updatedLeaderboard);
  }

  Future<void> unbanMember({
    required String leaderboardId,
    required String memberId,
  }) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);
    final currentUserId = authService.authenticatedUser.uid;

    if (leaderboard.userId != currentUserId) {
      throw StateError(
        'Only the owner can unban members from the leaderboard.',
      );
    }

    final updatedBannedMemberIds = Set<String>.from(leaderboard.bannedMemberIds)
      ..remove(memberId);

    final updatedLeaderboard = leaderboard.copyWith(
      bannedMemberIds: updatedBannedMemberIds,
    );

    await leaderboardController.updateSingle(updatedLeaderboard);
  }

  Future<void> leaveLeaderboard(String leaderboardId) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);
    final currentUserId = authService.authenticatedUser.uid;

    if (leaderboard.userId == currentUserId) {
      throw StateError('The owner cannot leave their own leaderboard.');
    }

    final updatedMemberIds = Set<String>.from(leaderboard.memberIds)
      ..remove(currentUserId);

    final updatedLeaderboard = leaderboard.copyWith(
      memberIds: updatedMemberIds,
    );

    await leaderboardController.updateSingle(updatedLeaderboard);
  }

  Future<JoinLeaderboardResult> joinLeaderboard(String leaderboardId) async {
    final leaderboard = await leaderboardController.findById(leaderboardId);
    final currentUserId = authService.authenticatedUser.uid;

    if (leaderboard.memberIds.contains(currentUserId)) {
      return JoinLeaderboardResult.alreadyMember;
    }

    if (leaderboard.bannedMemberIds.contains(currentUserId)) {
      return JoinLeaderboardResult.banned;
    }

    if (leaderboard.memberIds.length >= maxLeaderboardMembers) {
      return JoinLeaderboardResult.full;
    }

    final updatedLeaderboard = leaderboard.copyWith(
      memberIds: {...leaderboard.memberIds, currentUserId},
    );

    await leaderboardController.updateSingle(updatedLeaderboard);
    return JoinLeaderboardResult.success;
  }

  bool isOwner(Leaderboard leaderboard) {
    return leaderboard.userId == authService.authenticatedUser.uid;
  }

  Stream<List<LeaderboardEntry>> standingsStreamFor(Leaderboard leaderboard) {
    return Rx.combineLatest2(
      leaderboardController.streamById(leaderboard.id),
      monthService.selectedMonthStream,
      (leaderboard, selectedMonth) => (leaderboard, selectedMonth),
    ).switchMap((record) {
      final (leaderboard, selectedMonth) = record;
      return _standingsStreamForMemberIds(
        memberIds: leaderboard.memberIds.toList(),
        year: selectedMonth.year,
        month: selectedMonth.month,
      );
    });
  }

  Stream<LeaderboardEntry?> currentUserStandingStreamFor(
    Leaderboard leaderboard,
  ) {
    final now = DateTime.now();
    final currentUserId = authService.authenticatedUser.uid;

    return leaderboardController
        .streamById(leaderboard.id)
        .switchMap(
          (leaderboard) =>
              _standingsStreamForMemberIds(
                memberIds: leaderboard.memberIds.toList(),
                year: now.year,
                month: now.month,
              ).map(
                (standings) => standings
                    .where((e) => e.user.id == currentUserId)
                    .firstOrNull,
              ),
        );
  }

  Stream<List<LeaderboardEntry>> _standingsStreamForMemberIds({
    required List<String> memberIds,
    required int year,
    required int month,
  }) {
    if (memberIds.isEmpty) {
      return Stream.value([]);
    }

    final userStreams = memberIds.map(userController.streamById);

    return Rx.combineLatestList(userStreams).map((users) {
      final entries = users.map((user) {
        final stats = user.getMonthlyStats(year, month);
        return LeaderboardEntry(
          user: user,
          beersConsumed: stats.beersConsumed,
          alcoholConsumedMl: stats.alcoholConsumedMl,
          rankByBeers: 0,
          rankByAlcohol: 0,
        );
      }).toList();

      return _computeRanks(entries);
    });
  }

  List<LeaderboardEntry> _computeRanks(List<LeaderboardEntry> entries) {
    entries.sort((a, b) => b.beersConsumed.compareTo(a.beersConsumed));
    final byBeersRanks = <String, int>{};
    for (var i = 0; i < entries.length; i++) {
      byBeersRanks[entries[i].user.id] = i + 1;
    }

    entries.sort((a, b) => b.alcoholConsumedMl.compareTo(a.alcoholConsumedMl));
    final byAlcoholRanks = <String, int>{};
    for (var i = 0; i < entries.length; i++) {
      byAlcoholRanks[entries[i].user.id] = i + 1;
    }

    return entries
        .map(
          (e) => LeaderboardEntry(
            user: e.user,
            beersConsumed: e.beersConsumed,
            alcoholConsumedMl: e.alcoholConsumedMl,
            rankByBeers: byBeersRanks[e.user.id]!,
            rankByAlcohol: byAlcoholRanks[e.user.id]!,
          ),
        )
        .toList();
  }

  Future<String> _generateUniqueInviteCode() async {
    String code;
    var isUnique = false;

    do {
      code = _generateRandomCode();
      final existingLeaderboard = await leaderboardController.findByInviteCode(
        code,
      );
      isUnique = existingLeaderboard == null;
    } while (!isUnique);

    return code;
  }

  String _generateRandomCode() {
    return List.generate(
      inviteCodeLength,
      (_) => _inviteCodeChars[_random.nextInt(_inviteCodeChars.length)],
    ).join();
  }
}
