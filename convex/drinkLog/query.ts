import { v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { z } from "zod";
import { authQuery } from "../lib/authenticated";
import { logicalDayBoundaries } from "../lib/logicalDay";
import { schema } from "../schema";

export const listForDay = authQuery
  .extend(WithZod)
  .input(
    z.object({
      date: z.iso.date(),
    }),
  )
  .returns(v.array(schema.doc("drinkLog")))
  .handler(async (ctx, { date }) => {
    const { start, end } = logicalDayBoundaries(
      date,
      ctx.user.endOfDayBoundary,
      ctx.user.timeZone,
    );
    return await ctx.db
      .query("drinkLog")
      .withIndex("by_userId_and_deletedAt_and_consumedAt", (q) =>
        q
          .eq("userId", ctx.user._id)
          .eq("deletedAt", null)
          .gte("consumedAt", start)
          .lt("consumedAt", end),
      )
      .order(ctx.user.drinkLogSortOrder)
      .collect();
  });
