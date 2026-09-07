import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/controller/party_command_client.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/party/controller/party_game_controller.dart';
import 'package:remembeer/party/model/beerpong_tournament.dart';
import 'package:remembeer/party/service/beerpong_service.dart';

void main() {
  test(
    'create command sends the exact P19 settings and seed payload',
    () async {
      final calls = <_Call>[];
      final client = _client(calls);
      final service = BeerpongService(
        partyController: _FixedIdPartyController(client),
        gameController: PartyGameController(commandClient: client),
      );

      await service.createTournament(
        sessionId: 'session-1',
        teamCount: 4,
        thirdPlaceEnabled: true,
        firstPlacePoints: 100,
        secondPlacePoints: 50,
        thirdPlacePoints: 25,
      );

      expect(calls.single.name, 'create_beerpong_tournament');
      expect(calls.single.data, {
        'tournamentId': 'id-1',
        'teamCount': 4,
        'thirdPlaceEnabled': true,
        'firstPlacePointsUnits': 100000,
        'secondPlacePointsUnits': 50000,
        'thirdPlacePointsUnits': 25000,
        'randomSeedHash': sha256.convert(utf8.encode('id-1:0')).toString(),
        'sessionId': 'session-1',
        'commandId': 'id-2',
      });
    },
  );

  test(
    'result and opt-in commands include tournament revision fields',
    () async {
      final calls = <_Call>[];
      final client = _client(calls);
      final service = BeerpongService(
        partyController: _FixedIdPartyController(client),
        gameController: PartyGameController(commandClient: client),
      );

      await service.setOptIn(
        sessionId: 'session-1',
        tournamentId: 'tournament-1',
        expectedRevision: 7,
        optedIn: true,
      );
      await service.recordResult(
        sessionId: 'session-1',
        tournamentId: 'tournament-1',
        expectedRevision: 8,
        matchId: 'match-1',
        winnerTeamId: 'team-1',
      );

      expect(calls[0].data, {
        'optedIn': true,
        'tournamentId': 'tournament-1',
        'expectedRevision': 7,
        'sessionId': 'session-1',
        'commandId': 'id-1',
      });
      expect(calls[1].data, {
        'matchId': 'match-1',
        'winnerTeamId': 'team-1',
        'tournamentId': 'tournament-1',
        'expectedRevision': 8,
        'sessionId': 'session-1',
        'commandId': 'id-2',
      });
    },
  );

  test('admin lifecycle commands match every P19 payload', () async {
    final calls = <_Call>[];
    final client = _client(calls);
    final service = BeerpongService(
      partyController: _FixedIdPartyController(client),
      gameController: PartyGameController(commandClient: client),
    );
    final tournament = BeerpongTournament(
      id: 'tournament-1',
      status: BeerpongTournamentStatus.active,
      teamCount: 4,
      thirdPlaceEnabled: true,
      firstPlacePointsUnits: 100000,
      secondPlacePointsUnits: 50000,
      thirdPlacePointsUnits: 25000,
      revision: 3,
      randomSeedHash: sha256.convert(utf8.encode('tournament-1:0')).toString(),
      createdByUserId: 'admin-1',
      createdAt: DateTime.utc(2026),
    );

    await service.drawTournament(
      sessionId: 'session-1',
      tournament: tournament,
    );
    await service.redrawTournament(
      sessionId: 'session-1',
      tournament: tournament,
    );
    await service.renameTeam(
      sessionId: 'session-1',
      tournamentId: tournament.id,
      expectedRevision: 4,
      teamId: 'team-1',
      name: '  Winners  ',
    );
    await service.correctResult(
      sessionId: 'session-1',
      tournamentId: tournament.id,
      expectedRevision: 5,
      matchId: 'match-1',
      winnerTeamId: 'team-2',
    );
    await service.finalizeTournament(
      sessionId: 'session-1',
      tournamentId: tournament.id,
      expectedRevision: 6,
    );

    expect(calls[0].name, 'draw_beerpong_tournament');
    expect(calls[0].data, {
      'randomSeedReveal': 'tournament-1:0',
      'tournamentId': 'tournament-1',
      'expectedRevision': 3,
      'sessionId': 'session-1',
      'commandId': 'id-1',
    });
    expect(calls[1].name, 'redraw_beerpong_tournament');
    expect(calls[1].data, {
      'teamCount': 4,
      'thirdPlaceEnabled': true,
      'firstPlacePointsUnits': 100000,
      'secondPlacePointsUnits': 50000,
      'thirdPlacePointsUnits': 25000,
      'randomSeedHash': sha256
          .convert(utf8.encode('tournament-1:4'))
          .toString(),
      'tournamentId': 'tournament-1',
      'expectedRevision': 3,
      'sessionId': 'session-1',
      'commandId': 'id-2',
    });
    expect(calls[2].data, {
      'teamId': 'team-1',
      'name': 'Winners',
      'tournamentId': 'tournament-1',
      'expectedRevision': 4,
      'sessionId': 'session-1',
      'commandId': 'id-3',
    });
    expect(calls[3].name, 'correct_beerpong_match_result');
    expect(calls[3].data, {
      'matchId': 'match-1',
      'winnerTeamId': 'team-2',
      'tournamentId': 'tournament-1',
      'expectedRevision': 5,
      'sessionId': 'session-1',
      'commandId': 'id-4',
    });
    expect(calls[4].name, 'finalize_beerpong_tournament');
    expect(calls[4].data, {
      'tournamentId': 'tournament-1',
      'expectedRevision': 6,
      'sessionId': 'session-1',
      'commandId': 'id-5',
    });
  });
}

PartyCommandClient _client(List<_Call> calls) => PartyCommandClient(
  invoker: (name, data) async {
    calls.add(_Call(name, data));
    return <String, Object?>{};
  },
);

class _Call {
  const _Call(this.name, this.data);

  final String name;
  final Map<String, Object?> data;
}

class _FixedIdPartyController extends PartyController {
  _FixedIdPartyController(PartyCommandClient client)
    : super(commandClient: client);

  var _nextId = 1;

  @override
  String generateCommandId() => 'id-${_nextId++}';
}
