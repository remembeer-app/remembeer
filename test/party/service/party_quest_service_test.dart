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
    gameController.result = const PartyCommandResult({
      'started': false,
      'reason': 'noEnabledTemplates',
    });
    final startResult = await service.startNextQuest('session-1');

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
    expect(gameController.calls[2], {
      'commandName': 'start_next_party_quest',
      'sessionId': 'session-1',
      'commandId': 'command-3',
      'data': <String, Object?>{},
    });
    expect(startResult.started, isFalse);
    expect(startResult.reason, 'noEnabledTemplates');
  });

  test('rejects malformed start quest results', () async {
    final gameController = _FakeGameController()
      ..result = const PartyCommandResult({'reason': 'noEnabledTemplates'});
    final service = PartyQuestService(
      partyController: _FakePartyController(),
      gameController: gameController,
    );

    await expectLater(
      service.startNextQuest('session-1'),
      throwsA(isA<FormatException>()),
    );
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
  var result = const PartyCommandResult({'matched': true});

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
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
