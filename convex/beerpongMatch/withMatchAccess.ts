import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { access } from "../lib/access";
import { partyAccess, ongoingPartyAccess } from "../party/access";
import {
  loadTournament,
  tournamentSessionAccess,
  beerpongEnabledAccess,
} from "../beerpongTournament/access";

export function withMatchAccess() {
  return access<{ id: Id<"beerpongMatch"> }>()
    .use(async (ctx, { id }) => {
      const match = await ctx.db.get("beerpongMatch", id);
      if (!match) {
        throw new ConvexError("Match not found");
      }

      return { match };
    })
    .use((ctx) => loadTournament(ctx, { id: ctx.match.tournamentId }))
    .use(tournamentSessionAccess("admin"))
    .use(partyAccess)
    .use(ongoingPartyAccess)
    .use(beerpongEnabledAccess)
    .extend;
}
