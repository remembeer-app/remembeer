import { defineTable } from "convex/server";
import { v } from "convex/values";
import { drinkCategoryValidator } from "../drink/schema";

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

const commonFields = {
  sessionId: v.id("session"),
  userId: v.id("user"),
  sessionMemberStatus: sessionMemberStatusValidator,
  sessionMemberRole: sessionMemberRoleValidator,
  updatedAt: v.number(),
  sessionEndedAt: v.nullable(v.number()),
  sessionDeletedAt: v.nullable(v.number()),
};

export const sessionMemberValidator = v.object({
  ...commonFields,
  kind: v.literal("sessionMember"),
});

export const partyMemberValidator = v.object({
  ...commonFields,
  kind: v.literal("partyMember"),
  selectedClass: v.nullable(drinkCategoryValidator),
  beerpongOptIn: v.boolean(),
});

export const sessionMemberTable = defineTable(
  v.union(sessionMemberValidator, partyMemberValidator),
)
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
    "userId",
    "sessionMemberStatus.kind",
    "sessionDeletedAt",
    "sessionEndedAt",
  ]);
