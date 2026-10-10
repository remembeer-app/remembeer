import { v } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { authQuery, type AuthQueryCtx } from "../lib/authenticated";
import { schema } from "../schema";
import { getFriendship, listForUser } from "./relation";

const publicUserValidator = schema
  .doc("user")
  .pick("_id", "username", "accentColor")
  .extend({ avatarUrl: v.nullable(v.string()) });

async function publicUser(ctx: AuthQueryCtx, userId: Id<"user">) {
  const user = await ctx.db.get("user", userId);
  if (!user) return null;
  return {
    _id: user._id,
    username: user.username,
    accentColor: user.accentColor,
    avatarUrl: user.avatarStorageId
      ? await ctx.storage.getUrl(user.avatarStorageId)
      : null,
  };
}

export const listCurrent = authQuery
  .input({})
  .returns(v.array(publicUserValidator))
  .handler(async (ctx) => {
    const relations = await listForUser(ctx, ctx.user._id, "accepted");
    const users = await Promise.all(
      relations.map((relation) =>
        publicUser(
          ctx,
          relation.userAId === ctx.user._id
            ? relation.userBId
            : relation.userAId,
        ),
      ),
    );
    return users.filter((user) => user !== null);
  });

export const listRequests = authQuery
  .input({})
  .returns(
    v.array(
      v.object({
        friendship: schema.doc("friendship"),
        user: publicUserValidator,
      }),
    ),
  )
  .handler(async (ctx) => {
    const relations = await listForUser(ctx, ctx.user._id, "pending");
    const requests = await Promise.all(
      relations.map(async (friendship) => {
        const user = await publicUser(
          ctx,
          friendship.userAId === ctx.user._id
            ? friendship.userBId
            : friendship.userAId,
        );
        return user ? { friendship, user } : null;
      }),
    );
    return requests.filter((request) => request !== null);
  });

export const getStatus = authQuery
  .input({ userId: v.id("user") })
  .returns(
    v.union(
      v.literal("friends"),
      v.literal("requestSent"),
      v.literal("requestReceived"),
      v.literal("notFriends"),
    ),
  )
  .handler(async (ctx, { userId }) => {
    const relation = await getFriendship(ctx, ctx.user._id, userId);
    if (!relation) return "notFriends" as const;
    if (relation.status === "accepted") return "friends" as const;
    return relation.requestedById === ctx.user._id
      ? ("requestSent" as const)
      : ("requestReceived" as const);
  });
