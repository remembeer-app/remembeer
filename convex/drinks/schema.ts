import { defineTable } from "convex/server";
import { v } from "convex/values";
import { convexToZod } from "convex-helpers/server/zod4";
import { z } from "zod";

const drinkCategoryValidator = v.union(
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

const alcoholPercentageValidator = z
  .number()
  .min(1, "Alcohol percentage must be at least 1")
  .max(100, "Alcohol percentage must be at most 100");

export const createDrinkInputValidator = convexToZod(
  drinksTable.validator.pick("name", "category", "alcoholPercentage"),
).extend({
  alcoholPercentage: alcoholPercentageValidator,
});

export const updateDrinkInputValidator = createDrinkInputValidator
  .partial()
  .extend({
    id: convexToZod(v.id("drinks")),
  });
