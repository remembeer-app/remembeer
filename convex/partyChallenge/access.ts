import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";

export async function loadChallenge(
  ctx: AuthQueryCtx,
  { id }: { id: Id<"partyChallenge"> },
) {
  const challenge = await ctx.db.get("partyChallenge", id);
  if (!challenge) {
    throw new ConvexError("Challenge not found");
  }

  return { challenge };
}
