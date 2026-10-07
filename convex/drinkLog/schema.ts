import { defineTable } from "convex/server";
import { v } from "convex/values";
import { convexToZod } from "convex-helpers/server/zod4";
import { z } from "zod";

const location = v.object({
  latitude: v.number(),
  longitude: v.number(),
  accuracy: v.nullable(v.number()),
});

export const drinkLogTable = defineTable({
  userId: v.id("user"),
  sessionId: v.id("session"),
  drinkId: v.id("drink"),
  consumedAt: v.number(),
  volumeMl: v.number(),
  location: v.nullable(location),
  updatedAt: v.number(),
  deletedAt: v.nullable(v.number()),
})
  .index("by_userId_and_deletedAt_and_consumedAt", [
    "userId",
    "deletedAt",
    "consumedAt",
  ])
  .index("by_sessionId", ["sessionId"]);

export const createDrinkLogInputValidator = convexToZod(
  drinkLogTable.validator.pick(
    "sessionId",
    "drinkId",
    "consumedAt",
    "volumeMl",
    "location",
  ),
).extend({
  consumedAt: z.number().int(),
  volumeMl: z.number().positive(),
  location: z
    .object({
      latitude: z.number().min(-90).max(90),
      longitude: z.number().min(-180).max(180),
      accuracy: z.number().nonnegative().nullable(),
    })
    .nullable(),
});

export const updateDrinkLogInputValidator = createDrinkLogInputValidator
  .partial()
  .extend({ id: convexToZod(v.id("drinkLog")) });
