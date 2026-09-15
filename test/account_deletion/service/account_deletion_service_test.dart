import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/account_deletion/service/account_deletion_service.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/avatar/service/avatar_service.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';
import 'package:remembeer/friend_request/controller/friend_request_controller.dart';
import 'package:remembeer/friend_request/model/friend_request.dart';
import 'package:remembeer/leaderboard/controller/leaderboard_controller.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/party/controller/party_command_client.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_picture_service.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';

const _me = 'me';

void main() {
  late List<String> log;
  late _FakeDrinkTypeController drinkTypes;
  late _FakeSessionController sessions;
  late _FakeLeaderboardController leaderboards;
  late _FakeFriendRequestController friendRequests;
  late _FakeUserController users;
  late _FakeUserSettingsController userSettings;
  late _FakeAvatarService avatar;
  late _FakeSessionPictureService pictures;
  late _FakePartyController party;
  late _FakeAuthService auth;

  setUp(() {
    log = [];
    drinkTypes = _FakeDrinkTypeController(log);
    sessions = _FakeSessionController(log);
    leaderboards = _FakeLeaderboardController(log);
    friendRequests = _FakeFriendRequestController(log);
    users = _FakeUserController(log);
    userSettings = _FakeUserSettingsController(log);
    avatar = _FakeAvatarService(log);
    pictures = _FakeSessionPictureService(log);
    party = _FakePartyController(log);
    auth = _FakeAuthService(log);
  });

  AccountDeletionService service() => AccountDeletionService(
    authService: auth,
    drinkTypeController: drinkTypes,
    sessionController: sessions,
    leaderboardController: leaderboards,
    friendRequestController: friendRequests,
    userController: users,
    userSettingsController: userSettings,
    avatarService: avatar,
    sessionPictureService: pictures,
    partyController: party,
  );

  test('runs every step in order and deletes the auth user last', () async {
    drinkTypes.owned = [_drinkType('dt-1')];
    friendRequests.involving = [_friendRequest('fr-1')];
    users.withFriend = [_user('friend-1')];

    await service().deleteAccount();

    expect(log, [
      'drinkType.hardDelete dt-1',
      'session.allWithMember me',
      'leaderboard.allWithMember me',
      'friendRequest.hardDelete fr-1',
      'user.removeFriendFrom friend-1',
      'avatar.deleteFile',
      'user.anonymize',
      'userSettings.delete',
      'auth.delete',
    ]);
  });

  test('does not delete the auth user when an earlier step throws', () async {
    friendRequests
      ..involving = [_friendRequest('fr-1')]
      ..throwOnDelete = true;

    await expectLater(service().deleteAccount(), throwsA(isA<StateError>()));

    expect(log, isNot(contains('auth.delete')));
    expect(log, isNot(contains('user.anonymize')));
  });

  group('sessions', () {
    test('leaves a Party the user does not own via the callable', () async {
      sessions.withMember = [
        _session(
          'p-1',
          userId: 'owner',
          isParty: true,
          memberIds: {'owner', _me},
        ),
      ];

      await service().deleteAccount();

      expect(log, contains('party.leave p-1 me'));
      expect(log, isNot(contains('session.hardDelete p-1')));
    });

    test('continues when leaving a Party fails', () async {
      sessions.withMember = [
        _session(
          'p-1',
          userId: 'owner',
          isParty: true,
          memberIds: {'owner', _me},
        ),
      ];
      party.throwOnLeave = true;

      await service().deleteAccount();

      expect(log, contains('auth.delete'));
    });

    test('skips a Party the user owns', () async {
      sessions.withMember = [
        _session('p-1', userId: _me, isParty: true, memberIds: {_me, 'other'}),
      ];

      await service().deleteAccount();

      expect(log.where((entry) => entry.contains('p-1')), isEmpty);
    });

    test('hard-deletes a solo session together with its pictures', () async {
      sessions.withMember = [
        _session(
          's-1',
          userId: _me,
          memberIds: {_me},
          adminIds: {_me},
          pictureUrls: ['https://x/a.jpg', 'https://x/b.jpg'],
        ),
      ];

      await service().deleteAccount();

      expect(
        log,
        containsAllInOrder([
          'picture.deleteFile https://x/a.jpg',
          'picture.deleteFile https://x/b.jpg',
          'session.hardDelete s-1',
        ]),
      );
    });

    test(
      'hard-deletes an owned shared session that is already soft-deleted',
      () async {
        sessions.withMember = [
          _session(
            's-1',
            userId: _me,
            memberIds: {_me, 'other'},
            deletedAt: DateTime.utc(2026, 2),
          ),
        ];

        await service().deleteAccount();

        expect(log, contains('session.hardDelete s-1'));
      },
    );

    test(
      'hands an owned shared session to the first remaining admin',
      () async {
        sessions.withMember = [
          _session(
            's-1',
            userId: _me,
            memberIds: {_me, 'member', 'admin'},
            adminIds: {_me, 'admin'},
          ),
        ];

        await service().deleteAccount();

        expect(log, contains('session.strip s-1 me -> admin'));
      },
    );

    test(
      'hands an owned shared session to the first member when no admin remains',
      () async {
        sessions.withMember = [
          _session(
            's-1',
            userId: _me,
            memberIds: {_me, 'member-a', 'member-b'},
            adminIds: {_me},
          ),
        ];

        await service().deleteAccount();

        expect(log, contains('session.strip s-1 me -> member-a'));
      },
    );

    test('strips the user from a shared session they do not own', () async {
      sessions.withMember = [
        _session(
          's-1',
          userId: 'owner',
          memberIds: {'owner', _me},
          adminIds: {'owner', _me},
        ),
      ];

      await service().deleteAccount();

      expect(log, contains('session.strip s-1 me -> null'));
    });

    test(
      'skips a session whose write is rejected and continues with the rest',
      () async {
        sessions
          ..withMember = [
            _session(
              's-1',
              userId: 'owner',
              memberIds: {'owner', _me},
              adminIds: {'owner'},
            ),
            _session(
              's-2',
              userId: 'owner',
              memberIds: {'owner', _me},
              adminIds: {'owner'},
            ),
          ]
          ..rejectStripFor = {'s-1'};

        await service().deleteAccount();

        expect(log, contains('session.strip s-2 me -> null'));
        expect(log, contains('auth.delete'));
        expect(log, isNot(contains('session.strip s-1 me -> null')));
      },
    );

    test('never hands a session to a banned member', () async {
      sessions.withMember = [
        _session(
          's-1',
          userId: _me,
          memberIds: {_me, 'banned', 'clean'},
          adminIds: {_me, 'banned'},
          bannedMemberIds: {'banned'},
        ),
      ];

      await service().deleteAccount();

      expect(log, contains('session.strip s-1 me -> clean'));
    });
  });

  group('drink types', () {
    test(
      'skips a drink type whose delete is rejected and still deletes the auth user',
      () async {
        drinkTypes
          ..owned = [_drinkType('dt-1'), _drinkType('dt-2')]
          ..rejectDeleteFor = {'dt-1'};

        await service().deleteAccount();

        expect(log, contains('drinkType.hardDelete dt-2'));
        expect(log, contains('auth.delete'));
        expect(log, isNot(contains('drinkType.hardDelete dt-1')));
      },
    );
  });

  group('leaderboards', () {
    test('hard-deletes an owned leaderboard with no other member', () async {
      leaderboards.withMember = [
        _leaderboard('lb-1', userId: _me, memberIds: {_me}),
      ];

      await service().deleteAccount();

      expect(log, contains('leaderboard.hardDelete lb-1'));
    });

    test('hard-deletes an owned leaderboard that is soft-deleted', () async {
      leaderboards.withMember = [
        _leaderboard(
          'lb-1',
          userId: _me,
          memberIds: {_me, 'other'},
          deletedAt: DateTime.utc(2026, 2),
        ),
      ];

      await service().deleteAccount();

      expect(log, contains('leaderboard.hardDelete lb-1'));
    });

    test('hands an owned leaderboard to the first other member', () async {
      leaderboards.withMember = [
        _leaderboard('lb-1', userId: _me, memberIds: {_me, 'other', 'third'}),
      ];

      await service().deleteAccount();

      expect(log, contains('leaderboard.handOver lb-1 me -> other'));
    });

    test('removes the user from a leaderboard they do not own', () async {
      leaderboards.withMember = [
        _leaderboard('lb-1', userId: 'owner', memberIds: {'owner', _me}),
      ];

      await service().deleteAccount();

      expect(log, contains('leaderboard.removeMember lb-1 me'));
    });
  });
}

