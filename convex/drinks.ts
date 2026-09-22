import { v } from "convex/values";
import { authMutation, authQuery } from "./authenticated";
import { convex } from "./lib";

export const listMine = authQuery
  .handler(async (ctx) => {
    const [customDrinks, globalDrinks] = await Promise.all([
      ctx.db
        .query("drinks")
        .withIndex("by_ownerId_and_deletedAt", (q) =>
          q.eq("ownerId", ctx.user._id).eq("deletedAt", null),
        )
        .collect(),

      ctx.db
        .query("drinks")
        .withIndex("by_ownerId_and_deletedAt", (q) =>
          q.eq("ownerId", null).eq("deletedAt", null),
        )
        .collect(),
    ]);

    return [...customDrinks, ...globalDrinks];
  })
  .public();

export const get = convex
  .query()
  .input({
    id: v.id("drinks"),
  })
  .handler(async (ctx, { id }) => {
    const drink = await ctx.db.get("drinks", id);
    if (!drink) {
      throw new Error("Drink not found");
    }

    return drink;
  })
  .public();

export const create = authMutation
  .input({
    name: v.string(),
    category: v.union(
      v.object({ kind: v.literal("beer") }),
      v.object({ kind: v.literal("cider") }),
      v.object({ kind: v.literal("cocktail") }),
      v.object({ kind: v.literal("spirit") }),
      v.object({ kind: v.literal("wine") }),
    ),
    alcoholPercentage: v.number(),
  })
  .handler(async (ctx, { name, category, alcoholPercentage }) => {
    const now = Date.now();

    return await ctx.db.insert("drinks", {
      ownerId: ctx.user._id,
      name,
      category,
      alcoholPercentage,
      updatedAt: now,
      deletedAt: null,
    });
  })
  .public();

// TODO(ohtenkay): use patch, partial validators or something like that
export const update = authMutation
  .input({
    id: v.id("drinks"),
    name: v.string(),
    category: v.union(
      v.object({ kind: v.literal("beer") }),
      v.object({ kind: v.literal("cider") }),
      v.object({ kind: v.literal("cocktail") }),
      v.object({ kind: v.literal("spirit") }),
      v.object({ kind: v.literal("wine") }),
    ),
    alcoholPercentage: v.number(),
  })
  .handler(async (ctx, { id, name, category, alcoholPercentage }) => {
    const drink = await ctx.db.get("drinks", id);
    if (!drink) {
      throw new Error("Drink not found");
    }

    if (drink.ownerId !== ctx.user._id) {
      throw new Error("You do not have permission to update this drink");
    }

    const now = Date.now();

    await ctx.db.patch("drinks", id, {
      name,
      category,
      alcoholPercentage,
      updatedAt: now,
    });
  })
  .public();

export const softDelete = authMutation
  .input({
    id: v.id("drinks"),
  })
  .handler(async (ctx, { id }) => {
    const drink = await ctx.db.get("drinks", id);
    if (!drink) {
      throw new Error("Drink not found");
    }

    if (drink.ownerId !== ctx.user._id) {
      throw new Error("You do not have permission to delete this drink");
    }

    const now = Date.now();

    await ctx.db.patch("drinks", id, {
      deletedAt: now,
      updatedAt: now,
    });
  })
  .public();
