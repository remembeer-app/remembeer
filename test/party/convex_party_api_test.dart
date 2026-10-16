import 'package:dartvex/dartvex.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/convex_api/api.dart';

void main() {
  test(
    'party standings encode the session and decode scores and profiles',
    () async {
      final caller = _Caller();
      final party = ConvexApi(caller).party;
      final result = await party.standings(sessionId: const SessionId('party'));
      expect(caller.name, 'party:standings');
      expect(caller.args, <String, dynamic>{'sessionId': 'party'});
      final entry = result.entries.first;
      expect(entry.userId, const UserId('a'));
      expect(entry.user?.username, 'Alice');
      expect(entry.selectedClass, const Beer());
      expect(entry.rank, 1);
      expect(entry.scoreUnits, 52500);
      expect(entry.baseDrinkScoreUnits, 25000);
      expect(entry.classBonusScoreUnits, 2500);
      expect(entry.questScoreUnits, 25000);
      expect(entry.challengeScoreUnits, 0);
      expect(entry.wonChallengeCount, 0);
      expect(entry.completedQuestCount, 1);
      expect(entry.drinkCount, 1);
      expect(entry.volumeMl, 500);
      expect(entry.alcoholMl, 25);
      expect(result.entries.last.user, isNull);
      expect(result.entries.last.selectedClass, isNull);
    },
  );
}

class _Caller implements ConvexFunctionCaller {
  String? name;
  Map<String, dynamic>? args;

  @override
  Future<dynamic> query(String name, [Map<String, dynamic>? args]) async {
    this.name = name;
    this.args = args;
    return <String, dynamic>{
      'entries': [
        _entry,
        {
          ..._entry,
          'userId': 'removed-user',
          'user': null,
          'selectedClass': null,
        },
      ],
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _entry = <String, dynamic>{
  'userId': 'a',
  'user': {
    '_id': 'a',
    'username': 'Alice',
    'accentColor': 'amber',
    'avatarUrl': null,
  },
  'selectedClass': {'kind': 'beer'},
  'rank': 1,
  'scoreUnits': 52500,
  'baseDrinkScoreUnits': 25000,
  'classBonusScoreUnits': 2500,
  'questScoreUnits': 25000,
  'challengeScoreUnits': 0,
  'wonChallengeCount': 0,
  'completedQuestCount': 1,
  'drinkCount': 1,
  'volumeMl': 500,
  'alcoholMl': 25,
};
