import { defineTable } from "convex/server";
import { v } from "convex/values";
import { convexToZod } from "convex-helpers/server/zod4";
import { z } from "zod";

export const badgeTable = defineTable({
  userId: v.id("user"),
  badgeKey: v.string(),
  unlockedAt: v.number(),
  isShown: v.boolean(),
}).index("by_userId_and_badgeKey", ["userId", "badgeKey"]);

export const unlockBadgeInputValidator = convexToZod(
  badgeTable.validator.pick("userId", "badgeKey"),
).extend({
  badgeKey: z.string().min(1),
});

export const setBadgeVisibilityInputValidator = convexToZod(
  badgeTable.validator.pick("badgeKey", "isShown"),
).extend({
  badgeKey: z.string().min(1),
});
