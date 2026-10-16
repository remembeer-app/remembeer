import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/party.dart' as party;

void main() {
  final query = party.activityPaginatedQueryReference;

  test(
    'activity encodes typed filters without exposing pagination options',
    () {
      expect(query.name, 'party:activity');
      expect(
        query.encode((
          sessionId: const SessionId('party'),
          kinds: const Optional.of([
            party.ActivityArgsKindsItem.drinkLogValue,
            party.ActivityArgsKindsItem.socialQuestValue,
          ]),
          participantIds: const Optional.of([UserId('a'), UserId('b')]),
        )),
        {
          'sessionId': 'party',
          'kinds': ['drinkLog', 'socialQuest'],
          'participantIds': ['a', 'b'],
        },
      );
      expect(
        query.encode((
          sessionId: const SessionId('party'),
          kinds: const Optional.absent(),
          participantIds: const Optional.absent(),
        )),
        {'sessionId': 'party'},
      );
    },
  );

  test('activity decodes drink items with their page-local profiles', () {
    final item = query.decodeItem({
      'entry': {
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
      'users': [
        {
          '_id': 'a',
          'username': 'Alice',
          'accentColor': 'amber',
          'avatarUrl': null,
        },
      ],
    });
    final drink = item.entry as party.DrinkLog;
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
    expect(item.users.single.id, const UserId('a'));
    expect(item.users.single.username, 'Alice');
    expect(item.users.single.avatarUrl, isNull);
  });

  test('activity decodes quest, challenge and beerpong items', () {
    final quest =
        query.decodeItem({
              'entry': {
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
              'users': <Object?>[],
            }).entry
            as party.SocialQuest;
    expect(quest.questId, const PartyQuestId('quest'));
    expect(quest.questTitle, 'Toast');
    expect(quest.firstUserId, const UserId('a'));
    expect(quest.secondUserId, const UserId('b'));
    expect(quest.scoreUnits, 25000);
    final challenge =
        query.decodeItem({
              'entry': {
                'kind': 'partyChallenge',
                'id': 'challenge-entry',
                'occurredAt': 1500,
                'participantIds': ['a'],
                'challengeId': 'challenge',
                'challengeTitle': 'Dance',
                'userId': 'a',
                'scoreUnits': 10000,
              },
              'users': <Object?>[],
            }).entry
            as party.PartyChallenge;
    expect(challenge.challengeId, const PartyChallengeId('challenge'));
    expect(challenge.userId, const UserId('a'));
    expect(challenge.scoreUnits, 10000);
    final beerpong =
        query.decodeItem({
              'entry': {
                'kind': 'beerpongPlacement',
                'id': 'beerpong-entry',
                'occurredAt': 2000,
                'participantIds': ['a', 'b'],
                'tournamentId': 'tournament',
                'tournamentName': 'Friday cup',
                'teamId': 'team',
                'teamName': 'The Bees',
                'placement': 1,
                'userId': 'a',
                'scoreUnits': 15001,
              },
              'users': <Object?>[],
            }).entry
            as party.BeerpongPlacement;
    expect(beerpong.tournamentId, const BeerpongTournamentId('tournament'));
    expect(beerpong.teamId, const BeerpongTeamId('team'));
    expect(beerpong.placement, 1);
    expect(beerpong.participantIds, [const UserId('a'), const UserId('b')]);
    expect(beerpong.scoreUnits, 15001);
  });
}
