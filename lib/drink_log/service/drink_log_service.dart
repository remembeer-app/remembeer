import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/badge/service/badge_service.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/date/util/date_utils.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink_category.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';
import 'package:remembeer/drink_log/constants.dart';
import 'package:remembeer/drink_log/model/drink_log.dart';
import 'package:remembeer/drink_log/model/drink_log_create.dart';
import 'package:remembeer/drink_log/model/party_drink_log_command_result.dart';
import 'package:remembeer/drink_log/type/drink_log_with_session_id.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:remembeer/party/controller/party_command_client.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/service/user_stats_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:rxdart/rxdart.dart';

class DrinkLogService {
  final AuthService authService;
  final UserSettingsController userSettingsController;
  final UserController userController;
  final SessionController sessionController;
  final DateService dateService;
  final LocationService locationService;
  final UserStatsService userStatsService;
  final BadgeService badgeService;
  final DrinkController drinkController;
  final PartyController partyController;

  DrinkLogService({
    required this.authService,
    required this.userSettingsController,
    required this.userController,
    required this.sessionController,
    required this.dateService,
    required this.locationService,
    required this.userStatsService,
    required this.badgeService,
    required this.drinkController,
    required this.partyController,
  });

  Stream<List<DrinkLogWithSessionId>> _drinkLogsToShowFromSession(
    Session session,
  ) {
    return Rx.combineLatest2(
      dateService.selectedDateStateStream,
      userController.currentUserStream,
      (_, user) {
        final (startTime, endTime) = dateService.selectedDateBoundaries(
          user.endOfDayBoundary,
        );

        return session.drinkLogs
            .where(
              (drinkLog) =>
                  drinkLog.consumedByUserId ==
                  authService.authenticatedUser.uid,
            )
            .where((drinkLog) => drinkLog.consumedAt.isAfter(startTime))
            .where((drinkLog) => !drinkLog.consumedAt.isAfter(endTime))
            .map(
              (drinkLog) => (
                originalSessionId: session.id,
                drinkLog: drinkLog,
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
  Stream<List<DrinkLogWithSessionId>> drinkLogsWithSessionIdToShowFromSessions(
    List<Session> sessions,
  ) {
    if (sessions.isEmpty) {
      return Stream.value([]);
    }
    return Rx.combineLatest(
      sessions.map(_drinkLogsToShowFromSession),
      (drinkLogsInSessions) =>
          drinkLogsInSessions.expand((items) => items).toList(),
    );
  }

  /// Returns current users' drinks consumed on currently selected day
  /// with respect to custom end of day boundary
  Stream<List<DrinkLog>> drinkLogsToShowFromSessions(Session session) {
    return _drinkLogsToShowFromSession(
      session,
    ).map((items) => items.map((item) => item.drinkLog).toList());
  }

  Stream<DrinkLogWithSessionId> drinkLogWithSessionIdStream({
    required String sessionId,
    required String drinkLogId,
  }) {
    return sessionController.streamById(sessionId).switchMap((session) {
      final drinkLog = session.drinkLogs.singleWhere(
        (candidate) => candidate.id == drinkLogId,
      );
      invariant(
        drinkLog.consumedByUserId == authService.authenticatedUser.uid,
        'Users can only edit their own drinks',
      );
      DrinkLogWithSessionId result({required bool isReadOnly}) => (
        originalSessionId: session.id,
        drinkLog: drinkLog,
        isParty: session.isParty,
        isReadOnly: isReadOnly,
      );
      if (!session.isParty) {
        return Stream.value(result(isReadOnly: false));
      }
      return partyController
          .partyStream(sessionId)
          .map(
            (party) => result(
              isReadOnly:
                  session.endedAt != null ||
                  party.status == PartyStatus.archived,
            ),
          );
    });
  }

  /// Creates a new drink.
  ///
  /// If exactly one session is active at the drink's consumedAt time,
  /// the drink is added to that session. Otherwise, a new solo session
  /// is created for the drink. When [targetSessionId] is provided, the drink
  /// is added only to that session after validating it can accept the drink.
  Future<void> createDrinkLog(
    DrinkLogCreate drinkLogCreate, {
    String? targetSessionId,
  }) async {
    final drinkLogId = sessionController.generateId();
    final userId = authService.authenticatedUser.uid;

    final drinkLog = DrinkLog(
      id: drinkLogId,
      consumedByUserId: userId,
      consumedAt: drinkLogCreate.consumedAt,
      drink: drinkLogCreate.drink,
      volumeInMilliliters: drinkLogCreate.volumeInMilliliters,
      location: drinkLogCreate.location,
    );

    final alcohol = drinkLog.alcoholMl;

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
        targetSession.isActiveAt(drinkLogCreate.consumedAt),
        'The drink time must be within the targeted session.',
      );
      invariant(targetSession.hasFreeSpace, 'The targeted session is full.');
    } else {
      targetSession = null;
      activeSessions = await sessionController.sessionsActiveAt(
        drinkLogCreate.consumedAt,
      );
    }

    final automaticallySelectedSession = activeSessions.length == 1
        ? activeSessions.single
        : null;
    final selectedSession = targetSession ?? automaticallySelectedSession;
    final canAddToExisting = selectedSession?.hasFreeSpace ?? false;

    if (canAddToExisting && selectedSession!.isParty) {
      await _createPartyDrinkLog(selectedSession.id, drinkLog);
      return;
    }

    final effectiveDate = await _effectiveDate(drinkLogCreate.consumedAt);
    final after6pm = _calculateIsAfter6pm(
      drinkLogCreate.consumedAt,
      effectiveDate,
    );
    final beers = _beersEquivalent(
      category: drinkLogCreate.drink.category,
      volumeInMilliliters: drinkLogCreate.volumeInMilliliters,
    );
    var user = await userController.currentUser;
    user = user.addDrinkLog(
      year: effectiveDate.year,
      month: effectiveDate.month,
      day: effectiveDate.day,
      beersEquivalent: beers,
      alcoholMl: alcohol,
      after6pm: after6pm,
    );
    final stats = userStatsService.fromUser(user);
    user = badgeService.evaluateBadges(
      user,
      stats,
      effectiveDate,
      drink: drinkLogCreate.drink,
    );
    final batch = sessionController.batch;

    if (canAddToExisting) {
      sessionController.addDrinkLogInBatch(
        selectedSession!.id,
        drinkLog,
        batch,
      );
    } else {
      sessionController.createSoloSessionWithDrinkLogInBatch(drinkLog, batch);

      if (activeSessions.length == 1) {
        showNotification(
          'Session "${activeSessions.single.name}" is full. Drink was added outside of session.',
        );
      }
    }

    userController.createOrUpdateUserInBatch(user: user, batch: batch);

    await batch.commit();
  }

  Future<void> updateDrinkLog({
    required DrinkLog oldDrinkLog,
    required DrinkLog newDrinkLog,
    required String sessionId,
  }) async {
    invariant(
      oldDrinkLog.consumedByUserId == authService.authenticatedUser.uid,
      'Users can only edit their own drinks',
    );

    final session = await sessionController.findById(sessionId);
    if (session.isParty) {
      await _updatePartyDrinkLog(sessionId, oldDrinkLog, newDrinkLog);
      return;
    }

    final oldEffectiveDate = await _effectiveDate(oldDrinkLog.consumedAt);
    final oldAfter6pm = _calculateIsAfter6pm(
      oldDrinkLog.consumedAt,
      oldEffectiveDate,
    );

    final newEffectiveDate = await _effectiveDate(newDrinkLog.consumedAt);
    final newAfter6pm = _calculateIsAfter6pm(
      newDrinkLog.consumedAt,
      newEffectiveDate,
    );

    final oldBeers = _beersEquivalent(
      category: oldDrinkLog.drink.category,
      volumeInMilliliters: oldDrinkLog.volumeInMilliliters,
    );
    final oldAlcohol = oldDrinkLog.alcoholMl;
    final newBeers = _beersEquivalent(
      category: newDrinkLog.drink.category,
      volumeInMilliliters: newDrinkLog.volumeInMilliliters,
    );
    final newAlcohol = newDrinkLog.alcoholMl;

    var user = await userController.currentUser;

    user = user.removeDrinkLog(
      year: oldEffectiveDate.year,
      month: oldEffectiveDate.month,
      day: oldEffectiveDate.day,
      beersEquivalent: oldBeers,
      alcoholMl: oldAlcohol,
      after6pm: oldAfter6pm,
    );

    user = user.addDrinkLog(
      year: newEffectiveDate.year,
      month: newEffectiveDate.month,
      day: newEffectiveDate.day,
      beersEquivalent: newBeers,
      alcoholMl: newAlcohol,
      after6pm: newAfter6pm,
    );

    final stats = userStatsService.fromUser(user);
    user = badgeService.evaluateBadges(
      user,
      stats,
      newEffectiveDate,
      drink: newDrinkLog.drink,
    );

    final batch = sessionController.batch;

    // We need to use the arrayRemove and arrayUnion operations, as there is nothing like arrayUpdate
    _removeDrinkLogFromSessionInBatch(session, oldDrinkLog, batch);
    if (session.isSoloSession || !session.isActiveAt(newDrinkLog.consumedAt)) {
      sessionController.createSoloSessionWithDrinkLogInBatch(
        newDrinkLog,
        batch,
      );
    } else {
      sessionController.addDrinkLogInBatch(sessionId, newDrinkLog, batch);
    }

    userController.createOrUpdateUserInBatch(user: user, batch: batch);
    await batch.commit();
  }

  Future<void> deleteDrinkLog(String sessionId, DrinkLog drinkLog) async {
    final session = await sessionController.findById(sessionId);
    if (session.isParty) {
      await _deletePartyDrinkLog(sessionId, drinkLog.id);
      return;
    }

    final effectiveDate = await _effectiveDate(drinkLog.consumedAt);
    final after6pm = _calculateIsAfter6pm(drinkLog.consumedAt, effectiveDate);

    final beers = _beersEquivalent(
      category: drinkLog.drink.category,
      volumeInMilliliters: drinkLog.volumeInMilliliters,
    );
    final alcohol = drinkLog.alcoholMl;

    var user = await userController.currentUser;
    user = user.removeDrinkLog(
      year: effectiveDate.year,
      month: effectiveDate.month,
      day: effectiveDate.day,
      beersEquivalent: beers,
      alcoholMl: alcohol,
      after6pm: after6pm,
    );

    final stats = userStatsService.fromUser(user);
    user = badgeService.evaluateBadges(user, stats, effectiveDate, drink: null);

    final batch = sessionController.batch;

    _removeDrinkLogFromSessionInBatch(session, drinkLog, batch);
    userController.createOrUpdateUserInBatch(user: user, batch: batch);

    await batch.commit();
  }

  Future<void> addDefaultDrinkLog({String? targetSessionId}) async {
    final userSettings = await userSettingsController.currentUserSettings;
    final position = await locationService.getLastPositionIfAllowed();
    final location = position != null
        ? GeoPoint(position.latitude, position.longitude)
        : null;

    await createDrinkLog(
      DrinkLogCreate(
        consumedAt: DateTime.now(),
        drink: userSettings.defaultDrink,
        volumeInMilliliters: userSettings.defaultDrinkSize,
        location: location,
      ),
      targetSessionId: targetSessionId,
    );
    showSuccessNotification('Default drink added!');
  }

  Future<void> moveDrinkLogBetweenSessions({
    required DrinkLog drinkLog,
    required String fromSessionId,
    String? toSessionId,
  }) async {
    final fromSession = await sessionController.findById(fromSessionId);
    final toSession = toSessionId == null
        ? null
        : await sessionController.findById(toSessionId);
    if (fromSession.isParty || (toSession?.isParty ?? false)) {
      throw const PartyDrinkLogException(
        'Party drinks cannot be moved between Sessions.',
      );
    }
    final batch = sessionController.batch;

    _removeDrinkLogFromSessionInBatch(fromSession, drinkLog, batch);
    if (toSessionId != null) {
      sessionController.addDrinkLogInBatch(toSessionId, drinkLog, batch);
    } else {
      sessionController.createSoloSessionWithDrinkLogInBatch(drinkLog, batch);
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

  Future<void> _createPartyDrinkLog(String sessionId, DrinkLog drinkLog) async {
    final catalogDrinkId =
        drinkLog.catalogDrinkId ?? await _catalogDrinkId(drinkLog.drink);
    final result = await _runPartyCommand(
      () => partyController.createPartyDrinkLog(
        sessionId: sessionId,
        commandId: partyController.generateCommandId(),
        catalogDrinkId: catalogDrinkId,
        drinkLog: drinkLog,
      ),
    );
    _announcePartyBadges(result);
  }

  Future<void> _updatePartyDrinkLog(
    String sessionId,
    DrinkLog oldDrinkLog,
    DrinkLog newDrinkLog,
  ) async {
    final catalogDrinkId = oldDrinkLog.drink == newDrinkLog.drink
        ? oldDrinkLog.catalogDrinkId ?? await _catalogDrinkId(newDrinkLog.drink)
        : await _catalogDrinkId(newDrinkLog.drink);
    final result = await _runPartyCommand(
      () => partyController.updatePartyDrinkLog(
        sessionId: sessionId,
        commandId: partyController.generateCommandId(),
        catalogDrinkId: catalogDrinkId,
        drinkLog: newDrinkLog,
      ),
    );
    _announcePartyBadges(result);
  }

  Future<void> _deletePartyDrinkLog(String sessionId, String drinkLogId) async {
    final result = await _runPartyCommand(
      () => partyController.deletePartyDrinkLog(
        sessionId: sessionId,
        commandId: partyController.generateCommandId(),
        drinkLogId: drinkLogId,
      ),
    );
    _announcePartyBadges(result);
  }

  void _announcePartyBadges(PartyCommandResult result) {
    final drinkLogResult = PartyDrinkLogCommandResult.fromMutation(result);
    badgeService.notifyUnlockedBadges(drinkLogResult.unlockedBadgeIds);
  }

  Future<String> _catalogDrinkId(DrinkSnapshot drink) async {
    final available = await drinkController.allAvailableDrinksStream.first;
    for (final candidate in available) {
      if (candidate.name == drink.name &&
          candidate.category == drink.category &&
          candidate.alcoholPercentage == drink.alcoholPercentage) {
        return candidate.id;
      }
    }
    throw const PartyDrinkLogException(
      'The selected drink is no longer available.',
    );
  }

  Future<T> _runPartyCommand<T>(Future<T> Function() command) async {
    try {
      return await command();
    } on FirebaseFunctionsException catch (error) {
      throw PartyDrinkLogException(
        error.message ?? 'The Party drink could not be saved.',
      );
    }
  }

  void _removeDrinkLogFromSessionInBatch(
    Session session,
    DrinkLog drinkLog,
    WriteBatch batch,
  ) {
    if (session.isSoloSession) {
      invariant(
        session.drinkLogsCount == 1,
        'solo session must contain only single drink',
      );
      sessionController.deleteSingleInBatch(session, batch);
    } else {
      sessionController.removeDrinkLogInBatch(session.id, drinkLog, batch);
    }
  }
}
