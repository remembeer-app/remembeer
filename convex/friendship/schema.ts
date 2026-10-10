import { defineTable } from "convex/server";
import { v } from "convex/values";

export const friendshipTable = defineTable({
  userAId: v.id("user"),
  userBId: v.id("user"),
  requestedById: v.id("user"),
  status: v.union(v.literal("pending"), v.literal("accepted")),
  updatedAt: v.number(),
})
  .index("by_pair", ["userAId", "userBId"])
  .index("by_userAId_and_status", ["userAId", "status"])
  .index("by_userBId_and_status", ["userBId", "status"]);
