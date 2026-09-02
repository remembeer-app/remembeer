import 'package:remembeer/drink_type/model/drink_category.dart';

const partySchemaVersion = 1;

const partyFunctionsRegion = 'europe-west4';
const partiesCollection = 'parties';
const partyMembersCollection = 'members';
const partyEventsCollection = 'events';
const partyQuestTemplatesCollection = 'questTemplates';
const partyQuestsCollection = 'quests';
const partyQuestSelectionsCollection = 'selections';
const partyChallengesCollection = 'challenges';
const partyTournamentsCollection = 'tournaments';
const partyTeamsCollection = 'teams';
const partyMatchesCollection = 'matches';

const partyScoreUnitsPerPoint = 1000;
const partyClassBonusNumerator = 1;
const partyClassBonusDenominator = 10;

const partyEventPageSize = 25;

const minPartyTitleLength = 1;
const maxPartyTitleLength = 80;
const minPartyInstructionsLength = 1;
const maxPartyInstructionsLength = 500;
const minPartyAwardPointsUnits = partyScoreUnitsPerPoint;
const maxPartyAwardPointsUnits = 100 * partyScoreUnitsPerPoint;

const minPartyQuestDurationMinutes = 1;
const maxPartyQuestDurationMinutes = 60;
const minPartyQuestIntervalMinutes = 5;
const maxPartyQuestIntervalMinutes = 180;
const defaultPartyQuestDurationMinutes = 15;
const defaultPartyQuestMinIntervalMinutes = 15;
const defaultPartyQuestMaxIntervalMinutes = 45;

const minBeerpongTeamCount = 2;
const maxBeerpongTeamCount = 16;
const minBeerpongParticipantCount = 2;
const maxBeerpongTeamNameLength = 30;

class PartyClassMetadata {
  const PartyClassMetadata({required this.category, required this.title});

  final DrinkCategory category;
  final String title;
}

const partyClasses = <PartyClassMetadata>[
  PartyClassMetadata(category: DrinkCategory.beer, title: 'Beer Paladin'),
  PartyClassMetadata(category: DrinkCategory.cider, title: 'Cider Sentinel'),
  PartyClassMetadata(category: DrinkCategory.cocktail, title: 'Cocktail Druid'),
  PartyClassMetadata(category: DrinkCategory.spirit, title: 'Spirit Shaman'),
  PartyClassMetadata(category: DrinkCategory.wine, title: 'Wine Warrior'),
];

String formatPartyScore(int scoreUnits) {
  final fixed = (scoreUnits / partyScoreUnitsPerPoint).toStringAsFixed(3);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}
