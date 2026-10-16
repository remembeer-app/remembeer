import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { requireSessionAccess } from "../session/access";

export async function requirePartyMember(
  ctx: AuthQueryCtx,
  sessionId: Id<"session">,
) {
  const { session } = await requireSessionAccess(ctx, sessionId, "joined");
  if (session.kind !== "party") throw new ConvexError("A party is required");
  return session;
}

export async function requireEnabledPartyAdmin(
  ctx: AuthQueryCtx,
  sessionId: Id<"session">,
) {
  const { session } = await requireSessionAccess(ctx, sessionId, "admin");
  if (session.kind !== "party") throw new ConvexError("A party is required");
  if (session.endedAt !== null)
    throw new ConvexError("Ended parties are read-only");
  if (!session.modules.beerpongEnabled)
    throw new ConvexError("Beerpong is disabled");
  return session;
}
