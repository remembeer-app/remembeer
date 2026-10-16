import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { requireSessionAccess } from "../session/access";

export async function requireParty(
  ctx: AuthQueryCtx,
  sessionId: Id<"session">,
  permission: "joined" | "admin",
) {
  const { session } = await requireSessionAccess(ctx, sessionId, permission);
  if (session.kind !== "party") throw new ConvexError("A party is required");
  if (permission === "admin" && session.endedAt !== null)
    throw new ConvexError("Ended parties are read-only");
  return session;
}

export async function requireChallenge(
  ctx: AuthQueryCtx,
  id: Id<"partyChallenge">,
  permission: "joined" | "admin",
) {
  const challenge = await ctx.db.get("partyChallenge", id);
  if (!challenge) throw new ConvexError("Challenge not found");
  const session = await requireParty(ctx, challenge.sessionId, permission);
  return { challenge, session };
}
