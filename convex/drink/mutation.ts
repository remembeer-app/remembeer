import { v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authMutation } from "../lib/authenticated";
import { schema } from "../schema";
import { createDrinkInputValidator, updateDrinkInputValidator } from "./schema";
import { getCustomDrinkHandler } from "./query";

export const create = authMutation
  .extend(WithZod)
  .input(createDrinkInputValidator)
  .returns(schema.id("drink"))
  .handler(async (ctx, input) => {
    return await ctx.db.insert("drink", {
      ownerId: ctx.user._id,
      ...input,
      updatedAt: Date.now(),
      deletedAt: null,
    });
  });

export const update = authMutation
  .extend(WithZod)
  .input(updateDrinkInputValidator)
  .returns(v.null())
  .handler(async (ctx, { id, name, drinkCategory, alcoholPercentage }) => {
    const drink = await getCustomDrinkHandler(ctx, { id });

    await ctx.db.patch("drink", id, {
      name: name ?? drink.name,
      drinkCategory: drinkCategory ?? drink.drinkCategory,
      alcoholPercentage: alcoholPercentage ?? drink.alcoholPercentage,
      updatedAt: Date.now(),
    });

    return null;
  });

export const softDelete = authMutation
  .input({
    id: v.id("drink"),
  })
  .returns(v.null())
  .handler(async (ctx, { id }) => {
    await getCustomDrinkHandler(ctx, { id });

    const now = Date.now();
    await ctx.db.patch("drink", id, {
      deletedAt: now,
      updatedAt: now,
    });

    return null;
  });
