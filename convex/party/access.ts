import { ConvexError } from "convex/values";
import type { Doc } from "../_generated/dataModel";

type Party = Extract<Doc<"session">, { kind: "party" }>;

export function partyAccess(ctx: { session: Doc<"session"> }) {
  const { session } = ctx;
  if (session.kind !== "party") {
    throw new ConvexError("A party is required");
  }

  return { session };
}

export function ongoingPartyAccess(ctx: { session: Party }) {
  if (ctx.session.endedAt !== null) {
    throw new ConvexError("Ended parties are read-only");
  }

  return {};
}
