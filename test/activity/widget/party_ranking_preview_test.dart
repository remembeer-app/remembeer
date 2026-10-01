import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/activity/widget/party_ranking_preview.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/service/party_ranking_service.dart';

PartyStanding _standing(int rank, String username) {
  return PartyStanding(
    rank: rank,
    member: PartyMember(
      id: username,
      userId: username,
      scoreUnits: 1000 * (10 - rank),
      joinedAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
    username: username,
    isCurrentUser: false,
  );
}

Future<void> _pump(
  WidgetTester tester, {
  required List<PartyStanding> standings,
  bool isFinal = true,
  VoidCallback? onTap,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: PartyRankingPreview(
            standings: standings,
            isFinal: isFinal,
            onTap: onTap ?? () {},
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows only the podium of a finished party', (tester) async {
    await _pump(
      tester,
      standings: [
        _standing(1, 'Anna'),
        _standing(2, 'Bara'),
        _standing(3, 'Cyril'),
        _standing(4, 'David'),
      ],
    );

    expect(find.text('Final ranking'), findsOneWidget);
    expect(find.text('Anna'), findsOneWidget);
    expect(find.text('Bara'), findsOneWidget);
    expect(find.text('Cyril'), findsOneWidget);
    expect(find.text('David'), findsNothing);
  });

  testWidgets('keeps every member tied for the last podium rank', (
    tester,
  ) async {
    await _pump(
      tester,
      standings: [
        _standing(1, 'Anna'),
        _standing(2, 'Bara'),
        _standing(3, 'Cyril'),
        _standing(3, 'Dana'),
        _standing(5, 'Emil'),
      ],
    );

    expect(find.text('Dana'), findsOneWidget);
    expect(find.text('Emil'), findsNothing);
  });

  testWidgets('labels an ongoing party ranking as not final', (tester) async {
    await _pump(tester, standings: [_standing(1, 'Anna')], isFinal: false);

    expect(find.text('Ranking'), findsOneWidget);
    expect(find.text('Final ranking'), findsNothing);
  });

  testWidgets('opens the full standings from a standing or See all', (
    tester,
  ) async {
    var taps = 0;
    await _pump(
      tester,
      standings: [_standing(1, 'Anna'), _standing(2, 'Bara')],
      onTap: () => taps++,
    );

    await tester.tap(find.text('Bara'));
    await tester.tap(find.text('See all'));

    expect(taps, 2);
  });

  testWidgets('renders nothing without standings', (tester) async {
    await _pump(tester, standings: const []);

    expect(find.text('Final ranking'), findsNothing);
  });
}
