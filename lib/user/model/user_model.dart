import 'package:diacritic/diacritic.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/badge/model/unlocked_badge.dart';
import 'package:remembeer/common/model/document.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/model/daily_stats.dart';
import 'package:remembeer/user/model/monthly_stats.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel extends Document {
  final String email;
  final String username;
  final String searchableUsername;
  final String avatarName;
  final Set<String> friends;
  final Map<String, MonthlyStats> monthlyStats;
  final Map<String, UnlockedBadge> unlockedBadges;

  UserModel({
    required super.id,
    required this.email,
    required this.username,
    String? searchableUsername,
    this.avatarName = 'jirka_kara.png',
    this.friends = const {},
    this.monthlyStats = const {},
    this.unlockedBadges = const {},
  }) : searchableUsername = searchableUsername ?? toSearchable(username);

  List<UnlockedBadge> get shownBadges {
    return unlockedBadges.values.where((badge) => badge.isShown).toList()
      ..sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
  }

  List<UnlockedBadge> get allBadges {
    return unlockedBadges.values.toList()
      ..sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
  }

  static String toSearchable(String input) {
    return removeDiacritics(input).toLowerCase().replaceAll(' ', '');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? username,
    String? avatarName,
    Set<String>? friends,
    Map<String, MonthlyStats>? monthlyStats,
    Map<String, UnlockedBadge>? unlockedBadges,
  }) {
    return UserModel(
      id: id,
      email: email,
      username: username ?? this.username,
      searchableUsername: (username != null)
          ? toSearchable(username)
          : searchableUsername,
      avatarName: avatarName ?? this.avatarName,
      friends: friends ?? this.friends,
      monthlyStats: monthlyStats ?? this.monthlyStats,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
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
