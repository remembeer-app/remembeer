import { defineTable } from "convex/server";
import { v } from "convex/values";

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
  location,
  updatedAt: v.number(),
  deletedAt: v.nullable(v.number()),
})
  .index("by_userId_and_consumedAt", ["userId", "consumedAt"])
  .index("by_sessionId", ["sessionId"]);
