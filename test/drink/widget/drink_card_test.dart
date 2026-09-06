import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/widget/drink_card.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';
import 'package:remembeer/ioc/ioc_container.dart';

void main() {
  testWidgets('archived Party drink has no mutation controls', (tester) async {
    get.registerSingleton<DrinkService>(_FakeDrinkService());
    addTearDown(get.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DrinkCard(
            drinkWithSessionId: (
              originalSessionId: 'party-1',
              drink: Drink(
                id: 'drink-1',
                consumedByUserId: 'user-1',
                consumedAt: DateTime.utc(2026, 9, 2),
                drinkType: const DrinkTypeCore(
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

class _FakeDrinkService implements DrinkService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
