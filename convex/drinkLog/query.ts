import { ConvexError, v } from "convex/values";
import { authQuery, type AuthQueryCtx } from "../lib/authenticated";
import { schema } from "../schema";
import type { Id } from "../_generated/dataModel";

export const list = authQuery
  .returns(v.array(schema.doc("drinkLog")))
  // ponytail: returns all active logs; paginate when user histories grow.
  .handler(async (ctx) =>
    ctx.db
      .query("drinkLog")
      .withIndex("by_userId_and_deletedAt_and_consumedAt", (q) =>
        q.eq("userId", ctx.user._id).eq("deletedAt", null),
      )
      .order("desc")
      .collect(),
  );

export const get = authQuery
  .input({ id: v.id("drinkLog") })
  .returns(schema.doc("drinkLog"))
  .handler(getDrinkLogHandler);

export async function getDrinkLogHandler(
  ctx: AuthQueryCtx,
  { id }: { id: Id<"drinkLog"> },
) {
  const drinkLog = await ctx.db.get("drinkLog", id);
  if (!drinkLog) {
    throw new ConvexError("Drink log not found");
  }
  if (drinkLog.userId !== ctx.user._id) {
    throw new ConvexError("You do not have permission to access this drink log");
  }
  if (drinkLog.deletedAt !== null) {
    throw new ConvexError("Drink log has been deleted");
  }
  return drinkLog;
}
