import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/widget/accent_color_form.dart';

void main() {
  testWidgets('requires an accent before submitting', (tester) async {
    AccentColorKey? submittedAccent;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AccentColorForm(
            initialValue: null,
            submitText: 'Continue',
            onSubmit: (accent) async {
              submittedAccent = accent;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('Select an accent color.'), findsOneWidget);
    expect(submittedAccent, isNull);

    await tester.tap(find.byTooltip('Rose'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(submittedAccent, AccentColorKey.rose);
  });
}
