import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/model/party_drink_command_result.dart';
import 'package:remembeer/party/controller/party_command_client.dart';

void main() {
  test('maps Party drink callable result', () {
    final result = PartyDrinkCommandResult.fromMutation(
      const PartyCommandResult({
        'sessionId': 'party-1',
        'drink': {'id': 'drink-1'},
        'awardEventId': 'award-1',
        'baseScoreUnits': 1000,
        'classBonusUnits': 100,
        'awardedScoreUnits': 1100,
        'unlockedBadgeIds': <String>[],
      }),
    );

    expect(result.sessionId, 'party-1');
    expect(result.drinkId, 'drink-1');
    expect(result.awardEventId, 'award-1');
    expect(result.awardedScoreUnits, 1100);
    expect(result.unlockedBadgeIds, isEmpty);
  });

  test('maps newly unlocked badge ids', () {
    final result = PartyDrinkCommandResult.fromMutation(
      const PartyCommandResult({
        'sessionId': 'party-1',
        'drinkId': 'drink-1',
        'reversalEventId': 'reversal-1',
        'unlockedBadgeIds': ['masti_to_jak_drak', 'centurion'],
      }),
    );

    expect(result.unlockedBadgeIds, ['masti_to_jak_drak', 'centurion']);
  });

  test('rejects missing or malformed unlocked badge ids', () {
    for (final data in [
      const {'sessionId': 'party-1', 'drinkId': 'drink-1'},
      const {
        'sessionId': 'party-1',
        'drinkId': 'drink-1',
        'unlockedBadgeIds': ['masti_to_jak_drak', 3],
      },
    ]) {
      expect(
        () => PartyDrinkCommandResult.fromMutation(PartyCommandResult(data)),
        throwsStateError,
      );
    }
  });

  test('rejects malformed callable result', () {
    expect(
      () => PartyDrinkCommandResult.fromMutation(
        const PartyCommandResult({'sessionId': 'party-1'}),
      ),
      throwsStateError,
    );
  });
}
