import { v } from "convex/values";
import type { Doc } from "../_generated/dataModel";
import { authQuery } from "../lib/authenticated";
import { schema } from "../schema";
import { requireChallenge, requireParty } from "./access";

function visibleChallenge(
  challenge: Doc<"partyChallenge">,
  session: Doc<"session">,
) {
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
  .handler(async (ctx, { id }) => {
    const { challenge, session } = await requireChallenge(ctx, id, "joined");
    return visibleChallenge(challenge, session);
  });

export const listForSession = authQuery
  .input({ sessionId: v.id("session") })
  .returns(v.array(schema.doc("partyChallenge")))
  .handler(async (ctx, { sessionId }) => {
    const session = await requireParty(ctx, sessionId, "joined");
    const challenges = await ctx.db
      .query("partyChallenge")
      .withIndex("by_sessionId_and_startsAt", (q) =>
        q.eq("sessionId", sessionId),
      )
      .order("desc")
      .collect();
    return challenges.map((challenge) => visibleChallenge(challenge, session));
  });
