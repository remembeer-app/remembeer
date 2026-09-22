import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

void main() {
  const drinkTypeJson = {
    'name': 'Beer',
    'category': 'beer',
    'alcoholPercentage': 5.0,
  };
  final baseJson = <String, dynamic>{
    'id': 'drink-1',
    'consumedByUserId': 'user-1',
    'consumedAt': '2026-09-02T18:30:00.000Z',
    'drinkType': drinkTypeJson,
    'volumeInMilliliters': 500,
  };

  test('reads Party revision without writing it back', () {
    final drink = Drink.fromJson({...baseJson, 'partyRevision': 3});

    expect(drink.partyRevision, 3);
    expect(drink.drinkType.category, DrinkCategory.beer);
    expect(drink.toJson(), isNot(contains('partyRevision')));
  });

  test('legacy drinks use the backend-compatible first revision', () {
    final drink = Drink.fromJson(baseJson);

    expect(drink.partyRevision, 1);
    expect(drink.drinkTypeId, isNull);
    expect(drink.toJson(), isNot(contains('drinkTypeId')));
    expect(drink.toJson(), isNot(contains('partyRevision')));
  });

  test('reads consumed times into the local time zone', () {
    final utc = Drink.fromJson(baseJson);
    final withOffset = Drink.fromJson({
      ...baseJson,
      'consumedAt': '2026-09-02T20:30:00+02:00',
    });
    final local = Drink.fromJson({
      ...baseJson,
      'consumedAt': '2026-09-02T18:30:00.000',
    });
    final instant = DateTime.utc(2026, 9, 2, 18, 30);

    expect(utc.consumedAt.isUtc, isFalse);
    expect(utc.consumedAt.isAtSameMomentAs(instant), isTrue);
    expect(withOffset.consumedAt.isUtc, isFalse);
    expect(withOffset.consumedAt.isAtSameMomentAs(instant), isTrue);
    expect(local.consumedAt, DateTime(2026, 9, 2, 18, 30));
  });

  test('keeps writing local consumed times without an offset', () {
    final drink = Drink.fromJson({
      ...baseJson,
      'consumedAt': '2026-09-02T18:30:00.000',
    });

    expect(drink.toJson()['consumedAt'], '2026-09-02T18:30:00.000');
  });

  test('reads and writes the persisted drink type identity', () {
    final drink = Drink.fromJson({...baseJson, 'drinkTypeId': 'type-1'});

    expect(drink.drinkTypeId, 'type-1');
    expect(drink.toJson()['drinkTypeId'], 'type-1');
  });
}
