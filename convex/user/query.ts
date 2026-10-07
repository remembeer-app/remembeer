import { v } from "convex/values";
import { authQuery } from "../lib/authenticated";
import { schema } from "../schema";

export const current = authQuery
  .returns(v.object({
    ...schema.doc("user").omit("avatarStorageId").fields,
    avatarUrl: v.nullable(v.string()),
  }))
  .handler(async (ctx) => {
    const { avatarStorageId, ...user } = ctx.user;
    return {
      ...user,
      avatarUrl: avatarStorageId
        ? await ctx.storage.getUrl(avatarStorageId)
        : null,
    };
  });
