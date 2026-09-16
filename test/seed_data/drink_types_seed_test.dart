import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
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
  late List<Map<String, dynamic>> rawDrinkTypes;
  late List<DrinkType> drinkTypes;

  setUpAll(() {
    final content = File(
      'assets/seed_data/drink_types.json',
    ).readAsStringSync();
    rawDrinkTypes = (jsonDecode(content) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    drinkTypes = rawDrinkTypes.map(DrinkType.fromJson).toList();
  });

  test('every entry parses into a DrinkType', () {
    expect(drinkTypes, hasLength(rawDrinkTypes.length));
    expect(drinkTypes, isNotEmpty);
  });

  test('ids are unique', () {
    final ids = drinkTypes.map((drinkType) => drinkType.id).toList();
    expect(ids.toSet(), hasLength(ids.length));
  });

  test('ids follow the global-<category>-<slug> scheme', () {
    for (final drinkType in drinkTypes) {
      expect(
        drinkType.id,
        matches(RegExp(r'^global-[a-z]+-[a-z0-9-]+$')),
        reason: '${drinkType.name} has a malformed id',
      );
      expect(
        drinkType.id,
        startsWith('global-${drinkType.category.name}-'),
        reason: '${drinkType.name} id does not match its category',
      );
    }
  });

  test('every entry belongs to the global user', () {
    for (final drinkType in drinkTypes) {
      expect(drinkType.userId, globalUserId, reason: drinkType.name);
    }
  });

  test('names are unique and non-empty', () {
    final names = drinkTypes.map((drinkType) => drinkType.name).toList();

    for (final name in names) {
      expect(name.trim(), isNotEmpty);
      expect(name, name.trim(), reason: '"$name" has surrounding whitespace');
    }

    expect(names.toSet(), hasLength(names.length));
  });

  test('alcohol percentage is plausible for the category', () {
    for (final drinkType in drinkTypes) {
      final (min, max) = alcoholRangeByCategory[drinkType.category]!;

      expect(
        drinkType.alcoholPercentage,
        inInclusiveRange(min, max),
        reason:
            '${drinkType.name} (${drinkType.category.name}) has an implausible '
            'alcohol percentage',
      );
    }
  });

  test('every category is represented', () {
    final categories = drinkTypes
        .map((drinkType) => drinkType.category)
        .toSet();

    expect(categories, containsAll(DrinkCategory.values));
  });
}
