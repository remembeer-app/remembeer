import { APIError } from "better-auth/api";
import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authComponent, createAuth } from "../lib/auth";
import { authMutation } from "../lib/authenticated";
import { convex } from "../lib/builder";
import { getCurrentUserSafe } from "./currentUser";
import {
  normalizeUsername,
  updateEndOfDayBoundaryInputValidator,
  updateTimeZoneInputValidator,
  updateUsernameInputValidator,
  userTable,
} from "./schema";

const defaultEndOfDayBoundary = 6 * 60;
const accentColors = userTable.validator.fields.accentColor.members.map(
  (color) => color.value,
);

export const ensureCurrent = convex
  .mutation()
  .extend(WithZod)
  .input(updateTimeZoneInputValidator.partial())
  .returns(v.id("user"))
  .handler(async (ctx, { timeZone }) => {
    const { user, authUser } = await getCurrentUserSafe(ctx);
    if (user) {
      return user._id;
    }

    const username = authUser.name.trim() || authUser.email;

    return await ctx.db.insert("user", {
      authUserId: authUser._id,
      username,
      normalizedUsername: normalizeUsername(username),
      accentColor:
        accentColors[Math.floor(Math.random() * accentColors.length)]!,
      avatarStorageId: null,
      endOfDayBoundary: defaultEndOfDayBoundary,
      timeZone: timeZone ?? "UTC",
      defaultDrink: null,
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

export const generateAvatarUploadUrl = authMutation
  .input({})
  .returns(v.string())
  .handler(async (ctx) => ctx.storage.generateUploadUrl());

export const updateAvatar = authMutation
  .input({ storageId: v.nullable(v.id("_storage")) })
  .returns(v.nullable(v.string()))
  .handler(async (ctx, { storageId }) => {
    let avatarUrl: string | null = null;

    if (storageId !== null) {
      const owner = await ctx.db
        .query("user")
        .withIndex("by_avatarStorageId", (q) =>
          q.eq("avatarStorageId", storageId),
        )
        .first();

      if (owner && owner._id !== ctx.user._id) {
        throw new ConvexError("Avatar belongs to another user");
      }

      const metadata = await ctx.db.system.get(storageId);
      if (!metadata || metadata.contentType !== "image/jpeg") {
        throw new ConvexError("Avatar must be an uploaded JPEG image");
      }

      avatarUrl = await ctx.storage.getUrl(storageId);
      if (avatarUrl === null) {
        throw new ConvexError("Avatar file is not available");
      }
    }

    await ctx.db.patch("user", ctx.user._id, {
      avatarStorageId: storageId,
    });

    if (ctx.user.avatarStorageId && ctx.user.avatarStorageId !== storageId) {
      await ctx.storage.delete(ctx.user.avatarStorageId);
    }

    return avatarUrl;
  });

export const updateEndOfDayBoundary = authMutation
  .extend(WithZod)
  .input(updateEndOfDayBoundaryInputValidator)
  .returns(v.null())
  .handler(async (ctx, { endOfDayBoundary }) => {
    await ctx.db.patch("user", ctx.user._id, { endOfDayBoundary });

    return null;
  });

export const updateTimeZone = authMutation
  .extend(WithZod)
  .input(updateTimeZoneInputValidator)
  .returns(v.null())
  .handler(async (ctx, { timeZone }) => {
    await ctx.db.patch("user", ctx.user._id, { timeZone });

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

    await ctx.db.patch("user", ctx.user._id, {
      defaultDrink,
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

export const deleteCurrent = authMutation
  .input({ password: v.optional(v.string()) })
  .returns(v.null())
  .handler(async (ctx, { password }) => {
    const { auth, headers } = await authComponent.getAuth(createAuth, ctx);
    try {
      if (!password) {
        const accounts = await auth.api.listUserAccounts({ headers });
        if (accounts.some((account) => account.providerId === "credential")) {
          throw new ConvexError("Please enter your password.");
        }
        if (!accounts.some((account) => account.providerId === "google")) {
          throw new ConvexError("Please sign in with Google again.");
        }
      }
      await auth.api.deleteUser({
        body: password ? { password } : {},
        headers,
      });
    } catch (error) {
      if (error instanceof APIError) {
        throw new ConvexError(
          error.body?.message ?? "Could not delete account.",
        );
      }
      throw error;
    }

    return null;
  });
