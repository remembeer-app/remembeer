import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/badge/service/badge_service.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/date/util/date_utils.dart';
import 'package:remembeer/drink/constants.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/service/user_stats_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';
import 'package:rxdart/rxdart.dart';

class DrinkService {
  final UserSettingsController userSettingsController;
  final DrinkController drinkController;
  final UserController userController;
  final SessionController sessionController;
  final DateService dateService;
  final LocationService locationService;
  final UserStatsService userStatsService;
  final BadgeService badgeService;

  DrinkService({
    required this.userSettingsController,
    required this.drinkController,
    required this.userController,
    required this.sessionController,
    required this.dateService,
    required this.locationService,
    required this.userStatsService,
    required this.badgeService,
  });

  Stream<List<Drink>> get drinksForSelectedDateStream {
    return Rx.combineLatest4(
      drinkController.entitiesStreamForCurrentUser,
      dateService.selectedDateStateStream,
      userSettingsController.currentUserSettingsStream,
      userController.currentUserStream,
      (drinks, _, userSettings, user) {
        final drinkListSort = userSettings.drinkListSortOrder;
        final (startTime, endTime) = dateService.selectedDateBoundaries(
          user.endOfDayBoundary,
        );

        final filtered = drinks
            .where(
              (drink) =>
                  drink.consumedAt.isAfter(startTime) &&
                  drink.consumedAt.isBefore(endTime),
            )
            .toList();

        switch (drinkListSort) {
          case DrinkListSortOrder.descending:
            filtered.sort((a, b) => b.consumedAt.compareTo(a.consumedAt));
          case DrinkListSortOrder.ascending:
            filtered.sort((a, b) => a.consumedAt.compareTo(b.consumedAt));
        }

        return filtered;
      },
    );
  }

  Future<void> createDrink(DrinkCreate drinkCreate) async {
    var drinkToCreate = drinkCreate;

    final effectiveDate = await _effectiveDate(drinkToCreate.consumedAt);
    final after6pm = _calculateIsAfter6pm(
      drinkToCreate.consumedAt,
      effectiveDate,
    );

    final beers = _beersEquivalent(
      category: drinkToCreate.drinkType.category,
      volumeInMilliliters: drinkToCreate.volumeInMilliliters,
    );
    final alcohol = _alcoholMl(
      volumeInMilliliters: drinkToCreate.volumeInMilliliters,
      alcoholPercentage: drinkToCreate.drinkType.alcoholPercentage,
    );

    final activeSessions = await sessionController
        .sessionsActiveAtStream(drinkToCreate.consumedAt)
        .first;
    if (activeSessions.length == 1) {
      drinkToCreate = drinkToCreate.copyWith(
        sessionId: activeSessions.single.id,
      );
    }

    var user = await userController.currentUser;
    user = user.addDrink(
      year: effectiveDate.year,
      month: effectiveDate.month,
      day: effectiveDate.day,
      beersEquivalent: beers,
      alcoholMl: alcohol,
      after6pm: after6pm,
    );

    final stats = userStatsService.fromUser(user);
    user = badgeService.evaluateBadges(user, stats, effectiveDate);

    final batch = drinkController.batch;
    drinkController.createSingleInBatch(drinkToCreate, batch);
    userController.createOrUpdateUserInBatch(user: user, batch: batch);
    await batch.commit();
  }

