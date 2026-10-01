import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/model/drink_category.dart';
import 'package:remembeer/drink_log/model/drink_log.dart';

void main() {
  const drinkJson = {
    'name': 'Beer',
    'category': 'beer',
    'alcoholPercentage': 5.0,
  };
  final baseJson = <String, dynamic>{
    'id': 'drink-log-1',
    'consumedByUserId': 'user-1',
    'consumedAt': '2026-09-02T18:30:00.000Z',
    'drink': drinkJson,
    'volumeInMilliliters': 500,
  };

  test('reads Party revision without writing it back', () {
    final drink = DrinkLog.fromJson({...baseJson, 'partyRevision': 3});

    expect(drink.partyRevision, 3);
    expect(drink.drink.category, DrinkCategory.beer);
    expect(drink.toJson(), isNot(contains('partyRevision')));
  });

  test('drink logs use the first Party revision by default', () {
    final drinkLog = DrinkLog.fromJson(baseJson);

    expect(drinkLog.partyRevision, 1);
    expect(drinkLog.catalogDrinkId, isNull);
    expect(drinkLog.toJson(), isNot(contains('drinkId')));
    expect(drinkLog.toJson(), isNot(contains('partyRevision')));
  });

  test('reads consumed times into the local time zone', () {
    final utc = DrinkLog.fromJson(baseJson);
    final withOffset = DrinkLog.fromJson({
      ...baseJson,
      'consumedAt': '2026-09-02T20:30:00+02:00',
    });
    final local = DrinkLog.fromJson({
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
    final drink = DrinkLog.fromJson({
      ...baseJson,
      'consumedAt': '2026-09-02T18:30:00.000',
    });

    expect(drink.toJson()['consumedAt'], '2026-09-02T18:30:00.000');
  });

  test('reads and writes the persisted catalog drink identity', () {
    final drinkLog = DrinkLog.fromJson({...baseJson, 'drinkId': 'drink-1'});

    expect(drinkLog.catalogDrinkId, 'drink-1');
    expect(drinkLog.toJson()['drinkId'], 'drink-1');
  });
}
