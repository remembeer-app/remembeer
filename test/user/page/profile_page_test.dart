import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/friend_request/model/friend_request.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/page/profile_page.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user/service/user_stats_service.dart';

void main() {
  testWidgets('shows an accent warning on an incomplete own profile', (
    tester,
  ) async {
    _registerServices(_user());
    addTearDown(get.reset);

    await tester.pumpWidget(MaterialApp(home: ProfilePage(userId: 'user-1')));
    await tester.pump();

    expect(find.text('Choose an accent color'), findsOneWidget);
    expect(find.text('Choose'), findsOneWidget);
  });

  testWidgets('hides the accent warning after an accent is selected', (
    tester,
  ) async {
    _registerServices(_user(accentColorKey: AccentColorKey.amber));
    addTearDown(get.reset);

    await tester.pumpWidget(MaterialApp(home: ProfilePage(userId: 'user-1')));
    await tester.pump();

    expect(find.text('Choose an accent color'), findsNothing);
  });
}

void _registerServices(UserModel user) {
  get
    ..registerSingleton<AuthService>(_FakeAuthService())
    ..registerSingleton<UserService>(_FakeUserService(user))
    ..registerSingleton(UserStatsService());
}

UserModel _user({AccentColorKey? accentColorKey}) {
  return UserModel(
    id: 'user-1',
    email: 'user@example.com',
    username: 'User',
    searchableUsername: 'user',
    accentColorKey: accentColorKey,
  );
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

class _FakeUserService implements UserService {
  final UserModel user;

  _FakeUserService(this.user);

  @override
  Stream<UserModel> userStreamFor(String userId) => Stream.value(user);

  @override
  Stream<List<FriendRequest>> pendingFriendRequests() => Stream.value([]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
