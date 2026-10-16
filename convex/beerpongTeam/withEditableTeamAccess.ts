import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { access } from "../lib/access";
import { partyAccess, ongoingPartyAccess } from "../party/access";
import { requireSessionAccess } from "../session/access";
import { beerpongEnabledAccess } from "../beerpongTournament/access";

export function withEditableTeamAccess() {
  return access<{ id: Id<"beerpongTeam"> }>()
    .use(async (ctx, { id }) => {
      const team = await ctx.db.get("beerpongTeam", id);
      if (!team) {
        throw new ConvexError("Team not found");
      }

      return { team };
    })
    .use(async (ctx) => {
      const tournament = await ctx.db.get("beerpongTournament", ctx.team.tournamentId);
      if (!tournament) {
        throw new ConvexError("Tournament not found");
      }

      return { tournament };
    })
    .use((ctx) => requireSessionAccess(ctx, ctx.tournament.sessionId, "admin"))
    .use(partyAccess)
    .use(ongoingPartyAccess)
    .use(beerpongEnabledAccess)
    .use((ctx) => {
      if (ctx.tournament.status !== "setup" && ctx.tournament.status !== "active") {
        throw new ConvexError("Teams can only be edited during setup or active play");
      }

      return {};
    })
    .extend;
}
