import { defineTable } from "convex/server";
import { v } from "convex/values";
import { drinkCategoryValidator } from "../drink/schema";
import { pairQuestKinds } from "./constants";

export const partyQuestKindValidator = v.union(
  v.object({
    kind: v.literal("toastWithClass"),
    drinkCategory: drinkCategoryValidator,
  }),
  ...pairQuestKinds.map((kind) => v.object({ kind: v.literal(kind) })),
);

const memberPairValidator = v.object({
  firstUserId: v.id("user"),
  secondUserId: v.id("user"),
});

const commonFields = {
  sessionId: v.id("session"),
  title: v.string(),
  instructions: v.string(),
  pointsUnits: v.number(),
  startsAt: v.number(),
  endsAt: v.number(),
  status: v.union(v.literal("active"), v.literal("expired"), v.literal("cancelled")),
  selections: v.array(
    v.object({
      userId: v.id("user"),
      selectedUserId: v.id("user"),
      selectedAt: v.number(),
    }),
  ),
  results: v.array(memberPairValidator.extend({ completedAt: v.number() })),
  updatedAt: v.number(),
};

export const partyQuestTable = defineTable(
  v.union(...partyQuestKindValidator.members.map((quest) => quest.extend(commonFields))),
)
  .index("by_sessionId_and_startsAt", ["sessionId", "startsAt"])
  .index("by_sessionId_and_status", ["sessionId", "status"])
  .index("by_sessionId_and_kind", ["sessionId", "kind"]);
