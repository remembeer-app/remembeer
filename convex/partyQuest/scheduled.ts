import { v } from "convex/values";
import { convex } from "../lib/builder";
import { activeQuests, issueQuest, scheduleIssuance } from "./lifecycle";

export const expire = convex
  .mutation()
  .input({
    sessionId: v.id("session"),
    questId: v.id("partyQuest"),
    nextQuestAt: v.number(),
  })
  .returns(v.null())
  .handler(async (ctx, { sessionId, questId, nextQuestAt }) => {
    const party = await ctx.db.get("session", sessionId);
    if (
      !party ||
      party.kind !== "party" ||
      party.deletedAt !== null ||
      party.endedAt !== null ||
      !party.modules.socialQuestsEnabled ||
      party.questSchedule.nextQuestAt !== nextQuestAt
    )
      return null;
    const quest = await ctx.db.get("partyQuest", questId);
    const now = Date.now();
    if (
      !quest ||
      quest.sessionId !== sessionId ||
      quest.status !== "active" ||
      quest.endsAt > now
    )
      return null;
    await ctx.db.patch("partyQuest", questId, {
      status: "expired",
      updatedAt: now,
    });
    await scheduleIssuance(ctx, party, nextQuestAt, now);
    return null;
  });

export const issue = convex
  .mutation()
  .input({ sessionId: v.id("session"), nextQuestAt: v.number() })
  .returns(v.null())
  .handler(async (ctx, { sessionId, nextQuestAt }) => {
    const party = await ctx.db.get("session", sessionId);
    const now = Date.now();
    if (
      !party ||
      party.kind !== "party" ||
      party.deletedAt !== null ||
      party.endedAt !== null ||
      !party.modules.socialQuestsEnabled ||
      party.questSchedule.nextQuestAt !== nextQuestAt ||
      now < nextQuestAt
    )
      return null;
    if (
      (await activeQuests(ctx, sessionId)).some((quest) => quest.endsAt > now)
    )
      return null;
    // The issuing job is executing; do not cancel its own child expiry job.
    await issueQuest(
      ctx,
      {
        ...party,
        questSchedule: { ...party.questSchedule, scheduledFunctionId: null },
      },
      now,
    );
    return null;
  });
