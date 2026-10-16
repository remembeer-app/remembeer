import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/modules/leaderboard.dart'
    show CreateArgsIconName;

extension LeaderboardIconPresentation on CreateArgsIconName {
  IconData get icon => switch (this) {
    CreateArgsIconName.trophyValue => Icons.emoji_events,
    CreateArgsIconName.medalValue => Icons.military_tech,
    CreateArgsIconName.starValue => Icons.star,
    CreateArgsIconName.diamondValue => Icons.diamond,
    CreateArgsIconName.flameValue => Icons.local_fire_department,
    CreateArgsIconName.boltValue => Icons.bolt,
    CreateArgsIconName.rocketValue => Icons.rocket_launch,
    CreateArgsIconName.targetValue => Icons.gps_fixed,
    CreateArgsIconName.beerValue => Icons.sports_bar,
    CreateArgsIconName.wineValue => Icons.wine_bar,
    CreateArgsIconName.cocktailValue => Icons.local_bar,
    CreateArgsIconName.coffeeValue => Icons.coffee,
    CreateArgsIconName.heartValue => Icons.favorite,
    CreateArgsIconName.sadValue => Icons.sentiment_very_dissatisfied,
    CreateArgsIconName.partyValue => Icons.celebration,
    CreateArgsIconName.musicValue => Icons.music_note,
    CreateArgsIconName.gamepadValue => Icons.sports_esports,
    CreateArgsIconName.petValue => Icons.pets,
    CreateArgsIconName.natureValue => Icons.eco,
    CreateArgsIconName.sunValue => Icons.wb_sunny,
    CreateArgsIconName.moonValue => Icons.nightlight_round,
    CreateArgsIconName.flagValue => Icons.flag,
    CreateArgsIconName.shieldValue => Icons.shield,
    CreateArgsIconName.lightbulbValue => Icons.lightbulb,
  };
}

CreateArgsIconName leaderboardIconFor(String name) =>
    CreateArgsIconName.values.firstWhere(
      (icon) => icon.value == name,
      orElse: () => CreateArgsIconName.trophyValue,
    );
