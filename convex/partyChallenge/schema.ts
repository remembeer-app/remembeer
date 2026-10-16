import { defineTable } from "convex/server";
import { v } from "convex/values";

export const partyChallengeTable = defineTable({
  sessionId: v.id("session"),
  title: v.string(),
  instructions: v.string(),
  pointsUnits: v.number(),
  startsAt: v.number(),
  endsAt: v.number(),
  status: v.union(
    v.literal("active"),
    v.literal("completed"),
    v.literal("expired"),
    v.literal("cancelled"),
  ),
  createdByUserId: v.id("user"),
  updatedAt: v.number(),
  winners: v.array(
    v.object({
      userId: v.id("user"),
      awardedAt: v.number(),
    }),
  ),
})
  .index("by_sessionId_and_startsAt", ["sessionId", "startsAt"])
  .index("by_sessionId_and_status", ["sessionId", "status"]);
