import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authMutation, type AuthMutationCtx } from "../lib/authenticated";
import type { Id } from "../_generated/dataModel";
import {
  createLeaderboardInputValidator,
  updateLeaderboardInputValidator,
} from "./schema";
import {
  leaderboardTimeZone,
  leaderboardEndOfDayBoundary,
  maxLeaderboardMembers,
  inviteCodeLength,
  inviteCodeCharacters,
} from "./constants";
import {
  getMembership,
  listMemberships,
  requireLeaderboardAccess,
} from "./access";

const idInput = { id: v.id("leaderboard") };
const memberInput = { ...idInput, userId: v.id("user") };

export const create = authMutation
  .extend(WithZod)
  .input(createLeaderboardInputValidator)
  .returns(v.id("leaderboard"))
  .handler(async (ctx, input) => {
    let inviteCode: string;
    do {
      inviteCode = Array.from(
        { length: inviteCodeLength },
        () =>
          inviteCodeCharacters[
            Math.floor(Math.random() * inviteCodeCharacters.length)
          ],
      ).join("");
    } while (
      await ctx.db
        .query("leaderboard")
        .withIndex("by_inviteCode", (q) => q.eq("inviteCode", inviteCode))
        .unique()
    );
    const now = Date.now();
    const id = await ctx.db.insert("leaderboard", {
      ...input,
      ownerId: ctx.user._id,
      inviteCode,
      timeZone: leaderboardTimeZone,
      endOfDayBoundary: leaderboardEndOfDayBoundary,
      updatedAt: now,
      deletedAt: null,
    });
    await ctx.db.insert("leaderboardMember", {
      leaderboardId: id,
      userId: ctx.user._id,
      status: "joined",
      updatedAt: now,
    });
    return id;
  });

export const update = authMutation
  .extend(WithZod)
  .input(updateLeaderboardInputValidator)
  .returns(v.null())
  .handler(async (ctx, { id, ...input }) => {
    const { leaderboard } = await requireLeaderboardAccess(ctx, id, true);
    await ctx.db.patch("leaderboard", id, {
      name: input.name ?? leaderboard.name,
      iconName: input.iconName ?? leaderboard.iconName,
      updatedAt: Date.now(),
    });
    return null;
  });

export const softDelete = authMutation
  .input(idInput)
  .returns(v.null())
  .handler(async (ctx, { id }) => {
    await requireLeaderboardAccess(ctx, id, true);
    const now = Date.now();
    await ctx.db.patch("leaderboard", id, { deletedAt: now, updatedAt: now });
    return null;
  });

export const join = authMutation
  .input(idInput)
  .returns(
    v.union(
      v.literal("success"),
      v.literal("alreadyMember"),
      v.literal("banned"),
      v.literal("full"),
    ),
  )
  .handler(async (ctx, { id }) => {
    const leaderboard = await ctx.db.get("leaderboard", id);
    if (!leaderboard || leaderboard.deletedAt !== null)
      throw new ConvexError("Leaderboard not found");
    const member = await getMembership(ctx, id, ctx.user._id);
    if (member?.status === "joined") return "alreadyMember";
    if (member?.status === "banned") return "banned";
    if (
      (await listMemberships(ctx, id)).filter((m) => m.status === "joined")
        .length >= maxLeaderboardMembers
    )
      return "full";
    await ctx.db.insert("leaderboardMember", {
      leaderboardId: id,
      userId: ctx.user._id,
      status: "joined",
      updatedAt: Date.now(),
    });
    return "success";
  });

export const leave = authMutation
  .input(idInput)
  .returns(v.null())
  .handler(async (ctx, { id }) => {
    const { isOwner } = await requireLeaderboardAccess(ctx, id);
    if (isOwner)
      throw new ConvexError("The owner cannot leave their own leaderboard");
    const member = await getMembership(ctx, id, ctx.user._id);
    if (member) await ctx.db.delete("leaderboardMember", member._id);
    return null;
  });

export const remove = authMutation
  .input(memberInput)
  .returns(v.null())
  .handler((ctx, input) => changeMember(ctx, input, "remove"));
export const ban = authMutation
  .input(memberInput)
  .returns(v.null())
  .handler((ctx, input) => changeMember(ctx, input, "ban"));
export const unban = authMutation
  .input(memberInput)
  .returns(v.null())
  .handler((ctx, input) => changeMember(ctx, input, "unban"));

async function changeMember(
  ctx: AuthMutationCtx,
  { id, userId }: { id: Id<"leaderboard">; userId: Id<"user"> },
  action: "remove" | "ban" | "unban",
) {
  const { leaderboard } = await requireLeaderboardAccess(ctx, id, true);
  if (userId === leaderboard.ownerId)
    throw new ConvexError("The owner cannot remove or ban themselves");
  const member = await getMembership(ctx, id, userId);
  if (action === "ban") {
    if (!(await ctx.db.get("user", userId)))
      throw new ConvexError("User not found");
    if (member)
      await ctx.db.patch("leaderboardMember", member._id, {
        status: "banned",
        updatedAt: Date.now(),
      });
    else
      await ctx.db.insert("leaderboardMember", {
        leaderboardId: id,
        userId,
        status: "banned",
        updatedAt: Date.now(),
      });
  } else if (member?.status === (action === "remove" ? "joined" : "banned")) {
    await ctx.db.delete("leaderboardMember", member._id);
  }
  return null;
}
