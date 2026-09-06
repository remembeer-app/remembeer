import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/widget/party_module_settings.dart';
import 'package:toastification/toastification.dart';

void main() {
  testWidgets('starts the next quest and disables the button while pending', (
    tester,
  ) async {
    final result = Completer<PartyQuestStartResult>();
    var calls = 0;
    await tester.pumpWidget(
      _panel(
        onStartNextQuest: () {
          calls += 1;
          return result.future;
        },
      ),
    );

    await tester.ensureVisible(find.text('Start next quest now'));
    await tester.tap(find.text('Start next quest now'));
    await tester.pump();

    expect(calls, 1);
    expect(find.text('Starting quest...'), findsOneWidget);
    final pendingButton = tester.widget<OutlinedButton>(
      find.byType(OutlinedButton),
    );
    expect(pendingButton.onPressed, isNull);

    result.complete(const PartyQuestStartResult(started: true));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Start next quest now'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('reports why no quest started', (tester) async {
    await tester.pumpWidget(
      _panel(
        onStartNextQuest: () async => const PartyQuestStartResult(
          started: false,
          reason: 'noEnabledTemplates',
        ),
      ),
    );

    await tester.ensureVisible(find.text('Start next quest now'));
    await tester.tap(find.text('Start next quest now'));
    await tester.pump(const Duration(milliseconds: 500));

    final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    expect(button.onPressed, isNotNull);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('disables manual start while a quest is active', (tester) async {
    await tester.pumpWidget(
      _panel(
        hasActiveQuest: true,
        onStartNextQuest: () async =>
            const PartyQuestStartResult(started: true),
      ),
    );

    final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    expect(button.onPressed, isNull);
  });
}

Widget _panel({
  bool hasActiveQuest = false,
  required Future<PartyQuestStartResult> Function() onStartNextQuest,
}) => ToastificationWrapper(
  child: MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: PartyModuleSettingsPanel(
          settings: const PartyModuleSettings(socialQuestsEnabled: true),
          schedule: const PartyQuestSchedule(),
          onSaveSettings: (_) async {},
          onSaveSchedule: (_) async {},
          hasActiveQuest: hasActiveQuest,
          onStartNextQuest: onStartNextQuest,
        ),
      ),
    ),
  ),
);
