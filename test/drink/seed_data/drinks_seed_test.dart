import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_category.dart';
import 'package:remembeer/user/constants.dart';

/// Plausible alcohol percentage window per category. A value outside its window
/// means either a typo or an entry filed under the wrong category.
const alcoholRangeByCategory = <DrinkCategory, (double, double)>{
  DrinkCategory.beer: (0.0, 12.0),
  DrinkCategory.cider: (0.0, 8.0),
  DrinkCategory.cocktail: (3.0, 35.0),
  DrinkCategory.spirit: (10.0, 80.0),
  DrinkCategory.wine: (4.0, 22.0),
};

void main() {
  late List<Map<String, dynamic>> rawDrinks;
  late List<Drink> drinks;

  setUpAll(() {
    final content = File('assets/seed_data/drinks.json').readAsStringSync();
    rawDrinks = (jsonDecode(content) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    drinks = rawDrinks.map(Drink.fromJson).toList();
  });

  test('every entry parses into a Drink', () {
    expect(drinks, hasLength(rawDrinks.length));
    expect(drinks, isNotEmpty);
  });

  test('ids are unique', () {
    final ids = drinks.map((drink) => drink.id).toList();
    expect(ids.toSet(), hasLength(ids.length));
  });

  test('ids follow the global-<category>-<slug> scheme', () {
    for (final drink in drinks) {
      expect(
        drink.id,
        matches(RegExp(r'^global-[a-z]+-[a-z0-9-]+$')),
        reason: '${drink.name} has a malformed id',
      );
      expect(
        drink.id,
        startsWith('global-${drink.category.name}-'),
        reason: '${drink.name} id does not match its category',
      );
    }
  });

  test('every entry belongs to the global user', () {
    for (final drink in drinks) {
      expect(drink.userId, globalUserId, reason: drink.name);
    }
  });

  test('names are unique and non-empty', () {
    final names = drinks.map((drink) => drink.name).toList();

    for (final name in names) {
      expect(name.trim(), isNotEmpty);
      expect(name, name.trim(), reason: '"$name" has surrounding whitespace');
    }

    expect(names.toSet(), hasLength(names.length));
  });

  test('alcohol percentage is plausible for the category', () {
    for (final drink in drinks) {
      final (min, max) = alcoholRangeByCategory[drink.category]!;

      expect(
        drink.alcoholPercentage,
        inInclusiveRange(min, max),
        reason:
            '${drink.name} (${drink.category.name}) has an implausible '
            'alcohol percentage',
      );
    }
  });

  test('every category is represented', () {
    final categories = drinks.map((drink) => drink.category).toSet();

    expect(categories, containsAll(DrinkCategory.values));
  });
}
