import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";

export function getMembership(
  ctx: AuthQueryCtx,
  sessionId: Id<"session">,
  userId: Id<"user">,
) {
  return ctx.db
    .query("sessionMember")
    .withIndex("by_sessionId_and_userId", (q) =>
      q.eq("sessionId", sessionId).eq("userId", userId),
    )
    .unique();
}

export async function requireSessionAccess(
  ctx: AuthQueryCtx,
  id: Id<"session">,
  permission: "read" | "joined" | "admin" | "owner" | "membership" = "read",
) {
  const session = await ctx.db.get("session", id);
  if (!session || session.deletedAt !== null)
    throw new ConvexError("Session not found");

  const isOwner = session.ownerId === ctx.user._id;

  const member = isOwner ? null : await getMembership(ctx, id, ctx.user._id);

  const isJoined = member?.sessionMemberStatus.kind === "joined";

  const isAdmin =
    isOwner || (isJoined && member.sessionMemberRole.kind === "admin");

  const allowed =
    isOwner ||
    {
      read: isJoined || member?.sessionMemberStatus.kind === "invited",
      joined: isJoined,
      admin: isAdmin,
      owner: false,
      membership: member !== null,
    }[permission];
  if (!allowed)
    throw new ConvexError("You do not have permission to access this session");

  return { session, member, isOwner, isAdmin };
}
