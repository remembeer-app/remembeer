import 'package:remembeer/badge/data/badge_definitions.dart';
import 'package:remembeer/badge/data/onetime_badge_id.dart';
import 'package:remembeer/badge/model/badge_category.dart';
import 'package:remembeer/badge/model/badge_progress.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user_stats/model/user_stats.dart';

class BadgeService {
  BadgeService();

  /// Evaluates and unlocks badges based on the user's stats and the current drink.
  ///
  /// [consumedAt] should be the **effective date** of the drink, not necessarily the
  /// wall-clock time. This ensures that drinks consumed after midnight (but before
  /// the custom end-of-day boundary) are correctly attributed to the previous day.
  UserModel evaluateBadges(
    UserModel user,
    UserStats stats,
    DateTime consumedAt,
  ) {
    var updatedUser = user;

    updatedUser = _checkTotalBeers(updatedUser, stats);
    updatedUser = _checkTotalAlcohol(updatedUser, stats);
    updatedUser = _checkStreaks(updatedUser, stats);
    updatedUser = _checkOnetimeBadges(updatedUser, consumedAt);

    return updatedUser;
  }

  UserModel _checkTotalBeers(UserModel user, UserStats stats) {
    var updatedUser = user;

    for (final badge in getBadgesByCategory(BadgeCategory.beersTotal)) {
      if (stats.totalBeersConsumed >= badge.goal!) {
        updatedUser = _unlockIfNew(updatedUser, badge.id);
      }
    }

    return updatedUser;
  }

  UserModel _checkTotalAlcohol(UserModel user, UserStats stats) {
    var updatedUser = user;

    for (final badge in getBadgesByCategory(BadgeCategory.alcoholTotal)) {
      if (stats.totalAlcoholConsumed >= badge.goal!) {
        updatedUser = _unlockIfNew(updatedUser, badge.id);
      }
    }

    return updatedUser;
  }

  UserModel _checkStreaks(UserModel user, UserStats stats) {
    var updatedUser = user;

    for (final badge in getBadgesByCategory(BadgeCategory.streak)) {
      if (stats.isStreakActive && stats.streakDays >= badge.goal!) {
        updatedUser = _unlockIfNew(updatedUser, badge.id);
      }
    }

    return updatedUser;
  }

  UserModel _checkOnetimeBadges(UserModel user, DateTime consumedAt) {
    var updatedUser = user;

    for (final badgeId in OnetimeBadgeId.values) {
      final unlocked = switch (badgeId) {
        OnetimeBadgeId.earlyRiser => _checkEarlyRiser(consumedAt),
        OnetimeBadgeId.nightAnimal => _checkNightAnimal(user, consumedAt),
        OnetimeBadgeId.youRemembeered => _checkYouRemembeered(consumedAt),
      };

      if (unlocked) {
        updatedUser = _unlockIfNew(updatedUser, badgeId.id);
      }
    }

    return updatedUser;
  }

  bool _checkEarlyRiser(DateTime consumedAt) {
    return consumedAt.hour >= 6 && consumedAt.hour < 8;
  }

  bool _checkNightAnimal(UserModel user, DateTime consumedAt) {
    final dailyStats = user.getDailyStats(
      consumedAt.year,
      consumedAt.month,
      consumedAt.day,
    );
    return dailyStats.beersAfter6pm >= 10;
  }

  bool _checkYouRemembeered(DateTime consumedAt) {
    final now = DateTime.now();
    final difference = now.difference(consumedAt).inDays;
    return difference >= 5;
  }

  UserModel _unlockIfNew(UserModel user, String badgeId) {
    if (user.isBadgeUnlocked(badgeId)) return user;

    final progress = BadgeProgress(
      badgeId: badgeId,
      unlockedAt: DateTime.now(),
    );

    return user.updateBadgeProgress(progress);
  }
}