// ---------------------------------------------------------------------------
// Fixtures

DrinkType _drinkType(String id) => DrinkType(
  id: id,
  userId: _me,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  name: 'IPA',
  category: DrinkCategory.beer,
  alcoholPercentage: 6,
);

FriendRequest _friendRequest(String id) => FriendRequest(
  id: id,
  userId: _me,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  toUserId: 'other',
  senderUsername: 'Me',
);

UserModel _user(String id) => UserModel(
  id: id,
  email: '$id@example.com',
  username: id,
  searchableUsername: id,
  friends: const {_me},
);

Session _session(
  String id, {
  required String userId,
  required Set<String> memberIds,
  Set<String> adminIds = const {},
  Set<String> bannedMemberIds = const {},
  bool isParty = false,
  DateTime? deletedAt,
  List<String> pictureUrls = const [],
}) => Session(
  id: id,
  userId: userId,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  deletedAt: deletedAt,
  memberIds: memberIds,
  adminIds: adminIds,
  bannedMemberIds: bannedMemberIds,
  name: 'Session',
  startedAt: DateTime.utc(2026),
  isSoloSession: memberIds.length == 1,
  isParty: isParty,
  pictureUrls: pictureUrls,
  drinks: [
    Drink(
      id: 'd-$id',
      consumedByUserId: _me,
      consumedAt: DateTime.utc(2026),
      drinkType: const DrinkTypeCore(
        name: 'Beer',
        category: DrinkCategory.beer,
        alcoholPercentage: 4.5,
      ),
      volumeInMilliliters: 500,
    ),
  ],
);

