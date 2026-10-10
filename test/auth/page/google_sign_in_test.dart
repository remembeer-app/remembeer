import 'package:dartvex_auth_better/dartvex_auth_better.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/auth/page/login_page.dart';
import 'package:remembeer/auth/page/register_page.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';

void main() {
  for (final page in [const LoginPage(), const RegisterPage()]) {
    testWidgets(
      '${page.runtimeType} allows Google without filling the email form',
      (tester) async {
        final service = _AuthService();
        get.registerSingleton<ConvexAuthService>(service);
        addTearDown(get.reset);
        tester.view.physicalSize = const Size(1000, 2400);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(MaterialApp(home: page));
        await tester.tap(find.text('Continue with Google'));
        await tester.pumpAndSettle();
        expect(service.googleCalls, 1);
        expect(find.text('Continue with Google'), findsOneWidget);
        service.error = const BetterAuthException('Google sign-in failed');
        await tester.tap(find.text('Continue with Google'));
        await tester.pumpAndSettle();
        expect(find.text('Google sign-in failed'), findsOneWidget);
      },
    );
  }
}

class _AuthService implements ConvexAuthService {
  var googleCalls = 0;
  BetterAuthException? error;

  @override
  Future<bool> signInWithGoogle() async {
    googleCalls++;
    final failure = error;
    if (failure != null) throw failure;
    return false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
