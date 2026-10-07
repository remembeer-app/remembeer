import { v } from "convex/values";
import { authQuery } from "../lib/authenticated";
import { schema } from "../schema";

export const listCurrent = authQuery
  .returns(v.array(schema.doc("badge")))
  .handler(async (ctx) => {
    const badges = await ctx.db
      .query("badge")
      .withIndex("by_userId_and_badgeKey", (q) => q.eq("userId", ctx.user._id))
      .collect();
    return badges.sort((a, b) => b.unlockedAt - a.unlockedAt);
  });
