import 'package:remembeer/badge/data/onetime_badge_id.dart';
import 'package:remembeer/badge/model/badge_category.dart';
import 'package:remembeer/badge/type/badge_definition.dart';
import 'package:remembeer/common/util/invariant.dart';

// TODO(metju-ac): Add real icons. Also consider defining colors for badges.
final _badgeDefinitions = <BadgeDefinition>[
  (
    id: 'centurion',
    name: 'Centurion',
    description: 'Drink 100 beers in total.',
    iconPath: 'assets/badges/badge.png',
    category: BadgeCategory.beersTotal,
    goal: 100,
  ),
  (
    id: 'millennial',
    name: 'Millennial',
    description: 'Drink 1000 beers in total.',
    iconPath: 'assets/badges/badge.png',
    category: BadgeCategory.beersTotal,
    goal: 1000,
  ),

  (
    id: 'alchemist',
    name: 'Alchemist',
    description: 'Drink 1 liter of alcohol.',
    iconPath: 'assets/badges/badge.png',
    category: BadgeCategory.alcoholTotal,
    goal: 1000,
  ),
  (
    id: 'ethanol_engine',
    name: 'Ethanol Engine',
    description: 'Drink 10 liters of alcohol.',
    iconPath: 'assets/badges/badge.png',
    category: BadgeCategory.alcoholTotal,
    goal: 10000,
  ),

  (
    id: 'finding_the_rhythm',
    name: 'Finding the Rhythm',
    description: 'Achieve 3-day streak.',
    iconPath: 'assets/badges/badge.png',
    category: BadgeCategory.streak,
    goal: 3,
  ),
  (
    id: 'habit_formed',
    name: 'Habit Formed',
    description: 'Achieve 7-day streak.',
    iconPath: 'assets/badges/badge.png',
    category: BadgeCategory.streak,
    goal: 7,
  ),

  (
    id: OnetimeBadgeId.nightAnimal.id,
    name: 'Night Animal',
    description: 'Have 10+ beers after 6 PM.',
    iconPath: 'assets/badges/badge.png',
    category: BadgeCategory.onetimeEvent,
    goal: null,
  ),
  (
    id: OnetimeBadgeId.youRemembeered.id,
    name: 'You Remembeered',
    description: 'Log drink 5+ days after drinking it.',
    iconPath: 'assets/badges/badge.png',
    category: BadgeCategory.onetimeEvent,
    goal: null,
  ),
  (
    id: OnetimeBadgeId.earlyRiser.id,
    name: 'Early Riser',
    description: 'Have a beer between 6 AM and 8 AM.',
    iconPath: 'assets/badges/badge.png',
    category: BadgeCategory.onetimeEvent,
    goal: null,
  ),
  (
    id: OnetimeBadgeId.caseClosed.id,
    name: 'Case Closed',
    description: 'The box is empty. 20 beers in one day.',
    iconPath: 'assets/badges/badge.png',
    category: BadgeCategory.onetimeEvent,
    goal: null,
  ),
];

List<BadgeDefinition> getBadgesByCategory(BadgeCategory category) {
  return _badgeDefinitions
      .where((badge) => badge.category == category)
      .toList();
}

BadgeDefinition getBadgeById(String id) {
  return _badgeDefinitions.firstWhere(
    (badge) => badge.id == id,
    orElse: () => never('BadgeDefinition with id $id not found.'),
  );
}
