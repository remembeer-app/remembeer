import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authMutation, type AuthMutationCtx } from "../lib/authenticated";
import { schema } from "../schema";
import type { Id } from "../_generated/dataModel";
import { getDrinkLogHandler } from "./query";
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
    const drinkLog = await getDrinkLogHandler(ctx, { id });
    await checkReferences(ctx, input);
    await ctx.db.patch("drinkLog", id, {
      sessionId: input.sessionId ?? drinkLog.sessionId,
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
    await getDrinkLogHandler(ctx, { id });
    const now = Date.now();
    await ctx.db.patch("drinkLog", id, {
      updatedAt: now,
      deletedAt: now,
    });
    return null;
  });

async function checkReferences(
  ctx: AuthMutationCtx,
  { sessionId, drinkId }: {
    sessionId?: Id<"session"> | undefined;
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
  if (sessionId !== undefined) {
    const session = await ctx.db.get("session", sessionId);
    if (!session || session.deletedAt !== null) {
      throw new ConvexError("Session not found");
    }
    if (session.ownerId !== ctx.user._id) {
      const member = await ctx.db
        .query("sessionMember")
        .withIndex("by_sessionId_and_userId", (q) =>
          q.eq("sessionId", sessionId).eq("userId", ctx.user._id),
        )
        .unique();
      if (member?.sessionMemberStatus.kind !== "joined") {
        throw new ConvexError("You must be a session member to log a drink");
      }
    }
  }
}
