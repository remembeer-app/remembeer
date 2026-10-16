import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { requireSessionAccess } from "../session/access";

export async function loadDrinkLog(
  ctx: AuthQueryCtx,
  { id }: { id: Id<"drinkLog"> },
) {
  const drinkLog = await ctx.db.get("drinkLog", id);
  if (!drinkLog) {
    throw new ConvexError("Drink log not found");
  }

  return { drinkLog };
}

export function requireDrinkLogOwner(
  ctx: AuthQueryCtx & { drinkLog: Doc<"drinkLog"> },
) {
  if (ctx.drinkLog.userId !== ctx.user._id) {
    throw new ConvexError(
      "You do not have permission to access this drink log",
    );
  }

  return {};
}

export function requireUndeletedDrinkLog(ctx: { drinkLog: Doc<"drinkLog"> }) {
  if (ctx.drinkLog.deletedAt !== null) {
    throw new ConvexError("Drink log has been deleted");
  }

  return {};
}

export function requireValidConsumedTime(
  ctx: AuthQueryCtx & { drinkLog?: Doc<"drinkLog"> },
  { consumedAt }: { consumedAt?: number | undefined },
) {
  const now = Date.now();
  consumedAt ??= ctx.drinkLog?.consumedAt ?? now;
  if (consumedAt > now) {
    throw new ConvexError("Consumed time cannot be in the future");
  }

  return { now, consumedAt };
}

export async function requireUsableDrink(
  ctx: AuthQueryCtx & { drinkLog?: Doc<"drinkLog"> },
  { drinkId }: { drinkId?: Id<"drink"> | undefined },
) {
  if (drinkId === undefined || drinkId === ctx.drinkLog?.drinkId) return {};

  const drink = await ctx.db.get("drink", drinkId);
  if (!drink || drink.deletedAt !== null) {
    throw new ConvexError("Drink not found");
  }

  if (drink.ownerId !== null && drink.ownerId !== ctx.user._id) {
    throw new ConvexError("You do not have permission to use this drink");
  }

  return {};
}

export async function requireJoinedDrinkLogSession(
  ctx: AuthQueryCtx,
  { sessionId }: { sessionId?: Id<"session"> | null | undefined },
) {
  if (sessionId !== undefined && sessionId !== null) {
    await requireSessionAccess(ctx, sessionId, "joined");
  }

  return {};
}
