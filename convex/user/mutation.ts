import { ConvexError, v } from "convex/values";
import { authMutation } from "../lib/authenticated";
import { convex } from "../lib/builder";
import { getCurrentUserSafe } from "./currentUser";
import { userTable } from "./schema";

const minUsernameLength = 3;
const maxUsernameLength = 20;
const defaultEndOfDayBoundary = 6 * 60;

function normalizeUsername(username: string) {
  return username
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/\s/g, "");
}

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
      drinkLogSortOrder: "desc",
    });
  });

export const updateUsername = authMutation
  .input({ username: v.string() })
  .returns(v.null())
  .handler(async (ctx, { username }) => {
    const trimmed = username.trim();
    if (
      trimmed.length < minUsernameLength ||
      trimmed.length > maxUsernameLength
    ) {
      throw new ConvexError(
        `Username must be between ${minUsernameLength} and ${maxUsernameLength} characters`,
      );
    }

    await ctx.db.patch("user", ctx.user._id, {
      username: trimmed,
      normalizedUsername: normalizeUsername(trimmed),
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
  .input({ endOfDayBoundary: v.number() })
  .returns(v.null())
  .handler(async (ctx, { endOfDayBoundary }) => {
    if (
      !Number.isInteger(endOfDayBoundary) ||
      endOfDayBoundary < 0 ||
      endOfDayBoundary >= 24 * 60
    ) {
      throw new ConvexError("End-of-day boundary must be a minute of the day");
    }

    await ctx.db.patch("user", ctx.user._id, { endOfDayBoundary });
    return null;
  });

export const updateDefaultDrink = authMutation
  .input({ defaultDrink: userTable.validator.fields.defaultDrink })
  .returns(v.null())
  .handler(async (ctx, { defaultDrink }) => {
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

    await ctx.db.patch("user", ctx.user._id, { defaultDrink });
    return null;
  });

export const updateDrinkLogSortOrder = authMutation
  .input({ drinkLogSortOrder: userTable.validator.fields.drinkLogSortOrder })
  .returns(v.null())
  .handler(async (ctx, { drinkLogSortOrder }) => {
    await ctx.db.patch("user", ctx.user._id, { drinkLogSortOrder });
    return null;
  });
