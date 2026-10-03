import { defineTable } from "convex/server";
import { v } from "convex/values";
import { convexToZod } from "convex-helpers/server/zod4";
import { z } from "zod";

export const userTable = defineTable({
  authUserId: v.string(),
  username: v.string(),
  normalizedUsername: v.string(),
  accentColor: v.union(
    v.literal("amber"),
    v.literal("rose"),
    v.literal("violet"),
    v.literal("sky"),
    v.literal("emerald"),
    v.literal("lime"),
    v.literal("orange"),
    v.literal("fuchsia"),
  ),
  avatarUrl: v.nullable(v.string()),
  endOfDayBoundary: v.number(),
  defaultDrink: v.nullable(v.id("drink")),
  drinkLogSortOrder: v.union(v.literal("asc"), v.literal("desc")),
}).index("by_authUserId", ["authUserId"]);

export function normalizeUsername(username: string) {
  return username
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/\s/g, "");
}

export const updateUsernameInputValidator = convexToZod(
  userTable.validator.pick("username"),
).extend({
  username: z
    .string()
    .trim()
    .min(3)
    .max(20)
    .refine((username) => normalizeUsername(username).length >= 3, {
      message: "Username must contain at least 3 searchable characters",
    }),
});

export const updateEndOfDayBoundaryInputValidator = convexToZod(
  userTable.validator.pick("endOfDayBoundary"),
).extend({
  endOfDayBoundary: z
    .number()
    .int()
    .min(0)
    .max(24 * 60 - 1),
});
