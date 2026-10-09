import { defineTable } from "convex/server";
import { v } from "convex/values";

const sessionMemberStatusValidator = v.union(
  v.object({ kind: v.literal("invited") }),
  v.object({ kind: v.literal("joined") }),
  v.object({ kind: v.literal("left") }),
  v.object({ kind: v.literal("banned") }),
  v.object({ kind: v.literal("declined") }),
);

export const sessionMemberRoleValidator = v.union(
  v.object({ kind: v.literal("member") }),
  v.object({ kind: v.literal("admin") }),
);

export const sessionMemberTable = defineTable({
  sessionId: v.id("session"),
  userId: v.id("user"),
  sessionMemberStatus: sessionMemberStatusValidator,
  sessionMemberRole: sessionMemberRoleValidator,
  updatedAt: v.number(),
  sessionEndedAt: v.nullable(v.number()),
  sessionDeletedAt: v.nullable(v.number()),
})
  .index("by_sessionId_and_userId", ["sessionId", "userId"])
  .index("by_sessionId_and_sessionMemberStatus_kind", [
    "sessionId",
    "sessionMemberStatus.kind",
  ])
  .index("by_userId_and_sessionMemberStatus_kind", [
    "userId",
    "sessionMemberStatus.kind",
  ])
  .index("by_userId_and_status_and_sessionDeletedAt_and_sessionEndedAt", [
    "userId", "sessionMemberStatus.kind", "sessionDeletedAt", "sessionEndedAt",
  ]);
