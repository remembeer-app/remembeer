import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/party/controller/party_game_controller.dart';
import 'package:remembeer/party/model/beerpong_match.dart';
import 'package:remembeer/party/model/beerpong_team.dart';
import 'package:remembeer/party/model/beerpong_tournament.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class BeerpongDetailState {
  const BeerpongDetailState({
    required this.tournament,
    required this.teams,
    required this.matches,
  });

  final BeerpongTournament? tournament;
  final List<BeerpongTeam> teams;
  final List<BeerpongMatch> matches;
}

class BeerpongService {
  BeerpongService({
    required this.partyController,
    required this.gameController,
  });

  final PartyController partyController;
  final PartyGameController gameController;

  Stream<List<BeerpongTournament>> tournamentsStream(String sessionId) =>
      gameController.tournamentsStream(sessionId);

  Stream<List<PartyMember>> partyMembersStream(String sessionId) =>
      partyController.membersStream(sessionId);

  Stream<BeerpongDetailState> detailStateStream(
    String sessionId,
    String tournamentId,
  ) => Rx.combineLatest3(
    gameController.tournamentStream(sessionId, tournamentId),
    gameController.teamsStream(sessionId, tournamentId),
    gameController.matchesStream(sessionId, tournamentId),
    (tournament, teams, matches) => BeerpongDetailState(
      tournament: tournament,
      teams: teams,
      matches: matches,
    ),
  );

  Future<void> setOptIn({
    required String sessionId,
    required String tournamentId,
    required int expectedRevision,
    required bool optedIn,
  }) => _command(
    'set_beerpong_opt_in',
    sessionId,
    tournamentId,
    expectedRevision,
    {'optedIn': optedIn},
  );

  Future<void> createTournament({
    required String sessionId,
    required int teamCount,
    required bool thirdPlaceEnabled,
    required int firstPlacePoints,
    required int secondPlacePoints,
    required int thirdPlacePoints,
  }) async {
    final tournamentId = partyController.generateCommandId();
    await gameController.invokeCommand(
      commandName: 'create_beerpong_tournament',
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
      data: {
        'tournamentId': tournamentId,
        ..._settings(
          teamCount: teamCount,
          thirdPlaceEnabled: thirdPlaceEnabled,
          firstPlacePoints: firstPlacePoints,
          secondPlacePoints: secondPlacePoints,
          thirdPlacePoints: thirdPlacePoints,
        ),
        'randomSeedHash': _seedHash(tournamentId, 0),
      },
    );
  }

  Future<void> drawTournament({
    required String sessionId,
    required BeerpongTournament tournament,
  }) => _command(
    'draw_beerpong_tournament',
    sessionId,
    tournament.id,
    tournament.revision,
    {'randomSeedReveal': _committedSeedReveal(tournament)},
  );

  Future<void> redrawTournament({
    required String sessionId,
    required BeerpongTournament tournament,
  }) => _command(
    'redraw_beerpong_tournament',
    sessionId,
    tournament.id,
    tournament.revision,
    {
      'teamCount': tournament.teamCount,
      'thirdPlaceEnabled': tournament.thirdPlaceEnabled,
      'firstPlacePointsUnits': tournament.firstPlacePointsUnits,
      'secondPlacePointsUnits': tournament.secondPlacePointsUnits,
      'thirdPlacePointsUnits': tournament.thirdPlacePointsUnits,
      'randomSeedHash': _seedHash(tournament.id, tournament.revision + 1),
    },
  );

  Future<void> renameTeam({
    required String sessionId,
    required String tournamentId,
    required int expectedRevision,
    required String teamId,
    required String name,
  }) => _command(
    'rename_beerpong_team',
    sessionId,
    tournamentId,
    expectedRevision,
    {'teamId': teamId, 'name': name.trim()},
  );

  Future<void> recordResult({
    required String sessionId,
    required String tournamentId,
    required int expectedRevision,
    required String matchId,
    required String winnerTeamId,
  }) => _resultCommand(
    'record_beerpong_match_result',
    sessionId,
    tournamentId,
    expectedRevision,
    matchId,
    winnerTeamId,
  );

  Future<void> correctResult({
    required String sessionId,
    required String tournamentId,
    required int expectedRevision,
    required String matchId,
    required String winnerTeamId,
  }) => _resultCommand(
    'correct_beerpong_match_result',
    sessionId,
    tournamentId,
    expectedRevision,
    matchId,
    winnerTeamId,
  );

  Future<void> finalizeTournament({
    required String sessionId,
    required String tournamentId,
    required int expectedRevision,
  }) => _command(
    'finalize_beerpong_tournament',
    sessionId,
    tournamentId,
    expectedRevision,
  );

  Future<void> _resultCommand(
    String commandName,
    String sessionId,
    String tournamentId,
    int expectedRevision,
    String matchId,
    String winnerTeamId,
  ) => _command(commandName, sessionId, tournamentId, expectedRevision, {
    'matchId': matchId,
    'winnerTeamId': winnerTeamId,
  });

  Future<void> _command(
    String commandName,
    String sessionId,
    String tournamentId,
    int expectedRevision, [
    Map<String, Object?> data = const {},
  ]) async {
    await gameController.invokeCommand(
      commandName: commandName,
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
      data: {
        ...data,
        'tournamentId': tournamentId,
        'expectedRevision': expectedRevision,
      },
    );
  }

  Map<String, Object?> _settings({
    required int teamCount,
    required bool thirdPlaceEnabled,
    required int firstPlacePoints,
    required int secondPlacePoints,
    required int thirdPlacePoints,
  }) => {
    'teamCount': teamCount,
    'thirdPlaceEnabled': thirdPlaceEnabled,
    'firstPlacePointsUnits': firstPlacePoints * partyScoreUnitsPerPoint,
    'secondPlacePointsUnits': secondPlacePoints * partyScoreUnitsPerPoint,
    'thirdPlacePointsUnits': thirdPlacePoints * partyScoreUnitsPerPoint,
  };

  String _seedHash(String tournamentId, int revision) => sha256
      .convert(utf8.encode(_seedReveal(tournamentId, revision)))
      .toString();

  String _seedReveal(String tournamentId, int revision) =>
      '$tournamentId:$revision';

  String _committedSeedReveal(BeerpongTournament tournament) {
    for (var revision = tournament.revision; revision >= 0; revision--) {
      final reveal = _seedReveal(tournament.id, revision);
      if (sha256.convert(utf8.encode(reveal)).toString() ==
          tournament.randomSeedHash) {
        return reveal;
      }
    }
    throw StateError('Tournament seed commitment is invalid.');
  }
}
