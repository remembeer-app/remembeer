import 'package:remembeer/badge/constants.dart';
import 'package:remembeer/badge/data/badge_definitions.dart';
import 'package:remembeer/badge/data/onetime_badge_id.dart';
import 'package:remembeer/badge/model/badge_category.dart';
import 'package:remembeer/badge/type/badge_definition.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/type/user_stats.dart';

class BadgeService {
  BadgeService();

  /// Evaluates and unlocks badges based on the user's stats and the current drink.
  ///
  /// [consumedAt] should be the **effective date** of the drink, not necessarily the
  /// wall-clock time. This ensures that drinks consumed after midnight (but before
  /// the custom end-of-day boundary) are correctly attributed to the previous day.
  ///
  /// [drinkType] is the type of the drink that was just logged ).
  /// Pass `null` when a drink is being removed.
  UserModel evaluateBadges(
    UserModel user,
    UserStats stats,
    DateTime consumedAt, {
    required DrinkTypeCore? drinkType,
  }) {
    var updatedUser = user;

    updatedUser = _checkTotalBeers(updatedUser, stats);
    updatedUser = _checkTotalAlcohol(updatedUser, stats);
    updatedUser = _checkStreaks(updatedUser, stats);
    updatedUser = _checkOnetimeBadges(updatedUser, consumedAt, drinkType);

    return updatedUser;
  }

  UserModel _checkTotalBeers(UserModel user, UserStats stats) {
    var updatedUser = user;

    for (final badge in getBadgesByCategory(BadgeCategory.beersTotal)) {
      final goal =
          badge.goal ?? never('Beer total badge ${badge.id} must have a goal.');
      if (stats.totalBeersConsumed >= goal) {
        updatedUser = _unlockIfNew(updatedUser, badge);
      }
    }

    return updatedUser;
  }

  UserModel _checkTotalAlcohol(UserModel user, UserStats stats) {
    var updatedUser = user;

    for (final badge in getBadgesByCategory(BadgeCategory.alcoholTotal)) {
      final goal =
          badge.goal ??
          never('Alcohol total badge ${badge.id} must have a goal.');
      if (stats.totalAlcoholConsumed >= goal) {
        updatedUser = _unlockIfNew(updatedUser, badge);
      }
    }

    return updatedUser;
  }

  UserModel _checkStreaks(UserModel user, UserStats stats) {
    var updatedUser = user;

    for (final badge in getBadgesByCategory(BadgeCategory.streak)) {
      final goal =
          badge.goal ?? never('Streak badge ${badge.id} must have a goal.');
      if (stats.isStreakActive && stats.streakDays >= goal) {
        updatedUser = _unlockIfNew(updatedUser, badge);
      }
    }

    return updatedUser;
  }

  UserModel _checkOnetimeBadges(
    UserModel user,
    DateTime consumedAt,
    DrinkTypeCore? drinkType,
  ) {
    var updatedUser = user;

    for (final badgeId in OnetimeBadgeId.values) {
      final unlocked = switch (badgeId) {
        OnetimeBadgeId.earlyRiser => _checkEarlyRiser(consumedAt),
        OnetimeBadgeId.nightAnimal => _checkNightAnimal(user, consumedAt),
        OnetimeBadgeId.youRemembeered => _checkYouRemembeered(consumedAt),
        OnetimeBadgeId.caseClosed => _checkCaseClosed(user, consumedAt),
        OnetimeBadgeId.mastiToJakDrak => _checkMastiToJakDrak(drinkType),
      };

      if (unlocked) {
        updatedUser = _unlockIfNew(updatedUser, getBadgeById(badgeId.id));
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

  bool _checkCaseClosed(UserModel user, DateTime consumedAt) {
    final dailyStats = user.getDailyStats(
      consumedAt.year,
      consumedAt.month,
      consumedAt.day,
    );
    return dailyStats.beersConsumed >= 20;
  }

  bool _checkMastiToJakDrak(DrinkTypeCore? drinkType) {
    if (drinkType == null) return false;
    return drinkType.name.trim().toLowerCase() ==
        mastiToJakDrakDrinkTypeName.toLowerCase();
  }

  void notifyUnlockedBadges(Iterable<String> badgeIds) {
    for (final badgeId in badgeIds) {
      _notifyUnlocked(getBadgeById(badgeId));
    }
  }

  UserModel _unlockIfNew(UserModel user, BadgeDefinition badgeDefinition) {
    if (user.isBadgeUnlocked(badgeDefinition.id)) return user;
    _notifyUnlocked(badgeDefinition);
    return user.unlockBadge(badgeDefinition.id);
  }

  void _notifyUnlocked(BadgeDefinition badgeDefinition) {
    showSuccessNotification('${badgeDefinition.name} badge unlocked!');
  }
}
