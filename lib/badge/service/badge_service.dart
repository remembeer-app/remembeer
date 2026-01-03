import 'package:remembeer/badge/data/badge_definitions.dart';
import 'package:remembeer/badge/model/badge_category.dart';
import 'package:remembeer/badge/model/badge_progress.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user_stats/model/user_stats.dart';

class BadgeService {
  BadgeService();

  UserModel evaluateBadges(UserModel user, UserStats stats) {
    var updatedUser = user;

    updatedUser = _checkTotalBeers(updatedUser, stats);
    updatedUser = _checkTotalAlcohol(updatedUser, stats);
    updatedUser = _checkStreaks(updatedUser, stats);

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

  UserModel _unlockIfNew(UserModel user, String badgeId) {
    if (user.isBadgeUnlocked(badgeId)) return user;

    final progress = BadgeProgress(
      badgeId: badgeId,
      unlockedAt: DateTime.now(),
    );

    return user.updateBadgeProgress(progress);
  }
}
