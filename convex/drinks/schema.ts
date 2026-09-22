import { defineTable } from "convex/server";
import { v } from "convex/values";

export const drinkCategoryValidator = v.union(
  v.object({ kind: v.literal("beer") }),
  v.object({ kind: v.literal("cider") }),
  v.object({ kind: v.literal("cocktail") }),
  v.object({ kind: v.literal("spirit") }),
  v.object({ kind: v.literal("wine") }),
);

export const drinksTable = defineTable({
  ownerId: v.nullable(v.id("users")),
  name: v.string(),
  category: drinkCategoryValidator,
  alcoholPercentage: v.number(),
  updatedAt: v.number(),
  deletedAt: v.nullable(v.number()),
}).index("by_ownerId_and_deletedAt", ["ownerId", "deletedAt"]);
