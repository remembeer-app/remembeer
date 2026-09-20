import type { DataModel } from "./_generated/dataModel";
import { createBuilder, type QueryCtx } from "fluent-convex";
import { authComponent } from "./auth";
import { v } from "convex/values";

const convex = createBuilder<DataModel>();

export const ensureCurrent = convex
  .mutation()
  .returns(v.id("users"))
  .handler(async (ctx) => {
    const { user, authUser } = await getCurrentUser(ctx);
    if (user) {
      return user._id;
    }

    return await ctx.db.insert("users", { authUserId: authUser._id });
  })
  .public();

export const current = convex
  .query()
  .returns(
    v.nullable(
      v.object({
        _id: v.id("users"),
        _creationTime: v.number(),
        authUserId: v.string(),
      }),
    ),
  )
  .handler(async (ctx) => {
    const { user } = await getCurrentUser(ctx);

    return user;
  })
  .public();

async function getCurrentUser(ctx: QueryCtx<DataModel>) {
  const authUser = await authComponent.getAuthUser(ctx);

  const user = await ctx.db
    .query("users")
    .withIndex("by_authUserId", (q) => q.eq("authUserId", authUser._id))
    .unique();

  return { user, authUser };
}
