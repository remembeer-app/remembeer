import { type QueryCtx } from "fluent-convex";
import type { DataModel } from "../_generated/dataModel";
import { authComponent } from "../lib/auth";

export async function getCurrentUserSafe(ctx: QueryCtx<DataModel>) {
  const authUser = await authComponent.getAuthUser(ctx);

  const user = await ctx.db
    .query("users")
    .withIndex("by_authUserId", (q) => q.eq("authUserId", authUser._id))
    .unique();

  return { user, authUser };
}

export async function getCurrentUser(ctx: QueryCtx<DataModel>) {
  const { user, authUser } = await getCurrentUserSafe(ctx);
  if (!user) {
    // TODO(ohtenkay): Figure out errors in Convex.
    throw new Error("No user found for the authenticated user");
  }

  return { user, authUser };
}
