import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/beerpong_match.dart';
import 'package:remembeer/party/model/beerpong_team.dart';
import 'package:remembeer/party/widget/beerpong_bracket.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
  testWidgets('narrow bracket scrolls horizontally and explains every state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(constraints: const BoxConstraints()));

    final scrollView = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView),
    );
    expect(scrollView.scrollDirection, Axis.horizontal);
    expect(find.text('Your team'), findsWidgets);
    expect(find.text('Winner'), findsWidgets);
    expect(find.text('Bye: advances automatically'), findsOneWidget);
    expect(find.text('Waiting for previous match'), findsOneWidget);
    expect(find.text('TBD'), findsWidgets);
  });

  testWidgets('wide bracket lays rounds out without horizontal scrolling', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(constraints: const BoxConstraints()));

    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(find.text('Semifinals'), findsOneWidget);
    expect(find.text('Final'), findsOneWidget);
    expect(find.text('Third place'), findsOneWidget);
  });

  testWidgets('only ready matches expose result selection', (tester) async {
    final selections = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BeerpongBracket(
            teams: _teams,
            matches: _matches,
            members: _members,
            currentUserId: 'user-1',
            onRecordResult: (_, teamId) => selections.add(teamId),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Team One').first);
    expect(selections, ['team-1']);
  });
}

Widget _app({required BoxConstraints constraints}) => MaterialApp(
  home: Scaffold(
    body: ConstrainedBox(
      constraints: constraints,
      child: const BeerpongBracket(
        teams: _teams,
        matches: _matches,
        members: _members,
        currentUserId: 'user-1',
      ),
    ),
  ),
);

const _members = [
  UserModel(
    id: 'user-1',
    email: 'one@example.com',
    username: 'Player One',
    searchableUsername: 'player one',
  ),
  UserModel(
    id: 'user-2',
    email: 'two@example.com',
    username: 'Player Two',
    searchableUsername: 'player two',
  ),
];

const _teams = [
  BeerpongTeam(id: 'team-1', name: 'Team One', memberIds: ['user-1'], seed: 1),
  BeerpongTeam(id: 'team-2', name: 'Team Two', memberIds: ['user-2'], seed: 2),
];

const _matches = [
  BeerpongMatch(
    id: 'round-1',
    round: 1,
    position: 1,
    kind: BeerpongMatchKind.main,
    teamAId: 'team-1',
    teamBId: 'team-2',
    status: BeerpongMatchStatus.ready,
  ),
  BeerpongMatch(
    id: 'bye',
    round: 1,
    position: 2,
    kind: BeerpongMatchKind.main,
    teamAId: 'team-1',
    winnerTeamId: 'team-1',
    status: BeerpongMatchStatus.bye,
  ),
  BeerpongMatch(
    id: 'final',
    round: 2,
    position: 1,
    kind: BeerpongMatchKind.main,
    status: BeerpongMatchStatus.pending,
  ),
  BeerpongMatch(
    id: 'third',
    round: 2,
    position: 1,
    kind: BeerpongMatchKind.thirdPlace,
    teamAId: 'team-1',
    teamBId: 'team-2',
    winnerTeamId: 'team-2',
    loserTeamId: 'team-1',
    status: BeerpongMatchStatus.completed,
  ),
];
