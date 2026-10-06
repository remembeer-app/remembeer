import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/types.dart';

const convexDrinkCategories = <DrinkCategory>[
  Beer(),
  Cider(),
  Cocktail(),
  Spirit(),
  Wine(),
];

extension ConvexDrinkCategoryExtension on DrinkCategory {
  String get displayName => switch (this) {
    Beer() => 'Beer',
    Cider() => 'Cider',
    Cocktail() => 'Cocktail',
    Spirit() => 'Spirit',
    Wine() => 'Wine',
  };

  String get iconPath => switch (this) {
    Beer() => 'assets/icons/beer.svg',
    Cider() => 'assets/icons/cider.svg',
    Cocktail() => 'assets/icons/cocktail.svg',
    Spirit() => 'assets/icons/spirit.svg',
    Wine() => 'assets/icons/wine.svg',
  };

  Color get defaultColor => switch (this) {
    Beer() => const Color(0xFFD1A700),
    Cider() => const Color(0xFFFFEA00),
    Cocktail() => const Color(0xFF19D808),
    Spirit() => const Color(0xFF0080FF),
    Wine() => const Color(0xFFC0392B),
  };

  Map<String, int> get predefinedVolumes => switch (this) {
    Beer() => {'Tuplák': 1000, 'Big': 500, 'Small': 300},
    Cider() => {'Big': 500, 'Small': 300},
    Cocktail() => {'Short Drink': 250, 'Long Drink': 400},
    Spirit() => {'Shot': 40, 'Small shot': 20},
    Wine() => {'Glass': 200, 'Bottle': 750},
  };

  int get defaultVolume => switch (this) {
    Beer() => 500,
    Cider() => 500,
    Cocktail() => 250,
    Spirit() => 40,
    Wine() => 200,
  };

  String get kind => switch (this) {
    Beer() => 'beer',
    Cider() => 'cider',
    Cocktail() => 'cocktail',
    Spirit() => 'spirit',
    Wine() => 'wine',
  };
}
