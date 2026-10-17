import type { Doc, Id } from "../_generated/dataModel";
import type { MutationCtx } from "../_generated/server";
import { internal } from "../_generated/api";

export function activeChallenges(ctx: MutationCtx, sessionId: Id<"session">) {
  return ctx.db
    .query("partyChallenge")
    .withIndex("by_sessionId_and_status", (q) =>
      q.eq("sessionId", sessionId).eq("status", "active"),
    )
    .collect();
}

// Jobs check the current deadline and status, so edits and closure make old jobs harmless.
export async function scheduleExpiry(ctx: MutationCtx, id: Id<"partyChallenge">, endsAt: number) {
  await ctx.scheduler.runAt(endsAt, internal.partyChallenge.expire, {
    id,
    endsAt,
  });
}

export async function stopChallenges(ctx: MutationCtx, session: Doc<"session">, now: number) {
  if (session.kind !== "party") return;

  for (const challenge of await activeChallenges(ctx, session._id)) {
    await ctx.db.patch("partyChallenge", challenge._id, {
      status: challenge.endsAt <= now ? "expired" : "cancelled",
      updatedAt: now,
    });
  }
}
