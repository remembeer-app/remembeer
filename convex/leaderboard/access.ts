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
