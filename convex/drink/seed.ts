import { ConvexError, v } from "convex/values";
import seedData from "../../assets/seed_data/drinks.json";
import { convex } from "../lib/builder";
import { globalDrinkSeeds } from "./seedData";

const seeds = globalDrinkSeeds(seedData);

export const seedGlobal = convex
  .mutation()
  .input({ dryRun: v.optional(v.boolean()) })
  .returns(
    v.object({
      dryRun: v.boolean(),
      total: v.number(),
      created: v.number(),
      updated: v.number(),
      restored: v.number(),
      retired: v.number(),
      unchanged: v.number(),
    }),
  )
  .handler(async (ctx, { dryRun = false }) => {
    const existing = await ctx.db
      .query("drink")
      .withIndex("by_ownerId_and_deletedAt", (q) => q.eq("ownerId", null))
      .collect();
    const byKey = new Map<string, (typeof existing)[number]>();
    for (const drink of existing) {
      if (drink.seedKey === undefined) continue;
      if (byKey.has(drink.seedKey)) {
        throw new ConvexError(
          `Duplicate global drink seed key: ${drink.seedKey}`,
        );
      }
      byKey.set(drink.seedKey, drink);
    }

    const result = {
      dryRun,
      total: seeds.length,
      created: 0,
      updated: 0,
      restored: 0,
      retired: 0,
      unchanged: 0,
    };
    const now = Date.now();
    for (const seed of seeds) {
      const drink = byKey.get(seed.seedKey);
      if (!drink) {
        result.created++;
        if (!dryRun) {
          await ctx.db.insert("drink", {
            ...seed,
            ownerId: null,
            deletedAt: null,
            updatedAt: now,
          });
        }
        continue;
      }

      if (drink.deletedAt !== null) {
        result.restored++;
      } else if (
        drink.name !== seed.name ||
        drink.drinkCategory.kind !== seed.drinkCategory.kind ||
        drink.alcoholPercentage !== seed.alcoholPercentage
      ) {
        result.updated++;
      } else {
        result.unchanged++;
        continue;
      }
      if (!dryRun) {
        await ctx.db.patch("drink", drink._id, {
          ...seed,
          deletedAt: null,
          updatedAt: now,
        });
      }
    }

    const currentKeys = new Set(seeds.map((seed) => seed.seedKey));
    for (const [seedKey, drink] of byKey) {
      if (currentKeys.has(seedKey) || drink.deletedAt !== null) continue;
      result.retired++;
      if (!dryRun) {
        await ctx.db.patch("drink", drink._id, {
          deletedAt: now,
          updatedAt: now,
        });
      }
    }
    return result;
  });
