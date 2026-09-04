import 'package:flutter/foundation.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/party/controller/party_event_controller.dart';
import 'package:remembeer/party/controller/party_game_controller.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class PartyChallengeDetailState {
  const PartyChallengeDetailState({
    required this.challenge,
    required this.reversedWinnerIds,
  });

  final PartyChallenge? challenge;
  final Set<String> reversedWinnerIds;
}

class PartyChallengeService {
  PartyChallengeService({
    required this.partyController,
    required this.gameController,
    required this.eventController,
  });

  final PartyController partyController;
  final PartyGameController gameController;
  final PartyEventController eventController;

  Stream<List<PartyChallenge>> challengesStream(String sessionId) =>
      gameController.challengesStream(sessionId);

  Stream<PartyChallengeDetailState> challengeStateStream(
    String sessionId,
    String challengeId,
  ) => Rx.combineLatest2(
    gameController.challengeStream(sessionId, challengeId),
    eventController.challengeEventsStream(
      sessionId: sessionId,
      challengeId: challengeId,
    ),
    (challenge, events) => PartyChallengeDetailState(
      challenge: challenge,
      reversedWinnerIds: _reversedWinnerIds(events),
    ),
  );

  Future<void> setModuleSettings(
    String sessionId,
    PartyModuleSettings settings,
  ) async {
    await partyController.setModuleSettings(
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
      settings: settings,
    );
  }

  Future<void> setQuestSchedule(
    String sessionId,
    PartyQuestSchedule schedule,
  ) async {
    await partyController.setQuestSchedule(
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
      schedule: schedule,
    );
  }

  Future<void> createChallenge({
    required String sessionId,
    required String title,
    required String instructions,
    required int points,
    required int durationMinutes,
  }) async {
    await gameController.invokeCommand(
      commandName: 'create_admin_challenge',
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
      data: {
        'challengeId': partyController.generateCommandId(),
        'title': title.trim(),
        'instructions': instructions.trim(),
        'pointsUnits': points * partyScoreUnitsPerPoint,
        'durationMinutes': durationMinutes,
      },
    );
  }

  Future<void> awardWinner(
    String sessionId,
    String challengeId,
    String winnerUserId,
  ) => _challengeCommand(
    'award_admin_challenge_winner',
    sessionId,
    challengeId,
    data: {'winnerUserId': winnerUserId},
  );

  Future<void> completeChallenge(String sessionId, String challengeId) =>
      _challengeCommand('complete_admin_challenge', sessionId, challengeId);

  Future<void> cancelChallenge(String sessionId, String challengeId) =>
      _challengeCommand('cancel_admin_challenge', sessionId, challengeId);

  Future<void> reverseWinner(
    String sessionId,
    String challengeId,
    String winnerUserId,
  ) => _challengeCommand(
    'reverse_admin_challenge_winner',
    sessionId,
    challengeId,
    data: {'winnerUserId': winnerUserId},
  );

  Future<void> _challengeCommand(
    String commandName,
    String sessionId,
    String challengeId, {
    Map<String, Object?> data = const {},
  }) async {
    await gameController.invokeCommand(
      commandName: commandName,
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
      data: {...data, 'challengeId': challengeId},
    );
  }
}

Set<String> _reversedWinnerIds(List<PartyEvent> events) {
  final awardsById = {
    for (final event in events)
      if (event.kind == PartyEventKind.adminChallenge) event.id: event,
  };
  return Set.unmodifiable(
    events
        .where((event) => event.kind == PartyEventKind.reversal)
        .map((event) => awardsById[event.reversesEventId]?.recipientUserId)
        .whereType<String>(),
  );
}
