import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { requireEnabledPartyAdmin } from "../beerpongTournament/access";

export async function requireEditableTeam(
  ctx: AuthQueryCtx,
  id: Id<"beerpongTeam">,
) {
  const team = await ctx.db.get("beerpongTeam", id);
  if (!team) throw new ConvexError("Team not found");

  const tournament = await ctx.db.get("beerpongTournament", team.tournamentId);
  if (!tournament) throw new ConvexError("Tournament not found");

  await requireEnabledPartyAdmin(ctx, tournament.sessionId);
  if (tournament.status !== "setup" && tournament.status !== "active")
    throw new ConvexError("Teams can only be edited during setup or active play");

  return { team, tournament };
}
