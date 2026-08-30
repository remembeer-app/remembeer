import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/model/gender.dart';
import 'package:remembeer/user/widget/profile_details_form.dart';

void main() {
  testWidgets('requires both choices before submitting', (tester) async {
    Gender? submittedGender;
    AccentColorKey? submittedAccent;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileDetailsForm(
            initialGender: null,
            initialAccentColorKey: null,
            submitText: 'Continue',
            onSubmit: (gender, accent) async {
              submittedGender = gender;
              submittedAccent = accent;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('Select your gender.'), findsOneWidget);
    expect(find.text('Select an accent color.'), findsOneWidget);
    expect(submittedGender, isNull);
    expect(submittedAccent, isNull);

    await tester.tap(find.text('Female'));
    await tester.tap(find.byTooltip('Rose'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(submittedGender, Gender.female);
    expect(submittedAccent, AccentColorKey.rose);
  });
}
