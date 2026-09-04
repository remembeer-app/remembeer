import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/party_quest.dart';
import 'package:remembeer/party/widget/quest_card.dart';

void main() {
  testWidgets('shows a live countdown for an active quest', (tester) async {
    final now = DateTime(2026, 1, 1, 12);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuestCard(
            quest: _quest(endsAt: now.add(const Duration(seconds: 90))),
            now: now,
          ),
        ),
      ),
    );

    expect(find.text('ACTIVE'), findsOneWidget);
    expect(find.text('1:30 left'), findsOneWidget);
    expect(find.text('25 points'), findsOneWidget);
  });

  testWidgets('treats an overdue active quest as expired', (tester) async {
    final end = DateTime(2026, 1, 1, 12);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuestCard(
            quest: _quest(endsAt: end),
            now: end.add(const Duration(seconds: 1)),
          ),
        ),
      ),
    );

    expect(find.text('EXPIRED'), findsOneWidget);
    expect(find.textContaining('left'), findsNothing);
  });
}

PartyQuest _quest({required DateTime endsAt}) => PartyQuest(
  id: 'quest-1',
  templateId: 'template-1',
  titleSnapshot: 'Find your match',
  instructionsSnapshot: 'Choose the person who chose you.',
  pointsUnits: 25000,
  startsAt: endsAt.subtract(const Duration(minutes: 5)),
  endsAt: endsAt,
  status: PartyQuestStatus.active,
  createdAt: endsAt.subtract(const Duration(minutes: 5)),
);
