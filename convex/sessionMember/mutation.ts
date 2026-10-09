import { ConvexError, v } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { authMutation, type AuthMutationCtx } from "../lib/authenticated";
import { getMembership, requireSessionAccess } from "../session/access";
import { sessionIndexFields } from "./sessionIndex";
import { sessionMemberRoleValidator } from "./schema";

const sessionInput = { sessionId: v.id("session") };
const targetInput = { ...sessionInput, userId: v.id("user") };

export const invite = authMutation
  .input(targetInput)
  .returns(v.null())
  .handler(async (ctx, { sessionId, userId }) => {
    const { session } = await requireSessionAccess(ctx, sessionId, "admin");
    if (!(await ctx.db.get("user", userId)))
      throw new ConvexError("User not found");

    const member = await getMembership(ctx, sessionId, userId);
    if (member?.sessionMemberStatus.kind === "banned")
      throw new ConvexError("Unban this user before inviting them");

    if (
      member?.sessionMemberStatus.kind === "invited" ||
      member?.sessionMemberStatus.kind === "joined"
    )
      return null;

    const fields = {
      ...sessionIndexFields(session),
      sessionMemberStatus: { kind: "invited" as const },
      sessionMemberRole: { kind: "member" as const },
      updatedAt: Date.now(),
    };

    if (member) await ctx.db.patch("sessionMember", member._id, fields);
    else await ctx.db.insert("sessionMember", { sessionId, userId, ...fields });

    return null;
  });

export const accept = authMutation
  .input(sessionInput)
  .returns(v.null())
  .handler((ctx, { sessionId }) => respond(ctx, sessionId, "joined"));

export const decline = authMutation
  .input(sessionInput)
  .returns(v.null())
  .handler((ctx, { sessionId }) => respond(ctx, sessionId, "declined"));

export const leave = authMutation
  .input(sessionInput)
  .returns(v.null())
  .handler((ctx, { sessionId }) => respond(ctx, sessionId, "left"));

async function respond(
  ctx: AuthMutationCtx,
  sessionId: Id<"session">,
  next: "joined" | "declined" | "left",
) {
  const { session, member } = await requireSessionAccess(
    ctx,
    sessionId,
    "membership",
  );
  if (session.ownerId === ctx.user._id)
    throw new ConvexError("The session owner cannot change their membership");
  if (!member) throw new ConvexError("Membership not found");

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
  .handler((ctx, input) => moderate(ctx, input, "left"));

export const ban = authMutation
  .input(targetInput)
  .returns(v.null())
  .handler((ctx, input) => moderate(ctx, input, "banned"));

export const unban = authMutation
  .input(targetInput)
  .returns(v.null())
  .handler((ctx, input) => moderate(ctx, input, "unban"));

async function moderate(
  ctx: AuthMutationCtx,
  { sessionId, userId }: { sessionId: Id<"session">; userId: Id<"user"> },
  action: "left" | "banned" | "unban",
) {
  const { session, isOwner } = await requireSessionAccess(
    ctx,
    sessionId,
    "admin",
  );
  if (session.ownerId === userId)
    throw new ConvexError("The session owner cannot be moderated");

  const member = await getMembership(ctx, sessionId, userId);
  if (!member) throw new ConvexError("Membership not found");
  if (!isOwner && member.sessionMemberRole.kind === "admin")
    throw new ConvexError("Only the owner can moderate admins");

  const next = action === "unban" ? "left" : action;
  const current = member.sessionMemberStatus.kind;
  if (current === next) return null;
  if (
    (action === "unban" && current !== "banned") ||
    (action === "left" && current !== "invited" && current !== "joined")
  ) {
    throw new ConvexError("Invalid membership transition");
  }

  await ctx.db.patch("sessionMember", member._id, {
    sessionMemberStatus: { kind: next },
    sessionMemberRole: { kind: "member" },
    updatedAt: Date.now(),
  });

  return null;
}

export const setRole = authMutation
  .input({ ...targetInput, role: sessionMemberRoleValidator })
  .returns(v.null())
  .handler(async (ctx, { sessionId, userId, role }) => {
    const { session } = await requireSessionAccess(ctx, sessionId, "owner");
    if (session.ownerId === userId)
      throw new ConvexError("The session owner's role cannot be changed");

    const member = await getMembership(ctx, sessionId, userId);
    if (!member || member.sessionMemberStatus.kind !== "joined")
      throw new ConvexError("Only joined members can have roles assigned");
    if (member.sessionMemberRole.kind === role.kind) return null;

    await ctx.db.patch("sessionMember", member._id, {
      sessionMemberRole: role,
      updatedAt: Date.now(),
    });

    return null;
  });
