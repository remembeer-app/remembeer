import { v } from "convex/values";
import { authQuery } from "../lib/authenticated";
import { schema } from "../schema";
import { requireSessionAccess } from "../session/access";

export const listForSession = authQuery
  .input({ sessionId: v.id("session") })
  .returns(v.array(schema.doc("sessionMember")))
  .handler(async (ctx, { sessionId }) => {
    const { isAdmin } = await requireSessionAccess(ctx, sessionId, "joined");
    return isAdmin
      ? ctx.db.query("sessionMember")
        .withIndex("by_sessionId_and_userId", (q) => q.eq("sessionId", sessionId)).collect()
      : ctx.db.query("sessionMember")
        .withIndex("by_sessionId_and_sessionMemberStatus_kind", (q) =>
          q.eq("sessionId", sessionId).eq("sessionMemberStatus.kind", "joined")).collect();
  });

export const listInvitations = authQuery
  .input({})
  .returns(v.array(v.object({ member: schema.doc("sessionMember"), session: schema.doc("session") })))
  .handler(async (ctx) => {
    const members = await ctx.db.query("sessionMember")
      .withIndex("by_userId_and_sessionMemberStatus_kind", (q) =>
        q.eq("userId", ctx.user._id).eq("sessionMemberStatus.kind", "invited")).collect();
    const invitations = await Promise.all(members.map(async (member) => {
      const session = await ctx.db.get("session", member.sessionId);
      return session !== null && session.deletedAt === null ? { member, session } : null;
    }));
    return invitations.filter((invitation) => invitation !== null);
  });
