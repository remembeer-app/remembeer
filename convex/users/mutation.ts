import { v } from "convex/values";
import { convex } from "../lib/builder";
import { getCurrentUserSafe } from "./currentUser";

export const ensureCurrent = convex
  .mutation()
  .returns(v.id("users"))
  .handler(async (ctx) => {
    const { user, authUser } = await getCurrentUserSafe(ctx);
    if (user) {
      return user._id;
    }

    return await ctx.db.insert("users", { authUserId: authUser._id });
  });
