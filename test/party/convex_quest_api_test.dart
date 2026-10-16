import 'package:dartvex/dartvex.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/convex_api/api.dart';

void main() {
  test(
    'generated quest mutations encode identifiers and decode outcomes',
    () async {
      final caller = _Caller();
      final quests = ConvexApi(caller).partyQuest;
      await quests.setEnabled(
        enabled: true,
        sessionId: const SessionId('party'),
      );
      expect(caller.calls.last.name, 'partyQuest:setEnabled');
      expect(caller.calls.last.args, <String, dynamic>{
        'enabled': true,
        'sessionId': 'party',
      });
      expect(
        await quests.startNext(sessionId: const SessionId('party')),
        const PartyQuestId('quest'),
      );
      expect(caller.calls.last.args, <String, dynamic>{'sessionId': 'party'});
      caller.nextQuestId = null;
      expect(
        await quests.startNext(sessionId: const SessionId('party')),
        isNull,
      );
      expect(
        await quests.selectPartner(
          questId: const PartyQuestId('quest'),
          selectedUserId: const UserId('b'),
        ),
        isFalse,
      );
      expect(caller.calls.last.name, 'partyQuest:selectPartner');
      expect(caller.calls.last.args, <String, dynamic>{
        'questId': 'quest',
        'selectedUserId': 'b',
      });
      caller.matched = true;
      expect(
        await quests.selectPartner(
          questId: const PartyQuestId('quest'),
          selectedUserId: const UserId('b'),
        ),
        isTrue,
      );
    },
  );

  test(
    'generated queries reuse quest unions with embedded selections and results',
    () async {
      final caller = _Caller();
      final quests = ConvexApi(caller).partyQuest;
      final quest = await quests.getValue(id: const PartyQuestId('quest'));
      expect(quest, isA<ToastWithClass>());
      expect((quest as ToastWithClass).drinkCategory, const Beer());
      expect(quest.results.single.firstUserId, const UserId('a'));
      expect(quest.results.single.secondUserId, const UserId('b'));
      expect(quest.results.single.completedAt, 1500);
      expect(quest.selections.single.userId, const UserId('a'));
      final history = await quests.listForSession(
        sessionId: const SessionId('party'),
      );
      expect(history.single.id, quest.id);
      expect(history.single.results, quest.results);
    },
  );
}

class _Caller implements ConvexFunctionCaller {
  final calls = <({String name, Map<String, dynamic> args})>[];
  String? nextQuestId = 'quest';
  var matched = false;

  @override
  Future<dynamic> mutate(String name, [Map<String, dynamic>? args]) async {
    calls.add((name: name, args: args ?? const {}));
    return switch (name) {
      'partyQuest:startNext' => nextQuestId,
      'partyQuest:selectPartner' => matched,
      _ => null,
    };
  }

  @override
  Future<dynamic> query(String name, [Map<String, dynamic>? args]) async {
    calls.add((name: name, args: args ?? const {}));
    return name == 'partyQuest:get' ? _quest : [_quest];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _quest = <String, dynamic>{
  '_id': 'quest',
  '_creationTime': 1000,
  'kind': 'toastWithClass',
  'drinkCategory': {'kind': 'beer'},
  'sessionId': 'party',
  'title': 'Toast with a Beer Paladin',
  'instructions': 'Have a toast together.',
  'pointsUnits': 30000,
  'startsAt': 1000,
  'endsAt': 2000,
  'updatedAt': 1500,
  'status': 'active',
  'selections': [
    {'userId': 'a', 'selectedUserId': 'b', 'selectedAt': 1200},
  ],
  'results': [
    {'firstUserId': 'a', 'secondUserId': 'b', 'completedAt': 1500},
  ],
};
