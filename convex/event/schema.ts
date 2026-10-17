import { defineTable } from "convex/server";
import { v, type Infer } from "convex/values";
import { drinkCategoryValidator } from "../drink/schema";

const commonFields = {
  userId: v.id("user"),
  drinkLogId: v.id("drinkLog"),
};

const drinkLogSnapshot = v.object({
  consumedAt: v.number(),
  volumeMl: v.number(),
  drink: v.object({
    id: v.id("drink"),
    drinkCategory: drinkCategoryValidator,
    alcoholPercentage: v.number(),
  }),
});

const drinkLogCreatedValidator = v.object({
  ...commonFields,
  kind: v.literal("drinkLogCreated"),
  drinkLog: drinkLogSnapshot,
});

const drinkLogUpdatedValidator = v.object({
  ...commonFields,
  kind: v.literal("drinkLogUpdated"),
  before: drinkLogSnapshot,
  after: drinkLogSnapshot,
});

const drinkLogDeletedValidator = v.object({
  ...commonFields,
  kind: v.literal("drinkLogDeleted"),
  drinkLog: drinkLogSnapshot,
});

const eventValidator = v.union(
  drinkLogCreatedValidator,
  drinkLogUpdatedValidator,
  drinkLogDeletedValidator,
);

export type Event = Infer<typeof eventValidator>;

export const eventTable = defineTable(eventValidator)
  .index("by_userId", ["userId"])
  .index("by_kind", ["kind"])
  .index("by_drinkLogId", ["drinkLogId"]);
