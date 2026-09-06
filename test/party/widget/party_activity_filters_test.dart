import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/service/party_activity_service.dart';
import 'package:remembeer/party/widget/party_activity_filters.dart';

void main() {
  testWidgets('reversed activity is hidden until explicitly enabled', (
    tester,
  ) async {
    PartyActivityFilters? appliedFilters;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PartyActivityFiltersButton(
            filters: const PartyActivityFilters(),
            members: const [],
            onChanged: (filters) => appliedFilters = filters,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Filter activity'));
    await tester.pumpAndSettle();

    final toggle = tester.widget<SwitchListTile>(
      find.widgetWithText(SwitchListTile, 'Show reversed activity'),
    );
    expect(toggle.value, isFalse);
    expect(find.text('Reversals'), findsNothing);

    await tester.tap(find.text('Show reversed activity'));
    await tester.tap(find.text('Apply filters'));
    await tester.pumpAndSettle();

    expect(appliedFilters?.showReversed, isTrue);
  });
}
