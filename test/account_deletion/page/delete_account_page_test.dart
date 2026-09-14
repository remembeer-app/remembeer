import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/account_deletion/page/delete_account_page.dart';
import 'package:remembeer/account_deletion/service/account_deletion_service.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';

void main() {
  testWidgets('asks for the password when the account has one', (tester) async {
    _register(hasPassword: true);
    addTearDown(get.reset);

    await tester.pumpWidget(const MaterialApp(home: DeleteAccountPage()));

    expect(find.text('Confirm your password'), findsOneWidget);
    expect(find.text('Delete my account'), findsOneWidget);
  });

  testWidgets('offers Google confirmation for Google-only accounts', (
    tester,
  ) async {
    _register(hasPassword: false);
    addTearDown(get.reset);

    await tester.pumpWidget(const MaterialApp(home: DeleteAccountPage()));

    expect(find.text('Confirm your password'), findsNothing);
    expect(find.text('Confirm with Google and delete'), findsOneWidget);
  });

  testWidgets('shows the confirmation dialog before deleting', (tester) async {
    _register(hasPassword: false);
    addTearDown(get.reset);

    await tester.pumpWidget(const MaterialApp(home: DeleteAccountPage()));
    await tester.tap(find.text('Confirm with Google and delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete account?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });
}

void _register({required bool hasPassword}) {
  get
    ..registerSingleton<AuthService>(_FakeAuthService(hasPassword))
    ..registerSingleton<AccountDeletionService>(_FakeAccountDeletionService());
}

class _FakeAuthService implements AuthService {
  _FakeAuthService(this._hasPassword);
  final bool _hasPassword;

  @override
  bool get hasPasswordProvider => _hasPassword;

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

class _FakeAccountDeletionService implements AccountDeletionService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
