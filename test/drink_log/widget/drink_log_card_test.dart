import 'package:dartvex/dartvex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/drink_log/widget/drink_log_card.dart';
import 'package:remembeer/ioc/ioc_container.dart';

void main() {
  testWidgets(
    'missing catalogue drink still shows log volume and account-local time',
    (tester) async {
      get.registerSingleton(ConvexApi(_Caller()));
      addTearDown(get.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrinkLogCard(
              log: (
                creationTime: 1.0,
                id: const DrinkLogId('log'),
                consumedAt: 1.0,
                consumedAtLocal: '2026-01-01T06:00:00',
                deletedAt: null,
                drink: null,
                drinkId: const DrinkId('missing'),
                location: null,
                sessionId: null,
                updatedAt: 1.0,
                userId: const UserId('user'),
                volumeMl: 330.0,
              ),
            ),
          ),
        ),
      );
      expect(find.text('Unavailable drink'), findsOneWidget);
      expect(find.text('330 ml · 06:00'), findsOneWidget);
      expect(find.byTooltip('Delete drink'), findsOneWidget);
    },
  );
}

class _Caller implements ConvexFunctionCaller {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
