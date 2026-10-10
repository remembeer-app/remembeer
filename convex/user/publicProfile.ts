import { v } from "convex/values";
import type { QueryCtx } from "../_generated/server";
import type { Id } from "../_generated/dataModel";
import { schema } from "../schema";

export const publicUserValidator = schema
  .doc("user")
  .pick("_id", "username", "accentColor")
  .extend({ avatarUrl: v.nullable(v.string()) });

export async function publicUser(ctx: QueryCtx, userId: Id<"user">) {
  const user = await ctx.db.get("user", userId);
  if (!user) return null;
  return {
    _id: user._id,
    username: user.username,
    accentColor: user.accentColor,
    avatarUrl: user.avatarStorageId
      ? await ctx.storage.getUrl(user.avatarStorageId)
      : null,
  };
}
