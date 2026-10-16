import { defineTable } from "convex/server";
import { v } from "convex/values";

export const beerpongTournamentTable = defineTable({
  sessionId: v.id("session"),
  name: v.string(),
  status: v.union(
    v.literal("enrollment"),
    v.literal("setup"),
    v.literal("active"),
    v.literal("completed"),
    v.literal("cancelled"),
  ),
  teamCount: v.number(),
  thirdPlaceEnabled: v.boolean(),
  firstPlacePointsUnits: v.number(),
  secondPlacePointsUnits: v.number(),
  thirdPlacePointsUnits: v.number(),
  createdByUserId: v.id("user"),
  updatedAt: v.number(),
  completedAt: v.nullable(v.number()),
}).index("by_sessionId", ["sessionId"]);
