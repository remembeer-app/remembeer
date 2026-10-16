import 'package:remembeer/convex_api/types.dart';

const partyScoreUnitsPerPoint = 1000;
const defaultPartyChallengePoints = 25;
const defaultPartyQuestDurationMinutes = 15;
const partyActivityPageSize = 25;
const partyActivityScrollThreshold = 300.0;
const minBeerpongTeamCount = 2;
const defaultBeerpongFirstPlacePoints = 100;
const defaultBeerpongSecondPlacePoints = 50;
const defaultBeerpongThirdPlacePoints = 25;

class PartyClassMetadata {
  const PartyClassMetadata({required this.category, required this.title});
  final DrinkCategory category;
  final String title;
}

const partyClasses = <PartyClassMetadata>[
  PartyClassMetadata(category: Beer(), title: 'Beer Paladin'),
  PartyClassMetadata(category: Cider(), title: 'Cider Sentinel'),
  PartyClassMetadata(category: Cocktail(), title: 'Cocktail Druid'),
  PartyClassMetadata(category: Spirit(), title: 'Spirit Shaman'),
  PartyClassMetadata(category: Wine(), title: 'Wine Warrior'),
];

String formatPartyScore(int scoreUnits) {
  final fixed = (scoreUnits / partyScoreUnitsPerPoint).toStringAsFixed(3);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}
