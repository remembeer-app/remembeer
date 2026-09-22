import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authMutation, authQuery } from "../lib/authenticated";
import { schema } from "../schema";
import { createDrinkInputValidator, updateDrinkInputValidator } from "./schema";

export const listMine = authQuery
  .returns(v.array(schema.doc("drinks")))
  .handler(async (ctx) => {
    return await ctx.db
      .query("drinks")
      .withIndex("by_ownerId_and_deletedAt", (q) =>
        q.eq("ownerId", ctx.user._id).eq("deletedAt", null),
      )
      .collect();
  });

export const listAll = authQuery
  .returns(v.array(schema.doc("drinks")))
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
  });

export const get = authQuery
  .input({
    id: v.id("drinks"),
  })
  .returns(schema.doc("drinks"))
  .handler(async (ctx, { id }) => {
    const drink = await ctx.db.get("drinks", id);
    if (!drink) {
      throw new ConvexError("Drink not found");
    }

    if (drink.ownerId !== ctx.user._id) {
      throw new ConvexError("You do not have permission to view this drink");
    }

    if (drink.deletedAt !== null) {
      throw new ConvexError("Drink has been deleted");
    }

    return drink;
  });

export const create = authMutation
  .extend(WithZod)
  .input(createDrinkInputValidator)
  .returns(schema.id("drinks"))
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
  .input(updateDrinkInputValidator)
  .returns(v.null())
  .handler(async (ctx, { id, name, category, alcoholPercentage }) => {
    const drink = await ctx.db.get("drinks", id);
    if (!drink) {
      throw new ConvexError("Drink not found");
    }

    if (drink.ownerId !== ctx.user._id) {
      throw new ConvexError("You do not have permission to update this drink");
    }

    if (drink.deletedAt !== null) {
      throw new ConvexError("Drink has been deleted");
    }

    await ctx.db.patch("drinks", id, {
      name: name ?? drink.name,
      category: category ?? drink.category,
      alcoholPercentage: alcoholPercentage ?? drink.alcoholPercentage,
      updatedAt: Date.now(),
    });

    return null;
  });

export const softDelete = authMutation
  .input({
    id: v.id("drinks"),
  })
  .returns(v.null())
  .handler(async (ctx, { id }) => {
    const drink = await ctx.db.get("drinks", id);
    if (!drink) {
      throw new ConvexError("Drink not found");
    }

    if (drink.ownerId !== ctx.user._id) {
      throw new ConvexError("You do not have permission to delete this drink");
    }

    if (drink.deletedAt !== null) {
      throw new ConvexError("Drink has already been deleted");
    }

    const now = Date.now();

    await ctx.db.patch("drinks", id, {
      deletedAt: now,
      updatedAt: now,
    });

    return null;
  });
