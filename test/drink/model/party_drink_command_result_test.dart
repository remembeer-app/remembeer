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
      }),
    );

    expect(result.sessionId, 'party-1');
    expect(result.drinkId, 'drink-1');
    expect(result.awardEventId, 'award-1');
    expect(result.awardedScoreUnits, 1100);
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
