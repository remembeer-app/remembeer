import { defineTable } from "convex/server";
import { v } from "convex/values";

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
).index("by_ownerId_and_kind", ["ownerId", "kind"]);
