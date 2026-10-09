import { ConvexError, v } from "convex/values";
import { WithZod } from "fluent-convex/zod";
import { authMutation } from "../lib/authenticated";
import { createSessionInputValidator, updateSessionInputValidator } from "./schema";
import { requireSessionAccess } from "./access";

export const create = authMutation
  .extend(WithZod)
  .input(createSessionInputValidator)
  .returns(v.id("session"))
  .handler(async (ctx, input) => {
    const now = Date.now();
    const sessionId = await ctx.db.insert("session", {
      ...input, kind: "session", ownerId: ctx.user._id,
      endedAt: null, updatedAt: now, deletedAt: null,
    });
    await ctx.db.insert("sessionMember", {
      sessionId, userId: ctx.user._id,
      sessionMemberStatus: { kind: "joined" }, sessionMemberRole: { kind: "admin" },
      updatedAt: now,
    });
    return sessionId;
  });

export const update = authMutation
  .extend(WithZod)
  .input(updateSessionInputValidator)
  .returns(v.null())
  .handler(async (ctx, { id, ...input }) => {
    const { session } = await requireSessionAccess(ctx, id, "admin");
    const startedAt = input.startedAt ?? session.startedAt;
    const endedAt = input.endedAt === undefined ? session.endedAt : input.endedAt;
    if (endedAt !== null && endedAt < startedAt) throw new ConvexError("End time must not precede start time");
    await ctx.db.patch("session", id, {
      name: input.name ?? session.name,
      description: input.description ?? session.description,
      startedAt, endedAt, updatedAt: Date.now(),
    });
    return null;
  });

export const softDelete = authMutation
  .input({ id: v.id("session") })
  .returns(v.null())
  .handler(async (ctx, { id }) => {
    await requireSessionAccess(ctx, id, "owner");
    const now = Date.now();
    await ctx.db.patch("session", id, { deletedAt: now, updatedAt: now });
    return null;
  });

export const promoteToParty = authMutation
  .input({ id: v.id("session") })
  .returns(v.null())
  .handler(async (ctx, { id }) => {
    const { session } = await requireSessionAccess(ctx, id, "admin");
    if (session.kind === "party") return null;
    if (session.endedAt !== null) throw new ConvexError("Only ongoing sessions can become parties");
    await ctx.db.patch("session", id, { kind: "party", updatedAt: Date.now() });
    return null;
  });
