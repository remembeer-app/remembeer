import 'package:diacritic/diacritic.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/badge/model/badge_progress.dart';
import 'package:remembeer/user/model/daily_stats.dart';
import 'package:remembeer/user/model/monthly_stats.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  final String id;
  final String email;
  final String username;
  final String searchableUsername;
  final String avatarName;
  final Set<String> friends;
  final Map<String, MonthlyStats> monthlyStats;
  final Map<String, BadgeProgress> badgeProgress;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    String? searchableUsername,
    this.avatarName = 'jirka_kara.png',
    this.friends = const {},
    this.monthlyStats = const {},
    this.badgeProgress = const {},
  }) : searchableUsername = searchableUsername ?? toSearchable(username);

  static String toSearchable(String input) {
    return removeDiacritics(input).toLowerCase().replaceAll(' ', '');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? username,
    String? avatarName,
    Set<String>? friends,
    Map<String, MonthlyStats>? monthlyStats,
    Map<String, BadgeProgress>? badgeProgress,
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
      badgeProgress: badgeProgress ?? this.badgeProgress,
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
    return monthlyStats.dailyStats[day] ??
        DailyStats(day: day, beersConsumed: 0, alcoholConsumedMl: 0);
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
  }) {
    final currentStats = getMonthlyStats(year, month);
    final updatedStats = currentStats.addDrink(
      day: day,
      beersEquivalent: beersEquivalent,
      alcoholMl: alcoholMl,
    );
    return _updateMonthlyStats(updatedStats);
  }

  UserModel removeDrink({
    required int year,
    required int month,
    required int day,
    required double beersEquivalent,
    required double alcoholMl,
  }) {
    final currentStats = getMonthlyStats(year, month);
    final updatedStats = currentStats.removeDrink(
      day: day,
      beersEquivalent: beersEquivalent,
      alcoholMl: alcoholMl,
    );
    return _updateMonthlyStats(updatedStats);
  }
}
