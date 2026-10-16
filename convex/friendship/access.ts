import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { getFriendship } from "./relation";

export async function requireFriendRequestTarget(
  ctx: AuthQueryCtx,
  { userId }: { userId: Id<"user"> },
) {
  if (userId === ctx.user._id) {
    throw new ConvexError("Cannot befriend yourself");
  }

  if (!(await ctx.db.get("user", userId))) {
    throw new ConvexError("User not found");
  }

  return {};
}

export async function loadFriendship(
  ctx: AuthQueryCtx,
  { userId }: { userId: Id<"user"> },
) {
  const relation = await getFriendship(ctx, ctx.user._id, userId);

  return { relation };
}

export function requireNoIncomingFriendRequest(
  ctx: AuthQueryCtx & { relation: Doc<"friendship"> | null },
) {
  if (
    ctx.relation?.status === "pending" &&
    ctx.relation.requestedById !== ctx.user._id
  ) {
    throw new ConvexError("Accept the incoming friend request instead");
  }

  return {};
}

export function requireFriendRequest(
  ctx: { relation: Doc<"friendship"> | null },
) {
  if (!ctx.relation) throw new ConvexError("Friend request not found");

  return { relation: ctx.relation };
}

export function requireFriendRequestRecipient(
  ctx: AuthQueryCtx & { relation: Doc<"friendship"> },
) {
  if (ctx.relation.requestedById === ctx.user._id) {
    throw new ConvexError("Only the recipient can accept a friend request");
  }

  return {};
}

export function requirePendingFriendRequest(
  ctx: AuthQueryCtx & { relation: Doc<"friendship"> | null },
  role: "sender" | "recipient",
) {
  // A missing relation is a successful retry; the handler has nothing to delete.
  if (!ctx.relation) return {};

  if (
    ctx.relation.status !== "pending" ||
    (ctx.relation.requestedById === ctx.user._id) !== (role === "sender")
  ) {
    throw new ConvexError("Cannot change this friend request");
  }

  return {};
}

export function requireAcceptedFriendship(
  ctx: { relation: Doc<"friendship"> | null },
) {
  if (ctx.relation && ctx.relation.status !== "accepted") {
    throw new ConvexError("Users are not friends");
  }

  return {};
}
