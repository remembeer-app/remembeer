import { v } from "convex/values";
import { authQuery } from "../lib/authenticated";
import { schema } from "../schema";
import { getFriendship, listForUser } from "./relation";
import { publicUser, publicUserValidator } from "../user/publicProfile";

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
