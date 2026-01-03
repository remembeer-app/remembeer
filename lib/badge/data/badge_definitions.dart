import 'package:remembeer/badge/model/badge_category.dart';
import 'package:remembeer/badge/model/badge_definition.dart';

const _badgeDefinitions = <BadgeDefinition>[
  BadgeDefinition(
    id: 'centurion',
    name: 'Centurion',
    description: 'Drink 100 beers in total.',
    iconPath: 'assets/badges/centurion.png',
    category: BadgeCategory.beersTotal,
    goal: 100,
  ),
  BadgeDefinition(
    id: 'millennial',
    name: 'Millennial',
    description: 'Drink 1000 beers in total.',
    iconPath: 'assets/badges/millennial.png',
    category: BadgeCategory.beersTotal,
    goal: 1000,
  ),

  BadgeDefinition(
    id: 'alchemist',
    name: 'Alchemist',
    description: 'Drink 1 liter of alcohol.',
    iconPath: 'assets/badges/alchemist.png',
    category: BadgeCategory.alcoholTotal,
    goal: 1000,
  ),
  BadgeDefinition(
    id: 'ethanol_engine',
    name: 'Ethanol Engine',
    description: 'Drink 10 liters of alcohol.',
    iconPath: 'assets/badges/ethanol_engine.png',
    category: BadgeCategory.alcoholTotal,
    goal: 10000,
  ),

  BadgeDefinition(
    id: 'finding_the_rhythm',
    name: 'Finding the Rhythm',
    description: 'Achieve 3-day streak.',
    iconPath: 'assets/badges/finding_the_rhythm.png',
    category: BadgeCategory.streak,
    goal: 3,
  ),
  BadgeDefinition(
    id: 'habit_formed',
    name: 'Habit Formed',
    description: 'Achieve 7-day streak.',
    iconPath: 'assets/badges/habit_formed.png',
    category: BadgeCategory.streak,
    goal: 7,
  ),

  BadgeDefinition(
    id: 'night_animal',
    name: 'Night Animal',
    description: 'Have 10+ beers after 6 PM.',
    iconPath: 'assets/badges/night_animal.png',
    category: BadgeCategory.onetimeEvent,
  ),
  BadgeDefinition(
    id: 'you_remembeered',
    name: 'You Remembeered',
    description: 'Log drink 5+ days after drinking it.',
    iconPath: 'assets/badges/you_remembeered.png',
    category: BadgeCategory.onetimeEvent,
  ),
  BadgeDefinition(
    id: 'early_riser',
    name: 'Early Riser',
    description: 'Have a beer between 6 AM and 8 AM.',
    iconPath: 'assets/badges/early_riser.png',
    category: BadgeCategory.onetimeEvent,
  ),
];

List<BadgeDefinition> getBadgesByCategory(BadgeCategory category) {
  return _badgeDefinitions
      .where((badge) => badge.category == category)
      .toList();
}
