import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/drink/extension/convex_drink_category_extension.dart';

class DrinkCategoryConverter
    implements JsonConverter<DrinkCategory, Map<String, dynamic>> {
  const DrinkCategoryConverter();

  @override
  DrinkCategory fromJson(Map<String, dynamic> json) => switch (json['kind']) {
    'beer' => const Beer(),
    'cider' => const Cider(),
    'cocktail' => const Cocktail(),
    'spirit' => const Spirit(),
    'wine' => const Wine(),
    _ => throw FormatException('Unknown drink category: ${json['kind']}'),
  };

  @override
  Map<String, dynamic> toJson(DrinkCategory category) => {
    'kind': category.kind,
  };
}
