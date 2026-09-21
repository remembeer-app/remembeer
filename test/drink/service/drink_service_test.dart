import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/badge/service/badge_service.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:remembeer/party/controller/party_command_client.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/service/user_stats_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';

void main() {
  final consumedAt = DateTime.utc(2026, 9, 2, 18);
  const drinkType = DrinkTypeCore(
    name: 'Lager',
    category: DrinkCategory.beer,
    alcoholPercentage: 4.5,
  );

  test(
    'explicit Party create delegates before client-side user updates',
    () async {
      final partyController = _FakePartyController();
      final service = _service(
        sessionController: _FakeSessionController(_partySession(consumedAt)),
        partyController: partyController,
      );

      await service.createDrink(
        DrinkCreate(
          consumedAt: consumedAt,
          drinkType: drinkType,
          volumeInMilliliters: 500,
        ),
        targetSessionId: 'party-1',
      );

      expect(partyController.createdDrink?.id, 'drink-1');
      expect(partyController.createdDrinkTypeId, 'type-1');
      expect(partyController.createdCommandId, 'command-1');
    },
  );

  test('Party create announces badges unlocked by the server', () async {
    final partyController = _FakePartyController(
      unlockedBadgeIds: const ['masti_to_jak_drak'],
    );
    final badgeService = _RecordingBadgeService();
    final service = _service(
      sessionController: _FakeSessionController(_partySession(consumedAt)),
      partyController: partyController,
      badgeService: badgeService,
    );

    await service.createDrink(
      DrinkCreate(
        consumedAt: consumedAt,
        drinkType: drinkType,
        volumeInMilliliters: 500,
      ),
      targetSessionId: 'party-1',
    );

    expect(badgeService.announced, [
      ['masti_to_jak_drak'],
    ]);
  });

  test('automatically selected Party also uses the callable path', () async {
    final partyController = _FakePartyController();
    final service = _service(
      sessionController: _FakeSessionController(_partySession(consumedAt)),
      partyController: partyController,
    );

    await service.createDrink(
      DrinkCreate(
        consumedAt: consumedAt,
        drinkType: drinkType,
        volumeInMilliliters: 500,
      ),
    );

    expect(partyController.createdDrink, isNotNull);
  });

  test('Party update and delete delegate to their callable wrappers', () async {
    final partyController = _FakePartyController();
    final service = _service(
      sessionController: _FakeSessionController(_partySession(consumedAt)),
      partyController: partyController,
    );
    final oldDrink = Drink(
      id: 'drink-1',
      consumedByUserId: 'user-1',
      consumedAt: consumedAt,
      drinkType: drinkType,
      volumeInMilliliters: 500,
    );
    final updatedDrink = oldDrink.copyWith(volumeInMilliliters: 300);

    await service.updateDrink(
      oldDrink: oldDrink,
      newDrink: updatedDrink,
      sessionId: 'party-1',
    );
    await service.deleteDrink('party-1', updatedDrink);

    expect(partyController.updatedDrink, updatedDrink);
    expect(partyController.deletedDrinkId, 'drink-1');
  });

  test('Party update reuses a persisted drink type ID', () async {
    final partyController = _FakePartyController();
    final service = _service(
      sessionController: _FakeSessionController(_partySession(consumedAt)),
      partyController: partyController,
      drinkTypeController: _FakeDrinkTypeController(shouldFail: true),
    );
    final oldDrink = Drink(
      id: 'drink-1',
      consumedByUserId: 'user-1',
      consumedAt: consumedAt,
      drinkType: drinkType,
      drinkTypeId: 'persisted-type',
      volumeInMilliliters: 500,
    );

    await service.updateDrink(
      oldDrink: oldDrink,
      newDrink: oldDrink.copyWith(volumeInMilliliters: 300),
      sessionId: 'party-1',
    );

    expect(partyController.updatedDrinkTypeId, 'persisted-type');
  });
}