Leaderboard _leaderboard(
  String id, {
  required String userId,
  required Set<String> memberIds,
  DateTime? deletedAt,
}) => Leaderboard(
  id: id,
  userId: userId,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  deletedAt: deletedAt,
  memberIds: memberIds,
  bannedMemberIds: const {},
  name: 'Board',
  iconName: 'beer',
  inviteCode: 'ABC123',
);

// ---------------------------------------------------------------------------
// Fakes

class _FakeAuthService implements AuthService {
  _FakeAuthService(this.log);
  final List<String> log;

  @override
  User get authenticatedUser => _FakeFirebaseUser();

  @override
  Future<void> deleteAuthUser() async => log.add('auth.delete');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFirebaseUser implements User {
  @override
  String get uid => _me;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDrinkTypeController implements DrinkTypeController {
  _FakeDrinkTypeController(this.log);
  final List<String> log;
  List<DrinkType> owned = [];
  Set<String> rejectDeleteFor = {};

  @override
  Future<List<DrinkType>> allOwnedBy(String userId) async => owned;

  @override
  Future<void> hardDeleteSingle(DrinkType entity) async {
    if (rejectDeleteFor.contains(entity.id)) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
      );
    }
    log.add('drinkType.hardDelete ${entity.id}');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSessionController implements SessionController {
  _FakeSessionController(this.log);
  final List<String> log;
  List<Session> withMember = [];
  Set<String> rejectStripFor = {};

  @override
  Future<List<Session>> allWithMember(String userId) async {
    log.add('session.allWithMember $userId');
    return withMember;
  }

  @override
  Future<void> hardDeleteSingle(Session entity) async =>
      log.add('session.hardDelete ${entity.id}');

  @override
  Future<void> stripMemberAndHandOver({
    required String sessionId,
    required String userId,
    String? newOwnerId,
  }) async {
    if (rejectStripFor.contains(sessionId)) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
      );
    }
    log.add('session.strip $sessionId $userId -> $newOwnerId');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeLeaderboardController implements LeaderboardController {
  _FakeLeaderboardController(this.log);
  final List<String> log;
  List<Leaderboard> withMember = [];

  @override
  Future<List<Leaderboard>> allWithMember(String userId) async {
    log.add('leaderboard.allWithMember $userId');
    return withMember;
  }

  @override
  Future<void> hardDeleteSingle(Leaderboard entity) async =>
      log.add('leaderboard.hardDelete ${entity.id}');

  @override
  Future<void> handOver({
    required String leaderboardId,
    required String userId,
    required String newOwnerId,
  }) async =>
      log.add('leaderboard.handOver $leaderboardId $userId -> $newOwnerId');

  @override
  Future<void> removeMemberAtomic(String entityId, String memberId) async =>
      log.add('leaderboard.removeMember $entityId $memberId');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFriendRequestController implements FriendRequestController {
  _FakeFriendRequestController(this.log);
  final List<String> log;
  List<FriendRequest> involving = [];
  var throwOnDelete = false;

  @override
  Future<List<FriendRequest>> allInvolving(String userId) async => involving;

  @override
  Future<void> hardDeleteSingle(FriendRequest entity) async {
    if (throwOnDelete) {
      throw StateError('permission denied');
    }
    log.add('friendRequest.hardDelete ${entity.id}');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUserController implements UserController {
  _FakeUserController(this.log);
  final List<String> log;
  List<UserModel> withFriend = [];

  @override
  Future<List<UserModel>> usersWithFriend(String userId) async => withFriend;

  @override
  Future<void> removeFriendFrom({
    required String userId,
    required String friendId,
  }) async => log.add('user.removeFriendFrom $userId');

  @override
  Future<void> anonymizeCurrentUser() async => log.add('user.anonymize');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUserSettingsController implements UserSettingsController {
  _FakeUserSettingsController(this.log);
  final List<String> log;

  @override
  Future<void> deleteCurrentUserSettings() async =>
      log.add('userSettings.delete');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAvatarService implements AvatarService {
  _FakeAvatarService(this.log);
  final List<String> log;

  @override
  Future<void> deleteAvatarFile() async => log.add('avatar.deleteFile');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSessionPictureService implements SessionPictureService {
  _FakeSessionPictureService(this.log);
  final List<String> log;

  @override
  Future<void> deletePictureFile(String url) async =>
      log.add('picture.deleteFile $url');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePartyController implements PartyController {
  _FakePartyController(this.log);
  final List<String> log;
  var throwOnLeave = false;

  @override
  String generateCommandId() => 'command-1';

  @override
  Future<PartyCommandResult> syncMembership({
    required String sessionId,
    required String commandId,
    required String action,
    required String memberId,
  }) async {
    if (throwOnLeave) {
      throw FirebaseFunctionsException(
        message: 'archived',
        code: 'failed-precondition',
      );
    }
    log.add('party.$action $sessionId $memberId');
    return const PartyCommandResult({});
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
