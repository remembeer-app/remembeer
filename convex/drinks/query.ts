import { ConvexError, v } from "convex/values";
import { authQuery, type AuthQueryCtx } from "../lib/authenticated";
import { schema } from "../schema";
import type { Id } from "../_generated/dataModel";

export const listCustom = authQuery
  .returns(v.array(schema.doc("drinks")))
  .handler(listAvailableHanlder);

export const listAvailable = authQuery
  .returns(v.array(schema.doc("drinks")))
  .handler(async (ctx) => {
    const [customDrinks, globalDrinks] = await Promise.all([
      listAvailableHanlder(ctx),
      ctx.db
        .query("drinks")
        .withIndex("by_ownerId_and_deletedAt", (q) =>
          q.eq("ownerId", null).eq("deletedAt", null),
        )
        .collect(),
    ]);

    return [...customDrinks, ...globalDrinks];
  });

function listAvailableHanlder(ctx: AuthQueryCtx) {
  return ctx.db
    .query("drinks")
    .withIndex("by_ownerId_and_deletedAt", (q) =>
      q.eq("ownerId", ctx.user._id).eq("deletedAt", null),
    )
    .collect();
}

export const get = authQuery
  .input({
    id: v.id("drinks"),
  })
  .returns(schema.doc("drinks"))
  .handler(getCustomDrinkHandler);

export async function getCustomDrinkHandler(
  ctx: AuthQueryCtx,
  { id }: { id: Id<"drinks"> },
) {
  const drink = await ctx.db.get("drinks", id);
  if (!drink) {
    throw new ConvexError("Drink not found");
  }

  if (drink.ownerId !== ctx.user._id) {
    throw new ConvexError("You do not have permission to access this drink");
  }

  if (drink.deletedAt !== null) {
    throw new ConvexError("Drink has been deleted");
  }

  return drink;
}
