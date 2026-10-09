import { defineTable } from "convex/server";
import { v } from "convex/values";
import { convexToZod } from "convex-helpers/server/zod4";
import { z } from "zod";

const commonFields = {
  ownerId: v.id("user"),
  name: v.string(),
  description: v.string(),
  startedAt: v.number(),
  endedAt: v.nullable(v.number()),
  updatedAt: v.number(),
  deletedAt: v.nullable(v.number()),
};

export const sessionValidator = v.object({
  ...commonFields,
  kind: v.literal("session"),
});

export const partyValidator = v.object({
  ...commonFields,
  kind: v.literal("party"),
});

export const sessionTable = defineTable(
  v.union(sessionValidator, partyValidator),
)
  .index("by_ownerId_and_kind", ["ownerId", "kind"])
  .index("by_ownerId_and_deletedAt_and_endedAt", [
    "ownerId",
    "deletedAt",
    "endedAt",
  ]);

const timestamp = z.number().int().min(-8640000000000000).max(8640000000000000);

export const createSessionInputValidator = convexToZod(
  sessionValidator.pick("name", "description", "startedAt"),
).extend({
  name: z.string().trim().min(3).max(30),
  description: z.string().trim().max(500),
  startedAt: timestamp,
});

export const updateSessionInputValidator = createSessionInputValidator
  .partial()
  .extend({
    id: convexToZod(v.id("session")),
    endedAt: timestamp.nullable().optional(),
  });
