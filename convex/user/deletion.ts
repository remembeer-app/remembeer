import { syncSessionIndex } from "../sessionMember/sessionIndex";
import type { MutationCtx } from "../_generated/server";

// TODO(ohtenkay): This should be anonymized instead of deleted, something that will satisfy GDPR requirements.
export async function deleteUserData(ctx: MutationCtx, authUserId: string) {
  const user = await ctx.db
    .query("user")
    .withIndex("by_authUserId", (q) => q.eq("authUserId", authUserId))
    .unique();
  if (!user) return;

  const logs = await ctx.db
    .query("drinkLog")
    .withIndex("by_userId_and_deletedAt_and_consumedAt", (q) =>
      q.eq("userId", user._id),
    )
    .collect();
  for (const log of logs) {
    await ctx.db.delete("drinkLog", log._id);
  }

  const drinks = await ctx.db
    .query("drink")
    .withIndex("by_ownerId_and_deletedAt", (q) => q.eq("ownerId", user._id))
    .collect();
  for (const drink of drinks) {
    await ctx.db.delete("drink", drink._id);
  }

  const badges = await ctx.db
    .query("badge")
    .withIndex("by_userId_and_badgeKey", (q) => q.eq("userId", user._id))
    .collect();
  for (const badge of badges) {
    await ctx.db.delete("badge", badge._id);
  }

  const sessions = await ctx.db
    .query("session")
    .withIndex("by_ownerId_and_kind", (q) => q.eq("ownerId", user._id))
    .collect();
  const now = Date.now();
  for (const session of sessions) {
    if (session.deletedAt === null) {
      await ctx.db.patch("session", session._id, {
        deletedAt: now,
        updatedAt: now,
      });
      await syncSessionIndex(ctx, { ...session, deletedAt: now });
    }
  }
  const memberships = await ctx.db
    .query("sessionMember")
    .withIndex("by_userId_and_sessionMemberStatus_kind", (q) =>
      q.eq("userId", user._id),
    )
    .collect();
  for (const member of memberships) {
    await ctx.db.delete("sessionMember", member._id);
  }

  if (user.avatarStorageId) {
    await ctx.storage.delete(user.avatarStorageId);
  }
  await ctx.db.delete("user", user._id);
}
