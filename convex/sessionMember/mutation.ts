import { ConvexError, v } from "convex/values";
import { convexToZod } from "convex-helpers/server/zod4";
import { WithZod } from "fluent-convex/zod";
import type { Doc, Id } from "../_generated/dataModel";
import { authMutation, type AuthMutationCtx } from "../lib/authenticated";
import { access } from "../lib/access";
import { requireSessionAccess } from "../session/access";
import { sessionIndexFields } from "./sessionIndex";
import { partyMemberValidator, sessionMemberRoleValidator } from "./schema";
import { defaultPartyMemberFields } from "./constants";
import {
  loadTargetUser,
  loadTargetMember,
  requireTargetNotBanned,
  requireTargetNotOwner,
  requireTargetMember,
  requireCanModerateTarget,
  requireCallerNotOwner,
  requireCallerMember,
  requireJoinedTargetMember,
  requireOngoingClassParty,
  requireJoinedTargetPartyMember,
  requireBeerpongOptInParty,
  requireCallerPartyMember,
} from "./access";

const sessionInput = { sessionId: v.id("session") };
const targetInput = { ...sessionInput, userId: v.id("user") };

const callerMembershipAccess = access<{ sessionId: Id<"session"> }>()
  .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "membership"))
  .use(requireCallerNotOwner)
  .use(requireCallerMember);

const targetModerationAccess = access<{
  sessionId: Id<"session">;
  userId: Id<"user">;
}>()
  .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "admin"))
  .use(requireTargetNotOwner("moderate"))
  .use(loadTargetMember)
  .use(requireTargetMember)
  .use(requireCanModerateTarget);

export const invite = authMutation
  .input(targetInput)
  .returns(v.null())
  .extend(
    access<{ sessionId: Id<"session">; userId: Id<"user"> }>()
      .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "admin"))
      .use(loadTargetUser)
      .use(loadTargetMember)
      .use(requireTargetNotBanned)
      .extend,
  )
  .handler(async (ctx, { sessionId, userId }) => {
    const { session, targetMember } = ctx;

    if (
      targetMember?.sessionMemberStatus.kind === "invited" ||
      targetMember?.sessionMemberStatus.kind === "joined"
    )
      return null;

    const fields = {
      ...sessionIndexFields(session),
      sessionMemberStatus: { kind: "invited" as const },
      sessionMemberRole: { kind: "member" as const },
      updatedAt: Date.now(),
    };

    if (targetMember)
      await ctx.db.patch("sessionMember", targetMember._id, fields);
    else
      await ctx.db.insert("sessionMember", {
        ...(session.kind === "party"
          ? defaultPartyMemberFields
          : { kind: "sessionMember" as const }),
        sessionId,
        userId,
        ...fields,
      });

    return null;
  });

export const accept = authMutation
  .input(sessionInput)
  .returns(v.null())
  .extend(callerMembershipAccess.extend)
  .handler((ctx) => respond(ctx, "joined"));

export const decline = authMutation
  .input(sessionInput)
  .returns(v.null())
  .extend(callerMembershipAccess.extend)
  .handler((ctx) => respond(ctx, "declined"));

export const leave = authMutation
  .input(sessionInput)
  .returns(v.null())
  .extend(callerMembershipAccess.extend)
  .handler((ctx) => respond(ctx, "left"));

async function respond(
  ctx: AuthMutationCtx & { member: Doc<"sessionMember"> },
  next: "joined" | "declined" | "left",
) {
  const { member } = ctx;

  const current = member.sessionMemberStatus.kind;
  if (current === next) return null;

  if (current !== (next === "left" ? "joined" : "invited"))
    throw new ConvexError("Invalid membership transition");

  await ctx.db.patch("sessionMember", member._id, {
    sessionMemberStatus: { kind: next },
    sessionMemberRole: { kind: "member" },
    updatedAt: Date.now(),
  });

  return null;
}

export const remove = authMutation
  .input(targetInput)
  .returns(v.null())
  .extend(targetModerationAccess.extend)
  .handler((ctx) => moderate(ctx, "left"));

export const ban = authMutation
  .input(targetInput)
  .returns(v.null())
  .extend(targetModerationAccess.extend)
  .handler((ctx) => moderate(ctx, "banned"));

export const unban = authMutation
  .input(targetInput)
  .returns(v.null())
  .extend(targetModerationAccess.extend)
  .handler((ctx) => moderate(ctx, "unban"));

async function moderate(
  ctx: AuthMutationCtx & { targetMember: Doc<"sessionMember"> },
  action: "left" | "banned" | "unban",
) {
  const { targetMember } = ctx;

  const next = action === "unban" ? "left" : action;
  const current = targetMember.sessionMemberStatus.kind;
  if (current === next) return null;

  if (
    (action === "unban" && current !== "banned") ||
    (action === "left" && current !== "invited" && current !== "joined")
  ) {
    throw new ConvexError("Invalid membership transition");
  }

  await ctx.db.patch("sessionMember", targetMember._id, {
    sessionMemberStatus: { kind: next },
    sessionMemberRole: { kind: "member" },
    updatedAt: Date.now(),
  });

  return null;
}

export const setRole = authMutation
  .input({ ...targetInput, role: sessionMemberRoleValidator })
  .returns(v.null())
  .extend(
    access<{ sessionId: Id<"session">; userId: Id<"user"> }>()
      .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "owner"))
      .use(requireTargetNotOwner("changeRole"))
      .use(loadTargetMember)
      .use(requireJoinedTargetMember)
      .extend,
  )
  .handler(async (ctx, { role }) => {
    const { targetMember } = ctx;

    if (targetMember.sessionMemberRole.kind === role.kind) return null;

    await ctx.db.patch("sessionMember", targetMember._id, {
      sessionMemberRole: role,
      updatedAt: Date.now(),
    });

    return null;
  });

export const setClass = authMutation
  .extend(WithZod)
  .input(
    convexToZod(
      partyMemberValidator.pick("sessionId", "userId", "selectedClass"),
    ),
  )
  .returns(v.null())
  .extend(
    access<{ sessionId: Id<"session">; userId: Id<"user"> }>()
      .use((ctx, { sessionId, userId }) =>
        requireSessionAccess(
          ctx,
          sessionId,
          userId === ctx.user._id ? "joined" : "admin",
        ),
      )
      .use(requireOngoingClassParty)
      .use(loadTargetMember)
      .use(requireJoinedTargetPartyMember)
      .extend,
  )
  .handler(async (ctx, { selectedClass }) => {
    const { targetMember, isAdmin } = ctx;

    if (targetMember.selectedClass?.kind === selectedClass?.kind) return null;

    if (targetMember.selectedClass !== null && !isAdmin)
      throw new ConvexError("Only admins can change a selected class");

    const now = Date.now();
    await ctx.db.patch("sessionMember", targetMember._id, {
      selectedClass,
      updatedAt: now,
    });

    return null;
  });

export const setBeerpongOptIn = authMutation
  .input({ sessionId: v.id("session"), optedIn: v.boolean() })
  .returns(v.null())
  .extend(
    access<{ sessionId: Id<"session"> }>()
      .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "joined"))
      .use(requireBeerpongOptInParty)
      .use(requireCallerPartyMember)
      .extend,
  )
  .handler(async (ctx, { optedIn }) => {
    const { member } = ctx;

    await ctx.db.patch("sessionMember", member._id, {
      beerpongOptIn: optedIn,
      updatedAt: Date.now(),
    });

    return null;
  });
