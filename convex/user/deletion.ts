import type { MutationCtx } from "../_generated/server";

export async function deleteUserData(ctx: MutationCtx, authUserId: string) {
  const user = await ctx.db
    .query("user")
    .withIndex("by_authUserId", (q) => q.eq("authUserId", authUserId))
    .unique();
  if (!user) return;

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

  if (user.avatarStorageId) {
    await ctx.storage.delete(user.avatarStorageId);
  }
  await ctx.db.delete("user", user._id);
}
