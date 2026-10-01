import { defineTable } from "convex/server";
import { v } from "convex/values";

export const badgeTable = defineTable({
  userId: v.id("user"),
  badgeKey: v.string(),
  unlockedAt: v.number(),
  isShown: v.boolean(),
}).index("by_userId_and_badgeKey", ["userId", "badgeKey"]);
