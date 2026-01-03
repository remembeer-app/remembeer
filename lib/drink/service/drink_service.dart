import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/badge/service/badge_service.dart';
import 'package:remembeer/drink/constants.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink/service/date_service.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';
import 'package:remembeer/user_stats/service/user_stats_service.dart';
import 'package:rxdart/rxdart.dart';

class DrinkService {
  final UserSettingsController userSettingsController;
  final DrinkController drinkController;
  final UserController userController;
  final DateService dateService;
  final LocationService locationService;
  final UserStatsService userStatsService;
  final BadgeService badgeService;

  DrinkService({
    required this.userSettingsController,
    required this.drinkController,
    required this.userController,
    required this.dateService,
    required this.locationService,
    required this.userStatsService,
    required this.badgeService,
  });

  Stream<List<Drink>> get drinksForSelectedDateStream {
    return Rx.combineLatest3(
      drinkController.userRelatedEntitiesStream,
      dateService.selectedDateStream,
      userSettingsController.userSettingsStream,
      (drinks, selectedDate, userSettings) {
        final drinkListSort = userSettings.drinkListSort;
        final (startTime, endTime) = dateService.selectedDateBoundaries(
          userSettings.endOfDayBoundary,
        );

        final filtered = drinks
            .where(
              (drink) =>
                  drink.consumedAt.isAfter(startTime) &&
                  drink.consumedAt.isBefore(endTime),
            )
            .toList();

        switch (drinkListSort) {
          case DrinkListSort.descending:
            filtered.sort((a, b) => b.consumedAt.compareTo(a.consumedAt));
          case DrinkListSort.ascending:
            filtered.sort((a, b) => a.consumedAt.compareTo(b.consumedAt));
        }

        return filtered;
      },
    );
  }

  Future<void> createDrink(DrinkCreate drinkCreate) async {
    final effectiveDate = await _effectiveDate(drinkCreate.consumedAt);

    final beers = _beersEquivalent(
      category: drinkCreate.drinkType.category,
      volumeInMilliliters: drinkCreate.volumeInMilliliters,
    );
    final alcohol = _alcoholMl(
      volumeInMilliliters: drinkCreate.volumeInMilliliters,
      alcoholPercentage: drinkCreate.drinkType.alcoholPercentage,
    );

    var user = await userController.currentUser;
    user = user.addDrink(
      year: effectiveDate.year,
      month: effectiveDate.month,
      day: effectiveDate.day,
      beersEquivalent: beers,
      alcoholMl: alcohol,
    );

    final stats = userStatsService.fromUser(user);
    user = badgeService.evaluateBadges(user, stats, drinkCreate.consumedAt);

    final batch = drinkController.createBatch();
    drinkController.createSingleInBatch(dto: drinkCreate, batch: batch);
    userController.createOrUpdateInBatch(user: user, batch: batch);
    await batch.commit();
  }

  Future<void> updateDrink({
    required Drink oldDrink,
    required Drink newDrink,
  }) async {
    final oldEffectiveDate = await _effectiveDate(oldDrink.consumedAt);
    final newEffectiveDate = await _effectiveDate(newDrink.consumedAt);

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
    );

    user = user.addDrink(
      year: newEffectiveDate.year,
      month: newEffectiveDate.month,
      day: newEffectiveDate.day,
      beersEquivalent: newBeers,
      alcoholMl: newAlcohol,
    );

    final stats = userStatsService.fromUser(user);
    user = badgeService.evaluateBadges(user, stats, newDrink.consumedAt);

    final batch = drinkController.createBatch();
    drinkController.updateSingleInBatch(entity: newDrink, batch: batch);
    userController.createOrUpdateInBatch(user: user, batch: batch);
    await batch.commit();
  }

  Future<void> deleteDrink(Drink drink) async {
    final effectiveDate = await _effectiveDate(drink.consumedAt);

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
    );

    final stats = userStatsService.fromUser(user);
    user = badgeService.evaluateBadges(user, stats, drink.consumedAt);

    final batch = drinkController.createBatch();
    drinkController.deleteSingleInBatch(entity: drink, batch: batch);
    userController.createOrUpdateInBatch(user: user, batch: batch);
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
    final updatedDrink = sessionId == null
        ? drink.withoutSessionId()
        : drink.copyWith(sessionId: sessionId);
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

  Future<DateTime> _effectiveDate(DateTime consumedAt) async {
    final userSettings = await userSettingsController.currentUserSettings;
    final endOfDayBoundary = userSettings.endOfDayBoundary;

    final boundaryTime = DateTime(
      consumedAt.year,
      consumedAt.month,
      consumedAt.day,
      endOfDayBoundary.hour,
      endOfDayBoundary.minute,
    );

    if (consumedAt.isBefore(boundaryTime)) {
      return consumedAt.subtract(const Duration(days: 1));
    }
    return consumedAt;
  }
}
