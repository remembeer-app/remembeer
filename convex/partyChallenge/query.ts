import { v } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import { authQuery } from "../lib/authenticated";
import { access } from "../lib/access";
import { schema } from "../schema";
import { requireSessionAccess } from "../session/access";
import { requireParty } from "../party/access";
import { loadChallenge } from "./access";

function visibleChallenge(challenge: Doc<"partyChallenge">, session: Doc<"session">) {
  return {
    ...challenge,
    status:
      challenge.status !== "active"
        ? challenge.status
        : challenge.endsAt <= Date.now()
          ? ("expired" as const)
          : session.endedAt !== null
            ? ("cancelled" as const)
            : challenge.status,
  };
}

export const get = authQuery
  .input({ id: v.id("partyChallenge") })
  .returns(schema.doc("partyChallenge"))
  .extend(
    access<{ id: Id<"partyChallenge"> }>()
      .use(loadChallenge)
      .use((ctx) => requireSessionAccess(ctx, ctx.challenge.sessionId, "joined"))
      .use(requireParty).extend,
  )
  .handler(async (ctx) => visibleChallenge(ctx.challenge, ctx.session));

export const listForSession = authQuery
  .input({ sessionId: v.id("session") })
  .returns(v.array(schema.doc("partyChallenge")))
  .extend(
    access<{ sessionId: Id<"session"> }>()
      .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "joined"))
      .use(requireParty).extend,
  )
  .handler(async (ctx, { sessionId }) => {
    const { session } = ctx;

    const challenges = await ctx.db
      .query("partyChallenge")
      .withIndex("by_sessionId_and_startsAt", (q) => q.eq("sessionId", sessionId))
      .order("desc")
      .collect();

    return challenges.map((challenge) => visibleChallenge(challenge, session));
  });
