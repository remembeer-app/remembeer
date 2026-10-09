import { v } from "convex/values";
import { authQuery, type AuthQueryCtx } from "../lib/authenticated";
import { schema } from "../schema";
import type { Id } from "../_generated/dataModel";
import { getMembership, requireSessionAccess } from "./access";

export const get = authQuery
  .input({ id: v.id("session") })
  .returns(schema.doc("session"))
  .handler(
    async (ctx, { id }) => (await requireSessionAccess(ctx, id)).session,
  );

export const listCurrent = authQuery
  .input({})
  .returns(v.array(schema.doc("session")))
  .handler(listCurrentHandler);

export async function listCurrentHandler(ctx: AuthQueryCtx) {
  const [ownedSessions, memberships] = await Promise.all([
    ctx.db
      .query("session")
      .withIndex("by_ownerId_and_deletedAt_and_endedAt", (q) =>
        q.eq("ownerId", ctx.user._id).eq("deletedAt", null),
      )
      .collect(),
    ctx.db
      .query("sessionMember")
      .withIndex(
        "by_userId_and_status_and_sessionDeletedAt_and_sessionEndedAt",
        (q) =>
          q
            .eq("userId", ctx.user._id)
            .eq("sessionMemberStatus.kind", "joined")
            .eq("sessionDeletedAt", null),
      )
      .collect(),
  ]);

  const joinedSessions = await Promise.all(
    memberships.map((member) => ctx.db.get("session", member.sessionId)),
  );

  return [
    ...new Map(
      [...ownedSessions, ...joinedSessions]
        .filter((session) => session !== null)
        .filter((session) => session.deletedAt === null)
        .map((session) => [session._id, session] as const),
    ).values(),
  ].sort(
    (a, b) =>
      (a.startedAt - b.startedAt || a._id.localeCompare(b._id)) *
      (ctx.user.drinkLogSortOrder === "asc" ? 1 : -1),
  );
}

export async function listForDayHandler(
  ctx: AuthQueryCtx,
  start: number,
  end: number,
  referencedIds: Set<Id<"session">>,
) {
  const [ownedRanges, memberRanges, referenced] = await Promise.all([
    Promise.all(
      [null, start].map((endedAt) =>
        ctx.db
          .query("session")
          .withIndex("by_ownerId_and_deletedAt_and_endedAt", (q) => {
            const range = q.eq("ownerId", ctx.user._id).eq("deletedAt", null);
            return endedAt === null
              ? range.eq("endedAt", null)
              : range.gt("endedAt", endedAt);
          })
          .collect(),
      ),
    ),
    Promise.all(
      [null, start].map((endedAt) =>
        ctx.db
          .query("sessionMember")
          .withIndex(
            "by_userId_and_status_and_sessionDeletedAt_and_sessionEndedAt",
            (q) => {
              const range = q
                .eq("userId", ctx.user._id)
                .eq("sessionMemberStatus.kind", "joined")
                .eq("sessionDeletedAt", null);
              return endedAt === null
                ? range.eq("sessionEndedAt", null)
                : range.gt("sessionEndedAt", endedAt);
            },
          )
          .collect(),
      ),
    ),
    Promise.all(
      [...referencedIds].map(async (id) => {
        const session = await ctx.db.get("session", id);
        if (!session || session.deletedAt !== null) return null;
        if (session.ownerId === ctx.user._id) return session;
        const member = await getMembership(ctx, id, ctx.user._id);
        return member?.sessionMemberStatus.kind === "joined" ? session : null;
      }),
    ),
  ]);

  const joined = await Promise.all(
    memberRanges
      .flat()
      .map((member) => ctx.db.get("session", member.sessionId)),
  );

  const overlapping = [...ownedRanges.flat(), ...joined]
    .filter((session) => session !== null)
    .filter(
      (session) =>
        session.deletedAt === null &&
        session.startedAt < end &&
        (session.endedAt === null || session.endedAt > start),
    );

  return [
    ...new Map(
      [...overlapping, ...referenced.filter((session) => session !== null)].map(
        (session) => [session._id, session] as const,
      ),
    ).values(),
  ].sort(
    (a, b) =>
      (a.startedAt - b.startedAt || a._id.localeCompare(b._id)) *
      (ctx.user.drinkLogSortOrder === "asc" ? 1 : -1),
  );
}
