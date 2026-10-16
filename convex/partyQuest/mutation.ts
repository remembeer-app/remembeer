import { ConvexError, v } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { authMutation } from "../lib/authenticated";
import { access } from "../lib/access";
import { getMembership, requireSessionAccess } from "../session/access";
import {
  activeQuests,
  cancelJob,
  ensureLifecycle,
  issueQuest,
  randomBreak,
  scheduleExpiry,
  scheduleIssuance,
  stopQuests,
  validateSchedule,
} from "./lifecycle";
import { eligiblePairs, memberPair } from "./eligibility";
import { loadQuestContext } from "./context";
import { requireOngoingQuestParty, loadQuest, requireSocialQuestsEnabled } from "./access";

const questPartyAdminAccess = access<{ sessionId: Id<"session"> }>()
  .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "admin"))
  .use(requireOngoingQuestParty);

export const setEnabled = authMutation
  .input({ sessionId: v.id("session"), enabled: v.boolean() })
  .returns(v.null())
  .extend(questPartyAdminAccess.extend)
  .handler(async (ctx, { sessionId, enabled }) => {
    const { session } = ctx;

    const now = Date.now();
    if (!enabled) {
      await stopQuests(ctx, session, now);

      return null;
    }

    await ctx.db.patch("session", sessionId, {
      modules: { ...session.modules, socialQuestsEnabled: true },
      updatedAt: now,
    });
    await ensureLifecycle(ctx, session, now);

    return null;
  });

export const startNext = authMutation
  .input({ sessionId: v.id("session") })
  .returns(v.id("partyQuest"))
  .extend(questPartyAdminAccess.use(requireSocialQuestsEnabled).extend)
  .handler(async (ctx) => {
    const { session } = ctx;

    return await issueQuest(ctx, session, Date.now());
  });

export const setSchedule = authMutation
  .input({
    sessionId: v.id("session"),
    minIntervalMinutes: v.number(),
    maxIntervalMinutes: v.number(),
    defaultDurationMinutes: v.number(),
  })
  .returns(v.null())
  .extend(questPartyAdminAccess.extend)
  .handler(async (ctx, { sessionId, ...settings }) => {
    const { session } = ctx;
    validateSchedule(settings);

    const now = Date.now();
    const party = {
      ...session,
      questSchedule: { ...session.questSchedule, ...settings },
    };

    await ctx.db.patch("session", sessionId, {
      questSchedule: party.questSchedule,
      updatedAt: now,
    });
    if (!party.modules.socialQuestsEnabled) return null;

    await cancelJob(ctx, party);

    const active = await activeQuests(ctx, sessionId);

    const running = active.find((quest) => quest.endsAt > now);
    if (running) {
      await scheduleExpiry(
        ctx,
        party,
        running,
        running.endsAt + randomBreak(party.questSchedule),
        now,
      );
    } else {
      for (const quest of active)
        await ctx.db.patch("partyQuest", quest._id, {
          status: "expired",
          updatedAt: now,
        });

      await scheduleIssuance(ctx, party, now + randomBreak(party.questSchedule), now);
    }

    return null;
  });

export const selectPartner = authMutation
  .input({ questId: v.id("partyQuest"), selectedUserId: v.id("user") })
  .returns(v.boolean())
  .extend(
    access<{ questId: Id<"partyQuest"> }>()
      .use((ctx, { questId }) => loadQuest(ctx, { id: questId }))
      .use((ctx) => requireSessionAccess(ctx, ctx.quest.sessionId, "joined"))
      .use(requireOngoingQuestParty)
      .use(requireSocialQuestsEnabled).extend,
  )
  .handler(async (ctx, { questId, selectedUserId }) => {
    const { quest, session } = ctx;

    const now = Date.now();
    if (quest.status !== "active" || now < quest.startsAt || now >= quest.endsAt)
      throw new ConvexError("Quest is not active");

    if (ctx.user._id === selectedUserId) throw new ConvexError("You cannot select yourself");

    const partner = await getMembership(ctx, quest.sessionId, selectedUserId);
    if (partner?.kind !== "partyMember" || partner.sessionMemberStatus.kind !== "joined")
      throw new ConvexError("Partner must be a joined party member");

    const pair = memberPair(ctx.user._id, selectedUserId);
    if (
      quest.results.some(
        (result) =>
          result.firstUserId === pair.firstUserId && result.secondUserId === pair.secondUserId,
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
      throw new ConvexError("A member of this pair already completed the quest");

    const matched = quest.selections.some(
      (selection) =>
        selection.userId === selectedUserId && selection.selectedUserId === ctx.user._id,
    );
    if (matched) {
      const { players, previousPairs, finalistTeamIds } = await loadQuestContext(ctx, session, now);
      if (
        !eligiblePairs(quest, players, previousPairs, finalistTeamIds).some(
          (candidate) =>
            candidate.firstUserId === pair.firstUserId &&
            candidate.secondUserId === pair.secondUserId,
        )
      )
        throw new ConvexError("This pair does not currently qualify for this quest");
    }

    await ctx.db.patch("partyQuest", questId, {
      selections: [
        ...quest.selections.filter((selection) => selection.userId !== ctx.user._id),
        { userId: ctx.user._id, selectedUserId, selectedAt: now },
      ],
      results: matched ? [...quest.results, { ...pair, completedAt: now }] : quest.results,
      updatedAt: now,
    });

    return matched;
  });
