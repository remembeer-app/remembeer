import { ConvexError, v } from "convex/values";
import { authQuery } from "../lib/authenticated";
import { schema } from "../schema";
import type { Doc, Id } from "../_generated/dataModel";
import { LogicalDay } from "../lib/logicalDay";
import { beerVolumeMl } from "../leaderboard/constants";
import { publicUser, publicUserValidator } from "./publicProfile";
import { normalizeUsername } from "./schema";
import { components } from "../_generated/api";
import { userSearchResultsPerField } from "./constants";

export const get = authQuery
  .input({ userId: v.id("user") })
  .returns(publicUserValidator)
  .handler(async (ctx, { userId }) => {
    const user = await publicUser(ctx, userId);
    if (!user) throw new ConvexError("User not found");

    return user;
  });

export const search = authQuery
  .input({ query: v.string() })
  .returns(v.array(publicUserValidator))
  .handler(async (ctx, { query }) => {
    const emailPrefix = query.trim().toLowerCase();
    const usernamePrefix = normalizeUsername(query);
    if (!emailPrefix) return [];

    const [usernameMatches, emailMatches] = await Promise.all([
      usernamePrefix
        ? ctx.db
            .query("user")
            .withIndex("by_normalizedUsername", (q) =>
              q
                .gte("normalizedUsername", usernamePrefix)
                .lt("normalizedUsername", `${usernamePrefix}\uffff`),
            )
            .take(userSearchResultsPerField)
        : Promise.resolve([]),
      ctx.runQuery(components.betterAuth.adapter.findMany, {
        model: "user",
        where: [
          { field: "email", operator: "gte", value: emailPrefix },
          { field: "email", operator: "lt", value: `${emailPrefix}\uffff` },
        ],
        select: ["_id"],
        sortBy: { field: "email", direction: "asc" },
        paginationOpts: { cursor: null, numItems: userSearchResultsPerField },
      }) as Promise<{ page: { _id: string }[] }>,
    ]);

    const emailUsers = await Promise.all(
      emailMatches.page.map((authUser) =>
        ctx.db
          .query("user")
          .withIndex("by_authUserId", (q) => q.eq("authUserId", authUser._id))
          .unique(),
      ),
    );
    const users = new Map(
      [...usernameMatches, ...emailUsers]
        .filter((user) => user !== null)
        .filter((user) => user._id !== ctx.user._id)
        .map((user) => [user._id, user]),
    );
    const profiles = await Promise.all(
      [...users.values()].map((user) => publicUser(ctx, user._id)),
    );

    return profiles.filter((user) => user !== null);
  });

export const current = authQuery
  .returns(
    v.object({
      ...schema.doc("user").omit("avatarStorageId").fields,
      avatarUrl: v.nullable(v.string()),
    }),
  )
  .handler(async (ctx) => {
    const { avatarStorageId, ...user } = ctx.user;

    return {
      ...user,
      avatarUrl: avatarStorageId ? await ctx.storage.getUrl(avatarStorageId) : null,
    };
  });

export const currentDayConsumption = authQuery
  .input({ refreshAt: v.optional(v.number()) })
  .returns(v.object({ alcoholConsumedMl: v.number(), nextRefreshAt: v.number() }))
  .handler(async (ctx) => {
    const day = new LogicalDay(ctx.user);
    const now = Date.now();
    const { start, end } = day.boundaries(day.at(now));
    const logs = await ctx.db
      .query("drinkLog")
      .withIndex("by_userId_and_deletedAt_and_consumedAt", (q) =>
        q
          .eq("userId", ctx.user._id)
          .eq("deletedAt", null)
          .gte("consumedAt", start)
          .lt("consumedAt", end),
      )
      .collect();

    const drinks = new Map<Id<"drink">, Doc<"drink">>();
    let alcoholConsumedMl = 0;
    let nextRefreshAt = end;
    for (const log of logs) {
      if (log.consumedAt > now) {
        nextRefreshAt = Math.min(nextRefreshAt, log.consumedAt);
        continue;
      }
      let drink = drinks.get(log.drinkId);
      if (!drink) {
        const referencedDrink = await ctx.db.get("drink", log.drinkId);
        if (!referencedDrink) throw new ConvexError("A logged drink is missing");
        drink = referencedDrink;
        drinks.set(log.drinkId, drink);
      }
      alcoholConsumedMl += (log.volumeMl * drink.alcoholPercentage) / 100;
    }
    return { alcoholConsumedMl, nextRefreshAt };
  });

export const stats = authQuery
  .input({ userId: v.id("user"), refreshAt: v.optional(v.number()) })
  .returns(
    v.object({
      totalBeersConsumed: v.number(),
      totalAlcoholConsumed: v.number(),
      beersConsumedLast30Days: v.number(),
      alcoholConsumedLast30Days: v.number(),
      streakDays: v.number(),
      isStreakActive: v.boolean(),
      nextRefreshAt: v.number(),
    }),
  )
  .handler(async (ctx, { userId }) => {
    const user = await ctx.db.get("user", userId);
    if (!user) throw new ConvexError("User not found");

    const userDay = new LogicalDay(user);
    const now = Date.now();
    const today = Temporal.PlainDate.from(userDay.at(now));
    const firstDay = today.subtract({ days: 29 }).toString();
    let nextRefreshAt = userDay.boundaries(today.toString()).end;
    // shortcut: reads the full user history, revisit when Convex query read limits become a constraint.
    const logs = await ctx.db
      .query("drinkLog")
      .withIndex("by_userId_and_deletedAt_and_consumedAt", (q) =>
        q.eq("userId", userId).eq("deletedAt", null),
      )
      .collect();

    const drinks = new Map<Id<"drink">, Doc<"drink">>();
    const drinkingDays = new Set<string>();
    let totalBeersConsumed = 0;
    let totalAlcoholConsumed = 0;
    let beersConsumedLast30Days = 0;
    let alcoholConsumedLast30Days = 0;

    for (const log of logs) {
      if (log.consumedAt > now) {
        nextRefreshAt = Math.min(nextRefreshAt, log.consumedAt);
        continue;
      }

      let drink = drinks.get(log.drinkId);
      if (!drink) {
        const referencedDrink = await ctx.db.get("drink", log.drinkId);
        if (!referencedDrink) throw new ConvexError("A logged drink is missing");

        drink = referencedDrink;
        drinks.set(log.drinkId, drink);
      }

      const beers = drink.drinkCategory.kind === "beer" ? log.volumeMl / beerVolumeMl : 0;
      const alcohol = (log.volumeMl * drink.alcoholPercentage) / 100;
      const day = userDay.at(log.consumedAt);

      totalBeersConsumed += beers;
      totalAlcoholConsumed += alcohol;
      if (day >= firstDay) {
        beersConsumedLast30Days += beers;
        alcoholConsumedLast30Days += alcohol;
      }

      if (alcohol > 0) drinkingDays.add(day);
    }

    const isStreakActive = drinkingDays.has(today.toString());
    let day = isStreakActive ? today : today.subtract({ days: 1 });
    let streakDays = 0;

    while (drinkingDays.has(day.toString())) {
      streakDays++;
      day = day.subtract({ days: 1 });
    }

    return {
      totalBeersConsumed,
      totalAlcoholConsumed,
      beersConsumedLast30Days,
      alcoholConsumedLast30Days,
      streakDays,
      isStreakActive,
      nextRefreshAt,
    };
  });
