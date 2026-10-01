import { defineTable } from "convex/server";
import { v } from "convex/values";

export const userTable = defineTable({
  authUserId: v.string(),
  username: v.string(),
  normalizedUsername: v.string(),
  accentColor: v.union(
    v.literal("amber"),
    v.literal("rose"),
    v.literal("violet"),
    v.literal("sky"),
    v.literal("emerald"),
    v.literal("lime"),
    v.literal("orange"),
    v.literal("fuchsia"),
  ),
  avatarUrl: v.nullable(v.string()),
  endOfDayBoundary: v.number(),
  defaultDrink: v.nullable(v.id("drink")),
  drinkLogSortOrder: v.union(v.literal("asc"), v.literal("desc")),
}).index("by_authUserId", ["authUserId"]);
