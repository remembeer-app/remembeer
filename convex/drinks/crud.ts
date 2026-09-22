import { v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authMutation, authQuery } from "../lib/authenticated";
import { convex } from "../lib/builder";
import { createDrinkInputSchema, updateDrinkInputSchema } from "./schema";

export const listMine = authQuery.handler(async (ctx) => {
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
});

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
  });

export const create = authMutation
  .extend(WithZod)
  .input(createDrinkInputSchema)
  .handler(async (ctx, input) => {
    const now = Date.now();

    return await ctx.db.insert("drinks", {
      ownerId: ctx.user._id,
      ...input,
      updatedAt: now,
      deletedAt: null,
    });
  });

export const update = authMutation
  .extend(WithZod)
  .input(updateDrinkInputSchema)
  .handler(async (ctx, { id, name, category, alcoholPercentage }) => {
    const drink = await ctx.db.get("drinks", id);
    if (!drink) {
      throw new Error("Drink not found");
    }

    if (drink.ownerId !== ctx.user._id) {
      throw new Error("You do not have permission to update this drink");
    }

    await ctx.db.patch("drinks", id, {
      name: name ?? drink.name,
      category: category ?? drink.category,
      alcoholPercentage: alcoholPercentage ?? drink.alcoholPercentage,
      updatedAt: Date.now(),
    });
  });

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
  });
