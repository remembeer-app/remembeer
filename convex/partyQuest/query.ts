import { v } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import { authQuery } from "../lib/authenticated";
import { access } from "../lib/access";
import { requireSessionAccess } from "../session/access";
import { schema } from "../schema";
import { publicUser, publicUserValidator } from "../user/publicProfile";
import { loadQuestContext } from "./context";
import { loadQuest } from "./access";
import { eligiblePairs } from "./eligibility";

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
  .extend(
    access<{ id: Id<"partyQuest"> }>()
      .use(loadQuest)
      .use((ctx) => requireSessionAccess(ctx, ctx.quest.sessionId, "joined"))
      .extend,
  )
  .handler(async (ctx) => visibleQuest(ctx.quest, ctx.session, ctx.user._id));

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

// Partner eligibility is evaluated by the same rules used to confirm a pair.
export const partners = authQuery
  .input({ questId: v.id("partyQuest") })
  .returns(v.array(publicUserValidator))
  .extend(
    access<{ questId: Id<"partyQuest"> }>()
      .use((ctx, { questId }) => loadQuest(ctx, { id: questId }))
      .use((ctx) => requireSessionAccess(ctx, ctx.quest.sessionId, "joined"))
      .extend,
  )
  .handler(async (ctx) => {
    const { quest, session } = ctx;

    const now = Date.now();
    if (
      session.kind !== "party" ||
      session.endedAt !== null ||
      !session.modules.socialQuestsEnabled ||
      quest.status !== "active" ||
      now < quest.startsAt ||
      now >= quest.endsAt
    )
      return [];

    const completed = new Set(
      quest.results.flatMap((result) => [
        result.firstUserId,
        result.secondUserId,
      ]),
    );
    if (completed.has(ctx.user._id)) return [];

    const { players, previousPairs, finalistTeamIds } = await loadQuestContext(
      ctx,
      session,
      now,
    );

    const ids = eligiblePairs(quest, players, previousPairs, finalistTeamIds)
      .flatMap((pair) =>
        pair.firstUserId === ctx.user._id
          ? [pair.secondUserId]
          : pair.secondUserId === ctx.user._id
            ? [pair.firstUserId]
            : [],
      )
      .filter((id) => !completed.has(id));
    const users = await Promise.all(ids.map((id) => publicUser(ctx, id)));

    return users.filter((user) => user !== null);
  });
