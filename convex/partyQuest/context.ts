import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { maxQuestPlayers } from "./constants";
import { drinkScoreUnits, memberPair, type QuestPlayer } from "./eligibility";

export async function loadQuestContext(
  ctx: AuthQueryCtx,
  sessionId: Id<"session">,
  now: number,
) {
  const members = await ctx.db
    .query("sessionMember")
    .withIndex("by_sessionId_and_sessionMemberStatus_kind", (q) =>
      q.eq("sessionId", sessionId).eq("sessionMemberStatus.kind", "joined"),
    )
    .collect();
  const players: QuestPlayer[] = [];
  for (const member of members) {
    if (member.kind !== "partyMember" || member.selectedClass === null)
      continue;
    const user = await ctx.db.get("user", member.userId);
    if (user)
      players.push({
        userId: user._id,
        username: user.username,
        selectedClass: member.selectedClass.kind,
        accentColor: user.accentColor,
        scoreUnits: 0,
        // shortcut: beerpong quests stay unavailable until Convex tournament data exists.
        beerpongTeamId: null,
      });
  }
  if (players.length > maxQuestPlayers)
    throw new ConvexError(`Quests support at most ${maxQuestPlayers} players`);
  const byId = new Map(players.map((player) => [player.userId, player]));
  // shortcut: reads party history for ranks and previous partners, add aggregates when read limits become a constraint.
  const quests = await ctx.db
    .query("partyQuest")
    .withIndex("by_sessionId_and_startsAt", (q) => q.eq("sessionId", sessionId))
    .collect();
  const previousPairs = new Set<string>();
  for (const quest of quests) {
    for (const result of quest.results) {
      previousPairs.add(
        JSON.stringify(memberPair(result.firstUserId, result.secondUserId)),
      );
      for (const userId of [result.firstUserId, result.secondUserId]) {
        const player = byId.get(userId);
        if (player) player.scoreUnits += quest.pointsUnits;
      }
    }
  }
  const drinks = new Map<Id<"drink">, Doc<"drink">>();
  const logs = await ctx.db
    .query("drinkLog")
    .withIndex("by_sessionId", (q) => q.eq("sessionId", sessionId))
    .collect();
  for (const log of logs) {
    const player = byId.get(log.userId);
    if (!player || log.deletedAt !== null || log.consumedAt > now) continue;
    let drink = drinks.get(log.drinkId);
    if (!drink) {
      const referencedDrink = await ctx.db.get("drink", log.drinkId);
      if (!referencedDrink) throw new ConvexError("A logged drink is missing");
      drink = referencedDrink;
      drinks.set(log.drinkId, drink);
    }
    player.scoreUnits += drinkScoreUnits(
      log.volumeMl,
      drink.alcoholPercentage,
      player.selectedClass === drink.drinkCategory.kind,
    );
  }
  return { players, previousPairs, quests };
}
