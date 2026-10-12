import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";

export function getMembership(
  ctx: AuthQueryCtx,
  leaderboardId: Id<"leaderboard">,
  userId: Id<"user">,
) {
  return ctx.db
    .query("leaderboardMember")
    .withIndex("by_leaderboardId_and_userId", (q) =>
      q.eq("leaderboardId", leaderboardId).eq("userId", userId),
    )
    .unique();
}

export function listMemberships(
  ctx: AuthQueryCtx,
  leaderboardId: Id<"leaderboard">,
) {
  return ctx.db
    .query("leaderboardMember")
    .withIndex("by_leaderboardId_and_userId", (q) =>
      q.eq("leaderboardId", leaderboardId),
    )
    .collect();
}

export async function requireLeaderboardAccess(
  ctx: AuthQueryCtx,
  id: Id<"leaderboard">,
  ownerOnly = false,
) {
  const leaderboard = await ctx.db.get("leaderboard", id);
  if (!leaderboard || leaderboard.deletedAt !== null)
    throw new ConvexError("Leaderboard not found");
  const isOwner = leaderboard.ownerId === ctx.user._id;
  if (
    !isOwner &&
    (ownerOnly ||
      (await getMembership(ctx, id, ctx.user._id))?.status !== "joined")
  ) {
    throw new ConvexError(
      "You do not have permission to access this leaderboard",
    );
  }
  return { leaderboard, isOwner };
}
