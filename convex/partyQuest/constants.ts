export const partyScoreUnitsPerPoint = 1000;
export const partyClassBonusPercent = 10;
export const questCycleLength = 16;
export const earlyQuestCount = 5;
export const regularQuestCount = 10;
export const minQuestDurationMinutes = 1;
export const maxQuestDurationMinutes = 60;
export const millisecondsPerMinute = 60_000;
export const maxQuestPlayers = 100;

export const pairQuestKinds = [
  "sameAccent",
  "differentAccent",
  "newAlly",
  "sameClass",
  "differentClass",
  "bottomQuarter",
  "leader",
  "topThree",
  "oppositeRankingHalves",
  "nearbyRank",
  "differentBeerpongTeam",
  "sameBeerpongTeam",
  "finalistTeam",
] as const;
