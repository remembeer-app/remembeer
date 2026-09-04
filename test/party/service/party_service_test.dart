import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/party/controller/party_command_client.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';

void main() {
  test('activation delegates to the idempotent callable wrapper', () async {
    final partyController = _FakePartyController(party: _party());
    final service = PartyService(
      authService: _FakeAuthService(),
      sessionController: _FakeSessionController(
        _session(memberIds: {'user-1'}, adminIds: {'user-1'}),
      ),
      partyController: partyController,
    );

    await service.activateParty('session-1');

    expect(partyController.activatedSessionId, 'session-1');
    expect(partyController.activatedCommandId, 'command-1');
  });

  test('class selection delegates with a stable command id', () async {
    final partyController = _FakePartyController(party: _party());
    final service = PartyService(
      authService: _FakeAuthService(),
      sessionController: _FakeSessionController(
        _session(memberIds: {'user-1'}, adminIds: const {}),
      ),
      partyController: partyController,
    );

    await service.selectClass('session-1', DrinkCategory.wine);
    await service.setMemberClass('session-1', 'user-2', DrinkCategory.spirit);

    expect(partyController.selectedClass, DrinkCategory.wine);
    expect(partyController.changedMemberId, 'user-2');
    expect(partyController.changedMemberClass, DrinkCategory.spirit);
    expect(partyController.classCommandIds, everyElement('command-1'));
  });

  test('state identifies an active admin and current member', () async {
    final member = _member('user-1');
    final service = _service(
      session: _session(memberIds: {'user-1'}, adminIds: {'user-1'}),
      party: _party(),
      member: member,
    );

    final state = await service.stateStream('session-1').first;

    expect(state.access, PartyAccess.admin);
    expect(state.lifecycle, PartyLifecycle.active);
    expect(state.currentMember, member);
    expect(state.isMember, isTrue);
    expect(state.isAdmin, isTrue);
  });

  test(
    'state identifies a non-member without reading a member document',
    () async {
      final partyController = _FakePartyController(party: _party());
      final service = PartyService(
        authService: _FakeAuthService(),
        sessionController: _FakeSessionController(
          _session(memberIds: {'user-2'}, adminIds: {'user-2'}),
        ),
        partyController: partyController,
      );

      final state = await service.stateStream('session-1').first;

      expect(state.access, PartyAccess.nonMember);
      expect(state.currentMember, isNull);
      expect(partyController.memberStreamCalls, 0);
    },
  );

  test(
    'ended session is read-only even before party archive arrives',
    () async {
      final service = _service(
        session: _session(
          memberIds: {'user-1'},
          adminIds: const {},
          endedAt: DateTime.utc(2026, 1, 2),
        ),
        party: _party(),
        member: _member('user-1'),
      );

      final state = await service.stateStream('session-1').first;

      expect(state.access, PartyAccess.member);
      expect(state.lifecycle, PartyLifecycle.archived);
      expect(state.isArchived, isTrue);
    },
  );
}

PartyService _service({
  required Session session,
  required Party party,
  PartyMember? member,
}) => PartyService(
  authService: _FakeAuthService(),
  sessionController: _FakeSessionController(session),
  partyController: _FakePartyController(party: party, member: member),
);

Session _session({
  required Set<String> memberIds,
  required Set<String> adminIds,
  DateTime? endedAt,
}) => Session(
  id: 'session-1',
  userId: 'user-2',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  memberIds: memberIds,
  adminIds: adminIds,
  bannedMemberIds: const {},
  name: 'Party',
  startedAt: DateTime.utc(2026),
  endedAt: endedAt,
  isSoloSession: false,
  isParty: true,
);

Party _party() => Party(
  id: 'session-1',
  sessionId: 'session-1',
  status: PartyStatus.active,
  activatedAt: DateTime.utc(2026),
  activatedByUserId: 'user-2',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

PartyMember _member(String userId) => PartyMember(
  id: userId,
  userId: userId,
  joinedAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

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

class _FakeSessionController implements SessionController {
  _FakeSessionController(this.session);

  final Session session;

  @override
  Stream<Session> streamById(String id) => Stream.value(session);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePartyController implements PartyController {
  _FakePartyController({required this.party, this.member});

  final Party party;
  final PartyMember? member;
  var memberStreamCalls = 0;
  String? activatedSessionId;
  String? activatedCommandId;
  DrinkCategory? selectedClass;
  String? changedMemberId;
  DrinkCategory? changedMemberClass;
  final classCommandIds = <String>[];

  @override
  String generateCommandId() => 'command-1';

  @override
  Future<PartyCommandResult> activateParty({
    required String sessionId,
    required String commandId,
  }) async {
    activatedSessionId = sessionId;
    activatedCommandId = commandId;
    return const PartyCommandResult({});
  }

  @override
  Future<PartyCommandResult> selectPartyClass({
    required String sessionId,
    required String commandId,
    required DrinkCategory selectedClass,
  }) async {
    this.selectedClass = selectedClass;
    classCommandIds.add(commandId);
    return const PartyCommandResult({});
  }

  @override
  Future<PartyCommandResult> setPartyMemberClass({
    required String sessionId,
    required String commandId,
    required String memberId,
    required DrinkCategory selectedClass,
  }) async {
    changedMemberId = memberId;
    changedMemberClass = selectedClass;
    classCommandIds.add(commandId);
    return const PartyCommandResult({});
  }

  @override
  Stream<Party> partyStream(String sessionId) => Stream.value(party);

  @override
  Stream<PartyMember?> memberStream(String sessionId, String userId) {
    memberStreamCalls += 1;
    return Stream.value(member);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
