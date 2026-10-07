import { v } from "convex/values";
import { authQuery } from "../lib/authenticated";
import { schema } from "../schema";
import { timeZoneSearchLimit } from "./constants";

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

export const searchTimeZones = authQuery
  .input({ search: v.string() })
  .returns(v.array(v.string()))
  .handler(async (_, { search }) => {
    const normalizedSearch = search.trim().toLowerCase().replace(/[_/]/g, " ");
    if (!normalizedSearch) return [];
    return ["UTC", ...Intl.supportedValuesOf("timeZone")]
      .filter((timeZone) =>
        timeZone.toLowerCase().replace(/[_/]/g, " ").includes(normalizedSearch),
      )
      .slice(0, timeZoneSearchLimit);
  });
