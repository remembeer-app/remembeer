import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { access } from "../lib/access";

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

export type LeaderboardAccess = {
  leaderboard: Doc<"leaderboard">;
  // Owners are authorized directly, without loading their membership.
  member: Doc<"leaderboardMember"> | null;
  isOwner: boolean;
};

export function leaderboardAccess(permission: "member" | "owner") {
  return access<{ id: Id<"leaderboard"> }>()
    .use(async (ctx, input) => {
      const leaderboard = await ctx.db.get("leaderboard", input.id);
      if (!leaderboard || leaderboard.deletedAt !== null) {
        throw new ConvexError("Leaderboard not found");
      }

      const isOwner = leaderboard.ownerId === ctx.user._id;
      if (permission === "owner" && !isOwner) {
        throw new ConvexError(
          "You do not have permission to access this leaderboard",
        );
      }

      const member = isOwner
        ? null
        : await getMembership(ctx, input.id, ctx.user._id);
      if (!isOwner && member?.status !== "joined") {
        throw new ConvexError(
          "You do not have permission to access this leaderboard",
        );
      }

      return { leaderboard, member, isOwner };
    });
}
