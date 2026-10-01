import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authMutation } from "../lib/authenticated";
import { convex } from "../lib/builder";
import {
  setBadgeVisibilityInputValidator,
  unlockBadgeInputValidator,
} from "./schema";

const maxBadgesShown = 6;

export const unlockForUser = convex
  .mutation()
  .extend(WithZod)
  .input(unlockBadgeInputValidator)
  .returns(v.id("badge"))
  .handler(async (ctx, { userId, badgeKey }) => {
    if (!(await ctx.db.get("user", userId))) {
      throw new ConvexError("User not found");
    }

    const existing = await ctx.db
      .query("badge")
      .withIndex("by_userId_and_badgeKey", (q) =>
        q.eq("userId", userId).eq("badgeKey", badgeKey),
      )
      .unique();
    if (existing) {
      return existing._id;
    }

    const badges = await ctx.db
      .query("badge")
      .withIndex("by_userId_and_badgeKey", (q) => q.eq("userId", userId))
      .collect();
    const shownCount = badges.filter((badge) => badge.isShown).length;

    return await ctx.db.insert("badge", {
      userId,
      badgeKey,
      unlockedAt: Date.now(),
      isShown: shownCount < maxBadgesShown,
    });
  });

export const setVisibility = authMutation
  .extend(WithZod)
  .input(setBadgeVisibilityInputValidator)
  .returns(v.null())
  .handler(async (ctx, { badgeKey, isShown }) => {
    const badge = await ctx.db
      .query("badge")
      .withIndex("by_userId_and_badgeKey", (q) =>
        q.eq("userId", ctx.user._id).eq("badgeKey", badgeKey),
      )
      .unique();
    if (!badge) {
      throw new ConvexError("Badge is not unlocked");
    }

    if (isShown && !badge.isShown) {
      const badges = await ctx.db
        .query("badge")
        .withIndex("by_userId_and_badgeKey", (q) =>
          q.eq("userId", ctx.user._id),
        )
        .collect();
      if (badges.filter((unlocked) => unlocked.isShown).length >= maxBadgesShown) {
        throw new ConvexError(`Only ${maxBadgesShown} badges can be shown`);
      }
    }

    await ctx.db.patch("badge", badge._id, { isShown });
    return null;
  });
