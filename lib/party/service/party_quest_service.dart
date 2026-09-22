import 'package:flutter/foundation.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/party/controller/party_game_controller.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_quest.dart';
import 'package:remembeer/party/model/party_quest_selection.dart';
import 'package:remembeer/party/model/party_quest_template.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class PartyQuestDetailState {
  const PartyQuestDetailState({required this.quest, required this.selections});

  final PartyQuest? quest;
  final List<PartyQuestSelection> selections;

  PartyQuestSelection? selectionFor(String userId) => selections
      .where((selection) => selection.selectorUserId == userId)
      .firstOrNull;

  String? completedPartnerId(String userId) {
    final selection = selectionFor(userId);
    if (selection == null) {
      return null;
    }
    final reverse = selectionFor(selection.selectedUserId);
    final isMutual = reverse?.selectedUserId == userId;
    final isComplete =
        quest?.completedPairKeys.contains(
          partyQuestPairKey(userId, selection.selectedUserId),
        ) ??
        false;
    return isMutual && isComplete ? selection.selectedUserId : null;
  }
}

@immutable
class PartyQuestStartResult {
  const PartyQuestStartResult({required this.started, this.reason});

  final bool started;
  final String? reason;
}

class PartyQuestService {
  PartyQuestService({
    required this.partyController,
    required this.gameController,
  });

  final PartyController partyController;
  final PartyGameController gameController;

  Stream<List<PartyQuest>> questsStream(String sessionId) =>
      gameController.questsStream(sessionId);

  Stream<List<PartyQuestTemplate>> templatesStream(String sessionId) =>
      gameController.questTemplatesStream(sessionId);

  Stream<PartyQuestDetailState> questStateStream(
    String sessionId,
    String questId,
  ) => Rx.combineLatest2(
    gameController.questStream(sessionId, questId),
    gameController.questSelectionsStream(sessionId, questId),
    (quest, selections) =>
        PartyQuestDetailState(quest: quest, selections: selections),
  );

  Future<bool> selectPartner({
    required String sessionId,
    required String questId,
    required String selectedUserId,
  }) async {
    final result = await gameController.invokeCommand(
      commandName: 'select_quest_partner',
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
      data: {'questId': questId, 'selectedUserId': selectedUserId},
    );
    return result.data['matched'] == true;
  }

  Future<void> setSchedule(
    String sessionId,
    PartyQuestSchedule schedule,
  ) async {
    await gameController.invokeCommand(
      commandName: 'set_party_quest_schedule',
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
      data: {
        'questSchedule': {
          'minIntervalMinutes': schedule.minIntervalMinutes,
          'maxIntervalMinutes': schedule.maxIntervalMinutes,
          'defaultDurationMinutes': schedule.defaultDurationMinutes,
        },
      },
    );
  }

  Future<PartyQuestStartResult> startNextQuest(String sessionId) async {
    final result = await gameController.invokeCommand(
      commandName: 'start_next_party_quest',
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
    );
    final started = result.data['started'];
    if (started is! bool) {
      throw const FormatException(
        'The server returned an invalid start quest result.',
      );
    }
    final reason = result.data['reason'];
    if (reason != null && reason is! String) {
      throw const FormatException(
        'The server returned an invalid start quest reason.',
      );
    }
    return PartyQuestStartResult(started: started, reason: reason as String?);
  }

  Future<void> setTemplateEnabled(
    String sessionId,
    String templateId,
    bool enabled,
  ) => _templateCommand(
    'set_quest_template_enabled',
    sessionId,
    templateId,
    data: {'enabled': enabled},
  );

  Future<void> setTemplateDuration(
    String sessionId,
    String templateId,
    int? durationMinutes,
  ) => _templateCommand(
    'set_quest_template_duration',
    sessionId,
    templateId,
    data: {'durationMinutes': durationMinutes},
  );

  Future<void> _templateCommand(
    String commandName,
    String sessionId,
    String templateId, {
    Map<String, Object?> data = const {},
  }) async {
    await gameController.invokeCommand(
      commandName: commandName,
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
      data: {...data, 'templateId': templateId},
    );
  }
}

String partyQuestPairKey(String firstUserId, String secondUserId) {
  final ids = [firstUserId, secondUserId]..sort();
  return 'pair:${Uri.encodeComponent(ids[0])}:${Uri.encodeComponent(ids[1])}';
}
