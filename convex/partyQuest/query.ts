import { ConvexError, v } from "convex/values";
import type { Doc } from "../_generated/dataModel";
import { authQuery } from "../lib/authenticated";
import { requireSessionAccess } from "../session/access";
import { schema } from "../schema";

function visibleQuest(
  quest: Doc<"partyQuest">,
  session: Doc<"session">,
  userId: string,
) {
  return {
    ...quest,
    status:
      quest.status !== "active"
        ? quest.status
        : quest.endsAt <= Date.now()
          ? ("expired" as const)
          : session.endedAt !== null
            ? ("cancelled" as const)
            : quest.status,
    selections: quest.selections.filter(
      (selection) => selection.userId === userId,
    ),
  };
}

export const get = authQuery
  .input({ id: v.id("partyQuest") })
  .returns(schema.doc("partyQuest"))
  .handler(async (ctx, { id }) => {
    const quest = await ctx.db.get("partyQuest", id);
    if (!quest) throw new ConvexError("Quest not found");
    const { session } = await requireSessionAccess(
      ctx,
      quest.sessionId,
      "joined",
    );
    return visibleQuest(quest, session, ctx.user._id);
  });

export const listForSession = authQuery
  .input({ sessionId: v.id("session") })
  .returns(v.array(schema.doc("partyQuest")))
  .handler(async (ctx, { sessionId }) => {
    const { session } = await requireSessionAccess(ctx, sessionId, "joined");
    const quests = await ctx.db
      .query("partyQuest")
      .withIndex("by_sessionId_and_startsAt", (q) =>
        q.eq("sessionId", sessionId),
      )
      .order("desc")
      .collect();
    return quests.map((quest) => visibleQuest(quest, session, ctx.user._id));
  });
