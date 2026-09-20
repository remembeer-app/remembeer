import { v } from "convex/values";
import { convex } from "./lib";
import { getCurrentUser } from "./users";

export const listMine = convex
  .query()
  .handler(async (ctx) => {
    const { user } = await getCurrentUser(ctx);

    const [customDrinks, globalDrinks] = await Promise.all([
      ctx.db
        .query("drinks")
        .withIndex("by_ownerId_and_deletedAt", (q) =>
          q.eq("ownerId", user._id).eq("deletedAt", null),
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

export const create = convex
  .mutation()
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
    const { user } = await getCurrentUser(ctx);

    const now = Date.now();

    return await ctx.db.insert("drinks", {
      ownerId: user._id,
      name,
      category,
      alcoholPercentage,
      updatedAt: now,
      deletedAt: null,
    });
  })
  .public();

// TODO(ohtenkay): use patch, partial validators or something like that
export const update = convex
  .mutation()
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
    const { user } = await getCurrentUser(ctx);

    const drink = await ctx.db.get("drinks", id);
    if (!drink) {
      throw new Error("Drink not found");
    }

    if (drink.ownerId !== user._id) {
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

export const softDelete = convex
  .mutation()
  .input({
    id: v.id("drinks"),
  })
  .handler(async (ctx, { id }) => {
    const { user } = await getCurrentUser(ctx);

    const drink = await ctx.db.get("drinks", id);
    if (!drink) {
      throw new Error("Drink not found");
    }

    if (drink.ownerId !== user._id) {
      throw new Error("You do not have permission to delete this drink");
    }

    const now = Date.now();

    await ctx.db.patch("drinks", id, {
      deletedAt: now,
      updatedAt: now,
    });
  })
  .public();
