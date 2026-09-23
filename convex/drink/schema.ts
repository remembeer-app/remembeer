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

export const drinkTable = defineTable({
  ownerId: v.nullable(v.id("user")),
  name: v.string(),
  drinkCategory: drinkCategoryValidator,
  alcoholPercentage: v.number(),
  updatedAt: v.number(),
  deletedAt: v.nullable(v.number()),
}).index("by_ownerId_and_deletedAt", ["ownerId", "deletedAt"]);

const alcoholPercentageValidator = z
  .number()
  .min(1, "Alcohol percentage must be at least 1")
  .max(100, "Alcohol percentage must be at most 100");

export const createDrinkInputValidator = convexToZod(
  drinkTable.validator.pick("name", "drinkCategory", "alcoholPercentage"),
).extend({
  alcoholPercentage: alcoholPercentageValidator,
});

export const updateDrinkInputValidator = createDrinkInputValidator
  .partial()
  .extend({
    id: convexToZod(v.id("drink")),
  });
