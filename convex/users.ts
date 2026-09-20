import type { DataModel } from "./_generated/dataModel";
import { createBuilder } from "fluent-convex";
import { authComponent } from "./auth";
import { v } from "convex/values";

const convex = createBuilder<DataModel>();

export const ensureCurrent = convex
  .mutation()
  .returns(v.id("users"))
  .handler(async (ctx) => {
    const authUser = await authComponent.getAuthUser(ctx);

    const user = await ctx.db
      .query("users")
      .withIndex("by_authUserId", (q) => q.eq("authUserId", authUser._id))
      .unique();

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
    const authUser = await authComponent.getAuthUser(ctx);

    const user = await ctx.db
      .query("users")
      .withIndex("by_authUserId", (q) => q.eq("authUserId", authUser._id))
      .unique();

    return user;
  })
  .public();
