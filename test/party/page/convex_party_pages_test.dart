import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/convex_api/api.dart' show BeerpongTeamId, SessionId;
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/page/beerpong_page.dart';
import 'package:remembeer/party/page/challenge_detail_page.dart';
import 'package:remembeer/party/page/party_management_page.dart';
import 'package:remembeer/party/page/party_page.dart';
import 'package:remembeer/party/page/quest_detail_page.dart';
import 'package:remembeer/party/widget/party_activity.dart';
import 'package:remembeer/party/widget/party_creation_forms.dart';
import 'package:toastification/toastification.dart';

void main() {
  Future<void> mount(WidgetTester tester, _Client client, Widget page) async {
    tester.view.physicalSize = const Size(1000, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(() async {
      toastification.dismissAll();
      await tester.pumpWidget(const SizedBox.shrink());
      await client.dispose();
    });
    await tester.pumpWidget(
      ConvexProvider(
        client: client,
        child: ToastificationWrapper(child: MaterialApp(home: page)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'party standings display server ranks and react to score changes',
    (tester) async {
      final client = _Client();
      await mount(
        tester,
        client,
        const PartyPage(sessionId: 'party', tab: PartyTab.ranking),
      );
      expect(find.text('Friday'), findsOneWidget);
      expect(find.text('Owner'), findsOneWidget);
      expect(find.text('42.501'), findsOneWidget);
      client.responses['party:standings'] = {
        'entries': [
          {..._standing, 'scoreUnits': 90000, 'rank': 3},
        ],
      };
      client.emit('party:standings');
      await tester.pumpAndSettle();
      expect(find.text('90'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('42.501'), findsNothing);
    },
  );

  testWidgets(
    'games choose the Convex user class and toggle their beerpong opt-in',
    (tester) async {
      final client = _Client();
      client.responses['sessionMember:listForSession'] = [
        {
          'member': {..._member('owner'), 'selectedClass': null},
          'username': 'Owner',
        },
      ];
      await mount(
        tester,
        client,
        const PartyPage(sessionId: 'party', tab: PartyTab.games),
      );
      await tester.tap(find.text('Wine Warrior'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose class'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'sessionMember:setClass');
      expect(client.last.args, {
        'sessionId': 'party',
        'userId': 'owner',
        'selectedClass': {'kind': 'wine'},
      });
      client.responses['sessionMember:listForSession'] = [
        {
          'member': {
            ..._member('owner'),
            'selectedClass': {'kind': 'wine'},
          },
          'username': 'Owner',
        },
      ];
      client.emit('sessionMember:listForSession');
      await tester.pumpAndSettle();
      expect(find.text('Choose your Party class'), findsNothing);
      expect(find.text('Choose class'), findsNothing);
      await tester.ensureVisible(
        find.widgetWithText(SwitchListTile, 'Join beerpong draws'),
      );
      await tester.tap(
        find.widgetWithText(SwitchListTile, 'Join beerpong draws'),
      );
      await tester.pumpAndSettle();
      expect(client.last.name, 'sessionMember:setBeerpongOptIn');
      expect(client.last.args, {'sessionId': 'party', 'optedIn': true});
    },
  );

  testWidgets(
    'quests use server partner eligibility and complete without seeing the other selection',
    (tester) async {
      final client = _Client();
      await mount(
        tester,
        client,
        const QuestDetailPage(sessionId: 'party', questId: 'quest'),
      );
      expect(find.text('Alice'), findsOneWidget);
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'partyQuest:selectPartner');
      expect(client.last.args, {'questId': 'quest', 'selectedUserId': 'a'});
      client.responses['partyQuest:get'] = {
        ..._quest,
        'selections': [
          {'userId': 'owner', 'selectedUserId': 'a', 'selectedAt': 2000},
        ],
        'results': [
          {'firstUserId': 'a', 'secondUserId': 'owner', 'completedAt': 2000},
        ],
      };
      client.emit('partyQuest:get');
      await tester.pumpAndSettle();
      expect(find.text('Completed with Alice'), findsOneWidget);
      expect(find.text('Choose'), findsNothing);
      await tester.pump(const Duration(seconds: 5));
    },
  );

  testWidgets(
    'quest errors stay visible and live empty partner results remove choices',
    (tester) async {
      final client = _Client()..failNames.add('partyQuest:selectPartner');
      await mount(
        tester,
        client,
        const QuestDetailPage(sessionId: 'party', questId: 'quest'),
      );
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Server rejected request'), findsWidgets);
      client.responses['partyQuest:partners'] = <Object?>[];
      client.emit('partyQuest:partners');
      await tester.pumpAndSettle();
      expect(find.text('No eligible partners right now.'), findsOneWidget);
      expect(find.text('Choose'), findsNothing);
    },
  );

  testWidgets('archived parties expose history without gameplay mutations', (
    tester,
  ) async {
    final client = _Client();
    client.responses['session:get'] = {..._party, 'endedAt': 3000};
    await mount(
      tester,
      client,
      const PartyPage(sessionId: 'party', tab: PartyTab.games),
    );
    expect(find.text('Archived party'), findsOneWidget);
    expect(find.text('Choose class'), findsNothing);
    expect(find.text('Join beerpong draws'), findsOneWidget);
    expect(
      tester
          .widget<SwitchListTile>(
            find.widgetWithText(SwitchListTile, 'Join beerpong draws'),
          )
          .onChanged,
      isNull,
    );
    expect(find.byTooltip('Manage party'), findsNothing);
  });

  testWidgets('admins toggle modules directly and save the server schedule', (
    tester,
  ) async {
    final client = _Client();
    await mount(tester, client, const PartyManagementPage(sessionId: 'party'));
    await tester.tap(find.widgetWithText(SwitchListTile, 'Beerpong'));
    await tester.pumpAndSettle();
    expect(client.last.name, 'beerpongTournament:setEnabled');
    expect(client.last.args, {'sessionId': 'party', 'enabled': false});
    await tester.tap(find.widgetWithText(SwitchListTile, 'Social quests'));
    await tester.pumpAndSettle();
    expect(client.last.name, 'partyQuest:setEnabled');
    await tester.tap(find.widgetWithText(SwitchListTile, 'Challenges'));
    await tester.pumpAndSettle();
    expect(client.last.name, 'partyChallenge:setEnabled');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Minimum break (minutes)'),
      '10',
    );
    await tester.tap(find.text('Save schedule'));
    await tester.pumpAndSettle();
    expect(client.last.name, 'partyQuest:setSchedule');
    expect(client.last.args, {
      'sessionId': 'party',
      'minIntervalMinutes': 10.0,
      'maxIntervalMinutes': 45.0,
      'defaultDurationMinutes': 15.0,
    });
  });

  testWidgets('ordinary members cannot use the management view', (
    tester,
  ) async {
    final client = _Client();
    client.responses['user:current'] = {..._user, '_id': 'a'};
    await mount(tester, client, const PartyManagementPage(sessionId: 'party'));
    expect(
      find.text('Only admins can manage an ongoing party.'),
      findsOneWidget,
    );
    expect(find.byType(SwitchListTile), findsNothing);
  });

  testWidgets(
    'challenge winners are added and removed through Convex mutations',
    (tester) async {
      final client = _Client();
      await mount(
        tester,
        client,
        const ChallengeDetailPage(sessionId: 'party', challengeId: 'challenge'),
      );
      await tester.tap(find.text('Award').first);
      await tester.pumpAndSettle();
      expect(client.last.name, 'partyChallenge:addWinner');
      expect(client.last.args, {'id': 'challenge', 'userId': 'owner'});
      client.responses['partyChallenge:get'] = {
        ..._challenge,
        'status': 'expired',
        'winners': [
          {'userId': 'a', 'awardedAt': 2000},
        ],
      };
      client.emit('partyChallenge:get');
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Remove winner'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'partyChallenge:removeWinner');
      expect(client.last.args, {'id': 'challenge', 'userId': 'a'});
    },
  );

  testWidgets(
    'beerpong enrollment and setup invoke distinct draw and start mutations',
    (tester) async {
      final client = _Client();
      client.responses['beerpongTournament:get'] = {
        ..._detail,
        'tournament': {..._tournament, 'status': 'enrollment'},
      };
      await mount(
        tester,
        client,
        const BeerpongPage(sessionId: 'party', tournamentId: 'cup'),
      );
      await tester.tap(find.text('Draw teams'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'beerpongTournament:draw');
      expect(client.last.args, {'id': 'cup'});
      client.responses['beerpongTournament:get'] = {
        ..._detail,
        'tournament': {..._tournament, 'status': 'setup'},
      };
      client.emit('beerpongTournament:get');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start tournament'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'beerpongTournament:start');
      expect(client.last.args, {'id': 'cup'});
    },
  );

  testWidgets(
    'beerpong results and corrections use server-resolved opponents',
    (tester) async {
      final client = _Client();
      await mount(
        tester,
        client,
        const BeerpongPage(sessionId: 'party', tournamentId: 'cup'),
      );
      await tester.tap(find.text('Winner: Bees'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'beerpongMatch:recordResult');
      expect(client.last.args, {'id': 'final', 'winnerTeamId': 'bees'});
      client.responses['beerpongTournament:get'] = {
        ..._detail,
        'matches': [
          {
            ..._match,
            'winnerTeamId': 'bees',
            'completedAt': 2000,
            'status': 'completed',
          },
        ],
      };
      client.emit('beerpongTournament:get');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Correct to: Wasps'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Correct winner'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'beerpongMatch:correctResult');
      expect(client.last.args, {'id': 'final', 'winnerTeamId': 'wasps'});
    },
  );

  testWidgets(
    'activity scrolling accumulates pages and filter changes reset pagination',
    (tester) async {
      final client = _Client();
      final firstItems = List.generate(40, _activityItem);
      client.responses['party:activity'] = {
        'page': firstItems,
        'isDone': false,
      };
      await mount(
        tester,
        client,
        const Scaffold(body: PartyActivity(sessionId: 'party')),
      );
      final query = client.paginatedQueries.single;
      expect(query.pageSize, 25);
      expect(query.loadMoreCount, 0);
      expect(find.text('Owner logged Drink 0'), findsOneWidget);
      expect(find.text('Next'), findsNothing);
      await tester.drag(find.byType(ListView), const Offset(0, -3000));
      await tester.pumpAndSettle();
      expect(query.loadMoreCount, greaterThan(0));
      query.emit(
        ConvexPaginatedResult(
          results: firstItems,
          status: ConvexPaginationStatus.loadingMore,
          isDone: false,
        ),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      query.emit(
        ConvexPaginatedResult(
          results: [
            ...firstItems,
            ...List.generate(20, (index) => _activityItem(index + 40)),
          ],
          status: ConvexPaginationStatus.exhausted,
          isDone: true,
        ),
      );
      await tester.pumpAndSettle();
      final loaded = query.loadMoreCount;
      await tester.drag(find.byType(ListView), const Offset(0, -4000));
      await tester.pumpAndSettle();
      expect(find.text('Owner logged Drink 59'), findsOneWidget);
      expect(query.loadMoreCount, loaded);
      await tester.drag(find.byType(ListView), const Offset(0, 7000));
      await tester.pumpAndSettle();
      expect(find.text('Owner logged Drink 0'), findsOneWidget);
      client.responses['party:activity'] = _activity;
      await tester.tap(find.widgetWithText(FilterChip, 'Quests'));
      await tester.pumpAndSettle();
      expect(query.isCanceled, isTrue);
      expect(client.requests.last.args['kinds'], ['socialQuest']);
      expect(find.text('No matching party activity.'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilterChip, 'Owner'));
      await tester.pumpAndSettle();
      expect(client.requests.last.args['participantIds'], ['owner']);
      expect(client.paginatedQueries, hasLength(3));
    },
  );

  testWidgets(
    'activity fills short viewports and retains rows on later errors',
    (tester) async {
      final client = _Client();
      final items = [_activityItem(0)];
      client.responses['party:activity'] = {'page': items, 'isDone': false};
      await mount(
        tester,
        client,
        const Scaffold(body: PartyActivity(sessionId: 'party')),
      );
      final query = client.paginatedQueries.single;
      expect(query.loadMoreCount, greaterThan(0));
      query.emit(
        ConvexPaginatedResult(
          results: items,
          status: ConvexPaginationStatus.error,
          isDone: false,
          error: StateError('backend failed'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Owner logged Drink 0'), findsOneWidget);
      expect(find.text('Could not load party activity.'), findsOneWidget);
      client.responses['party:activity'] = _activity;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(query.isCanceled, isTrue);
      expect(client.paginatedQueries, hasLength(2));
      expect(find.text('No matching party activity.'), findsOneWidget);
    },
  );

  testWidgets(
    'challenge creation converts displayed points and shows backend errors',
    (tester) async {
      final client = _Client()..failNames.add('partyChallenge:create');
      await mount(
        tester,
        client,
        const Scaffold(
          body: SingleChildScrollView(
            child: PartyChallengeForm(sessionId: SessionId('party')),
          ),
        ),
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Title'),
        'Toast',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Instructions'),
        'Raise a glass',
      );
      await tester.tap(find.text('Create challenge'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'partyChallenge:create');
      expect(client.last.args['pointsUnits'], 25000);
      expect(find.textContaining('Server rejected request'), findsWidgets);
    },
  );

  testWidgets(
    'roster editing adds, moves, removes, and renames through team mutations',
    (tester) async {
      final client = _Client();
      client.responses['sessionMember:listForSession'] = [
        {'member': _member('owner'), 'username': 'Owner'},
        {'member': _member('a'), 'username': 'Alice'},
        {'member': _member('b'), 'username': 'Bob'},
      ];
      await mount(
        tester,
        client,
        const BeerpongPage(sessionId: 'party', tournamentId: 'cup'),
      );
      await tester.tap(find.text('Bees').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to team'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'beerpongTeam:addMember');
      expect(client.last.args, {'id': 'bees', 'userId': 'b'});
      await tester.tap(find.byType(PopupMenuButton<BeerpongTeamId>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Move to Wasps'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'beerpongTeam:moveMember');
      expect(client.last.args, {
        'id': 'bees',
        'targetTeamId': 'wasps',
        'userId': 'owner',
      });
      await tester.tap(find.byType(PopupMenuButton<BeerpongTeamId>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove from team'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'beerpongTeam:removeMember');
      expect(client.last.args, {'id': 'bees', 'userId': 'owner'});
      await tester.tap(find.text('Rename team'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Name'),
        'Bumblebees',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'beerpongTeam:rename');
      expect(client.last.args, {'id': 'bees', 'name': 'Bumblebees'});
    },
  );

  testWidgets('finalization locks the completed tournament view', (
    tester,
  ) async {
    final client = _Client();
    client.responses['beerpongTournament:get'] = {
      ..._detail,
      'matches': [
        {
          ..._match,
          'winnerTeamId': 'bees',
          'completedAt': 2000,
          'status': 'completed',
        },
      ],
    };
    await mount(
      tester,
      client,
      const BeerpongPage(sessionId: 'party', tournamentId: 'cup'),
    );
    await tester.tap(find.text('Finalize and award points'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Finalize'));
    await tester.pumpAndSettle();
    expect(client.last.name, 'beerpongTournament:finalize');
    expect(client.last.args, {'id': 'cup'});
    client.responses['beerpongTournament:get'] = {
      ..._detail,
      'tournament': {
        ..._tournament,
        'status': 'completed',
        'completedAt': 2000,
      },
      'matches': [
        {
          ..._match,
          'winnerTeamId': 'bees',
          'completedAt': 2000,
          'status': 'completed',
        },
      ],
      'placements': [
        {'teamId': 'bees', 'placement': 1},
        {'teamId': 'wasps', 'placement': 2},
      ],
    };
    client.emit('beerpongTournament:get');
    await tester.pumpAndSettle();
    expect(find.text('Place #1'), findsOneWidget);
    expect(find.text('Finalize and award points'), findsNothing);
    expect(find.text('Correct to: Wasps'), findsNothing);
    await tester.tap(find.text('Bees').first);
    await tester.pumpAndSettle();
    expect(find.text('Rename team'), findsNothing);
  });

  testWidgets(
    'expired challenges can be edited without resubmitting their duration',
    (tester) async {
      final client = _Client();
      client.responses['partyChallenge:get'] = {
        ..._challenge,
        'status': 'expired',
      };
      await mount(
        tester,
        client,
        const ChallengeDetailPage(sessionId: 'party', challengeId: 'challenge'),
      );
      await tester.tap(find.text('Edit challenge'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Title'),
        'Updated toast',
      );
      await tester.tap(find.text('Save challenge'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'partyChallenge:update');
      expect(client.last.args['title'], 'Updated toast');
      expect(client.last.args['pointsUnits'], 30000);
      expect(client.last.args.containsKey('durationMinutes'), isFalse);
    },
  );

  testWidgets(
    'tournament creation sends its name, team count, and prize units to Convex',
    (tester) async {
      final client = _Client()..failNames.add('beerpongTournament:create');
      await mount(
        tester,
        client,
        const Scaffold(
          body: SingleChildScrollView(
            child: PartyTournamentForm(sessionId: SessionId('party')),
          ),
        ),
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tournament name'),
        'Summer cup',
      );
      await tester.tap(find.text('Open enrollment'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'beerpongTournament:create');
      expect(client.last.args, {
        'sessionId': 'party',
        'name': 'Summer cup',
        'teamCount': 2.0,
        'thirdPlaceEnabled': true,
        'firstPlacePointsUnits': 100000.0,
        'secondPlacePointsUnits': 50000.0,
        'thirdPlacePointsUnits': 25000.0,
      });
      expect(find.textContaining('Server rejected request'), findsWidgets);
    },
  );
}

const _party = <String, dynamic>{
  '_id': 'party',
  '_creationTime': 1,
  'ownerId': 'owner',
  'name': 'Friday',
  'description': '',
  'kind': 'party',
  'startedAt': 1000,
  'endedAt': null,
  'updatedAt': 1,
  'deletedAt': null,
  'activatedAt': 1000,
  'activatedByUserId': 'owner',
  'modules': {
    'socialQuestsEnabled': true,
    'partyChallengesEnabled': true,
    'beerpongEnabled': true,
  },
  'questSchedule': {
    'minIntervalMinutes': 15,
    'maxIntervalMinutes': 45,
    'defaultDurationMinutes': 15,
    'nextQuestAt': null,
    'scheduledFunctionId': null,
  },
};
const _user = <String, dynamic>{
  '_id': 'owner',
  '_creationTime': 1,
  'authUserId': 'auth',
  'username': 'Owner',
  'normalizedUsername': 'owner',
  'accentColor': 'amber',
  'avatarUrl': null,
  'defaultDrink': null,
  'endOfDayBoundary': 360,
  'timeZone': 'Europe/Prague',
  'drinkLogSortOrder': 'desc',
};
Map<String, dynamic> _member(String id) => {
  '_id': 'member-$id',
  '_creationTime': 1,
  'sessionId': 'party',
  'kind': 'partyMember',
  'userId': id,
  'sessionMemberStatus': {'kind': 'joined'},
  'sessionMemberRole': {'kind': id == 'owner' ? 'admin' : 'member'},
  'sessionEndedAt': null,
  'sessionDeletedAt': null,
  'updatedAt': 1,
  'selectedClass': {'kind': 'beer'},
  'beerpongOptIn': false,
};
const _standing = <String, dynamic>{
  'userId': 'owner',
  'user': {
    '_id': 'owner',
    'username': 'Owner',
    'accentColor': 'amber',
    'avatarUrl': null,
  },
  'selectedClass': {'kind': 'beer'},
  'rank': 1,
  'scoreUnits': 42501,
  'baseDrinkScoreUnits': 0,
  'classBonusScoreUnits': 0,
  'questScoreUnits': 0,
  'challengeScoreUnits': 42501,
  'beerpongScoreUnits': 0,
  'wonChallengeCount': 1,
  'completedQuestCount': 0,
  'drinkCount': 0,
  'volumeMl': 0,
  'alcoholMl': 0,
};
const _quest = <String, dynamic>{
  '_id': 'quest',
  '_creationTime': 1,
  'sessionId': 'party',
  'kind': 'sameBeerpongTeam',
  'title': 'Team Morale',
  'instructions': 'Toast with your teammate.',
  'pointsUnits': 25000,
  'startsAt': 1000,
  'endsAt': 9999999999999,
  'status': 'active',
  'updatedAt': 1,
  'selections': <Object?>[],
  'results': <Object?>[],
};
const _challenge = <String, dynamic>{
  '_id': 'challenge',
  '_creationTime': 1,
  'sessionId': 'party',
  'title': 'Toast contest',
  'instructions': 'Make a toast.',
  'pointsUnits': 30000,
  'startsAt': 1000,
  'endsAt': 9999999999999,
  'status': 'active',
  'createdByUserId': 'owner',
  'updatedAt': 1,
  'winners': <Object?>[],
};
const _tournament = <String, dynamic>{
  '_id': 'cup',
  '_creationTime': 1,
  'sessionId': 'party',
  'name': 'Friday cup',
  'status': 'active',
  'teamCount': 2,
  'thirdPlaceEnabled': false,
  'firstPlacePointsUnits': 100000,
  'secondPlacePointsUnits': 50000,
  'thirdPlacePointsUnits': 25000,
  'createdByUserId': 'owner',
  'updatedAt': 1,
  'completedAt': null,
};
const _match = <String, dynamic>{
  '_id': 'final',
  '_creationTime': 1,
  'tournamentId': 'cup',
  'round': 1,
  'position': 1,
  'kind': 'main',
  'slotA': {'kind': 'team', 'teamId': 'bees'},
  'slotB': {'kind': 'team', 'teamId': 'wasps'},
  'teamAId': 'bees',
  'teamBId': 'wasps',
  'winnerTeamId': null,
  'completedAt': null,
  'updatedAt': 1,
  'status': 'ready',
};
const _detail = <String, dynamic>{
  'tournament': _tournament,
  'teams': [
    {
      '_id': 'bees',
      '_creationTime': 1,
      'tournamentId': 'cup',
      'name': 'Bees',
      'memberUserIds': ['owner'],
      'updatedAt': 1,
    },
    {
      '_id': 'wasps',
      '_creationTime': 1,
      'tournamentId': 'cup',
      'name': 'Wasps',
      'memberUserIds': ['a'],
      'updatedAt': 1,
    },
  ],
  'matches': [_match],
  'placements': <Object?>[],
};
const _activity = <String, dynamic>{'page': <Object?>[], 'isDone': true};

Map<String, dynamic> _activityItem(int index) => {
  'entry': {
    'kind': 'drinkLog',
    'id': 'activity-$index',
    'occurredAt': 2000 - index,
    'participantIds': ['owner'],
    'drinkLogId': 'log-$index',
    'userId': 'owner',
    'drinkId': 'beer',
    'drinkName': 'Drink $index',
    'drinkCategory': {'kind': 'beer'},
    'volumeMl': 500,
    'alcoholMl': 25,
    'baseDrinkScoreUnits': 25000,
    'classBonusScoreUnits': 2500,
    'scoreUnits': 27500,
  },
  'users': [
    {
      '_id': 'owner',
      'username': 'Owner',
      'accentColor': 'amber',
      'avatarUrl': null,
    },
  ],
};

class _Client implements ConvexRuntimeClient {
  final responses = <String, dynamic>{
    'session:get': _party,
    'user:current': _user,
    'sessionMember:listForSession': [
      {'member': _member('owner'), 'username': 'Owner'},
      {'member': _member('a'), 'username': 'Alice'},
    ],
    'party:standings': {
      'entries': [_standing],
    },
    'party:activity': _activity,
    'partyQuest:listForSession': [_quest],
    'partyQuest:get': _quest,
    'partyQuest:partners': [
      {
        '_id': 'a',
        'username': 'Alice',
        'accentColor': 'rose',
        'avatarUrl': null,
      },
    ],
    'partyChallenge:listForSession': [_challenge],
    'partyChallenge:get': _challenge,
    'beerpongTournament:listForSession': [_tournament],
    'beerpongTournament:get': _detail,
  };
  final requests = <({String name, Map<String, dynamic> args})>[];
  final _events = <String, StreamController<ConvexRuntimeQueryEvent>>{};
  final failNames = <String>{};
  final paginatedQueries = <FakeConvexPaginatedQuery>[];

  @override
  ConvexRuntimePaginatedQuery paginatedQuery(
    String name,
    Map<String, dynamic> args, {
    int pageSize = 20,
  }) {
    requests.add((name: name, args: args));
    final query = FakeConvexPaginatedQuery(name: name, pageSize: pageSize);
    final response = responses[name] as Map<String, dynamic>;
    query.emit(
      ConvexPaginatedResult(
        results: response['page'] as List<dynamic>,
        status: response['isDone'] == true
            ? ConvexPaginationStatus.exhausted
            : ConvexPaginationStatus.canLoadMore,
        isDone: response['isDone'] == true,
      ),
    );
    paginatedQueries.add(query);
    return query;
  }

  var last = (name: '', args: <String, dynamic>{});

  void emit(String name) =>
      _events[name]?.add(ConvexRuntimeQuerySuccess(responses[name]));
  @override
  Future<void> dispose() async {
    for (final query in paginatedQueries) {
      query.cancel();
    }
    for (final stream in _events.values) {
      await stream.close();
    }
  }

  @override
  ConvexConnectionState get currentConnectionState =>
      ConvexConnectionState.connected;
  @override
  ConvexRuntimeSubscription subscribe(
    String name, [
    Map<String, dynamic> args = const {},
  ]) {
    requests.add((name: name, args: args));
    // Closed by dispose.
    // ignore: close_sinks
    final events = _events.putIfAbsent(
      name,
      StreamController<ConvexRuntimeQueryEvent>.broadcast,
    );
    return _Subscription(
      Stream.multi((controller) {
        controller.add(ConvexRuntimeQuerySuccess(responses[name]));
        final subscription = events.stream.listen(controller.add);
        controller.onCancel = subscription.cancel;
      }),
    );
  }

  @override
  Future<dynamic> mutate(
    String name, [
    Map<String, dynamic> args = const {},
    OptimisticUpdate? optimisticUpdate,
  ]) async {
    last = (name: name, args: args);
    if (failNames.contains(name)) throw Exception('Server rejected request');
    return name == 'partyQuest:selectPartner' ? true : null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Subscription implements ConvexRuntimeSubscription {
  _Subscription(this.stream);
  @override
  final Stream<ConvexRuntimeQueryEvent> stream;
  @override
  void cancel() {}
}
