import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/controller/party_command_client.dart';

void main() {
  test('call adds session and command ids to callable data', () async {
    String? invokedName;
    Map<String, Object?>? invokedData;
    final client = PartyCommandClient(
      invoker: (commandName, data) async {
        invokedName = commandName;
        invokedData = data;
        return <String, Object?>{'accepted': true};
      },
    );

    final result = await client.call(
      commandName: 'archive_party',
      sessionId: 'session-1',
      commandId: 'command-1',
      data: const {'reason': 'ended'},
    );

    expect(invokedName, 'archive_party');
    expect(invokedData, {
      'reason': 'ended',
      'sessionId': 'session-1',
      'commandId': 'command-1',
    });
    expect(result.data, {'accepted': true});
  });
}
