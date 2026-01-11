import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/badge/model/unlocked_badge.dart';
import 'package:remembeer/common/converter/time_of_day_converter.dart';
import 'package:remembeer/common/extension/searchable.dart';
import 'package:remembeer/common/model/document.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/model/daily_stats.dart';
import 'package:remembeer/user/model/monthly_stats.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel implements Document {
  const UserModel._();

  const factory UserModel({
    required String id,

    required String email,
    required String username,
    required String searchableUsername,
    @Default('jirka_kara.png') String avatarName,
    @Default({}) Set<String> friends,
    @Default({}) Map<String, MonthlyStats> monthlyStats,
    @Default({}) Map<String, UnlockedBadge> unlockedBadges,
    @TimeOfDayConverter()
    @Default(defaultEndOfDayBoundary)
    TimeOfDay endOfDayBoundary,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Creates a copy of the current UserModel with an updated username
  /// and its searchable version. Use instead of copyWith when changing username.
  UserModel withUsername(String newUsername) {
    return copyWith(
      username: newUsername,
      searchableUsername: newUsername.toSearchable(),
    );
  }

  UserModel addFriend(String friendId) {
    final updatedFriends = Set<String>.from(friends)..add(friendId);
    return copyWith(friends: updatedFriends);
  }

  UserModel removeFriend(String friendId) {
    final updatedFriends = Set<String>.from(friends)..remove(friendId);
    return copyWith(friends: updatedFriends);
  }

  MonthlyStats getMonthlyStats(int year, int month) {
    final key = MonthlyStats.keyFor(year, month);
    return monthlyStats[key] ??
        MonthlyStats(
          year: year,
          month: month,
          beersConsumed: 0,
          alcoholConsumedMl: 0,
        );
  }

  DailyStats getDailyStats(int year, int month, int day) {
    final monthlyStats = getMonthlyStats(year, month);
    return monthlyStats.dailyStats[day] ?? DailyStats(day: day);
  }

  UserModel _updateMonthlyStats(MonthlyStats stats) {
    final updatedStats = Map<String, MonthlyStats>.from(monthlyStats);
    updatedStats[stats.key] = stats;
    return copyWith(monthlyStats: updatedStats);
  }

  // TODO(ohtenkay): try to rewrite this using the deepcopy from freezed
  UserModel addDrink({
    required int year,
    required int month,
    required int day,
    required double beersEquivalent,
    required double alcoholMl,
    required bool after6pm,
  }) {
    final currentStats = getMonthlyStats(year, month);
    final updatedStats = currentStats.addDrink(
      day: day,
      beersEquivalent: beersEquivalent,
      alcoholMl: alcoholMl,
      after6pm: after6pm,
    );
    return _updateMonthlyStats(updatedStats);
  }

  UserModel removeDrink({
    required int year,
    required int month,
    required int day,
    required double beersEquivalent,
    required double alcoholMl,
    required bool after6pm,
  }) {
    final currentStats = getMonthlyStats(year, month);
    final updatedStats = currentStats.removeDrink(
      day: day,
      beersEquivalent: beersEquivalent,
      alcoholMl: alcoholMl,
      after6pm: after6pm,
    );
    return _updateMonthlyStats(updatedStats);
  }

  List<UnlockedBadge> get shownBadges {
    return unlockedBadges.values.where((badge) => badge.isShown).toList()
      ..sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
  }

  List<UnlockedBadge> get allBadges {
    return unlockedBadges.values.toList()
      ..sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
  }

  bool isBadgeUnlocked(String badgeId) {
    return unlockedBadges[badgeId] != null;
  }

  UserModel unlockBadge(String badgeId) {
    final shownBadgesCount = shownBadges.length;
    final updatedUnlockedBadges = Map<String, UnlockedBadge>.from(
      unlockedBadges,
    );

    updatedUnlockedBadges[badgeId] = UnlockedBadge(
      badgeId: badgeId,
      unlockedAt: DateTime.now(),
      isShown: shownBadgesCount < maxBadgesShown,
    );

    return copyWith(unlockedBadges: updatedUnlockedBadges);
  }

  UserModel updateBadgeVisibility(String badgeId, bool isShown) {
    final badge = unlockedBadges[badgeId];
    if (badge == null) {
      throw StateError(
        'Cannot update visibility for badge $badgeId that is not unlocked.',
      );
    }

    final updatedUnlockedBadges = Map<String, UnlockedBadge>.from(
      unlockedBadges,
    );

    updatedUnlockedBadges[badgeId] = UnlockedBadge(
      badgeId: badge.badgeId,
      unlockedAt: badge.unlockedAt,
      isShown: isShown,
    );

    return copyWith(unlockedBadges: updatedUnlockedBadges);
  }
}
