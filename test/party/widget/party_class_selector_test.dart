import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/party/widget/party_class_selector.dart';

void main() {
  testWidgets('shows all five classes and submits the selection', (
    tester,
  ) async {
    DrinkCategory? submittedClass;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PartyClassSelector(
              onSubmit: (selectedClass) async {
                submittedClass = selectedClass;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('Beer Paladin'), findsOneWidget);
    expect(find.text('Cider Sentinel'), findsOneWidget);
    expect(find.text('Cocktail Druid'), findsOneWidget);
    expect(find.text('Spirit Shaman'), findsOneWidget);
    expect(find.text('Wine Warrior'), findsOneWidget);

    await tester.tap(find.text('Wine Warrior'));
    await tester.pump();
    await tester.tap(find.text('Choose class'));
    await tester.pumpAndSettle();

    expect(submittedClass, DrinkCategory.wine);
  });

  testWidgets('states that the class bonus applies to Party points', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: PartyClassSelector(onSubmit: (_) async {})),
      ),
    );

    expect(find.textContaining('10% Party point bonus'), findsOneWidget);
  });
}
