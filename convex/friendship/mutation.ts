import { ConvexError, v } from "convex/values";
import { authMutation, type AuthMutationCtx } from "../lib/authenticated";
import type { Id } from "../_generated/dataModel";
import { getFriendship } from "./relation";

const targetInput = { userId: v.id("user") };

export const sendRequest = authMutation
  .input(targetInput)
  .returns(v.null())
  .handler(async (ctx, { userId }) => {
    if (userId === ctx.user._id)
      throw new ConvexError("Cannot befriend yourself");
    if (!(await ctx.db.get("user", userId)))
      throw new ConvexError("User not found");
    const relation = await getFriendship(ctx, ctx.user._id, userId);
    if (relation) {
      if (
        relation.status === "pending" &&
        relation.requestedById !== ctx.user._id
      ) {
        throw new ConvexError("Accept the incoming friend request instead");
      }
      return null;
    }
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
  .handler(async (ctx, { userId }) => {
    const relation = await getFriendship(ctx, ctx.user._id, userId);
    if (!relation) throw new ConvexError("Friend request not found");
    if (relation.requestedById === ctx.user._id)
      throw new ConvexError("Only the recipient can accept a friend request");
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
  .handler((ctx, { userId }) => deletePending(ctx, userId, false));

export const cancel = authMutation
  .input(targetInput)
  .returns(v.null())
  .handler((ctx, { userId }) => deletePending(ctx, userId, true));

async function deletePending(
  ctx: AuthMutationCtx,
  userId: Id<"user">,
  isSender: boolean,
) {
  const relation = await getFriendship(ctx, ctx.user._id, userId);
  if (!relation) return null;
  if (
    relation.status !== "pending" ||
    (relation.requestedById === ctx.user._id) !== isSender
  ) {
    throw new ConvexError("Cannot change this friend request");
  }
  await ctx.db.delete("friendship", relation._id);
  return null;
}

export const remove = authMutation
  .input(targetInput)
  .returns(v.null())
  .handler(async (ctx, { userId }) => {
    const relation = await getFriendship(ctx, ctx.user._id, userId);
    if (!relation) return null;
    if (relation.status !== "accepted")
      throw new ConvexError("Users are not friends");
    await ctx.db.delete("friendship", relation._id);
    return null;
  });
