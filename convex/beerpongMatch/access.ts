import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { access } from "../lib/access";
import {
  loadTournament,
  requireEditableBeerpongParty,
} from "../beerpongTournament/access";

export function editableMatchAccess() {
  return access<{ id: Id<"beerpongMatch"> }>()
    .use(async (ctx, { id }) => {
      const match = await ctx.db.get("beerpongMatch", id);
      if (!match) {
        throw new ConvexError("Match not found");
      }

      return { match };
    })
    .use((ctx) => loadTournament(ctx, { id: ctx.match.tournamentId }))
    .use((ctx) => requireEditableBeerpongParty(ctx, ctx.tournament.sessionId));
}
