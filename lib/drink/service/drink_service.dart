import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/badge/service/badge_service.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/date/util/date_utils.dart';
import 'package:remembeer/drink/constants.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink/model/party_drink_command_result.dart';
import 'package:remembeer/drink/type/drink_with_session_id.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/service/user_stats_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:rxdart/rxdart.dart';

class DrinkService {
  final AuthService authService;
  final UserSettingsController userSettingsController;
  final UserController userController;
  final SessionController sessionController;
  final DateService dateService;
  final LocationService locationService;
  final UserStatsService userStatsService;
  final BadgeService badgeService;
  final DrinkTypeController drinkTypeController;
  final PartyController partyController;

  DrinkService({
    required this.authService,
    required this.userSettingsController,
    required this.userController,
    required this.sessionController,
    required this.dateService,
    required this.locationService,
    required this.userStatsService,
    required this.badgeService,
    required this.drinkTypeController,
    required this.partyController,
  });

  Stream<List<DrinkWithSessionId>> _drinksToShowFromSession(Session session) {
    return Rx.combineLatest2(
      dateService.selectedDateStateStream,
      userController.currentUserStream,
      (_, user) {
        final (startTime, endTime) = dateService.selectedDateBoundaries(
          user.endOfDayBoundary,
        );

        return session.drinks
            .where(
              (drink) =>
                  drink.consumedByUserId == authService.authenticatedUser.uid,
            )
            .where((drink) => drink.consumedAt.isAfter(startTime))
            .where((drink) => !drink.consumedAt.isAfter(endTime))
            .map(
              (drink) => (
                originalSessionId: session.id,
                drink: drink,
                isParty: session.isParty,
                isReadOnly: session.isParty && session.endedAt != null,
              ),
            )
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

  Stream<DrinkWithSessionId> drinkWithSessionIdStream({
    required String sessionId,
    required String drinkId,
  }) {
    return sessionController.streamById(sessionId).map((session) {
      final drink = session.drinks.singleWhere((drink) => drink.id == drinkId);
      invariant(
        drink.consumedByUserId == authService.authenticatedUser.uid,
        'Users can only edit their own drinks',
      );
      return (
        originalSessionId: session.id,
        drink: drink,
        isParty: session.isParty,
        isReadOnly: session.isParty && session.endedAt != null,
      );
    });
  }

  /// Creates a new drink.
  ///
  /// If exactly one session is active at the drink's consumedAt time,
  /// the drink is added to that session. Otherwise, a new solo session
  /// is created for the drink. When [targetSessionId] is provided, the drink
  /// is added only to that session after validating it can accept the drink.
  Future<void> createDrink(
    DrinkCreate drinkCreate, {
    String? targetSessionId,
  }) async {
    final drinkId = sessionController.generateId();
    final userId = authService.authenticatedUser.uid;

    final drink = Drink(
      id: drinkId,
      consumedByUserId: userId,
      consumedAt: drinkCreate.consumedAt,
      drinkType: drinkCreate.drinkType,
      volumeInMilliliters: drinkCreate.volumeInMilliliters,
      location: drinkCreate.location,
    );

    final alcohol = drink.alcoholMl;

    final Session? targetSession;
    final List<Session> activeSessions;
    if (targetSessionId != null) {
      targetSession = await sessionController.findById(targetSessionId);
      activeSessions = const [];
      invariant(
        targetSession.memberIds.contains(userId),
        'Drinks can only be added to sessions the user belongs to.',
      );
      invariant(
        !targetSession.isSoloSession,
        'Drinks cannot explicitly target a solo session.',
      );
      invariant(
        targetSession.isActiveAt(drinkCreate.consumedAt),
        'The drink time must be within the targeted session.',
      );
      invariant(targetSession.hasFreeSpace, 'The targeted session is full.');
    } else {
      targetSession = null;
      activeSessions = await sessionController.sessionsActiveAt(
        drinkCreate.consumedAt,
      );
    }

    final automaticallySelectedSession = activeSessions.length == 1
        ? activeSessions.single
        : null;
    final selectedSession = targetSession ?? automaticallySelectedSession;
    final canAddToExisting = selectedSession?.hasFreeSpace ?? false;

    if (canAddToExisting && selectedSession!.isParty) {
      await _createPartyDrink(selectedSession.id, drink);
      return;
    }

    final effectiveDate = await _effectiveDate(drinkCreate.consumedAt);
    final after6pm = _calculateIsAfter6pm(
      drinkCreate.consumedAt,
      effectiveDate,
    );
    final beers = _beersEquivalent(
      category: drinkCreate.drinkType.category,
      volumeInMilliliters: drinkCreate.volumeInMilliliters,
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

    if (canAddToExisting) {
      sessionController.addDrinkInBatch(selectedSession!.id, drink, batch);
    } else {
      sessionController.createSoloSessionWithDrinkInBatch(drink, batch);

      if (activeSessions.length == 1) {
        showNotification(
          'Session "${activeSessions.single.name}" is full. Drink was added outside of session.',
        );
      }
    }

    userController.createOrUpdateUserInBatch(user: user, batch: batch);

    await batch.commit();
  }

  Future<void> updateDrink({
    required Drink oldDrink,
    required Drink newDrink,
    required String sessionId,
  }) async {
    invariant(
      oldDrink.consumedByUserId == authService.authenticatedUser.uid,
      'Users can only edit their own drinks',
    );

    final session = await sessionController.findById(sessionId);
    if (session.isParty) {
      await _updatePartyDrink(sessionId, newDrink);
      return;
    }

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
    final oldAlcohol = oldDrink.alcoholMl;
    final newBeers = _beersEquivalent(
      category: newDrink.drinkType.category,
      volumeInMilliliters: newDrink.volumeInMilliliters,
    );
    final newAlcohol = newDrink.alcoholMl;

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

    final batch = sessionController.batch;

    // We need to use the arrayRemove and arrayUnion operations, as there is nothing like arrayUpdate
    _removeDrinkFromSessionInBatch(session, oldDrink, batch);
    if (session.isSoloSession || !session.isActiveAt(newDrink.consumedAt)) {
      sessionController.createSoloSessionWithDrinkInBatch(newDrink, batch);
    } else {
      sessionController.addDrinkInBatch(sessionId, newDrink, batch);
    }

    userController.createOrUpdateUserInBatch(user: user, batch: batch);
    await batch.commit();
  }

  Future<void> deleteDrink(String sessionId, Drink drink) async {
    final session = await sessionController.findById(sessionId);
    if (session.isParty) {
      await _deletePartyDrink(sessionId, drink.id);
      return;
    }

    final effectiveDate = await _effectiveDate(drink.consumedAt);
    final after6pm = _calculateIsAfter6pm(drink.consumedAt, effectiveDate);

    final beers = _beersEquivalent(
      category: drink.drinkType.category,
      volumeInMilliliters: drink.volumeInMilliliters,
    );
    final alcohol = drink.alcoholMl;

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

    final batch = sessionController.batch;

    _removeDrinkFromSessionInBatch(session, drink, batch);
    userController.createOrUpdateUserInBatch(user: user, batch: batch);

    await batch.commit();
  }

  Future<void> addDefaultDrink({String? targetSessionId}) async {
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
      targetSessionId: targetSessionId,
    );
    showSuccessNotification('Default drink added!');
  }

  Future<void> moveDrinkBetweenSessions({
    required Drink drink,
    required String fromSessionId,
    String? toSessionId,
  }) async {
    final fromSession = await sessionController.findById(fromSessionId);
    final toSession = toSessionId == null
        ? null
        : await sessionController.findById(toSessionId);
    if (fromSession.isParty || (toSession?.isParty ?? false)) {
      throw const PartyDrinkException(
        'Party drinks cannot be moved between Sessions.',
      );
    }
    final batch = sessionController.batch;

    _removeDrinkFromSessionInBatch(fromSession, drink, batch);
    if (toSessionId != null) {
      sessionController.addDrinkInBatch(toSessionId, drink, batch);
    } else {
      sessionController.createSoloSessionWithDrinkInBatch(drink, batch);
    }

    await batch.commit();
  }

  double _beersEquivalent({
    required DrinkCategory category,
    required int volumeInMilliliters,
  }) {
    if (category != DrinkCategory.beer) return 0;
    return volumeInMilliliters / beerVolumeMl;
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

  Future<void> _createPartyDrink(String sessionId, Drink drink) async {
    final drinkTypeId = await _drinkTypeId(drink.drinkType);
    final result = await _runPartyCommand(
      () => partyController.createPartyDrink(
        sessionId: sessionId,
        commandId: partyController.generateCommandId(),
        drinkTypeId: drinkTypeId,
        drink: drink,
      ),
    );
    PartyDrinkCommandResult.fromMutation(result);
  }

  Future<void> _updatePartyDrink(String sessionId, Drink drink) async {
    final drinkTypeId = await _drinkTypeId(drink.drinkType);
    final result = await _runPartyCommand(
      () => partyController.updatePartyDrink(
        sessionId: sessionId,
        commandId: partyController.generateCommandId(),
        drinkTypeId: drinkTypeId,
        drink: drink,
      ),
    );
    PartyDrinkCommandResult.fromMutation(result);
  }

  Future<void> _deletePartyDrink(String sessionId, String drinkId) async {
    final result = await _runPartyCommand(
      () => partyController.deletePartyDrink(
        sessionId: sessionId,
        commandId: partyController.generateCommandId(),
        drinkId: drinkId,
      ),
    );
    PartyDrinkCommandResult.fromMutation(result);
  }

  Future<String> _drinkTypeId(DrinkTypeCore drinkType) async {
    final available =
        await drinkTypeController.allAvailableDrinkTypesStream.first;
    for (final candidate in available) {
      if (candidate.name == drinkType.name &&
          candidate.category == drinkType.category &&
          candidate.alcoholPercentage == drinkType.alcoholPercentage) {
        return candidate.id;
      }
    }
    throw const PartyDrinkException(
      'The selected drink type is no longer available.',
    );
  }

  Future<T> _runPartyCommand<T>(Future<T> Function() command) async {
    try {
      return await command();
    } on FirebaseFunctionsException catch (error) {
      throw PartyDrinkException(
        error.message ?? 'The Party drink could not be saved.',
      );
    }
  }

  void _removeDrinkFromSessionInBatch(
    Session session,
    Drink drink,
    WriteBatch batch,
  ) {
    if (session.isSoloSession) {
      invariant(
        session.drinksCount == 1,
        'solo session must contain only single drink',
      );
      sessionController.deleteSingleInBatch(session, batch);
    } else {
      sessionController.removeDrinkInBatch(session.id, drink, batch);
    }
  }
}
