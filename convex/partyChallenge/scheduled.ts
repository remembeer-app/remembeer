import { v } from "convex/values";
import { convex } from "../lib/builder";

export const expire = convex
  .mutation()
  .input({ id: v.id("partyChallenge"), endsAt: v.number() })
  .returns(v.null())
  .handler(async (ctx, { id, endsAt }) => {
    const challenge = await ctx.db.get("partyChallenge", id);
    const now = Date.now();
    if (
      !challenge ||
      challenge.status !== "active" ||
      challenge.endsAt !== endsAt ||
      endsAt > now
    )
      return null;
    await ctx.db.patch("partyChallenge", id, {
      status: "expired",
      updatedAt: now,
    });
    return null;
  });
