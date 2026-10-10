import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authQuery } from "../lib/authenticated";
import { schema } from "../schema";
import { publicUser, publicUserValidator } from "./publicProfile";
import { normalizeUsername, updateUsernameInputValidator } from "./schema";

export const get = authQuery
  .input({ userId: v.id("user") })
  .returns(publicUserValidator)
  .handler(async (ctx, { userId }) => {
    const user = await publicUser(ctx, userId);
    if (!user) throw new ConvexError("User not found");
    return user;
  });

export const search = authQuery
  .extend(WithZod)
  .input(updateUsernameInputValidator)
  .returns(v.array(publicUserValidator))
  .handler(async (ctx, { username }) => {
    const users = await ctx.db
      .query("user")
      .withIndex("by_normalizedUsername", (q) =>
        q.eq("normalizedUsername", normalizeUsername(username)),
      )
      .take(20);
    const profiles = await Promise.all(
      users
        .filter((user) => user._id !== ctx.user._id)
        .map((user) => publicUser(ctx, user._id)),
    );
    return profiles.filter((user) => user !== null);
  });

export const current = authQuery
  .returns(
    v.object({
      ...schema.doc("user").omit("avatarStorageId").fields,
      avatarUrl: v.nullable(v.string()),
    }),
  )
  .handler(async (ctx) => {
    const { avatarStorageId, ...user } = ctx.user;
    return {
      ...user,
      avatarUrl: avatarStorageId
        ? await ctx.storage.getUrl(avatarStorageId)
        : null,
    };
  });
