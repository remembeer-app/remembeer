import { ConvexError, v, type Infer } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import { authQuery } from "../lib/authenticated";
import { requireSessionAccess } from "../session/access";
import { publicUser, publicUserValidator } from "../user/publicProfile";
import { drinkCategoryValidator } from "../drink/schema";
import { drinkScoreBreakdown } from "./scoring";
import {
  partyActivityDefaultPageSize,
  partyActivityMaxPageSize,
} from "./constants";

const cursorValidator = v.object({ occurredAt: v.number(), id: v.string() });
const kindValidator = v.union(
  v.literal("drinkLog"),
  v.literal("socialQuest"),
  v.literal("partyChallenge"),
);
const common = {
  id: v.string(),
  occurredAt: v.number(),
  participantIds: v.array(v.id("user")),
};
const entryValidator = v.union(
  v.object({
    ...common,
    kind: v.literal("partyChallenge"),
    challengeId: v.id("partyChallenge"),
    challengeTitle: v.string(),
    userId: v.id("user"),
    scoreUnits: v.number(),
  }),
  v.object({
    ...common,
    kind: v.literal("drinkLog"),
    drinkLogId: v.id("drinkLog"),
    userId: v.id("user"),
    drinkId: v.id("drink"),
    drinkName: v.string(),
    drinkCategory: drinkCategoryValidator,
    volumeMl: v.number(),
    alcoholMl: v.number(),
    baseDrinkScoreUnits: v.number(),
    classBonusScoreUnits: v.number(),
    scoreUnits: v.number(),
  }),
  v.object({
    ...common,
    kind: v.literal("socialQuest"),
    questId: v.id("partyQuest"),
    questTitle: v.string(),
    firstUserId: v.id("user"),
    secondUserId: v.id("user"),
    // Each participant earns this amount, not half of it.
    scoreUnits: v.number(),
  }),
);

// Descending time, then descending stable ID. Use the same ordering for cursors.
function compare(
  a: Infer<typeof cursorValidator>,
  b: Infer<typeof cursorValidator>,
) {
  return (
    b.occurredAt - a.occurredAt || (a.id < b.id ? 1 : a.id > b.id ? -1 : 0)
  );
}

// A live projection of source rows; restart pagination after changing filters or timestamps.
export const activity = authQuery
  .input({
    sessionId: v.id("session"),
    kinds: v.optional(v.array(kindValidator)),
    participantIds: v.optional(v.array(v.id("user"))),
    cursor: v.optional(cursorValidator),
    pageSize: v.optional(v.number()),
  })
  .returns(
    v.object({
      entries: v.array(entryValidator),
      users: v.array(publicUserValidator),
      nextCursor: v.nullable(cursorValidator),
      hasMore: v.boolean(),
    }),
  )
  .handler(
    async (
      ctx,
      {
        sessionId,
        kinds,
        participantIds,
        cursor,
        pageSize = partyActivityDefaultPageSize,
      },
    ) => {
      const { session } = await requireSessionAccess(ctx, sessionId, "joined");
      if (session.kind !== "party")
        throw new ConvexError("A party is required");
      if (
        !Number.isInteger(pageSize) ||
        pageSize < 1 ||
        pageSize > partyActivityMaxPageSize
      )
        throw new ConvexError(
          `Page size must be an integer from 1 to ${partyActivityMaxPageSize}`,
        );
      const now = Date.now();
      const [members, logs, quests, challenges] = await Promise.all([
        ctx.db
          .query("sessionMember")
          .withIndex("by_sessionId_and_userId", (q) =>
            q.eq("sessionId", sessionId),
          )
          .collect(),
        ctx.db
          .query("drinkLog")
          .withIndex("by_sessionId", (q) => q.eq("sessionId", sessionId))
          .collect(),
        ctx.db
          .query("partyQuest")
          .withIndex("by_sessionId_and_startsAt", (q) =>
            q.eq("sessionId", sessionId),
          )
          .collect(),
        ctx.db
          .query("partyChallenge")
          .withIndex("by_sessionId_and_startsAt", (q) =>
            q.eq("sessionId", sessionId),
          )
          .collect(),
      ]);
      const classes = new Map(
        members.map((member) => [
          member.userId,
          member.kind === "partyMember" ? member.selectedClass : null,
        ]),
      );
      const drinks = new Map<Id<"drink">, Doc<"drink">>();
      const entries: Infer<typeof entryValidator>[] = [];
      for (const log of logs) {
        if (log.deletedAt !== null || log.consumedAt > now) continue;
        let drink = drinks.get(log.drinkId);
        if (!drink) {
          const referencedDrink = await ctx.db.get("drink", log.drinkId);
          if (!referencedDrink)
            throw new ConvexError("A logged drink is missing");
          drink = referencedDrink;
          drinks.set(log.drinkId, drink);
        }
        entries.push({
          kind: "drinkLog",
          id: JSON.stringify(["drinkLog", log._id]),
          occurredAt: log.consumedAt,
          participantIds: [log.userId],
          drinkLogId: log._id,
          userId: log.userId,
          drinkId: log.drinkId,
          drinkName: drink.name,
          drinkCategory: drink.drinkCategory,
          volumeMl: log.volumeMl,
          ...drinkScoreBreakdown(
            log.volumeMl,
            drink.alcoholPercentage,
            classes.get(log.userId)?.kind === drink.drinkCategory.kind,
          ),
        });
      }
      const seen = new Set<string>();
      for (const quest of quests) {
        for (const result of quest.results) {
          const [firstUserId, secondUserId] =
            result.firstUserId < result.secondUserId
              ? ([result.firstUserId, result.secondUserId] as const)
              : ([result.secondUserId, result.firstUserId] as const);
          const id = JSON.stringify([
            "socialQuest",
            quest._id,
            firstUserId,
            secondUserId,
          ]);
          if (seen.has(id)) continue;
          seen.add(id);
          entries.push({
            kind: "socialQuest",
            id,
            occurredAt: result.completedAt,
            participantIds: [firstUserId, secondUserId],
            firstUserId,
            secondUserId,
            questId: quest._id,
            questTitle: quest.title,
            scoreUnits: quest.pointsUnits,
          });
        }
      }
      for (const challenge of challenges) {
        for (const winner of challenge.winners) {
          entries.push({
            kind: "partyChallenge",
            id: JSON.stringify([
              "partyChallenge",
              challenge._id,
              winner.userId,
            ]),
            occurredAt: winner.awardedAt,
            participantIds: [winner.userId],
            challengeId: challenge._id,
            challengeTitle: challenge.title,
            userId: winner.userId,
            scoreUnits: challenge.pointsUnits,
          });
        }
      }
      const filtered = entries
        .filter(
          (entry) =>
            (!kinds?.length || kinds.includes(entry.kind)) &&
            (!participantIds?.length ||
              entry.participantIds.some((id) => participantIds.includes(id))) &&
            (!cursor || compare(entry, cursor) > 0),
        )
        .sort(compare);
      const page = filtered.slice(0, pageSize);
      const hasMore = filtered.length > pageSize;
      const last = page[page.length - 1];
      const users = await Promise.all(
        [...new Set(page.flatMap((entry) => entry.participantIds))].map((id) =>
          publicUser(ctx, id),
        ),
      );
      return {
        entries: page,
        users: users.filter((user) => user !== null),
        hasMore,
        nextCursor:
          hasMore && last ? { occurredAt: last.occurredAt, id: last.id } : null,
      };
    },
  );
