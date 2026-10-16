import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { getMembership } from "../session/access";

type Member = Doc<"sessionMember">;
type Session = Doc<"session">;

export async function loadTargetUser(
  ctx: AuthQueryCtx,
  { userId }: { userId: Id<"user"> },
) {
  const targetUser = await ctx.db.get("user", userId);
  if (!targetUser) {
    throw new ConvexError("User not found");
  }

  return { targetUser };
}

export async function loadTargetMember(
  ctx: AuthQueryCtx & { session: Session; member: Member | null },
  { userId }: { userId: Id<"user"> },
) {
  const targetMember = userId === ctx.user._id
    ? ctx.member
    : await getMembership(ctx, ctx.session._id, userId);

  return { targetMember };
}

export function requireTargetNotBanned(ctx: { targetMember: Member | null }) {
  if (ctx.targetMember?.sessionMemberStatus.kind === "banned") {
    throw new ConvexError("Unban this user before inviting them");
  }

  return {};
}

export function requireTargetNotOwner(action: "moderate" | "changeRole") {
  return (ctx: { session: Session }, { userId }: { userId: Id<"user"> }) => {
    if (ctx.session.ownerId === userId) {
      throw new ConvexError(
        action === "moderate"
          ? "The session owner cannot be moderated"
          : "The session owner's role cannot be changed",
      );
    }

    return {};
  };
}

export function requireTargetMember(ctx: { targetMember: Member | null }) {
  const { targetMember } = ctx;
  if (!targetMember) {
    throw new ConvexError("Membership not found");
  }

  return { targetMember };
}

export function requireCanModerateTarget(ctx: {
  isOwner: boolean;
  targetMember: Member;
}) {
  if (!ctx.isOwner && ctx.targetMember.sessionMemberRole.kind === "admin") {
    throw new ConvexError("Only the owner can moderate admins");
  }

  return {};
}

export function requireCallerNotOwner(ctx: { isOwner: boolean }) {
  if (ctx.isOwner) {
    throw new ConvexError("The session owner cannot change their membership");
  }

  return {};
}

export function requireCallerMember(ctx: { member: Member | null }) {
  const { member } = ctx;
  if (!member) {
    throw new ConvexError("Membership not found");
  }

  return { member };
}

export function requireJoinedTargetMember(ctx: { targetMember: Member | null }) {
  const { targetMember } = ctx;
  if (!targetMember || targetMember.sessionMemberStatus.kind !== "joined") {
    throw new ConvexError("Only joined members can have roles assigned");
  }

  return { targetMember };
}

export function requireOngoingClassParty(ctx: { session: Session }) {
  const { session } = ctx;
  if (session.kind !== "party" || session.endedAt !== null) {
    throw new ConvexError("Classes can only be changed in ongoing parties");
  }

  return { session };
}

export function requireJoinedTargetPartyMember(ctx: {
  targetMember: Member | null;
}) {
  const { targetMember } = ctx;
  if (
    !targetMember ||
    targetMember.kind !== "partyMember" ||
    targetMember.sessionMemberStatus.kind !== "joined"
  ) {
    throw new ConvexError("Only joined party members can have classes assigned");
  }

  return { targetMember };
}

export function requireBeerpongOptInParty(ctx: { session: Session }) {
  const { session } = ctx;
  if (
    session.kind !== "party" ||
    session.endedAt !== null ||
    !session.modules.beerpongEnabled
  ) {
    throw new ConvexError("An ongoing party with beerpong enabled is required");
  }

  return { session };
}

export function requireCallerPartyMember(ctx: { member: Member | null }) {
  const { member } = ctx;
  if (member?.kind !== "partyMember") {
    throw new ConvexError("Party membership required");
  }

  return { member };
}
