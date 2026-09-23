import { type QueryCtx } from "fluent-convex";
import type { DataModel } from "../_generated/dataModel";
import { authComponent } from "../lib/auth";
import { ConvexError } from "convex/values";

export async function getCurrentUserSafe(ctx: QueryCtx<DataModel>) {
  const authUser = await authComponent.getAuthUser(ctx);

  const user = await ctx.db
    .query("user")
    .withIndex("by_authUserId", (q) => q.eq("authUserId", authUser._id))
    .unique();

  return { user, authUser };
}

export async function getCurrentUser(ctx: QueryCtx<DataModel>) {
  const { user, authUser } = await getCurrentUserSafe(ctx);
  if (!user) {
    throw new ConvexError("No user found for the authenticated user");
  }

  return { user, authUser };
}
