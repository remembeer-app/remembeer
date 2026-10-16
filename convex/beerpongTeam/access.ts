import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { access } from "../lib/access";
import {
  loadTournament,
  requireEditableBeerpongParty,
} from "../beerpongTournament/access";

export function editableTeamAccess() {
  return access<{ id: Id<"beerpongTeam"> }>()
    .use(async (ctx, { id }) => {
      const team = await ctx.db.get("beerpongTeam", id);
      if (!team) {
        throw new ConvexError("Team not found");
      }

      return { team };
    })
    .use((ctx) => loadTournament(ctx, { id: ctx.team.tournamentId }))
    .use((ctx) => requireEditableBeerpongParty(ctx, ctx.tournament.sessionId))
    .use((ctx) => {
      if (ctx.tournament.status !== "setup" && ctx.tournament.status !== "active") {
        throw new ConvexError("Teams can only be edited during setup or active play");
      }

      return {};
    });
}
