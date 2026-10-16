import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";

export async function loadQuest(
  ctx: AuthQueryCtx,
  { id }: { id: Id<"partyQuest"> },
) {
  const quest = await ctx.db.get("partyQuest", id);
  if (!quest) {
    throw new ConvexError("Quest not found");
  }

  return { quest };
}

export function activeQuestPartyAccess(ctx: { session: Doc<"session"> }) {
  const { session } = ctx;
  if (session.kind !== "party" || session.endedAt !== null) {
    throw new ConvexError("An ongoing party is required");
  }

  return { session };
}
