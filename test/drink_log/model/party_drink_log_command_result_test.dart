import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink_log/model/party_drink_log_command_result.dart';
import 'package:remembeer/party/controller/party_command_client.dart';

void main() {
  test('maps Party drink callable result', () {
    final result = PartyDrinkLogCommandResult.fromMutation(
      const PartyCommandResult({
        'sessionId': 'party-1',
        'drinkLog': {'id': 'drink-log-1'},
        'awardEventId': 'award-1',
        'baseScoreUnits': 1000,
        'classBonusUnits': 100,
        'awardedScoreUnits': 1100,
        'unlockedBadgeIds': <String>[],
      }),
    );

    expect(result.sessionId, 'party-1');
    expect(result.drinkLogId, 'drink-log-1');
    expect(result.awardEventId, 'award-1');
    expect(result.awardedScoreUnits, 1100);
    expect(result.unlockedBadgeIds, isEmpty);
  });

  test('maps newly unlocked badge ids', () {
    final result = PartyDrinkLogCommandResult.fromMutation(
      const PartyCommandResult({
        'sessionId': 'party-1',
        'drinkLogId': 'drink-log-1',
        'reversalEventId': 'reversal-1',
        'unlockedBadgeIds': ['masti_to_jak_drak', 'centurion'],
      }),
    );

    expect(result.unlockedBadgeIds, ['masti_to_jak_drak', 'centurion']);
  });

  test('accepts a response from before badge IDs were added', () {
    final result = PartyDrinkLogCommandResult.fromMutation(
      const PartyCommandResult({
        'sessionId': 'party-1',
        'drinkLogId': 'drink-log-1',
      }),
    );

    expect(result.unlockedBadgeIds, isEmpty);
  });

  test('rejects malformed unlocked badge ids', () {
    expect(
      () => PartyDrinkLogCommandResult.fromMutation(
        const PartyCommandResult({
          'sessionId': 'party-1',
          'drinkLogId': 'drink-log-1',
          'unlockedBadgeIds': ['masti_to_jak_drak', 3],
        }),
      ),
      throwsStateError,
    );
  });

  test('rejects malformed callable result', () {
    expect(
      () => PartyDrinkLogCommandResult.fromMutation(
        const PartyCommandResult({'sessionId': 'party-1'}),
      ),
      throwsStateError,
    );
  });
}
