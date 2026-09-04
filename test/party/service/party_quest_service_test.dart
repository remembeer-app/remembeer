import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/controller/party_command_client.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/party/controller/party_game_controller.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_quest.dart';
import 'package:remembeer/party/model/party_quest_selection.dart';
import 'package:remembeer/party/service/party_quest_service.dart';

void main() {
  test('sends quest commands with server contract fields', () async {
    final gameController = _FakeGameController();
    final service = PartyQuestService(
      partyController: _FakePartyController(),
      gameController: gameController,
    );

    final matched = await service.selectPartner(
      sessionId: 'session-1',
      questId: 'quest-1',
      selectedUserId: 'user-2',
    );
    await service.setSchedule(
      'session-1',
      const PartyQuestSchedule(
        minIntervalMinutes: 5,
        maxIntervalMinutes: 30,
        defaultDurationMinutes: 10,
      ),
    );
    await service.createTemplate(
      sessionId: 'session-1',
      title: '  Toast  ',
      instructions: '  Find a partner.  ',
      points: 25,
      durationMinutes: 10,
    );

    expect(matched, isTrue);
    expect(gameController.calls[0], {
      'commandName': 'select_quest_partner',
      'sessionId': 'session-1',
      'commandId': 'command-1',
      'data': {'questId': 'quest-1', 'selectedUserId': 'user-2'},
    });
    expect(gameController.calls[1]['commandName'], 'set_party_quest_schedule');
    expect(gameController.calls[1]['data'], {
      'questSchedule': {
        'minIntervalMinutes': 5,
        'maxIntervalMinutes': 30,
        'defaultDurationMinutes': 10,
      },
    });
    expect(
      gameController.calls[2]['commandName'],
      'create_custom_quest_template',
    );
    expect(gameController.calls[2]['data'], {
      'title': 'Toast',
      'instructions': 'Find a partner.',
      'pointsUnits': 25000,
      'durationMinutes': 10,
      'templateId': 'command-3',
    });
  });

  test('derives pending and completed mutual selection states', () {
    final now = DateTime.utc(2026);
    final pending = PartyQuestDetailState(
      quest: _quest(now),
      selections: [_selection('a', 'b', now)],
    );
    final complete = PartyQuestDetailState(
      quest: _quest(now, completedPairKeys: [partyQuestPairKey('a', 'b')]),
      selections: [_selection('a', 'b', now), _selection('b', 'a', now)],
    );

    expect(pending.selectionFor('a')?.selectedUserId, 'b');
    expect(pending.completedPartnerId('a'), isNull);
    expect(complete.completedPartnerId('a'), 'b');
    expect(partyQuestPairKey('b', 'a'), partyQuestPairKey('a', 'b'));
  });
}

PartyQuest _quest(DateTime now, {List<String> completedPairKeys = const []}) =>
    PartyQuest(
      id: 'quest-1',
      templateId: 'template-1',
      titleSnapshot: 'Quest',
      instructionsSnapshot: 'Choose.',
      pointsUnits: 25000,
      startsAt: now,
      endsAt: now.add(const Duration(minutes: 5)),
      status: PartyQuestStatus.active,
      eligibleMemberIds: const ['a', 'b'],
      completedPairKeys: completedPairKeys,
      createdAt: now,
    );

PartyQuestSelection _selection(
  String selectorUserId,
  String selectedUserId,
  DateTime now,
) => PartyQuestSelection(
  id: selectorUserId,
  selectorUserId: selectorUserId,
  selectedUserId: selectedUserId,
  selectedAt: now,
);

class _FakePartyController implements PartyController {
  var _nextId = 0;

  @override
  String generateCommandId() => 'command-${++_nextId}';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeGameController implements PartyGameController {
  final calls = <Map<String, Object?>>[];

  @override
  Future<PartyCommandResult> invokeCommand({
    required String commandName,
    required String sessionId,
    required String commandId,
    Map<String, Object?> data = const {},
  }) async {
    calls.add({
      'commandName': commandName,
      'sessionId': sessionId,
      'commandId': commandId,
      'data': data,
    });
    return const PartyCommandResult({'matched': true});
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
