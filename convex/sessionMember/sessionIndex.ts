import type { Doc } from "../_generated/dataModel";
import type { AuthMutationCtx } from "../lib/authenticated";

export function sessionIndexFields(session: Pick<Doc<"session">, "endedAt" | "deletedAt">) {
  return { sessionEndedAt: session.endedAt, sessionDeletedAt: session.deletedAt };
}

export async function syncSessionIndex(ctx: Pick<AuthMutationCtx, "db">, session: Doc<"session">) {
  const members = await ctx.db.query("sessionMember")
    .withIndex("by_sessionId_and_userId", (q) => q.eq("sessionId", session._id)).collect();
  for (const member of members) {
    await ctx.db.patch("sessionMember", member._id, sessionIndexFields(session));
  }
}
