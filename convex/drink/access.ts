import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";

export async function loadDrink(ctx: AuthQueryCtx, { id }: { id: Id<"drink"> }) {
  const drink = await ctx.db.get("drink", id);
  if (!drink) {
    throw new ConvexError("Drink not found");
  }

  return { drink };
}

export function drinkOwnerAccess(ctx: AuthQueryCtx & { drink: Doc<"drink"> }) {
  if (ctx.drink.ownerId !== ctx.user._id) {
    throw new ConvexError("You do not have permission to access this drink");
  }

  return {};
}

export function undeletedDrinkAccess(ctx: { drink: Doc<"drink"> }) {
  if (ctx.drink.deletedAt !== null) {
    throw new ConvexError("Drink has been deleted");
  }

  return {};
}
