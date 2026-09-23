import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/model/drink_category.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';
import 'package:remembeer/drink_log/model/drink_log.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/drink_log/widget/drink_log_card.dart';
import 'package:remembeer/ioc/ioc_container.dart';

void main() {
  testWidgets('archived Party drink has no mutation controls', (tester) async {
    get.registerSingleton<DrinkLogService>(_FakeDrinkLogService());
    addTearDown(get.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DrinkLogCard(
            drinkLogWithSessionId: (
              originalSessionId: 'party-1',
              drinkLog: DrinkLog(
                id: 'drink-1',
                consumedByUserId: 'user-1',
                consumedAt: DateTime.utc(2026, 9, 2),
                drink: const DrinkSnapshot(
                  name: 'Beer',
                  category: DrinkCategory.beer,
                  alcoholPercentage: 4.5,
                ),
                volumeInMilliliters: 500,
              ),
              isParty: true,
              isReadOnly: true,
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.delete_outline), findsNothing);
    expect(find.byType(LongPressDraggable), findsNothing);
    expect(tester.widget<ListTile>(find.byType(ListTile)).onTap, isNull);
  });
}

class _FakeDrinkLogService implements DrinkLogService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
