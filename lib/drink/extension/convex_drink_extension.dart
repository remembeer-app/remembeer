import 'package:remembeer/convex_api/modules/drink.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';

extension ConvexDrinkExtension on ListAvailableResultItem {
  DrinkSnapshot get snapshot => DrinkSnapshot(
    name: name,
    category: drinkCategory.legacyCategory,
    alcoholPercentage: alcoholPercentage,
  );
}
