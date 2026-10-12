import { defineTable } from "convex/server";
import { v } from "convex/values";
import { z } from "zod";
import { convexToZod } from "convex-helpers/server/zod4";
import {
  leaderboardIcons,
  minLeaderboardNameLength,
  maxLeaderboardNameLength,
} from "./constants";

export const leaderboardTable = defineTable({
  ownerId: v.id("user"),
  name: v.string(),
  iconName: v.string(),
  inviteCode: v.string(),
  timeZone: v.string(),
  endOfDayBoundary: v.number(),
  updatedAt: v.number(),
  deletedAt: v.nullable(v.number()),
})
  .index("by_ownerId", ["ownerId"])
  .index("by_inviteCode", ["inviteCode"]);

export const createLeaderboardInputValidator = z.object({
  name: z
    .string()
    .trim()
    .min(minLeaderboardNameLength)
    .max(maxLeaderboardNameLength),
  iconName: z.enum(leaderboardIcons),
});
export const updateLeaderboardInputValidator = createLeaderboardInputValidator
  .partial()
  .extend({ id: convexToZod(v.id("leaderboard")) });
