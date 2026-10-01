import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/types.dart' as convex;
import 'package:remembeer/drink/model/drink_category.dart' as legacy;

const convexDrinkCategories = <convex.DrinkCategory>[
  convex.Beer(),
  convex.Cider(),
  convex.Cocktail(),
  convex.Spirit(),
  convex.Wine(),
];

extension ConvexDrinkCategoryExtension on convex.DrinkCategory {
  String get displayName => switch (this) {
    convex.Beer() => 'Beer',
    convex.Cider() => 'Cider',
    convex.Cocktail() => 'Cocktail',
    convex.Spirit() => 'Spirit',
    convex.Wine() => 'Wine',
  };

  String get iconPath => switch (this) {
    convex.Beer() => 'assets/icons/beer.svg',
    convex.Cider() => 'assets/icons/cider.svg',
    convex.Cocktail() => 'assets/icons/cocktail.svg',
    convex.Spirit() => 'assets/icons/spirit.svg',
    convex.Wine() => 'assets/icons/wine.svg',
  };

  Color get defaultColor => switch (this) {
    convex.Beer() => const Color(0xFFD1A700),
    convex.Cider() => const Color(0xFFFFEA00),
    convex.Cocktail() => const Color(0xFF19D808),
    convex.Spirit() => const Color(0xFF0080FF),
    convex.Wine() => const Color(0xFFC0392B),
  };

  Map<String, int> get predefinedVolumes => switch (this) {
    convex.Beer() => {'Tuplák': 1000, 'Big': 500, 'Small': 300},
    convex.Cider() => {'Big': 500, 'Small': 300},
    convex.Cocktail() => {'Short Drink': 250, 'Long Drink': 400},
    convex.Spirit() => {'Shot': 40, 'Small shot': 20},
    convex.Wine() => {'Glass': 200, 'Bottle': 750},
  };

  int get defaultVolume => switch (this) {
    convex.Beer() => 500,
    convex.Cider() => 500,
    convex.Cocktail() => 250,
    convex.Spirit() => 40,
    convex.Wine() => 200,
  };

  legacy.DrinkCategory get legacyCategory => switch (this) {
    convex.Beer() => legacy.DrinkCategory.beer,
    convex.Cider() => legacy.DrinkCategory.cider,
    convex.Cocktail() => legacy.DrinkCategory.cocktail,
    convex.Spirit() => legacy.DrinkCategory.spirit,
    convex.Wine() => legacy.DrinkCategory.wine,
  };
}
