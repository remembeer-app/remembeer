import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/page/update_drink_page.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/type/drink_with_session_id.dart';
import 'package:remembeer/drink/widget/drink_form.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';

void main() {
  testWidgets('archived Party direct link displays a read-only state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: UpdateDrinkPage(
          sessionId: 'party-1',
          drinkId: 'drink-1',
          drinkService: _ArchivedDrinkService(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Archived Party'), findsOneWidget);
    expect(
      find.text('This drink is read-only because the Party has ended.'),
      findsOneWidget,
    );
    expect(find.byType(DrinkForm), findsNothing);
  });
}

class _ArchivedDrinkService implements DrinkService {
  @override
  Stream<DrinkWithSessionId> drinkWithSessionIdStream({
    required String sessionId,
    required String drinkId,
  }) => Stream.value((
    originalSessionId: sessionId,
    drink: Drink(
      id: drinkId,
      consumedByUserId: 'user-1',
      consumedAt: DateTime.utc(2026, 9, 2, 18, 30),
      drinkType: const DrinkTypeCore(
        name: 'Beer',
        category: DrinkCategory.beer,
        alcoholPercentage: 5,
      ),
      volumeInMilliliters: 500,
    ),
    isParty: true,
    isReadOnly: true,
  ));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
