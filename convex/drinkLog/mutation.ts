import { v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authMutation } from "../lib/authenticated";
import { schema } from "../schema";
import { access } from "../lib/access";
import {
  loadDrinkLog,
  requireDrinkLogOwner,
  requireUndeletedDrinkLog,
  requireValidConsumedTime,
  requireUsableDrink,
  requireJoinedDrinkLogSession,
} from "./access";
import type { Id } from "../_generated/dataModel";
import { createDrinkLogInputValidator, updateDrinkLogInputValidator } from "./schema";

const editableDrinkLogAccess = access<{
  id: Id<"drinkLog">;
  consumedAt?: number | undefined;
  drinkId?: Id<"drink"> | undefined;
  sessionId?: Id<"session"> | null | undefined;
}>()
  .use(loadDrinkLog)
  .use(requireDrinkLogOwner)
  .use(requireUndeletedDrinkLog);

export const create = authMutation
  .extend(WithZod)
  .input(createDrinkLogInputValidator)
  .returns(schema.id("drinkLog"))
  .extend(
    access<{
      consumedAt?: number | undefined;
      drinkId: Id<"drink">;
      sessionId: Id<"session"> | null;
    }>()
      .use(requireValidConsumedTime)
      .use(requireUsableDrink)
      .use(requireJoinedDrinkLogSession).extend,
  )
  .handler(async (ctx, input) => {
    const { now, consumedAt } = ctx;

    return await ctx.db.insert("drinkLog", {
      ...input,
      consumedAt,
      userId: ctx.user._id,
      updatedAt: now,
      deletedAt: null,
    });
  });

export const update = authMutation
  .extend(WithZod)
  .input(updateDrinkLogInputValidator)
  .returns(v.null())
  .extend(
    editableDrinkLogAccess
      .use(requireValidConsumedTime)
      .use(requireUsableDrink)
      .use(requireJoinedDrinkLogSession).extend,
  )
  .handler(async (ctx, { id, ...input }) => {
    const { drinkLog, now, consumedAt } = ctx;

    await ctx.db.patch("drinkLog", id, {
      sessionId: input.sessionId === undefined ? drinkLog.sessionId : input.sessionId,
      drinkId: input.drinkId ?? drinkLog.drinkId,
      consumedAt,
      volumeMl: input.volumeMl ?? drinkLog.volumeMl,
      location: input.location === undefined ? drinkLog.location : input.location,
      updatedAt: now,
    });

    return null;
  });

export const softDelete = authMutation
  .input({ id: v.id("drinkLog") })
  .returns(v.null())
  .extend(editableDrinkLogAccess.extend)
  .handler(async (ctx, { id }) => {
    const now = Date.now();
    await ctx.db.patch("drinkLog", id, {
      updatedAt: now,
      deletedAt: now,
    });

    return null;
  });
