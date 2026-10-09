import { v } from "convex/values";
import { authQuery, type AuthQueryCtx } from "../lib/authenticated";
import { schema } from "../schema";
import { requireSessionAccess } from "./access";

export const get = authQuery
  .input({ id: v.id("session") })
  .returns(schema.doc("session"))
  .handler(async (ctx, { id }) => (await requireSessionAccess(ctx, id)).session);

export const listCurrent = authQuery
  .input({})
  .returns(v.array(schema.doc("session")))
  .handler(listCurrentHandler);

export async function listCurrentHandler(ctx: AuthQueryCtx) {
  // shortcut: reads all accessible session history; add day-filtered indexes when history approaches Convex read limits.
  const [ownedSessions, memberships] = await Promise.all([
    ctx.db.query("session")
      .withIndex("by_ownerId_and_kind", (q) => q.eq("ownerId", ctx.user._id))
      .collect(),
    ctx.db.query("sessionMember")
      .withIndex("by_userId_and_sessionMemberStatus_kind", (q) =>
        q.eq("userId", ctx.user._id).eq("sessionMemberStatus.kind", "joined"))
      .collect(),
  ]);
  const joinedSessions = await Promise.all(
    memberships.map((member) => ctx.db.get("session", member.sessionId)),
  );
  return [...new Map(
    [...ownedSessions, ...joinedSessions]
      .filter((session) => session !== null)
      .filter((session) => session.deletedAt === null)
      .map((session) => [session._id, session] as const),
  ).values()].sort((a, b) => (a.startedAt - b.startedAt || a._id.localeCompare(b._id)) *
    (ctx.user.drinkLogSortOrder === "asc" ? 1 : -1));
}
