import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';

void main() {
  test('every Convex category round trips as a tagged snapshot', () {
    for (final category in convexDrinkCategories) {
      final snapshot = DrinkSnapshot(
        name: 'Test drink',
        category: category,
        alcoholPercentage: 5,
      );
      expect(snapshot.toJson()['category'], {'kind': category.kind});
      expect(DrinkSnapshot.fromJson(snapshot.toJson()), snapshot);
    }
  });

  test('rejects unknown category kinds', () {
    expect(
      () => DrinkSnapshot.fromJson({
        'name': 'Test drink',
        'category': {'kind': 'unknown'},
        'alcoholPercentage': 5,
      }),
      throwsFormatException,
    );
  });
}
