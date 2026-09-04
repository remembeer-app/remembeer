import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';
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
    final drink = Drink(
      id: 'drink-1',
      consumedByUserId: 'user-1',
      consumedAt: DateTime(2026, 9, 2, 20),
      drinkType: const DrinkTypeCore(
        name: 'Wine',
        category: DrinkCategory.wine,
        alcoholPercentage: 12,
      ),
      volumeInMilliliters: 200,
      location: const GeoPoint(49.2, 16.6),
    );

    await controller.createPartyDrink(
      sessionId: 'party-1',
      commandId: 'command-1',
      drinkTypeId: 'type-1',
      drink: drink,
    );

    expect(invokedName, 'create_party_drink');
    expect(invokedData, {
      'drinkId': 'drink-1',
      'drinkTypeId': 'type-1',
      'consumedAt': drink.consumedAt.toUtc().toIso8601String(),
      'volumeInMilliliters': 200,
      'location': {'latitude': 49.2, 'longitude': 16.6},
      'sessionId': 'party-1',
      'commandId': 'command-1',
    });
  });
}
