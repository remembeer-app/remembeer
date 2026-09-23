import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/page/settings_page.dart';

void main() {
  testWidgets('shows the about section with privacy policy and support link', (
    tester,
  ) async {
    get.registerSingleton<ConvexAuthService>(_FakeConvexAuthService());
    addTearDown(get.reset);

    tester.view.physicalSize = const Size(1000, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MaterialApp(home: SettingsPage()));
    await tester.pump();

    expect(find.text('About'), findsOneWidget);
    expect(find.text('Privacy policy'), findsOneWidget);
    expect(find.text('Contact support'), findsOneWidget);
    expect(find.text('info@alcorythmics.cz'), findsOneWidget);
  });
}

class _FakeConvexAuthService implements ConvexAuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
