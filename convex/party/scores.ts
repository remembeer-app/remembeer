import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { QueryCtx } from "../_generated/server";
import { drinkScoreBreakdown } from "./scoring";

export async function loadPartyScores(
  ctx: QueryCtx,
  sessionId: Id<"session">,
  now: number,
) {
  const members = await ctx.db
    .query("sessionMember")
    .withIndex("by_sessionId_and_sessionMemberStatus_kind", (q) =>
      q.eq("sessionId", sessionId).eq("sessionMemberStatus.kind", "joined"),
    )
    .collect();
  const entries = await Promise.all(
    members
      .filter((member) => member.kind === "partyMember")
      .map(async (member) => ({
        member,
        user: await ctx.db.get("user", member.userId),
        userId: member.userId,
        drinkCount: 0,
        volumeMl: 0,
        alcoholMl: 0,
        baseDrinkScoreUnits: 0,
        classBonusScoreUnits: 0,
        questScoreUnits: 0,
        completedQuestCount: 0,
        scoreUnits: 0,
      })),
  );
  const byId = new Map(entries.map((entry) => [entry.userId, entry]));
  // shortcut: derive scores from party history; add aggregates when read limits become a constraint.
  const quests = await ctx.db
    .query("partyQuest")
    .withIndex("by_sessionId_and_startsAt", (q) => q.eq("sessionId", sessionId))
    .collect();
  for (const quest of quests) {
    for (const result of quest.results) {
      for (const userId of [result.firstUserId, result.secondUserId]) {
        const entry = byId.get(userId);
        if (!entry) continue;
        // Recorded results survive expiry, cancellation and later eligibility changes.
        entry.questScoreUnits += quest.pointsUnits;
        entry.completedQuestCount++;
      }
    }
  }
  const drinks = new Map<Id<"drink">, Doc<"drink">>();
  const logs = await ctx.db
    .query("drinkLog")
    .withIndex("by_sessionId", (q) => q.eq("sessionId", sessionId))
    .collect();
  for (const log of logs) {
    const entry = byId.get(log.userId);
    if (!entry || log.deletedAt !== null || log.consumedAt > now) continue;
    let drink = drinks.get(log.drinkId);
    if (!drink) {
      const referencedDrink = await ctx.db.get("drink", log.drinkId);
      if (!referencedDrink) throw new ConvexError("A logged drink is missing");
      drink = referencedDrink;
      drinks.set(log.drinkId, drink);
    }
    const score = drinkScoreBreakdown(
      log.volumeMl,
      drink.alcoholPercentage,
      entry.member.selectedClass?.kind === drink.drinkCategory.kind,
    );
    entry.drinkCount++;
    entry.volumeMl += log.volumeMl;
    entry.alcoholMl += score.alcoholMl;
    entry.baseDrinkScoreUnits += score.baseDrinkScoreUnits;
    entry.classBonusScoreUnits += score.classBonusScoreUnits;
  }
  for (const entry of entries) {
    entry.scoreUnits =
      entry.baseDrinkScoreUnits +
      entry.classBonusScoreUnits +
      entry.questScoreUnits;
    if (
      ![
        entry.baseDrinkScoreUnits,
        entry.classBonusScoreUnits,
        entry.questScoreUnits,
        entry.scoreUnits,
      ].every(Number.isSafeInteger)
    )
      throw new ConvexError("Party score is outside the supported range");
  }
  return { entries, quests };
}
