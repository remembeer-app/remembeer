import { v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { z } from "zod";
import { authQuery } from "../lib/authenticated";
import { logicalDayBoundaries, logicalDayAt } from "../lib/logicalDay";
import { schema } from "../schema";

export const listForDay = authQuery
  .extend(WithZod)
  .input(
    z.object({
      date: z.iso.date(),
    }),
  )
  .returns(v.array(schema.doc("drinkLog").extend({
    drink: v.nullable(schema.doc("drink")),
    consumedAtLocal: v.string(),
  })))
  .handler(async (ctx, { date }) => {
    const { start, end } = logicalDayBoundaries(
      date,
      ctx.user.endOfDayBoundary,
      ctx.user.timeZone,
    );
    const logs = await ctx.db
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
    return await Promise.all(logs.map(async (log) => ({
      ...log,
      drink: await ctx.db.get("drink", log.drinkId),
      consumedAtLocal: Temporal.Instant.fromEpochMilliseconds(log.consumedAt)
        .toZonedDateTimeISO(ctx.user.timeZone).toPlainDateTime().toString(),
    })));
  });

export const dayContext = authQuery
  .extend(WithZod)
  .input(z.object({ at: z.number().int() }))
  .returns(v.object({ today: v.string(), nextBoundary: v.number() }))
  .handler(async (ctx, { at }) => logicalDayAt(
    at,
    ctx.user.endOfDayBoundary,
    ctx.user.timeZone,
  ));
