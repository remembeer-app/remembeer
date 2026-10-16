import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import { access } from "../lib/access";
import { requireSessionAccess } from "../session/access";

// Existing endpoints use either "id" or "questId" for the quest reference.
export function questAccess<TIdField extends string>(idField: TIdField) {
  return access<Record<TIdField, Id<"partyQuest">>>()
    .use(async (ctx, input) => {
      const quest = await ctx.db.get("partyQuest", input[idField]);
      if (!quest) {
        throw new ConvexError("Quest not found");
      }

      return { quest };
    })
    .use((ctx) => requireSessionAccess(ctx, ctx.quest.sessionId, "joined"));
}

export function activeQuestPartyAccess(ctx: { session: Doc<"session"> }) {
  const { session } = ctx;
  if (session.kind !== "party" || session.endedAt !== null) {
    throw new ConvexError("An ongoing party is required");
  }

  return { session };
}
