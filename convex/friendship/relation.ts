import type { QueryCtx } from "../_generated/server";
import type { Doc, Id } from "../_generated/dataModel";

export function getFriendship(
  ctx: QueryCtx,
  userId: Id<"user">,
  otherUserId: Id<"user">,
) {
  const [userAId, userBId] =
    userId < otherUserId ? [userId, otherUserId] : [otherUserId, userId];
  return ctx.db
    .query("friendship")
    .withIndex("by_pair", (q) =>
      q.eq("userAId", userAId).eq("userBId", userBId),
    )
    .unique();
}

export async function listForUser(
  ctx: QueryCtx,
  userId: Id<"user">,
  status?: Doc<"friendship">["status"],
) {
  const [asA, asB] = await Promise.all([
    ctx.db
      .query("friendship")
      .withIndex("by_userAId_and_status", (q) =>
        status === undefined
          ? q.eq("userAId", userId)
          : q.eq("userAId", userId).eq("status", status),
      )
      .collect(),
    ctx.db
      .query("friendship")
      .withIndex("by_userBId_and_status", (q) =>
        status === undefined
          ? q.eq("userBId", userId)
          : q.eq("userBId", userId).eq("status", status),
      )
      .collect(),
  ]);
  return [...asA, ...asB];
}
