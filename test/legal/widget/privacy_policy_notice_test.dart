import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/legal/widget/privacy_policy_notice.dart';

void main() {
  testWidgets('opens the callback when the privacy policy link is tapped', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: PrivacyPolicyNotice(onOpen: () => tapped = true)),
      ),
    );

    expect(find.textContaining('By creating an account'), findsOneWidget);

    await tester.tapOnText(find.textRange.ofSubstring('Privacy Policy'));

    expect(tapped, isTrue);
  });
}
