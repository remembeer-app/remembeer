import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authMutation, type AuthMutationCtx } from "../lib/authenticated";
import { schema } from "../schema";
import { requireSessionAccess } from "../session/access";
import type { Id } from "../_generated/dataModel";
import {
  createDrinkLogInputValidator,
  updateDrinkLogInputValidator,
} from "./schema";

export const create = authMutation
  .extend(WithZod)
  .input(createDrinkLogInputValidator)
  .returns(schema.id("drinkLog"))
  .handler(async (ctx, input) => {
    await checkReferences(ctx, input);

    return await ctx.db.insert("drinkLog", {
      ...input,
      userId: ctx.user._id,
      updatedAt: Date.now(),
      deletedAt: null,
    });
  });

export const update = authMutation
  .extend(WithZod)
  .input(updateDrinkLogInputValidator)
  .returns(v.null())
  .handler(async (ctx, { id, ...input }) => {
    const drinkLog = await getDrinkLog(ctx, { id });
    await checkReferences(ctx, {
      sessionId: input.sessionId,
      drinkId: input.drinkId === drinkLog.drinkId ? undefined : input.drinkId,
    });

    await ctx.db.patch("drinkLog", id, {
      sessionId:
        input.sessionId === undefined ? drinkLog.sessionId : input.sessionId,
      drinkId: input.drinkId ?? drinkLog.drinkId,
      consumedAt: input.consumedAt ?? drinkLog.consumedAt,
      volumeMl: input.volumeMl ?? drinkLog.volumeMl,
      location:
        input.location === undefined ? drinkLog.location : input.location,
      updatedAt: Date.now(),
    });

    return null;
  });

export const softDelete = authMutation
  .input({ id: v.id("drinkLog") })
  .returns(v.null())
  .handler(async (ctx, { id }) => {
    await getDrinkLog(ctx, { id });
    const now = Date.now();
    await ctx.db.patch("drinkLog", id, {
      updatedAt: now,
      deletedAt: now,
    });
    return null;
  });

async function getDrinkLog(
  ctx: AuthMutationCtx,
  { id }: { id: Id<"drinkLog"> },
) {
  const drinkLog = await ctx.db.get("drinkLog", id);
  if (!drinkLog) {
    throw new ConvexError("Drink log not found");
  }
  if (drinkLog.userId !== ctx.user._id) {
    throw new ConvexError(
      "You do not have permission to access this drink log",
    );
  }
  if (drinkLog.deletedAt !== null) {
    throw new ConvexError("Drink log has been deleted");
  }

  return drinkLog;
}

async function checkReferences(
  ctx: AuthMutationCtx,
  {
    sessionId,
    drinkId,
  }: {
    sessionId?: Id<"session"> | null | undefined;
    drinkId?: Id<"drink"> | undefined;
  },
) {
  if (drinkId !== undefined) {
    const drink = await ctx.db.get("drink", drinkId);
    if (!drink || drink.deletedAt !== null) {
      throw new ConvexError("Drink not found");
    }
    if (drink.ownerId !== null && drink.ownerId !== ctx.user._id) {
      throw new ConvexError("You do not have permission to use this drink");
    }
  }
  if (sessionId !== undefined && sessionId !== null) {
    await requireSessionAccess(ctx, sessionId, "joined");
  }
}
