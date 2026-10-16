import type { Infer } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { partyQuestKindValidator } from "./schema";
import { rankByScore } from "../party/scoring";

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

export function eligiblePairs(
  definition: Infer<typeof partyQuestKindValidator>,
  players: readonly QuestPlayer[],
  previousPairs: ReadonlySet<string>,
  finalistTeamIds: ReadonlySet<string> = new Set(),
) {
  const ranks = new Map(
    rankByScore(players).map((player) => [player.userId, player.rank]),
  );

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
