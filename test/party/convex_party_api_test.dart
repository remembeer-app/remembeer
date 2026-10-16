import 'package:dartvex/dartvex.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/convex_api/api.dart';

void main() {
  test(
    'party standings encode refresh time and decode scores and profiles',
    () async {
      final caller = _Caller();
      final party = ConvexApi(caller).party;
      final result = await party.standings(
        sessionId: const SessionId('party'),
        refreshAt: const Optional.of(1000),
      );
      expect(caller.name, 'party:standings');
      expect(caller.args, <String, dynamic>{
        'sessionId': 'party',
        'refreshAt': 1000.0,
      });
      final entry = result.entries.first;
      expect(entry.userId, const UserId('a'));
      expect(entry.user?.username, 'Alice');
      expect(entry.selectedClass, const Beer());
      expect(entry.rank, 1);
      expect(entry.scoreUnits, 52500);
      expect(entry.baseDrinkScoreUnits, 25000);
      expect(entry.classBonusScoreUnits, 2500);
      expect(entry.questScoreUnits, 25000);
      expect(entry.completedQuestCount, 1);
      expect(entry.drinkCount, 1);
      expect(entry.volumeMl, 500);
      expect(entry.alcoholMl, 25);
      expect(result.entries.last.user, isNull);
      expect(result.entries.last.selectedClass, isNull);
      expect(result.nextRefreshAt, 2000);

      caller.nextRefreshAt = null;
      final refreshed = await party.standings(
        sessionId: const SessionId('party'),
      );
      expect(caller.args, <String, dynamic>{'sessionId': 'party'});
      expect(refreshed.nextRefreshAt, isNull);
    },
  );
}

class _Caller implements ConvexFunctionCaller {
  String? name;
  Map<String, dynamic>? args;
  int? nextRefreshAt = 2000;

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
      'nextRefreshAt': nextRefreshAt,
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
  'completedQuestCount': 1,
  'drinkCount': 1,
  'volumeMl': 500,
  'alcoholMl': 25,
};
