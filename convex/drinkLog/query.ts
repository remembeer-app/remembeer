import { v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { z } from "zod";
import { authQuery } from "../lib/authenticated";
import { logicalDayBoundaries, logicalDayAt } from "../lib/logicalDay";
import { schema } from "../schema";
import { listForDayHandler } from "../session/query";

export const listForDay = authQuery
  .extend(WithZod)
  .input(
    z.object({
      date: z.iso.date().optional(),
      at: z.number().int(),
    }),
  )
  .returns(
    v.object({
      today: v.string(),
      date: v.string(),
      sessions: v.array(
        v.object({
          _id: v.id("session"),
          kind: v.union(v.literal("session"), v.literal("party")),
          name: v.string(),
          description: v.string(),
          startedAtLocal: v.string(),
          endedAtLocal: v.nullable(v.string()),
        }),
      ),
      logs: v.array(
        schema.doc("drinkLog").extend({
          drink: v.nullable(schema.doc("drink")),
          consumedAtLocal: v.string(),
        }),
      ),
    }),
  )
  .handler(async (ctx, { date: selectedDate, at }) => {
    const today = logicalDayAt(
      at,
      ctx.user.endOfDayBoundary,
      ctx.user.timeZone,
    );

    const date =
      selectedDate === undefined || selectedDate > today ? today : selectedDate;

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

    const referencedIds = new Set(
      logs.map((log) => log.sessionId).filter((id) => id !== null),
    );

    const sessions = await listForDayHandler(ctx, start, end, referencedIds);

    const localTime = (at: number) =>
      Temporal.Instant.fromEpochMilliseconds(at)
        .toZonedDateTimeISO(ctx.user.timeZone)
        .toPlainDateTime()
        .toString();

    return {
      today,
      date,
      sessions: sessions.map((session) => ({
        _id: session._id,
        kind: session.kind,
        name: session.name,
        description: session.description,
        startedAtLocal: localTime(session.startedAt),
        endedAtLocal:
          session.endedAt === null ? null : localTime(session.endedAt),
      })),
      logs: await Promise.all(
        logs.map(async (log) => ({
          ...log,
          drink: await ctx.db.get("drink", log.drinkId),
          consumedAtLocal: localTime(log.consumedAt),
        })),
      ),
    };
  });
