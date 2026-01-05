import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user_stats/model/user_stats.dart';

class UserStatsService {
  final UserController userController;

  UserStatsService({required this.userController});

  Stream<UserStats> get userStatsStream {
    return userController.currentUserStream.map(fromUser);
  }

  Stream<UserStats> userStatsStreamFor(String userId) {
    return userController.userStreamFor(userId).map(fromUser);
  }

  UserStats fromUser(UserModel user) {
    final (totalBeers, totalAlcohol) = _calculateTotals(user);
    final (beersLast30Days, alcoholLast30Days) = _calculateLast30Days(user);

    final (isStreakActive, streakDays) = _calculateStreak(user);

    return UserStats(
      totalBeersConsumed: totalBeers,
      totalAlcoholConsumed: totalAlcohol,
      beersConsumedLast30Days: beersLast30Days,
      alcoholConsumedLast30Days: alcoholLast30Days,
      streakDays: streakDays,
      isStreakActive: isStreakActive,
    );
  }

  (double, double) _calculateTotals(UserModel user) {
    var totalBeers = 0.0;
    var totalAlcohol = 0.0;

    for (final monthly in user.monthlyStats.values) {
      totalBeers += monthly.beersConsumed;
      totalAlcohol += monthly.alcoholConsumedMl;
    }

    return (totalBeers, totalAlcohol);
  }

  (double, double) _calculateLast30Days(UserModel user) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    var beersLast30Days = 0.0;
    var alcoholLast30Days = 0.0;

    for (final i in List.generate(30, (i) => i)) {
      final date = today.subtract(Duration(days: i));
      final daily = user.getDailyStats(date.year, date.month, date.day);
      beersLast30Days += daily.beersConsumed;
      alcoholLast30Days += daily.alcoholConsumedMl;
    }

    return (beersLast30Days, alcoholLast30Days);
  }

  (bool, int) _calculateStreak(UserModel user) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    final isStreakActive = _hadDrinkOnDate(user, todayDate);

    var streakDays = 0;
    var currentDate = isStreakActive
        ? todayDate
        : todayDate.subtract(const Duration(days: 1));

    while (_hadDrinkOnDate(user, currentDate)) {
      streakDays++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    return (isStreakActive, streakDays);
  }

  bool _hadDrinkOnDate(UserModel user, DateTime date) {
    final stats = user.getDailyStats(date.year, date.month, date.day);
    return stats.alcoholConsumedMl > 0;
  }
}
