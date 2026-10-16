import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import type { Id } from "../_generated/dataModel";
import { authMutation } from "../lib/authenticated";
import { access } from "../lib/access";
import { stopChallenges } from "../partyChallenge/lifecycle";
import { stopQuests } from "../partyQuest/lifecycle";
import { syncSessionIndex } from "../sessionMember/sessionIndex";
import { defaultPartyMemberFields } from "../sessionMember/constants";
import { createSessionInputValidator, updateSessionInputValidator } from "./schema";
import { requireSessionAccess } from "./access";
import {
  defaultPartyQuestMinIntervalMinutes,
  defaultPartyQuestMaxIntervalMinutes,
  defaultPartyQuestDurationMinutes,
} from "./constants";

export const create = authMutation
  .extend(WithZod)
  .input(createSessionInputValidator)
  .returns(v.id("session"))
  .handler(async (ctx, input) => {
    const now = Date.now();
    const sessionId = await ctx.db.insert("session", {
      ...input,
      kind: "session",
      ownerId: ctx.user._id,
      endedAt: null,
      updatedAt: now,
      deletedAt: null,
    });

    await ctx.db.insert("sessionMember", {
      kind: "sessionMember",
      sessionId,
      userId: ctx.user._id,
      sessionMemberStatus: { kind: "joined" },
      sessionMemberRole: { kind: "admin" },
      updatedAt: now,
      sessionEndedAt: null,
      sessionDeletedAt: null,
    });

    return sessionId;
  });

export const update = authMutation
  .extend(WithZod)
  .input(updateSessionInputValidator)
  .returns(v.null())
  .extend(
    access<{ id: Id<"session"> }>()
      .use((ctx, { id }) => requireSessionAccess(ctx, id, "admin"))
      .extend,
  )
  .handler(async (ctx, { id, ...input }) => {
    const { session } = ctx;

    const startedAt = input.startedAt ?? session.startedAt;
    const endedAt =
      input.endedAt === undefined ? session.endedAt : input.endedAt;
    if (endedAt !== null && endedAt < startedAt)
      throw new ConvexError("End time must not precede start time");

    await ctx.db.patch("session", id, {
      name: input.name ?? session.name,
      description: input.description ?? session.description,
      startedAt,
      endedAt,
      updatedAt: Date.now(),
    });

    if (endedAt !== null) {
      const now = Date.now();
      await stopQuests(ctx, session, now);
      await stopChallenges(ctx, session, now);
    }

    if (endedAt !== session.endedAt) {
      await syncSessionIndex(ctx, { ...session, endedAt });
    }

    return null;
  });

export const softDelete = authMutation
  .input({ id: v.id("session") })
  .returns(v.null())
  .extend(
    access<{ id: Id<"session"> }>()
      .use((ctx, { id }) => requireSessionAccess(ctx, id, "owner"))
      .extend,
  )
  .handler(async (ctx, { id }) => {
    const { session } = ctx;

    const now = Date.now();

    await stopQuests(ctx, session, now);
    await stopChallenges(ctx, session, now);
    await ctx.db.patch("session", id, { deletedAt: now, updatedAt: now });
    await syncSessionIndex(ctx, { ...session, deletedAt: now });

    return null;
  });

export const promoteToParty = authMutation
  .input({ id: v.id("session") })
  .returns(v.null())
  .extend(
    access<{ id: Id<"session"> }>()
      .use((ctx, { id }) => requireSessionAccess(ctx, id, "admin"))
      .extend,
  )
  .handler(async (ctx, { id }) => {
    const { session } = ctx;
    if (session.kind === "party") return null;

    if (session.endedAt !== null)
      throw new ConvexError("Only ongoing sessions can become parties");

    const now = Date.now();
    await ctx.db.patch("session", id, {
      kind: "party",
      activatedAt: now,
      activatedByUserId: ctx.user._id,
      modules: {
        socialQuestsEnabled: false,
        partyChallengesEnabled: false,
        beerpongEnabled: false,
      },
      questSchedule: {
        minIntervalMinutes: defaultPartyQuestMinIntervalMinutes,
        maxIntervalMinutes: defaultPartyQuestMaxIntervalMinutes,
        defaultDurationMinutes: defaultPartyQuestDurationMinutes,
        nextQuestAt: null,
        scheduledFunctionId: null,
      },
      updatedAt: now,
    });

    const members = await ctx.db
      .query("sessionMember")
      .withIndex("by_sessionId_and_userId", (q) => q.eq("sessionId", id))
      .collect();

    for (const member of members) {
      await ctx.db.patch("sessionMember", member._id, {
        ...defaultPartyMemberFields,
        updatedAt: now,
      });
    }

    return null;
  });
