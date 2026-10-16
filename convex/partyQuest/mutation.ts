import { ConvexError, v } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { authMutation, type AuthMutationCtx } from "../lib/authenticated";
import { getMembership, requireSessionAccess } from "../session/access";
import { builtInQuests } from "./catalog";
import {
  earlyQuestCount,
  regularQuestCount,
  questCycleLength,
  minQuestDurationMinutes,
  maxQuestDurationMinutes,
  millisecondsPerMinute,
} from "./constants";
import { eligiblePairs, memberPair } from "./eligibility";
import { loadQuestContext } from "./context";

async function requireActiveParty(
  ctx: AuthMutationCtx,
  sessionId: Id<"session">,
  permission: "admin" | "joined",
) {
  const { session } = await requireSessionAccess(ctx, sessionId, permission);
  if (session.kind !== "party" || session.endedAt !== null)
    throw new ConvexError("An ongoing party is required");
  return session;
}

function activeQuests(ctx: AuthMutationCtx, sessionId: Id<"session">) {
  return ctx.db
    .query("partyQuest")
    .withIndex("by_sessionId_and_status", (q) =>
      q.eq("sessionId", sessionId).eq("status", "active"),
    )
    .collect();
}

export const setEnabled = authMutation
  .input({ sessionId: v.id("session"), enabled: v.boolean() })
  .returns(v.null())
  .handler(async (ctx, { sessionId, enabled }) => {
    const session = await requireActiveParty(ctx, sessionId, "admin");
    const now = Date.now();
    if (!enabled) {
      for (const quest of await activeQuests(ctx, sessionId)) {
        await ctx.db.patch("partyQuest", quest._id, {
          status: quest.endsAt <= now ? "expired" : "cancelled",
          updatedAt: now,
        });
      }
    }
    await ctx.db.patch("session", sessionId, {
      modules: { ...session.modules, socialQuestsEnabled: enabled },
      updatedAt: now,
    });
    return null;
  });

export const startNext = authMutation
  .input({ sessionId: v.id("session") })
  .returns(v.nullable(v.id("partyQuest")))
  .handler(async (ctx, { sessionId }) => {
    const session = await requireActiveParty(ctx, sessionId, "admin");
    if (!session.modules.socialQuestsEnabled)
      throw new ConvexError("Social quests are disabled");
    const now = Date.now();
    for (const quest of await activeQuests(ctx, sessionId)) {
      if (quest.endsAt > now) return quest._id;
      await ctx.db.patch("partyQuest", quest._id, {
        status: "expired",
        updatedAt: now,
      });
    }
    const duration = session.questSchedule.defaultDurationMinutes;
    if (
      !Number.isInteger(duration) ||
      duration < minQuestDurationMinutes ||
      duration > maxQuestDurationMinutes
    )
      throw new ConvexError("Invalid quest duration");
    const { players, previousPairs, quests } = await loadQuestContext(
      ctx,
      sessionId,
      now,
    );
    if (players.length < 2) return null;
    const cycleCount = quests.length % questCycleLength;
    const cycle = cycleCount === 0 ? [] : quests.slice(-cycleCount);
    const identity = (quest: {
      kind: string;
      drinkCategory?: { kind: string };
    }) => `${quest.kind}:${quest.drinkCategory?.kind ?? ""}`;
    const used = new Set(cycle.map(identity));
    const candidates = builtInQuests
      .filter(
        (quest) =>
          quest.availability === "early" ||
          (quest.availability === "regular" && cycleCount >= earlyQuestCount) ||
          (quest.availability === "final" && cycleCount >= regularQuestCount),
      )
      .map((definition) => ({
        definition,
        pairs: eligiblePairs(definition, players, previousPairs),
      }))
      .filter((candidate) => candidate.pairs.length > 0);
    const unused = candidates.filter(
      (candidate) => !used.has(identity(candidate.definition)),
    );
    const choices = unused.length ? unused : candidates;
    const chosen = choices[Math.floor(Math.random() * choices.length)];
    if (!chosen) return null;
    const { availability, ...definition } = chosen.definition;
    return await ctx.db.insert("partyQuest", {
      ...definition,
      sessionId,
      startsAt: now,
      endsAt: now + duration * millisecondsPerMinute,
      status: "active",
      updatedAt: now,
      selections: [],
      results: [],
    });
  });

export const selectPartner = authMutation
  .input({ questId: v.id("partyQuest"), selectedUserId: v.id("user") })
  .returns(v.boolean())
  .handler(async (ctx, { questId, selectedUserId }) => {
    const quest = await ctx.db.get("partyQuest", questId);
    if (!quest) throw new ConvexError("Quest not found");
    const session = await requireActiveParty(ctx, quest.sessionId, "joined");
    if (!session.modules.socialQuestsEnabled)
      throw new ConvexError("Social quests are disabled");
    const now = Date.now();
    if (
      quest.status !== "active" ||
      now < quest.startsAt ||
      now >= quest.endsAt
    )
      throw new ConvexError("Quest is not active");
    if (ctx.user._id === selectedUserId)
      throw new ConvexError("You cannot select yourself");
    const partner = await getMembership(ctx, quest.sessionId, selectedUserId);
    if (
      partner?.kind !== "partyMember" ||
      partner.sessionMemberStatus.kind !== "joined"
    )
      throw new ConvexError("Partner must be a joined party member");
    const pair = memberPair(ctx.user._id, selectedUserId);
    if (
      quest.results.some(
        (result) =>
          result.firstUserId === pair.firstUserId &&
          result.secondUserId === pair.secondUserId,
      )
    )
      return true;
    if (
      quest.results.some((result) =>
        [result.firstUserId, result.secondUserId].some(
          (id) => id === ctx.user._id || id === selectedUserId,
        ),
      )
    )
      throw new ConvexError(
        "A member of this pair already completed the quest",
      );
    const matched = quest.selections.some(
      (selection) =>
        selection.userId === selectedUserId &&
        selection.selectedUserId === ctx.user._id,
    );
    if (matched) {
      const { players, previousPairs } = await loadQuestContext(
        ctx,
        quest.sessionId,
        now,
      );
      if (
        !eligiblePairs(quest, players, previousPairs).some(
          (candidate) =>
            candidate.firstUserId === pair.firstUserId &&
            candidate.secondUserId === pair.secondUserId,
        )
      )
        throw new ConvexError(
          "This pair does not currently qualify for this quest",
        );
    }
    await ctx.db.patch("partyQuest", questId, {
      selections: [
        ...quest.selections.filter(
          (selection) => selection.userId !== ctx.user._id,
        ),
        { userId: ctx.user._id, selectedUserId, selectedAt: now },
      ],
      results: matched
        ? [...quest.results, { ...pair, completedAt: now }]
        : quest.results,
      updatedAt: now,
    });
    return matched;
  });
