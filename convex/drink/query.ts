import { v } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { authQuery, type AuthQueryCtx } from "../lib/authenticated";
import { access } from "../lib/access";
import { schema } from "../schema";
import { loadDrink, requireDrinkOwner, requireUndeletedDrink } from "./access";

export const listCustom = authQuery
  .returns(v.array(schema.doc("drink")))
  .handler(listCustomHanlder);

export const listAvailable = authQuery
  .returns(v.array(schema.doc("drink")))
  .handler(async (ctx) => {
    const [customDrinks, globalDrinks] = await Promise.all([
      listCustomHanlder(ctx),
      ctx.db
        .query("drink")
        .withIndex("by_ownerId_and_deletedAt", (q) =>
          q.eq("ownerId", null).eq("deletedAt", null),
        )
        .collect(),
    ]);

    return [...customDrinks, ...globalDrinks];
  });

function listCustomHanlder(ctx: AuthQueryCtx) {
  return ctx.db
    .query("drink")
    .withIndex("by_ownerId_and_deletedAt", (q) =>
      q.eq("ownerId", ctx.user._id).eq("deletedAt", null),
    )
    .collect();
}

export const get = authQuery
  .input({
    id: v.id("drink"),
  })
  .returns(schema.doc("drink"))
  .extend(
    access<{ id: Id<"drink"> }>()
      .use(loadDrink)
      .use(requireDrinkOwner)
      .use(requireUndeletedDrink)
      .extend,
  )
  .handler(async (ctx) => ctx.drink);
