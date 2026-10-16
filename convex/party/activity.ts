import { ConvexError, v, type Infer } from "convex/values";
import { paginationOptsValidator } from "convex/server";
import type { Doc, Id } from "../_generated/dataModel";
import { authQuery } from "../lib/authenticated";
import { requireSessionAccess } from "../session/access";
import { publicUser, publicUserValidator } from "../user/publicProfile";
import { drinkCategoryValidator } from "../drink/schema";
import { drinkScoreBreakdown } from "./scoring";
import { loadBeerpongAwards } from "../beerpongTournament/scoring";
import { partyActivityMaxPageSize } from "./constants";

const cursorValidator = v.object({ occurredAt: v.number(), id: v.string() });
const kindValidator = v.union(
  v.literal("drinkLog"),
  v.literal("socialQuest"),
  v.literal("partyChallenge"),
  v.literal("beerpongPlacement"),
);
const common = {
  id: v.string(),
  occurredAt: v.number(),
  participantIds: v.array(v.id("user")),
};
const entryValidator = v.union(
  v.object({
    ...common,
    kind: v.literal("beerpongPlacement"),
    tournamentId: v.id("beerpongTournament"),
    tournamentName: v.string(),
    teamId: v.id("beerpongTeam"),
    teamName: v.string(),
    placement: v.number(),
    userId: v.id("user"),
    scoreUnits: v.number(),
  }),
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

// A live projection of source rows. Cursors use the same descending ordering.
// Filter changes start a new pagination subscription.
// TODO(ohtenkay): Replace this projection with an activity table containing
// stable event keys, session IDs, timestamps, kinds, participants, and source
// references. Maintain those rows transactionally when source events are
// created, edited, removed, or awarded. Index the feed by session and ordering
// fields, with indexed access paths for its kind and participant filters.
// Paginate that table natively, then hydrate source details and public profiles
// only for the returned page, preserving live names and score calculations.
export const activity = authQuery
  .input({
    sessionId: v.id("session"),
    kinds: v.optional(v.array(kindValidator)),
    participantIds: v.optional(v.array(v.id("user"))),
    paginationOpts: paginationOptsValidator,
  })
  .returns(
    v.object({
      page: v.array(
        v.object({
          entry: entryValidator,
          users: v.array(publicUserValidator),
        }),
      ),
      continueCursor: v.string(),
      isDone: v.boolean(),
      splitCursor: v.optional(v.string()),
      pageStatus: v.optional(v.literal("SplitRecommended")),
    }),
  )
  .handler(
    async (ctx, { sessionId, kinds, participantIds, paginationOpts }) => {
      const pageSize = paginationOpts.numItems;
      const cursor = decodeCursor(paginationOpts.cursor);
      const endCursor = decodeCursor(paginationOpts.endCursor ?? null);
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
      // TODO(ohtenkay): Eliminate these full-session reads and the in-memory
      // merge/sort once the activity index exists. Every page subscription,
      // including split pages and reactive reruns, currently repeats this work;
      // the smaller response does not reduce the source data read or processed.
      const [members, logs, quests, challenges, beerpongAwards] =
        await Promise.all([
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
          loadBeerpongAwards(ctx, sessionId),
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

      for (const award of beerpongAwards) {
        entries.push({
          ...award,
          kind: "beerpongPlacement",
          id: JSON.stringify([
            "beerpongPlacement",
            award.tournamentId,
            award.teamId,
            award.userId,
          ]),
        });
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
      const bounded = paginationOpts.endCursor !== undefined;
      const page = bounded
        ? filtered.filter(
            (entry) => !endCursor || compare(entry, endCursor) <= 0,
          )
        : filtered.slice(0, pageSize);
      const hasMore = bounded
        ? endCursor !== null &&
          filtered.some((entry) => compare(entry, endCursor) > 0)
        : filtered.length > pageSize;
      const last = page[page.length - 1];
      const users = await Promise.all(
        [...new Set(page.flatMap((entry) => entry.participantIds))].map((id) =>
          publicUser(ctx, id),
        ),
      );

      const profiles = new Map(
        users.filter((user) => user !== null).map((user) => [user._id, user]),
      );

      return {
        page: page.map((entry) => ({
          entry,
          users: entry.participantIds.flatMap((id) => {
            const user = profiles.get(id);

            return user ? [user] : [];
          }),
        })),
        isDone: !hasMore,
        continueCursor: bounded
          ? (paginationOpts.endCursor ?? "")
          : hasMore && last
            ? encodeCursor(last)
            : "",
        // Unlike a native DB paginate call, a projection has no server-side
        // page journal. Splitting pins both ranges before subsequent live
        // updates can move the boundary between loaded pages. An empty string
        // marks the unbounded tail, so backdated activity remains visible too.
        // TODO(ohtenkay): Return native paginate() cursor/split metadata after
        // indexing activity, and remove this eager splitting, compare(), and
        // the custom JSON cursor encoder/decoder. Keep Dartvex cursors opaque.
        ...(page.length
          ? {
              splitCursor: encodeCursor(
                page[Math.floor((page.length - 1) / 2)]!,
              ),
              ...(!bounded ? { pageStatus: "SplitRecommended" as const } : {}),
            }
          : {}),
      };
    },
  );

function decodeCursor(
  raw: string | null,
): Infer<typeof cursorValidator> | null {
  if (raw === null || raw === "") return null;

  try {
    const value: unknown = JSON.parse(raw);
    if (
      typeof value === "object" &&
      value !== null &&
      "occurredAt" in value &&
      typeof value.occurredAt === "number" &&
      Number.isFinite(value.occurredAt) &&
      "id" in value &&
      typeof value.id === "string"
    )
      return { occurredAt: value.occurredAt, id: value.id };
  } catch {
    // Invalid client cursors are reported as an application error below.
  }

  throw new ConvexError("Invalid activity cursor");
}

function encodeCursor(value: Infer<typeof cursorValidator>): string {
  return JSON.stringify({ occurredAt: value.occurredAt, id: value.id });
}
