import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
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

export function listMemberships(ctx: AuthQueryCtx, leaderboardId: Id<"leaderboard">) {
  return ctx.db
    .query("leaderboardMember")
    .withIndex("by_leaderboardId_and_userId", (q) => q.eq("leaderboardId", leaderboardId))
    .collect();
}

export async function loadLeaderboard(ctx: AuthQueryCtx, { id }: { id: Id<"leaderboard"> }) {
  const leaderboard = await ctx.db.get("leaderboard", id);
  if (!leaderboard || leaderboard.deletedAt !== null) {
    throw new ConvexError("Leaderboard not found");
  }

  return { leaderboard };
}

export function requireLeaderboardPermission(permission: "member" | "owner") {
  return async (ctx: AuthQueryCtx & { leaderboard: Doc<"leaderboard"> }) => {
    const { leaderboard } = ctx;
    const isOwner = leaderboard.ownerId === ctx.user._id;
    if (permission === "owner" && !isOwner) {
      throw new ConvexError("You do not have permission to access this leaderboard");
    }

    const member = isOwner ? null : await getMembership(ctx, leaderboard._id, ctx.user._id);
    if (!isOwner && member?.status !== "joined") {
      throw new ConvexError("You do not have permission to access this leaderboard");
    }

    return { member, isOwner };
  };
}

export function requireCallerNotOwner(ctx: { isOwner: boolean }) {
  if (ctx.isOwner) {
    throw new ConvexError("The owner cannot leave their own leaderboard");
  }

  return {};
}

export function requireTargetNotOwner(
  ctx: { leaderboard: Doc<"leaderboard"> },
  { userId }: { userId: Id<"user"> },
) {
  if (userId === ctx.leaderboard.ownerId) {
    throw new ConvexError("The owner cannot remove or ban themselves");
  }

  return {};
}
