import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { z } from "zod";
import { convexToZod } from "convex-helpers/server/zod4";
import { authQuery } from "../lib/authenticated";
import { logicalDayAt, logicalDayBoundaries } from "../lib/logicalDay";
import { schema } from "../schema";
import { publicUser, publicUserValidator } from "../user/publicProfile";
import type { Doc, Id } from "../_generated/dataModel";
import { listMemberships, requireLeaderboardAccess } from "./access";
import {
  beerVolumeMl,
  inviteCodeLength,
  inviteCodeCharacters,
} from "./constants";

const idInput = { id: v.id("leaderboard") };

export const listCurrent = authQuery
  .input({})
  .returns(v.array(schema.doc("leaderboard")))
  .handler(async (ctx) => {
    const memberships = await ctx.db
      .query("leaderboardMember")
      .withIndex("by_userId_and_status", (q) =>
        q.eq("userId", ctx.user._id).eq("status", "joined"),
      )
      .collect();
    const leaderboards = await Promise.all(
      memberships.map((member) =>
        ctx.db.get("leaderboard", member.leaderboardId),
      ),
    );
    return leaderboards
      .filter((board) => board !== null)
      .filter((board) => board.deletedAt === null)
      .sort(
        (a, b) =>
          a._creationTime - b._creationTime || a._id.localeCompare(b._id),
      );
  });

export const get = authQuery
  .input(idInput)
  .returns(
    v.object({
      leaderboard: schema.doc("leaderboard"),
      members: v.array(publicUserValidator),
      bannedMembers: v.array(publicUserValidator),
    }),
  )
  .handler(async (ctx, { id }) => {
    const { leaderboard, isOwner } = await requireLeaderboardAccess(ctx, id);
    const memberships = await listMemberships(ctx, id);
    const profiles = await Promise.all(
      memberships
        .filter((member) => member.status === "joined" || isOwner)
        .map(async (member) => ({
          status: member.status,
          user: await publicUser(ctx, member.userId),
        })),
    );
    return {
      leaderboard,
      members: profiles
        .filter((p) => p.status === "joined")
        .flatMap((p) => (p.user ? [p.user] : [])),
      bannedMembers: profiles
        .filter((p) => p.status === "banned")
        .flatMap((p) => (p.user ? [p.user] : [])),
    };
  });

export const findByInviteCode = authQuery
  .extend(WithZod)
  .input(
    z.object({
      inviteCode: z
        .string()
        .trim()
        .toUpperCase()
        .length(inviteCodeLength)
        .refine(
          (code) =>
            [...code].every((character) =>
              inviteCodeCharacters.includes(character),
            ),
          "Invalid invite code",
        ),
    }),
  )
  .returns(
    v.nullable(
      v.object({
        id: v.id("leaderboard"),
        name: v.string(),
        iconName: v.string(),
        memberCount: v.number(),
      }),
    ),
  )
  .handler(async (ctx, { inviteCode }) => {
    const leaderboard = await ctx.db
      .query("leaderboard")
      .withIndex("by_inviteCode", (q) => q.eq("inviteCode", inviteCode))
      .unique();
    if (!leaderboard || leaderboard.deletedAt !== null) return null;
    return {
      id: leaderboard._id,
      name: leaderboard.name,
      iconName: leaderboard.iconName,
      memberCount: (await listMemberships(ctx, leaderboard._id)).filter(
        (m) => m.status === "joined",
      ).length,
    };
  });

export const standings = authQuery
  .extend(WithZod)
  .input(
    z.object({
      id: convexToZod(v.id("leaderboard")),
      month: z
        .string()
        .regex(/^\d{4}-(0[1-9]|1[0-2])$/)
        .optional(),
    }),
  )
  .returns(
    v.object({
      month: v.string(),
      currentMonth: v.string(),
      nextMonthAt: v.number(),
      entries: v.array(
        v.object({
          user: publicUserValidator,
          beersConsumed: v.number(),
          alcoholConsumedMl: v.number(),
          rankByBeers: v.number(),
          rankByAlcohol: v.number(),
        }),
      ),
    }),
  )
  .handler(async (ctx, { id, month: selectedMonth }) => {
    const { leaderboard } = await requireLeaderboardAccess(ctx, id);
    const { timeZone, endOfDayBoundary } = leaderboard;
    const currentMonth = logicalDayAt(
      Date.now(),
      endOfDayBoundary,
      timeZone,
    ).slice(0, 7);
    const month = selectedMonth ?? currentMonth;
    if (month > currentMonth)
      throw new ConvexError("Cannot view a future reporting month");
    const firstDay = Temporal.PlainDate.from(`${month}-01`);
    const start = logicalDayBoundaries(
      firstDay.toString(),
      endOfDayBoundary,
      timeZone,
    ).start;
    const end = logicalDayBoundaries(
      firstDay.add({ months: 1 }).toString(),
      endOfDayBoundary,
      timeZone,
    ).start;
    const nextMonthAt = logicalDayBoundaries(
      Temporal.PlainDate.from(`${currentMonth}-01`)
        .add({ months: 1 })
        .toString(),
      endOfDayBoundary,
      timeZone,
    ).start;
    const memberships = (await listMemberships(ctx, id)).filter(
      (m) => m.status === "joined",
    );
    const drinkCache = new Map<Id<"drink">, Promise<Doc<"drink"> | null>>();
    // shortcut: totals read every monthly log, add aggregates when query read limits become a constraint.
    const entries = await Promise.all(
      memberships.map(async (member) => {
        const user = await publicUser(ctx, member.userId);
        if (!user) throw new ConvexError("Leaderboard member not found");
        const logs = await ctx.db
          .query("drinkLog")
          .withIndex("by_userId_and_deletedAt_and_consumedAt", (q) =>
            q
              .eq("userId", member.userId)
              .eq("deletedAt", null)
              .gte("consumedAt", start)
              .lt("consumedAt", end),
          )
          .collect();
        let beersConsumed = 0;
        let alcoholConsumedMl = 0;
        for (const log of logs) {
          let drinkPromise = drinkCache.get(log.drinkId);
          if (!drinkPromise) {
            drinkPromise = ctx.db.get("drink", log.drinkId);
            drinkCache.set(log.drinkId, drinkPromise);
          }
          const drink = await drinkPromise;
          if (!drink) throw new ConvexError("A logged drink is missing");
          if (drink.drinkCategory.kind === "beer")
            beersConsumed += log.volumeMl / beerVolumeMl;
          alcoholConsumedMl += (log.volumeMl * drink.alcoholPercentage) / 100;
        }
        return {
          user,
          beersConsumed,
          alcoholConsumedMl,
          rankByBeers: 0,
          rankByAlcohol: 0,
        };
      }),
    );
    const byBeers = [...entries].sort(
      (a, b) =>
        b.beersConsumed - a.beersConsumed ||
        a.user._id.localeCompare(b.user._id),
    );
    const byAlcohol = [...entries].sort(
      (a, b) =>
        b.alcoholConsumedMl - a.alcoholConsumedMl ||
        a.user._id.localeCompare(b.user._id),
    );
    byBeers.forEach((entry, index) => {
      entry.rankByBeers = index + 1;
    });
    byAlcohol.forEach((entry, index) => {
      entry.rankByAlcohol = index + 1;
    });
    return { month, currentMonth, nextMonthAt, entries: byAlcohol };
  });
