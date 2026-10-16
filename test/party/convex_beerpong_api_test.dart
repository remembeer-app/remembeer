import 'package:dartvex/dartvex.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/beerpongTournament.dart'
    as beerpong;

void main() {
  test(
    'tournament list decodes shared documents and encodes the session',
    () async {
      final caller = _Caller([_tournament]);
      final api = ConvexApi(caller).beerpongTournament;
      final result = await api.listForSession(
        sessionId: const SessionId('party'),
      );
      expect(caller.name, 'beerpongTournament:listForSession');
      expect(caller.args, <String, dynamic>{'sessionId': 'party'});
      expect(result.single.id, const BeerpongTournamentId('tournament'));
      expect(
        result.single.status,
        BeerpongTournamentDocumentStatus.activeValue,
      );
      expect(result.single.name, 'Friday cup');
      expect(api.listForSessionQuery.encodeResult(result), [_tournament]);
    },
  );

  test(
    'detail decodes both slot aliases, byes and partially resolved matches',
    () async {
      final caller = _Caller(_detail);
      final api = ConvexApi(caller).beerpongTournament;
      final result = await api.getValue(
        id: const BeerpongTournamentId('tournament'),
      );
      expect(caller.name, 'beerpongTournament:get');
      expect(caller.args, <String, dynamic>{'id': 'tournament'});
      expect(result.tournament.id, const BeerpongTournamentId('tournament'));
      expect(result.teams.single.memberUserIds, [const UserId('a')]);
      final bye = result.matches.first;
      expect(bye.slotA, isA<Team>());
      expect((bye.slotA as Team).teamId, const BeerpongTeamId('team'));
      expect(bye.slotB, isA<Bye>());
      expect(bye.status, beerpong.GetTypeResultMatchesItemStatus.byeValue);
      expect(bye.teamAId, const BeerpongTeamId('team'));
      expect(bye.teamBId, isNull);
      final pending = result.matches.last;
      expect(pending.slotA, isA<Winner>());
      expect((pending.slotA as Winner).matchId, const BeerpongMatchId('bye'));
      expect(pending.slotB, isA<Loser>());
      expect(
        pending.status,
        beerpong.GetTypeResultMatchesItemStatus.pendingValue,
      );
      expect(pending.teamAId, const BeerpongTeamId('team'));
      expect(pending.teamBId, isNull);
      expect(result.placements, isEmpty);
      expect(api.getValueQuery.encodeResult(result), _detail);
    },
  );

  test(
    'detail decodes final placements without awarding points in the response',
    () async {
      final raw = <String, dynamic>{
        ..._detail,
        'tournament': {
          ..._tournament,
          'status': 'completed',
          'completedAt': 3000.0,
        },
        'placements': [
          {'teamId': 'team', 'placement': 1.0},
          {'teamId': 'other-team', 'placement': 2.0},
        ],
      };
      final api = ConvexApi(_Caller(raw)).beerpongTournament;
      final result = await api.getValue(
        id: const BeerpongTournamentId('tournament'),
      );
      expect(
        result.tournament.status,
        BeerpongTournamentDocumentStatus.completedValue,
      );
      expect(result.placements.first.teamId, const BeerpongTeamId('team'));
      expect(result.placements.first.placement, 1);
      expect(result.placements.last.placement, 2);
      expect(api.getValueQuery.encodeResult(result), raw);
    },
  );
}

class _Caller implements ConvexFunctionCaller {
  _Caller(this.response);

  final Object response;
  String? name;
  Map<String, dynamic>? args;

  @override
  Future<dynamic> query(String name, [Map<String, dynamic>? args]) async {
    this.name = name;
    this.args = args;
    return response;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _tournament = <String, dynamic>{
  '_id': 'tournament',
  '_creationTime': 1000.0,
  'sessionId': 'party',
  'name': 'Friday cup',
  'status': 'active',
  'teamCount': 3.0,
  'thirdPlaceEnabled': false,
  'firstPlacePointsUnits': 30000.0,
  'secondPlacePointsUnits': 20000.0,
  'thirdPlacePointsUnits': 10000.0,
  'createdByUserId': 'owner',
  'updatedAt': 2000.0,
  'completedAt': null,
};

const _detail = <String, dynamic>{
  'tournament': _tournament,
  'teams': [
    {
      '_id': 'team',
      '_creationTime': 1500.0,
      'tournamentId': 'tournament',
      'name': 'The Bees',
      'memberUserIds': ['a'],
      'updatedAt': 1500.0,
    },
  ],
  'matches': [
    {
      '_id': 'bye',
      '_creationTime': 2000.0,
      'tournamentId': 'tournament',
      'round': 1.0,
      'position': 1.0,
      'kind': 'main',
      'slotA': {'kind': 'team', 'teamId': 'team'},
      'slotB': {'kind': 'bye'},
      'winnerTeamId': 'team',
      'completedAt': 2000.0,
      'updatedAt': 2000.0,
      'teamAId': 'team',
      'teamBId': null,
      'status': 'bye',
    },
    {
      '_id': 'pending',
      '_creationTime': 2000.0,
      'tournamentId': 'tournament',
      'round': 2.0,
      'position': 1.0,
      'kind': 'main',
      'slotA': {'kind': 'winner', 'matchId': 'bye'},
      'slotB': {'kind': 'loser', 'matchId': 'other-match'},
      'winnerTeamId': null,
      'completedAt': null,
      'updatedAt': 2000.0,
      'teamAId': 'team',
      'teamBId': null,
      'status': 'pending',
    },
  ],
  'placements': <dynamic>[],
};
