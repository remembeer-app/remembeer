import { v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import type { Id } from "../_generated/dataModel";
import { authMutation } from "../lib/authenticated";
import { access } from "../lib/access";
import { schema } from "../schema";
import { createDrinkInputValidator, updateDrinkInputValidator } from "./schema";
import { loadDrink, drinkOwnerAccess, undeletedDrinkAccess } from "./access";

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
  .extend(
    access<{ id: Id<"drink"> }>()
      .use(loadDrink)
      .use(drinkOwnerAccess)
      .use(undeletedDrinkAccess)
      .extend,
  )
  .handler(async (ctx, { id, name, drinkCategory, alcoholPercentage }) => {
    const { drink } = ctx;

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
  .extend(
    access<{ id: Id<"drink"> }>()
      .use(loadDrink)
      .use(drinkOwnerAccess)
      .use(undeletedDrinkAccess)
      .extend,
  )
  .handler(async (ctx, { id }) => {
    const now = Date.now();
    await ctx.db.patch("drink", id, {
      deletedAt: now,
      updatedAt: now,
    });

    return null;
  });
