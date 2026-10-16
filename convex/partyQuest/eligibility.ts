import { ConvexError, type Infer } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { partyQuestKindValidator } from "./schema";
import { partyClassBonusPercent, partyScoreUnitsPerPoint } from "./constants";

export type QuestPlayer = {
  userId: Id<"user">;
  username: string;
  selectedClass: string;
  accentColor: string;
  scoreUnits: number;
  beerpongTeamId: string | null;
};

export function memberPair(firstUserId: Id<"user">, secondUserId: Id<"user">) {
  return firstUserId < secondUserId
    ? { firstUserId, secondUserId }
    : { firstUserId: secondUserId, secondUserId: firstUserId };
}

export function drinkScoreUnits(
  volumeMl: number,
  alcoholPercentage: number,
  matchesClass: boolean,
) {
  const base = Math.round(
    (volumeMl * alcoholPercentage * partyScoreUnitsPerPoint) / 100,
  );
  const score =
    base +
    (matchesClass ? Math.round((base * partyClassBonusPercent) / 100) : 0);
  if (!Number.isSafeInteger(score) || score < 0)
    throw new ConvexError("Drink score is outside the supported range");
  return score;
}

export function eligiblePairs(
  definition: Infer<typeof partyQuestKindValidator>,
  players: readonly QuestPlayer[],
  previousPairs: ReadonlySet<string>,
  finalistTeamIds: ReadonlySet<string> = new Set(),
) {
  const ordered = [...players].sort(
    (a, b) =>
      b.scoreUnits - a.scoreUnits ||
      a.username.toLowerCase().localeCompare(b.username.toLowerCase()) ||
      a.username.localeCompare(b.username) ||
      a.userId.localeCompare(b.userId),
  );
  const ranks = new Map<Id<"user">, number>();
  let rank = 0;
  ordered.forEach((player, index) => {
    if (index === 0 || player.scoreUnits !== ordered[index - 1]?.scoreUnits)
      rank = index + 1;
    ranks.set(player.userId, rank);
  });

  function matches(a: QuestPlayer, b: QuestPlayer) {
    const aRank = ranks.get(a.userId)!;
    const bRank = ranks.get(b.userId)!;
    switch (definition.kind) {
      case "toastWithClass":
        return (
          (a.selectedClass === definition.drinkCategory.kind) !==
          (b.selectedClass === definition.drinkCategory.kind)
        );
      case "sameAccent":
        return a.accentColor === b.accentColor;
      case "differentAccent":
        return a.accentColor !== b.accentColor;
      case "newAlly":
        return !previousPairs.has(
          JSON.stringify(memberPair(a.userId, b.userId)),
        );
      case "sameClass":
        return a.selectedClass === b.selectedClass;
      case "differentClass":
        return a.selectedClass !== b.selectedClass;
      case "bottomQuarter":
        return (
          aRank > Math.floor(players.length * 0.75) !==
          bRank > Math.floor(players.length * 0.75)
        );
      case "leader":
        return (aRank === 1) !== (bRank === 1);
      case "topThree":
        return aRank <= 3 !== bRank <= 3;
      case "oppositeRankingHalves":
        return (
          aRank <= Math.ceil(players.length / 2) !==
          bRank <= Math.ceil(players.length / 2)
        );
      case "nearbyRank":
        return Math.abs(aRank - bRank) <= 3;
      case "differentBeerpongTeam":
        return (
          a.beerpongTeamId !== null &&
          b.beerpongTeamId !== null &&
          a.beerpongTeamId !== b.beerpongTeamId
        );
      case "sameBeerpongTeam":
        return (
          a.beerpongTeamId !== null && a.beerpongTeamId === b.beerpongTeamId
        );
      case "finalistTeam":
        return (
          (a.beerpongTeamId !== null &&
            finalistTeamIds.has(a.beerpongTeamId)) ||
          (b.beerpongTeamId !== null && finalistTeamIds.has(b.beerpongTeamId))
        );
    }
  }

  const candidates = [...players].sort((a, b) =>
    a.userId.localeCompare(b.userId),
  );
  const pairs: ReturnType<typeof memberPair>[] = [];
  for (let index = 0; index < candidates.length; index++) {
    const first = candidates[index]!;
    for (const second of candidates.slice(index + 1)) {
      if (matches(first, second))
        pairs.push(memberPair(first.userId, second.userId));
    }
  }
  return pairs;
}