  Future<void> updateDrink({
    required Drink oldDrink,
    required Drink newDrink,
  }) async {
    final oldEffectiveDate = await _effectiveDate(oldDrink.consumedAt);
    final oldAfter6pm = _calculateIsAfter6pm(
      oldDrink.consumedAt,
      oldEffectiveDate,
    );

    final newEffectiveDate = await _effectiveDate(newDrink.consumedAt);
    final newAfter6pm = _calculateIsAfter6pm(
      newDrink.consumedAt,
      newEffectiveDate,
    );

    final oldBeers = _beersEquivalent(
      category: oldDrink.drinkType.category,
      volumeInMilliliters: oldDrink.volumeInMilliliters,
    );
    final oldAlcohol = _alcoholMl(
      volumeInMilliliters: oldDrink.volumeInMilliliters,
      alcoholPercentage: oldDrink.drinkType.alcoholPercentage,
    );
    final newBeers = _beersEquivalent(
      category: newDrink.drinkType.category,
      volumeInMilliliters: newDrink.volumeInMilliliters,
    );
    final newAlcohol = _alcoholMl(
      volumeInMilliliters: newDrink.volumeInMilliliters,
      alcoholPercentage: newDrink.drinkType.alcoholPercentage,
    );

    var user = await userController.currentUser;

    user = user.removeDrink(
      year: oldEffectiveDate.year,
      month: oldEffectiveDate.month,
      day: oldEffectiveDate.day,
      beersEquivalent: oldBeers,
      alcoholMl: oldAlcohol,
      after6pm: oldAfter6pm,
    );

    user = user.addDrink(
      year: newEffectiveDate.year,
      month: newEffectiveDate.month,
      day: newEffectiveDate.day,
      beersEquivalent: newBeers,
      alcoholMl: newAlcohol,
      after6pm: newAfter6pm,
    );

    final stats = userStatsService.fromUser(user);
    user = badgeService.evaluateBadges(user, stats, newEffectiveDate);

    if (newDrink.sessionId != null) {
      final session = await sessionController.findById(newDrink.sessionId!);

      final consumedAt = newDrink.consumedAt;
      final sessionStart = session.startedAt;
      final sessionEnd = session.endedAt;

      final isBeforeStart = consumedAt.isBefore(sessionStart);
      final isAfterEnd = sessionEnd != null && consumedAt.isAfter(sessionEnd);

      if (isBeforeStart || isAfterEnd) {
        newDrink = newDrink.copyWith(sessionId: null);
      }
    }

    final batch = drinkController.batch;
    drinkController.updateSingleInBatch(newDrink, batch);
    userController.createOrUpdateUserInBatch(user: user, batch: batch);
    await batch.commit();
  }

  Future<void> deleteDrink(Drink drink) async {
    final effectiveDate = await _effectiveDate(drink.consumedAt);
    final after6pm = _calculateIsAfter6pm(drink.consumedAt, effectiveDate);

    final beers = _beersEquivalent(
      category: drink.drinkType.category,
      volumeInMilliliters: drink.volumeInMilliliters,
    );
    final alcohol = _alcoholMl(
      volumeInMilliliters: drink.volumeInMilliliters,
      alcoholPercentage: drink.drinkType.alcoholPercentage,
    );

    var user = await userController.currentUser;
    user = user.removeDrink(
      year: effectiveDate.year,
      month: effectiveDate.month,
      day: effectiveDate.day,
      beersEquivalent: beers,
      alcoholMl: alcohol,
      after6pm: after6pm,
    );

    final stats = userStatsService.fromUser(user);
    user = badgeService.evaluateBadges(user, stats, effectiveDate);

    final batch = drinkController.batch;
    drinkController.deleteSingleInBatch(drink, batch);
    userController.createOrUpdateUserInBatch(user: user, batch: batch);
    await batch.commit();
  }

  Future<void> addDefaultDrink() async {
    final userSettings = await userSettingsController.currentUserSettings;
    final position = await locationService.getLastPositionIfAllowed();
    final location = position != null
        ? GeoPoint(position.latitude, position.longitude)
        : null;

    await createDrink(
      DrinkCreate(
        consumedAt: DateTime.now(),
        drinkType: userSettings.defaultDrinkType,
        volumeInMilliliters: userSettings.defaultDrinkSize,
        location: location,
      ),
    );
  }

  Future<void> updateDrinkSession(Drink drink, String? sessionId) async {
    if (drink.sessionId == sessionId) return;
    final updatedDrink = drink.copyWith(sessionId: sessionId);
    await drinkController.updateSingle(updatedDrink);
  }

  double _beersEquivalent({
    required DrinkCategory category,
    required int volumeInMilliliters,
  }) {
    if (category != DrinkCategory.beer) return 0;
    return volumeInMilliliters / beerVolumeMl;
  }

  double _alcoholMl({
    required int volumeInMilliliters,
    required double alcoholPercentage,
  }) {
    return volumeInMilliliters * alcoholPercentage / 100;
  }

  bool _calculateIsAfter6pm(DateTime consumedAt, DateTime effectiveDate) {
    final sixPmOnEffectiveDay = DateTime(
      effectiveDate.year,
      effectiveDate.month,
      effectiveDate.day,
      18,
    );
    return consumedAt.isAfter(sixPmOnEffectiveDay);
  }

  Future<DateTime> _effectiveDate(DateTime consumedAt) async {
    final user = await userController.currentUser;
    final endOfDayBoundary = user.endOfDayBoundary;

    return effectiveDate(consumedAt, endOfDayBoundary);
  }
}
