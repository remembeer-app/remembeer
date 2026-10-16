import 'package:dartvex/dartvex.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/party.dart' as party;

void main() {
  test('activity encodes filters and cursor and decodes both variants', () async {
    final caller = _Caller();
    final api = ConvexApi(caller).party;
    final result = await api.activity(
      sessionId: const SessionId('party'),
      cursor: const Optional.of((id: 'previous', occurredAt: 2000.0)),
      kinds: const Optional.of([
        party.ActivityArgsKindsItem.drinkLogValue,
        party.ActivityArgsKindsItem.socialQuestValue,
      ]),
      participantIds: const Optional.of([UserId('a'), UserId('b')]),
      pageSize: const Optional.of(2),
    );
    expect(caller.name, 'party:activity');
    expect(caller.args, <String, dynamic>{
      'sessionId': 'party',
      'cursor': {'id': 'previous', 'occurredAt': 2000.0},
      'kinds': ['drinkLog', 'socialQuest'],
      'participantIds': ['a', 'b'],
      'pageSize': 2.0,
    });
    final drink = result.entries.first as party.DrinkLog;
    expect(drink.id, 'drink-entry');
    expect(drink.drinkLogId, const DrinkLogId('log'));
    expect(drink.userId, const UserId('a'));
    expect(drink.participantIds, [const UserId('a')]);
    expect(drink.drinkId, const DrinkId('beer'));
    expect(drink.drinkName, 'Beer');
    expect(drink.drinkCategory, const Beer());
    expect(drink.occurredAt, 1500);
    expect(drink.volumeMl, 500);
    expect(drink.alcoholMl, 25);
    expect(drink.baseDrinkScoreUnits, 25000);
    expect(drink.classBonusScoreUnits, 2500);
    expect(drink.scoreUnits, 27500);
    final quest = result.entries.last as party.SocialQuest;
    expect(quest.id, 'quest-entry');
    expect(quest.questId, const PartyQuestId('quest'));
    expect(quest.questTitle, 'Toast');
    expect(quest.firstUserId, const UserId('a'));
    expect(quest.secondUserId, const UserId('b'));
    expect(quest.participantIds, [const UserId('a'), const UserId('b')]);
    expect(quest.occurredAt, 1000);
    expect(quest.scoreUnits, 25000);
    expect(result.users.single.id, const UserId('a'));
    expect(result.users.single.username, 'Alice');
    expect(result.users.single.avatarUrl, isNull);
    expect(result.hasMore, isTrue);
    expect(result.nextCursor, (id: 'quest-entry', occurredAt: 1000.0));
    // Exercise generated result encoding as well as decoding for both union arms.
    expect(api.activityQuery.encodeResult(result), _page);
    final decodedArgs = api.activityQuery.decodeArgs(caller.args!);
    expect(api.activityQuery.encode(decodedArgs), caller.args);
  });

  test('activity decodes challenge awards and encodes their filter', () async {
    final caller = _Caller()
      ..response = {
        'entries': [
          {
            'kind': 'partyChallenge',
            'id': 'award',
            'occurredAt': 1500.0,
            'participantIds': ['a'],
            'challengeId': 'challenge',
            'challengeTitle': 'Dance',
            'userId': 'a',
            'scoreUnits': 10000.0,
          },
        ],
        'users': <dynamic>[],
        'hasMore': false,
        'nextCursor': null,
      };
    final api = ConvexApi(caller).party;
    final result = await api.activity(
      sessionId: const SessionId('party'),
      kinds: const Optional.of([
        party.ActivityArgsKindsItem.partyChallengeValue,
      ]),
    );
    final award = result.entries.single as party.PartyChallenge;
    expect(award.challengeId, const PartyChallengeId('challenge'));
    expect(award.userId, const UserId('a'));
    expect(award.scoreUnits, 10000);
    expect(caller.args?['kinds'], ['partyChallenge']);
    expect(api.activityQuery.encodeResult(result), caller.response);
  });

  test(
    'activity omits absent options and decodes an exhausted empty page',
    () async {
      final caller = _Caller()
        ..response = {
          'entries': <dynamic>[],
          'users': <dynamic>[],
          'hasMore': false,
          'nextCursor': null,
        };
      final result = await ConvexApi(
        caller,
      ).party.activity(sessionId: const SessionId('party'));
      expect(caller.args, <String, dynamic>{'sessionId': 'party'});
      expect(result.entries, isEmpty);
      expect(result.users, isEmpty);
      expect(result.hasMore, isFalse);
      expect(result.nextCursor, isNull);
    },
  );
}

class _Caller implements ConvexFunctionCaller {
  String? name;
  Map<String, dynamic>? args;
  Map<String, dynamic> response = _page;

  @override
  Future<dynamic> query(String name, [Map<String, dynamic>? args]) async {
    this.name = name;
    this.args = args;
    return response;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _page = <String, dynamic>{
  'entries': [
    {
      'kind': 'drinkLog',
      'id': 'drink-entry',
      'occurredAt': 1500,
      'participantIds': ['a'],
      'drinkLogId': 'log',
      'userId': 'a',
      'drinkId': 'beer',
      'drinkName': 'Beer',
      'drinkCategory': {'kind': 'beer'},
      'volumeMl': 500,
      'alcoholMl': 25,
      'baseDrinkScoreUnits': 25000,
      'classBonusScoreUnits': 2500,
      'scoreUnits': 27500,
    },
    {
      'kind': 'socialQuest',
      'id': 'quest-entry',
      'occurredAt': 1000,
      'participantIds': ['a', 'b'],
      'questId': 'quest',
      'questTitle': 'Toast',
      'firstUserId': 'a',
      'secondUserId': 'b',
      'scoreUnits': 25000,
    },
  ],
  'users': [
    {
      '_id': 'a',
      'username': 'Alice',
      'accentColor': 'amber',
      'avatarUrl': null,
    },
  ],
  'hasMore': true,
  'nextCursor': {'id': 'quest-entry', 'occurredAt': 1000},
};