DrinkService _service({
  required _FakeSessionController sessionController,
  required _FakePartyController partyController,
  DrinkTypeController? drinkTypeController,
  BadgeService? badgeService,
}) => DrinkService(
  authService: _FakeAuthService(),
  userSettingsController: _UnusedUserSettingsController(),
  userController: _UnusedUserController(),
  sessionController: sessionController,
  dateService: _UnusedDateService(),
  locationService: _UnusedLocationService(),
  userStatsService: UserStatsService(),
  badgeService: badgeService ?? BadgeService(),
  drinkTypeController: drinkTypeController ?? _FakeDrinkTypeController(),
  partyController: partyController,
);

Session _partySession(DateTime consumedAt) => Session(
  id: 'party-1',
  userId: 'user-1',
  createdAt: consumedAt.subtract(const Duration(hours: 2)),
  updatedAt: consumedAt,
  memberIds: const {'user-1'},
  adminIds: const {'user-1'},
  bannedMemberIds: const {},
  name: 'Party',
  startedAt: consumedAt.subtract(const Duration(hours: 1)),
  isSoloSession: false,
  isParty: true,
);

class _FakeSessionController implements SessionController {
  _FakeSessionController(this.session);

  final Session session;

  @override
  String generateId() => 'drink-1';

  @override
  Future<Session> findById(String id) async => session;

  @override
  Future<List<Session>> sessionsActiveAt(DateTime at) async => [session];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Captures announced badge ids instead of showing toasts, which need a
/// widget tree.
class _RecordingBadgeService extends BadgeService {
  final announced = <List<String>>[];

  @override
  void notifyUnlockedBadges(Iterable<String> badgeIds) {
    announced.add(badgeIds.toList());
  }
}

class _FakePartyController implements PartyController {
  _FakePartyController({this.unlockedBadgeIds = const []});

  final List<String> unlockedBadgeIds;
  Drink? createdDrink;
  String? createdDrinkTypeId;
  String? createdCommandId;
  Drink? updatedDrink;
  String? updatedDrinkTypeId;
  String? deletedDrinkId;

  @override
  String generateCommandId() => 'command-1';

  @override
  Future<PartyCommandResult> createPartyDrink({
    required String sessionId,
    required String commandId,
    required String drinkTypeId,
    required Drink drink,
  }) async {
    createdDrink = drink;
    createdDrinkTypeId = drinkTypeId;
    createdCommandId = commandId;
    return _result(drink.id);
  }

  @override
  Future<PartyCommandResult> updatePartyDrink({
    required String sessionId,
    required String commandId,
    required String drinkTypeId,
    required Drink drink,
  }) async {
    updatedDrink = drink;
    updatedDrinkTypeId = drinkTypeId;
    return _result(drink.id);
  }

  @override
  Future<PartyCommandResult> deletePartyDrink({
    required String sessionId,
    required String commandId,
    required String drinkId,
  }) async {
    deletedDrinkId = drinkId;
    return PartyCommandResult({
      'sessionId': sessionId,
      'drinkId': drinkId,
      'reversalEventId': 'reversal-1',
      'unlockedBadgeIds': <String>[],
    });
  }

  PartyCommandResult _result(String drinkId) => PartyCommandResult({
    'sessionId': 'party-1',
    'drink': {'id': drinkId},
    'awardEventId': 'award-1',
    'baseScoreUnits': 22500,
    'classBonusUnits': 2250,
    'awardedScoreUnits': 24750,
    'unlockedBadgeIds': unlockedBadgeIds,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDrinkTypeController implements DrinkTypeController {
  _FakeDrinkTypeController({this.shouldFail = false});

  final bool shouldFail;

  @override
  Stream<List<DrinkType>> get allAvailableDrinkTypesStream => shouldFail
      ? Stream.error(StateError('Drink types should not be loaded.'))
      : Stream.value([
          DrinkType(
            id: 'type-1',
            userId: 'global',
            createdAt: DateTime.utc(2026),
            updatedAt: DateTime.utc(2026),
            name: 'Lager',
            category: DrinkCategory.beer,
            alcoholPercentage: 4.5,
          ),
        ]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthService implements AuthService {
  @override
  User get authenticatedUser => _FakeFirebaseUser();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirebaseUser implements User {
  @override
  String get uid => 'user-1';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedUserSettingsController implements UserSettingsController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedUserController implements UserController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedDateService implements DateService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedLocationService implements LocationService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
