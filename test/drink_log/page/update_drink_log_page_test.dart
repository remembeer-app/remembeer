import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/model/drink_category.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';
import 'package:remembeer/drink_log/model/drink_log.dart';
import 'package:remembeer/drink_log/page/update_drink_log_page.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/drink_log/type/drink_log_with_session_id.dart';
import 'package:remembeer/drink_log/widget/drink_log_form.dart';

void main() {
  testWidgets('archived Party direct link displays a read-only state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: UpdateDrinkLogPage(
          sessionId: 'party-1',
          drinkLogId: 'drink-log-1',
          drinkLogService: _ArchivedDrinkLogService(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Archived Party'), findsOneWidget);
    expect(
      find.text('This drink is read-only because the Party has ended.'),
      findsOneWidget,
    );
    expect(find.byType(DrinkLogForm), findsNothing);
  });
}

class _ArchivedDrinkLogService implements DrinkLogService {
  @override
  Stream<DrinkLogWithSessionId> drinkLogWithSessionIdStream({
    required String sessionId,
    required String drinkLogId,
  }) => Stream.value((
    originalSessionId: sessionId,
    drinkLog: DrinkLog(
      id: drinkLogId,
      consumedByUserId: 'user-1',
      consumedAt: DateTime.utc(2026, 9, 2, 18, 30),
      drink: const DrinkSnapshot(
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
