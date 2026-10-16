import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { convexToZod } from "convex-helpers/server/zod4";
import { z } from "zod";
import { authMutation } from "../lib/authenticated";
import { getMembership } from "../session/access";
import { requireChallenge, requireParty } from "./access";
import { activeChallenges, scheduleExpiry, stopChallenges } from "./lifecycle";
import {
  maxChallengeTitleLength,
  maxChallengeInstructionsLength,
  minChallengePointsUnits,
  maxChallengePointsUnits,
  minChallengeDurationMinutes,
  maxChallengeDurationMinutes,
  millisecondsPerMinute,
} from "./constants";

const fields = z.object({
  title: z.string().trim().min(1).max(maxChallengeTitleLength),
  instructions: z.string().trim().min(1).max(maxChallengeInstructionsLength),
  pointsUnits: z
    .number()
    .int()
    .min(minChallengePointsUnits)
    .max(maxChallengePointsUnits),
  durationMinutes: z
    .number()
    .int()
    .min(minChallengeDurationMinutes)
    .max(maxChallengeDurationMinutes),
});
const idInput = { id: v.id("partyChallenge") };

export const setEnabled = authMutation
  .input({ sessionId: v.id("session"), enabled: v.boolean() })
  .returns(v.null())
  .handler(async (ctx, { sessionId, enabled }) => {
    const session = await requireParty(ctx, sessionId, "admin");
    const now = Date.now();
    if (!enabled) await stopChallenges(ctx, session, now);
    await ctx.db.patch("session", sessionId, {
      modules: { ...session.modules, partyChallengesEnabled: enabled },
      updatedAt: now,
    });
    return null;
  });

export const create = authMutation
  .extend(WithZod)
  .input(fields.extend({ sessionId: convexToZod(v.id("session")) }))
  .returns(v.id("partyChallenge"))
  .handler(async (ctx, { sessionId, durationMinutes, ...input }) => {
    const session = await requireParty(ctx, sessionId, "admin");
    if (!session.modules.partyChallengesEnabled)
      throw new ConvexError("Challenges are disabled");
    const now = Date.now();
    const active = await activeChallenges(ctx, sessionId);
    if (active.some((challenge) => challenge.endsAt > now))
      throw new ConvexError("A challenge is already active");
    for (const challenge of active)
      await ctx.db.patch("partyChallenge", challenge._id, {
        status: "expired",
        updatedAt: now,
      });
    const endsAt = now + durationMinutes * millisecondsPerMinute;
    const id = await ctx.db.insert("partyChallenge", {
      ...input,
      sessionId,
      startsAt: now,
      endsAt,
      status: "active",
      createdByUserId: ctx.user._id,
      updatedAt: now,
      winners: [],
    });
    await scheduleExpiry(ctx, id, endsAt);
    return id;
  });

export const update = authMutation
  .extend(WithZod)
  .input(fields.partial().extend({ id: convexToZod(v.id("partyChallenge")) }))
  .returns(v.null())
  .handler(async (ctx, { id, durationMinutes, ...input }) => {
    const { challenge } = await requireChallenge(ctx, id, "admin");
    const now = Date.now();
    let endsAt = challenge.endsAt;
    if (durationMinutes !== undefined) {
      endsAt = challenge.startsAt + durationMinutes * millisecondsPerMinute;
      if (
        challenge.status !== "active" ||
        challenge.endsAt <= now ||
        endsAt <= now
      )
        throw new ConvexError(
          "Only an active challenge can have its duration changed; deadline must be in the future",
        );
      await scheduleExpiry(ctx, id, endsAt);
    }
    await ctx.db.patch("partyChallenge", id, {
      title: input.title ?? challenge.title,
      instructions: input.instructions ?? challenge.instructions,
      pointsUnits: input.pointsUnits ?? challenge.pointsUnits,
      endsAt,
      updatedAt: now,
    });
    return null;
  });

// Winners can be corrected after completion/expiry, while the party is ongoing.
export const addWinner = authMutation
  .input({ ...idInput, userId: v.id("user") })
  .returns(v.null())
  .handler(async (ctx, { id, userId }) => {
    const { challenge } = await requireChallenge(ctx, id, "admin");
    const member = await getMembership(ctx, challenge.sessionId, userId);
    if (
      !member ||
      member.kind !== "partyMember" ||
      member.sessionMemberStatus.kind !== "joined" ||
      !(await ctx.db.get("user", userId))
    )
      throw new ConvexError("Winner must be a joined party member");
    if (challenge.winners.some((winner) => winner.userId === userId))
      return null;
    const now = Date.now();
    await ctx.db.patch("partyChallenge", id, {
      winners: [...challenge.winners, { userId, awardedAt: now }],
      updatedAt: now,
    });
    return null;
  });

export const removeWinner = authMutation
  .input({ ...idInput, userId: v.id("user") })
  .returns(v.null())
  .handler(async (ctx, { id, userId }) => {
    const { challenge } = await requireChallenge(ctx, id, "admin");
    await ctx.db.patch("partyChallenge", id, {
      winners: challenge.winners.filter((winner) => winner.userId !== userId),
      updatedAt: Date.now(),
    });
    return null;
  });

function close(status: "completed" | "cancelled") {
  return authMutation
    .input(idInput)
    .returns(v.null())
    .handler(async (ctx, { id }) => {
      const { challenge } = await requireChallenge(ctx, id, "admin");
      if (challenge.status === status) return null;
      const now = Date.now();
      if (challenge.status !== "active" || challenge.endsAt <= now)
        throw new ConvexError("Challenge is not active");
      await ctx.db.patch("partyChallenge", id, { status, updatedAt: now });
      return null;
    });
}

export const complete = close("completed");
export const cancel = close("cancelled");
