import { v } from "convex/values";
import { authMutation } from "../lib/authenticated";
import type { Id } from "../_generated/dataModel";
import { access } from "../lib/access";
import {
  loadFriendship,
  requireFriendRequestTarget,
  requireNoIncomingFriendRequest,
  requireFriendRequest,
  requireFriendRequestRecipient,
  requirePendingFriendRequest,
  requireAcceptedFriendship,
} from "./access";

const targetInput = { userId: v.id("user") };

export const sendRequest = authMutation
  .input(targetInput)
  .returns(v.null())
  .extend(
    access<{ userId: Id<"user"> }>()
      .use(requireFriendRequestTarget)
      .use(loadFriendship)
      .use(requireNoIncomingFriendRequest).extend,
  )
  .handler(async (ctx, { userId }) => {
    if (ctx.relation) return null;

    const [userAId, userBId] =
      ctx.user._id < userId ? [ctx.user._id, userId] : [userId, ctx.user._id];

    await ctx.db.insert("friendship", {
      userAId,
      userBId,
      requestedById: ctx.user._id,
      status: "pending",
      updatedAt: Date.now(),
    });

    return null;
  });

export const accept = authMutation
  .input(targetInput)
  .returns(v.null())
  .extend(
    access<{ userId: Id<"user"> }>()
      .use(loadFriendship)
      .use(requireFriendRequest)
      .use(requireFriendRequestRecipient).extend,
  )
  .handler(async (ctx) => {
    const { relation } = ctx;

    if (relation.status === "accepted") return null;

    await ctx.db.patch("friendship", relation._id, {
      status: "accepted",
      updatedAt: Date.now(),
    });

    return null;
  });

export const decline = authMutation
  .input(targetInput)
  .returns(v.null())
  .extend(
    access<{ userId: Id<"user"> }>()
      .use(loadFriendship)
      .use((ctx) => requirePendingFriendRequest(ctx, "recipient")).extend,
  )
  .handler(async (ctx) => {
    if (!ctx.relation) return null;

    await ctx.db.delete("friendship", ctx.relation._id);

    return null;
  });

export const cancel = authMutation
  .input(targetInput)
  .returns(v.null())
  .extend(
    access<{ userId: Id<"user"> }>()
      .use(loadFriendship)
      .use((ctx) => requirePendingFriendRequest(ctx, "sender")).extend,
  )
  .handler(async (ctx) => {
    if (!ctx.relation) return null;

    await ctx.db.delete("friendship", ctx.relation._id);

    return null;
  });

export const remove = authMutation
  .input(targetInput)
  .returns(v.null())
  .extend(
    access<{ userId: Id<"user"> }>().use(loadFriendship).use(requireAcceptedFriendship).extend,
  )
  .handler(async (ctx) => {
    if (!ctx.relation) return null;

    await ctx.db.delete("friendship", ctx.relation._id);

    return null;
  });
