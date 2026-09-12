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
            currentUserId: 'other',
            now: now,
          ),
        ),
      ),
    );

    expect(find.text('ACTIVE'), findsOneWidget);
    expect(find.text('1:30 left'), findsOneWidget);
    expect(find.text('25 points each'), findsOneWidget);
  });

  testWidgets('tailors class instructions and exposes the card action', (
    tester,
  ) async {
    final now = DateTime(2026, 1, 1, 12);
    var tapped = false;
    final quest = _quest(
      endsAt: now.add(const Duration(minutes: 5)),
      eligibilityRule: 'oneMemberClass:beer',
      targetClassMemberIds: const ['target'],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuestCard(
            quest: quest,
            currentUserId: 'target',
            now: now,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.textContaining('You are the Beer Paladin.'), findsOneWidget);
    expect(find.textContaining('Let yourself be found'), findsOneWidget);
    expect(find.text('Choose your toast partner'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.byType(QuestCard));
    expect(tapped, isTrue);
  });

  testWidgets('guides the other side toward the target class', (tester) async {
    final now = DateTime(2026, 1, 1, 12);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuestCard(
            quest: _quest(
              endsAt: now.add(const Duration(minutes: 5)),
              eligibilityRule: 'oneMemberClass:beer',
              targetClassMemberIds: const ['target'],
            ),
            currentUserId: 'other',
            now: now,
          ),
        ),
      ),
    );

    expect(
      find.textContaining('Have a toast with a Beer Paladin'),
      findsOneWidget,
    );
    expect(find.textContaining('Exactly one of you'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets('does not prompt an ineligible user to choose a partner', (
    tester,
  ) async {
    final now = DateTime(2026, 1, 1, 12);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuestCard(
            quest: _quest(endsAt: now.add(const Duration(minutes: 5))),
            currentUserId: 'ineligible',
            now: now,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Choose your toast partner'), findsNothing);
    expect(find.text('View quest details'), findsOneWidget);
  });

  testWidgets('does not prompt a completed user to choose again', (
    tester,
  ) async {
    final now = DateTime(2026, 1, 1, 12);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuestCard(
            quest: _quest(
              endsAt: now.add(const Duration(minutes: 5)),
              completedPairKeys: const ['pair:target:other'],
            ),
            currentUserId: 'target',
            now: now,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Choose your toast partner'), findsNothing);
    expect(find.text('View quest details'), findsOneWidget);
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

PartyQuest _quest({
  required DateTime endsAt,
  String eligibilityRule = 'allEligibleMembers',
  List<String> targetClassMemberIds = const [],
  List<String> completedPairKeys = const [],
}) => PartyQuest(
  id: 'quest-1',
  templateId: 'template-1',
  titleSnapshot: 'Find your match',
  instructionsSnapshot: 'Choose the person who chose you.',
  eligibilityRuleSnapshot: eligibilityRule,
  targetClassMemberIds: targetClassMemberIds,
  pointsUnits: 25000,
  startsAt: endsAt.subtract(const Duration(minutes: 5)),
  endsAt: endsAt,
  status: PartyQuestStatus.active,
  eligibleMemberIds: const ['target', 'other'],
  completedPairKeys: completedPairKeys,
  createdAt: endsAt.subtract(const Duration(minutes: 5)),
);
