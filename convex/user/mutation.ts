import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authMutation } from "../lib/authenticated";
import { convex } from "../lib/builder";
import { getCurrentUserSafe } from "./currentUser";
import {
  normalizeUsername,
  updateDefaultDrinkInputValidator,
  updateEndOfDayBoundaryInputValidator,
  updateUsernameInputValidator,
  userTable,
} from "./schema";

const defaultEndOfDayBoundary = 6 * 60;
const defaultDrinkVolumeMl = 500;

export const ensureCurrent = convex
  .mutation()
  .returns(v.id("user"))
  .handler(async (ctx) => {
    const { user, authUser } = await getCurrentUserSafe(ctx);
    if (user) {
      return user._id;
    }

    const username = authUser.name.trim() || authUser.email;

    return await ctx.db.insert("user", {
      authUserId: authUser._id,
      username,
      normalizedUsername: normalizeUsername(username),
      accentColor: "amber",
      avatarUrl: null,
      endOfDayBoundary: defaultEndOfDayBoundary,
      defaultDrink: null,
      defaultDrinkVolumeMl,
      drinkLogSortOrder: "desc",
    });
  });

export const updateUsername = authMutation
  .extend(WithZod)
  .input(updateUsernameInputValidator)
  .returns(v.null())
  .handler(async (ctx, { username }) => {
    await ctx.db.patch("user", ctx.user._id, {
      username,
      normalizedUsername: normalizeUsername(username),
    });
    return null;
  });

export const updateAccentColor = authMutation
  .input({ accentColor: userTable.validator.fields.accentColor })
  .returns(v.null())
  .handler(async (ctx, { accentColor }) => {
    await ctx.db.patch("user", ctx.user._id, { accentColor });
    return null;
  });

export const updateAvatarUrl = authMutation
  .input({ avatarUrl: userTable.validator.fields.avatarUrl })
  .returns(v.null())
  .handler(async (ctx, { avatarUrl }) => {
    await ctx.db.patch("user", ctx.user._id, { avatarUrl });
    return null;
  });

export const updateEndOfDayBoundary = authMutation
  .extend(WithZod)
  .input(updateEndOfDayBoundaryInputValidator)
  .returns(v.null())
  .handler(async (ctx, { endOfDayBoundary }) => {
    await ctx.db.patch("user", ctx.user._id, { endOfDayBoundary });
    return null;
  });

export const updateDefaultDrink = authMutation
  .extend(WithZod)
  .input(updateDefaultDrinkInputValidator)
  .returns(v.null())
  .handler(async (ctx, { defaultDrink, defaultDrinkVolumeMl }) => {
    if (defaultDrink !== null) {
      const drink = await ctx.db.get("drink", defaultDrink);
      if (
        !drink ||
        drink.deletedAt !== null ||
        (drink.ownerId !== null && drink.ownerId !== ctx.user._id)
      ) {
        throw new ConvexError("Drink is not available to this user");
      }
    }

    await ctx.db.patch("user", ctx.user._id, {
      defaultDrink,
      defaultDrinkVolumeMl,
    });
    return null;
  });

export const updateDrinkLogSortOrder = authMutation
  .input({ drinkLogSortOrder: userTable.validator.fields.drinkLogSortOrder })
  .returns(v.null())
  .handler(async (ctx, { drinkLogSortOrder }) => {
    await ctx.db.patch("user", ctx.user._id, { drinkLogSortOrder });
    return null;
  });
