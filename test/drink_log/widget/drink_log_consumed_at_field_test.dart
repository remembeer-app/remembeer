import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/common/widget/app_form.dart';
import 'package:remembeer/drink_log/widget/drink_log_consumed_at_field.dart';

void main() {
  testWidgets('future consumed time blocks submission and can be corrected', (
    tester,
  ) async {
    final fieldKey = GlobalKey<FormFieldState<DateTime>>();
    var submissions = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppForm(
            isSubmitting: false,
            submitLabel: 'Save',
            submitButtonLabel: 'Save',
            onSubmit: () => submissions++,
            builder: (context, submit) => DrinkLogConsumedAtField(
              key: fieldKey,
              initialValue: DateTime.now().add(const Duration(hours: 1)),
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(submissions, 0);
    expect(find.text('Consumed time cannot be in the future.'), findsOneWidget);

    fieldKey.currentState!.didChange(
      DateTime.now().subtract(const Duration(minutes: 1)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Consumed time cannot be in the future.'), findsNothing);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(submissions, 1);
  });

  testWidgets('date picker opens safely for an existing future-dated value', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DrinkLogConsumedAtField(
            initialValue: DateTime.now().add(const Duration(days: 1)),
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });
}
