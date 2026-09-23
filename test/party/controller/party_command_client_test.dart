import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/model/drink_category.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';
import 'package:remembeer/drink_log/model/drink_log.dart';
import 'package:remembeer/party/controller/party_command_client.dart';
import 'package:remembeer/party/controller/party_controller.dart';

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
  test('call rejects callable results with non-string map keys', () async {
    final client = PartyCommandClient(
      invoker: (_, _) async => <Object?, Object?>{1: true},
    );

    await expectLater(
      client.call(
        commandName: 'archive_party',
        sessionId: 'session-1',
        commandId: 'command-1',
      ),
      throwsAssertionError,
    );
  });

  test(
    'Party activation sends the device UTC offset for stored drinks',
    () async {
      Map<String, Object?>? invokedData;
      final controller = PartyController(
        commandClient: PartyCommandClient(
          invoker: (commandName, data) async {
            invokedData = data;
            return <String, Object?>{};
          },
        ),
      );

      await controller.activateParty(
        sessionId: 'party-1',
        commandId: 'command-1',
      );

      expect(invokedData, {
        'timeZoneOffsetMinutes': DateTime.now().timeZoneOffset.inMinutes,
        'sessionId': 'party-1',
        'commandId': 'command-1',
      });

      await controller.activateParty(
        sessionId: 'party-1',
        commandId: 'command-2',
        timeZoneOffsetMinutes: 120,
      );

      expect(invokedData, {
        'timeZoneOffsetMinutes': 120,
        'sessionId': 'party-1',
        'commandId': 'command-2',
      });
    },
  );

  test('Party drink wrapper maps the backend payload', () async {
    String? invokedName;
    Map<String, Object?>? invokedData;
    final controller = PartyController(
      commandClient: PartyCommandClient(
        invoker: (commandName, data) async {
          invokedName = commandName;
          invokedData = data;
          return <String, Object?>{};
        },
      ),
    );
    final drinkLog = DrinkLog(
      id: 'drink-log-1',
      consumedByUserId: 'user-1',
      consumedAt: DateTime(2026, 9, 2, 20),
      drink: const DrinkSnapshot(
        name: 'Wine',
        category: DrinkCategory.wine,
        alcoholPercentage: 12,
      ),
      volumeInMilliliters: 200,
      location: const GeoPoint(49.2, 16.6),
    );

    await controller.createPartyDrinkLog(
      sessionId: 'party-1',
      commandId: 'command-1',
      catalogDrinkId: 'drink-1',
      drinkLog: drinkLog,
    );

    final consumedAt = invokedData?['consumedAt'];
    expect(consumedAt, isA<String>());
    expect(consumedAt, matches(RegExp(r'(Z|[+-]\d{2}:\d{2})$')));
    expect(DateTime.parse(consumedAt! as String), drinkLog.consumedAt.toUtc());
    expect(invokedName, 'create_party_drink_log');
    expect(invokedData, {
      'drinkLogId': 'drink-log-1',
      'drinkId': 'drink-1',
      'consumedAt': consumedAt,
      'volumeInMilliliters': 200,
      'location': {'latitude': 49.2, 'longitude': 16.6},
      'sessionId': 'party-1',
      'commandId': 'command-1',
    });
  });
}
