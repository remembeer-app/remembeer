import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";

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
