import { ConvexError } from "convex/values";
import { partyClassBonusPercent, partyScoreUnitsPerPoint } from "./constants";

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

// Shared by standings and activity so rounding and class bonuses agree.
export function drinkScoreBreakdown(
  volumeMl: number,
  alcoholPercentage: number,
  matchesClass: boolean,
) {
  const baseDrinkScoreUnits = drinkScoreUnits(
    volumeMl,
    alcoholPercentage,
    false,
  );
  const scoreUnits = drinkScoreUnits(volumeMl, alcoholPercentage, matchesClass);

  return {
    baseDrinkScoreUnits,
    classBonusScoreUnits: scoreUnits - baseDrinkScoreUnits,
    scoreUnits,
    alcoholMl: (volumeMl * alcoholPercentage) / 100,
  };
}

// Competition ranks: equal scores share a rank, and the next rank skips places.
export function rankByScore<
  T extends { userId: string; username: string; scoreUnits: number },
>(players: readonly T[]) {
  const ordered = [...players].sort(
    (a, b) =>
      b.scoreUnits - a.scoreUnits ||
      a.username.toLowerCase().localeCompare(b.username.toLowerCase()) ||
      a.username.localeCompare(b.username) ||
      a.userId.localeCompare(b.userId),
  );
  let rank = 0;

  return ordered.map((player, index) => {
    if (index === 0 || player.scoreUnits !== ordered[index - 1]?.scoreUnits)
      rank = index + 1;

    return { ...player, rank };
  });
}
