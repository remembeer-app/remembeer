import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/badge/service/badge_service.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/date/util/date_utils.dart';
import 'package:remembeer/drink/constants.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink/type/drink_with_session_id.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/service/user_stats_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';
import 'package:rxdart/rxdart.dart';

class DrinkService {
  final AuthService authService;
  final UserSettingsController userSettingsController;
  final DrinkController drinkController;
  final UserController userController;
  final SessionController sessionController;
  final DateService dateService;
  final LocationService locationService;
  final UserStatsService userStatsService;
  final BadgeService badgeService;

  DrinkService({
    required this.authService,
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

  Stream<List<DrinkWithSessionId>> _drinksToShowFromSession(Session session) {
    return Rx.combineLatest2(
      dateService.selectedDateStateStream,
      userController.currentUserStream,
      (_, user) {
        final (startTime, endTime) = dateService.selectedDateBoundaries(
          user.endOfDayBoundary,
        );

        return session.drinks
            .where((drink) => drink.userId == authService.authenticatedUser.uid)
            .where((drink) => drink.consumedAt.isAfter(startTime))
            .where((drink) => !drink.consumedAt.isAfter(endTime))
            .map((drink) => (originalSessionId: session.id, drink: drink))
            .toList();
      },
    );
  }

  /// Returns current users' drinks consumed on currently selected day
  /// with respect to custom end of day boundary
  Stream<List<DrinkWithSessionId>> drinksWithIdToShowFromSessions(
    List<Session> sessions,
  ) {
    if (sessions.isEmpty) {
      return Stream.value([]);
    }
    return Rx.combineLatest(
      sessions.map(_drinksToShowFromSession),
      (drinksInSessions) => drinksInSessions.expand((i) => i).toList(),
    );
  }

  /// Returns current users' drinks consumed on currently selected day
  /// with respect to custom end of day boundary
  Stream<List<Drink>> drinksToShowFromSessions(Session session) {
    return _drinksToShowFromSession(
      session,
    ).map((items) => items.map((item) => item.drink).toList());
  }

  /// Creates a new drink.
  ///
  /// If exactly one session is active at the drink's consumedAt time,
  /// the drink is added to that session. Otherwise, a new solo session
  /// is created for the drink.
  Future<void> createDrink(DrinkCreate drinkCreate) async {
    final effectiveDate = await _effectiveDate(drinkCreate.consumedAt);
    final after6pm = _calculateIsAfter6pm(
      drinkCreate.consumedAt,
      effectiveDate,
    );

    final beers = _beersEquivalent(
      category: drinkCreate.drinkType.category,
      volumeInMilliliters: drinkCreate.volumeInMilliliters,
    );
    final alcohol = _alcoholMl(
      volumeInMilliliters: drinkCreate.volumeInMilliliters,
      alcoholPercentage: drinkCreate.drinkType.alcoholPercentage,
    );

    final drinkId = sessionController.generateId();
    final userId = authService.authenticatedUser.uid;
    final now = DateTime.now();

    // TODO(metju-ac): Refactor to use server timestamps
    final drink = Drink(
      id: drinkId,
      userId: userId,
      createdAt: now,
      updatedAt: now,
      consumedAt: drinkCreate.consumedAt,
      drinkType: drinkCreate.drinkType,
      volumeInMilliliters: drinkCreate.volumeInMilliliters,
      location: drinkCreate.location,
    );

    final activeSessions = await sessionController.sessionsActiveAt(
      drinkCreate.consumedAt,
    );

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

    final batch = sessionController.batch;

    if (activeSessions.length == 1) {
      sessionController.addDrinkInBatch(activeSessions.single.id, drink, batch);
    } else {
      sessionController.createSoloSessionWithDrinkInBatch(drink, batch);
    }

    userController.createOrUpdateUserInBatch(user: user, batch: batch);

    await batch.commit();
  }

  Future<void> updateDrink({
    required Drink oldDrink,
    required Drink newDrink,
  }) async {
    var drinkToUpdate = newDrink;

    final oldEffectiveDate = await _effectiveDate(oldDrink.consumedAt);
    final oldAfter6pm = _calculateIsAfter6pm(
      oldDrink.consumedAt,
      oldEffectiveDate,
    );

    final newEffectiveDate = await _effectiveDate(drinkToUpdate.consumedAt);
    final newAfter6pm = _calculateIsAfter6pm(
      drinkToUpdate.consumedAt,
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
      category: drinkToUpdate.drinkType.category,
      volumeInMilliliters: drinkToUpdate.volumeInMilliliters,
    );
    final newAlcohol = _alcoholMl(
      volumeInMilliliters: drinkToUpdate.volumeInMilliliters,
      alcoholPercentage: drinkToUpdate.drinkType.alcoholPercentage,
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

    if (drinkToUpdate.sessionId != null) {
      final session = await sessionController.findById(
        drinkToUpdate.sessionId!,
      );

      final consumedAt = drinkToUpdate.consumedAt;
      final sessionStart = session.startedAt;
      final sessionEnd = session.endedAt;

      final isBeforeStart = consumedAt.isBefore(sessionStart);
      final isAfterEnd = sessionEnd != null && consumedAt.isAfter(sessionEnd);

      if (isBeforeStart || isAfterEnd) {
        drinkToUpdate = drinkToUpdate.copyWith(sessionId: null);
      }
    }

    final batch = drinkController.batch;
    drinkController.updateSingleInBatch(drinkToUpdate, batch);
    userController.createOrUpdateUserInBatch(user: user, batch: batch);
    await batch.commit();
  }

  Future<void> deleteDrink(String sessionId, Drink drink) async {
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

    final session = await sessionController.findById(sessionId);
    final batch = drinkController.batch;

    sessionController.removeDrinkInBatch(sessionId, drink, batch);
    userController.createOrUpdateUserInBatch(user: user, batch: batch);
    _deleteEmptySoloSessionInBatch(session, batch);
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
    showSuccessNotification('Default drink added!');
  }

  Future<void> moveDrinkBetweenSessions({
    required Drink drink,
    required String fromSessionId,
    String? toSessionId,
  }) {
    // TODO(metju-ac): implement
    return Future.value();
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

  void _deleteEmptySoloSessionInBatch(Session session, WriteBatch batch) {
    if (!session.isSoloSession) return;
    invariant(
      session.drinks.length == 1,
      'solo session must contain only single drink',
    );

    sessionController.deleteSingleInBatch(session, batch);
  }
}
