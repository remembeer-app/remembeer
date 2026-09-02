import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/notification/service/notification_service.dart';
import 'package:remembeer/party/controller/party_command_client.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';

void main() {
  test('session admin activation uses the Party callable', () async {
    final partyController = _FakePartyController();
    final service = _service(partyController);

    await service.turnSessionIntoParty(_session());

    expect(partyController.activatedSessionId, 'session-1');
    expect(partyController.lastCommandId, 'command-1');
  });

  test(
    'ending an active Party delegates the whole transition to archive',
    () async {
      final partyController = _FakePartyController();
      final service = _service(partyController);
      final endedAt = DateTime.utc(2026, 1, 2);

      await service.updateSession(
        session: _session(isParty: true),
        endedAt: endedAt,
      );

      expect(partyController.archivedSessionId, 'session-1');
      expect(partyController.archivedAt, endedAt);
      expect(partyController.lastCommandId, 'command-1');
    },
  );
}

SessionService _service(PartyController partyController) => SessionService(
  authService: _FakeAuthService(),
  sessionController: _FakeSessionController(),
  dateService: _FakeDateService(),
  userSettingsController: _FakeUserSettingsController(),
  userService: _FakeUserService(),
  notificationService: _FakeNotificationService(),
  partyController: partyController,
);

Session _session({bool isParty = false}) => Session(
  id: 'session-1',
  userId: 'owner',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  memberIds: const {'owner', 'admin'},
  adminIds: const {'owner', 'admin'},
  bannedMemberIds: const {},
  name: 'Party',
  startedAt: DateTime.utc(2026),
  isSoloSession: false,
  isParty: isParty,
);

class _FakeAuthService implements AuthService {
  @override
  User get authenticatedUser => _FakeFirebaseUser();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirebaseUser implements User {
  @override
  String get uid => 'admin';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePartyController implements PartyController {
  String? activatedSessionId;
  String? archivedSessionId;
  DateTime? archivedAt;
  String? lastCommandId;

  @override
  String generateCommandId() => 'command-1';

  @override
  Future<PartyCommandResult> activateParty({
    required String sessionId,
    required String commandId,
  }) async {
    activatedSessionId = sessionId;
    lastCommandId = commandId;
    return const PartyCommandResult({});
  }

  @override
  Future<PartyCommandResult> archiveParty({
    required String sessionId,
    required String commandId,
    required DateTime endedAt,
  }) async {
    archivedSessionId = sessionId;
    archivedAt = endedAt;
    lastCommandId = commandId;
    return const PartyCommandResult({});
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSessionController implements SessionController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDateService implements DateService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUserSettingsController implements UserSettingsController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUserService implements UserService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeNotificationService implements NotificationService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
