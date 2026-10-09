import { WithZod } from "fluent-convex/zod";
import {
  normalizeUsername,
  updateUsernameInputValidator,
} from "../user/schema";
import { convexToZod } from "convex-helpers/server/zod4";
import { v } from "convex/values";
import { authQuery } from "../lib/authenticated";
import { schema } from "../schema";
import { requireSessionAccess } from "../session/access";

export const listForSession = authQuery
  .input({ sessionId: v.id("session") })
  .returns(
    v.array(schema.doc("sessionMember").extend({ username: v.string() })),
  )
  .handler(async (ctx, { sessionId }) => {
    const { isAdmin } = await requireSessionAccess(ctx, sessionId, "joined");
    const members = await (isAdmin
      ? ctx.db
          .query("sessionMember")
          .withIndex("by_sessionId_and_userId", (q) =>
            q.eq("sessionId", sessionId),
          )
          .collect()
      : ctx.db
          .query("sessionMember")
          .withIndex("by_sessionId_and_sessionMemberStatus_kind", (q) =>
            q
              .eq("sessionId", sessionId)
              .eq("sessionMemberStatus.kind", "joined"),
          )
          .collect());

    return Promise.all(
      members.map(async (member) => ({
        ...member,
        username:
          (await ctx.db.get("user", member.userId))?.username ??
          "Unavailable user",
      })),
    );
  });

export const listInvitations = authQuery
  .input({})
  .returns(
    v.array(
      v.object({
        member: schema.doc("sessionMember"),
        session: schema.doc("session"),
      }),
    ),
  )
  .handler(async (ctx) => {
    const members = await ctx.db
      .query("sessionMember")
      .withIndex("by_userId_and_sessionMemberStatus_kind", (q) =>
        q.eq("userId", ctx.user._id).eq("sessionMemberStatus.kind", "invited"),
      )
      .collect();

    const invitations = await Promise.all(
      members.map(async (member) => {
        const session = await ctx.db.get("session", member.sessionId);
        return session !== null && session.deletedAt === null
          ? { member, session }
          : null;
      }),
    );

    return invitations.filter((invitation) => invitation !== null);
  });

export const findInvitee = authQuery
  .extend(WithZod)
  .input(
    updateUsernameInputValidator.extend({
      sessionId: convexToZod(v.id("session")),
    }),
  )
  .returns(v.array(v.object({ _id: v.id("user"), username: v.string() })))
  .handler(async (ctx, { sessionId, username }) => {
    await requireSessionAccess(ctx, sessionId, "admin");

    const users = await ctx.db
      .query("user")
      .withIndex("by_normalizedUsername", (q) =>
        q.eq("normalizedUsername", normalizeUsername(username)),
      )
      .take(20);

    return users.map((user) => ({ _id: user._id, username: user.username }));
  });
