import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { access } from "../lib/access";
import { partyAccess, ongoingPartyAccess } from "../party/access";
import { requireSessionAccess } from "../session/access";

export function withChallengeAccess(permission: "joined" | "admin") {
  const chain = access<{ id: Id<"partyChallenge"> }>()
    .use(async (ctx, { id }) => {
      const challenge = await ctx.db.get("partyChallenge", id);
      if (!challenge) {
        throw new ConvexError("Challenge not found");
      }

      return { challenge };
    })
    .use((ctx) => requireSessionAccess(ctx, ctx.challenge.sessionId, permission))
    .use(partyAccess);

  return permission === "admin"
    ? chain.use(ongoingPartyAccess).extend
    : chain.extend;
}
