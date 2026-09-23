import 'package:flutter/material.dart';

enum DrinkCategory {
  beer,
  cider,
  cocktail,
  spirit,
  wine;

  String get displayName {
    return switch (this) {
      DrinkCategory.beer => 'Beer',
      DrinkCategory.cider => 'Cider',
      DrinkCategory.cocktail => 'Cocktail',
      DrinkCategory.spirit => 'Spirit',
      DrinkCategory.wine => 'Wine',
    };
  }

  String get iconPath {
    return switch (this) {
      DrinkCategory.beer => 'assets/icons/beer.svg',
      DrinkCategory.cider => 'assets/icons/cider.svg',
      DrinkCategory.cocktail => 'assets/icons/cocktail.svg',
      DrinkCategory.spirit => 'assets/icons/spirit.svg',
      DrinkCategory.wine => 'assets/icons/wine.svg',
    };
  }

  Color get defaultColor {
    return switch (this) {
      DrinkCategory.beer => const Color(0xFFD1A700),
      DrinkCategory.cider => const Color(0xFFFFEA00),
      DrinkCategory.cocktail => const Color(0xFF19D808),
      DrinkCategory.spirit => const Color(0xFF0080FF),
      DrinkCategory.wine => const Color(0xFFC0392B),
    };
  }

  Map<String, int> get predefinedVolumes {
    return switch (this) {
      DrinkCategory.beer => {'Tuplák': 1000, 'Big': 500, 'Small': 300},
      DrinkCategory.cider => {'Big': 500, 'Small': 300},
      DrinkCategory.cocktail => {'Short Drink': 250, 'Long Drink': 400},
      DrinkCategory.spirit => {'Shot': 40, 'Small shot': 20},
      DrinkCategory.wine => {'Glass': 200, 'Bottle': 750},
    };
  }

  int get defaultVolume {
    return switch (this) {
      DrinkCategory.beer => 500,
      DrinkCategory.cider => 500,
      DrinkCategory.cocktail => 250,
      DrinkCategory.spirit => 40,
      DrinkCategory.wine => 200,
    };
  }
}
