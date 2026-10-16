import 'package:dartvex/dartvex.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/convex_api/api.dart';

void main() {
  test('challenge API encodes edits and decodes embedded winners', () async {
    final caller = _Caller();
    final api = ConvexApi(caller).partyChallenge;
    const id = PartyChallengeId('challenge');
    final challenge = await api.getValue(id: id);
    expect(caller.name, 'partyChallenge:get');
    expect(caller.args, <String, dynamic>{'id': 'challenge'});
    expect(challenge.status, PartyChallengeDocumentStatus.completedValue);
    expect(challenge.winners.single.userId, const UserId('a'));
    expect(challenge.winners.single.awardedAt, 2000);
    await api.update(id: id, pointsUnits: const Optional.of(20000));
    expect(caller.name, 'partyChallenge:update');
    expect(caller.args, <String, dynamic>{
      'id': 'challenge',
      'pointsUnits': 20000.0,
    });
    await api.addWinner(id: id, userId: const UserId('a'));
    expect(caller.name, 'partyChallenge:addWinner');
    expect(caller.args, <String, dynamic>{'id': 'challenge', 'userId': 'a'});
    await api.removeWinner(id: id, userId: const UserId('a'));
    expect(caller.name, 'partyChallenge:removeWinner');
    final created = await api.create(
      durationMinutes: 5,
      instructions: 'Dance together',
      pointsUnits: 10000,
      sessionId: const SessionId('party'),
      title: 'Dance',
    );
    expect(created, id);
    expect(caller.name, 'partyChallenge:create');
    expect(caller.args, <String, dynamic>{
      'durationMinutes': 5.0,
      'instructions': 'Dance together',
      'pointsUnits': 10000.0,
      'sessionId': 'party',
      'title': 'Dance',
    });
  });
}

class _Caller implements ConvexFunctionCaller {
  String? name;
  Map<String, dynamic>? args;

  @override
  Future<dynamic> query(String name, [Map<String, dynamic>? args]) async {
    this.name = name;
    this.args = args;
    return <String, dynamic>{
      '_id': 'challenge',
      '_creationTime': 1000.0,
      'sessionId': 'party',
      'title': 'Dance',
      'instructions': 'Dance together',
      'pointsUnits': 10000.0,
      'startsAt': 1000.0,
      'endsAt': 301000.0,
      'status': 'completed',
      'createdByUserId': 'owner',
      'updatedAt': 2000.0,
      'winners': [
        {'userId': 'a', 'awardedAt': 2000.0},
      ],
    };
  }

  @override
  Future<dynamic> mutate(String name, [Map<String, dynamic>? args]) async {
    this.name = name;
    this.args = args;
    return name == 'partyChallenge:create' ? 'challenge' : null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
