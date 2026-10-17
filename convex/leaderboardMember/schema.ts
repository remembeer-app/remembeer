import { defineTable } from "convex/server";
import { v } from "convex/values";

export const leaderboardMemberTable = defineTable({
  leaderboardId: v.id("leaderboard"),
  userId: v.id("user"),
  status: v.union(v.literal("joined"), v.literal("banned")),
  updatedAt: v.number(),
})
  .index("by_leaderboardId_and_userId", ["leaderboardId", "userId"])
  .index("by_userId_and_status", ["userId", "status"]);
