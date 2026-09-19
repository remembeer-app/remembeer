import { defineTable, defineSchema } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    authUserId: v.string(),
  }).index("by_authUserId", ["authUserId"]),
  drinks: defineTable({
    ownerId: v.nullable(v.id("users")),
    name: v.string(),
    category: v.union(
      v.object({ kind: v.literal("beer") }),
      v.object({ kind: v.literal("cider") }),
      v.object({ kind: v.literal("cocktail") }),
      v.object({ kind: v.literal("spirit") }),
      v.object({ kind: v.literal("wine") }),
    ),
    alcoholPercentage: v.number(),
    updatedAt: v.number(),
    deletedAt: v.nullable(v.number()),
  }).index("by_onwerId_and_deletedAt", ["ownerId", "deletedAt"]),
});
