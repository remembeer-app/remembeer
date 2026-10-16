import { ConvexError, v } from "convex/values";
import { authMutation } from "../lib/authenticated";
import { editableMatchAccess } from "./access";
import { downstreamMatches, matchResolver } from "./resolution";

function resultMutation(correcting: boolean) {
  return authMutation
    .input({ id: v.id("beerpongMatch"), winnerTeamId: v.id("beerpongTeam") })
    .returns(v.null())
    .extend(editableMatchAccess().extend)
    .handler(async (ctx, { id, winnerTeamId }) => {
      const { match, tournament } = ctx;
      if (tournament.status !== "active")
        throw new ConvexError("Results can only be changed in an active tournament");

      const matches = await ctx.db.query("beerpongMatch")
        .withIndex("by_tournamentId_and_round_and_position", (q) =>
          q.eq("tournamentId", match.tournamentId),
        )
        .collect();

      const { teamAId, teamBId } = matchResolver(matches)(id);
      if (teamAId === null || teamBId === null)
        throw new ConvexError("Bye matches advance automatically and cannot be edited");

      if (teamAId === undefined || teamBId === undefined)
        throw new ConvexError("Both opponents must be known before recording a result");

      if (winnerTeamId !== teamAId && winnerTeamId !== teamBId)
        throw new ConvexError("Winner must be one of the match opponents");

      if (correcting && match.winnerTeamId === null)
        throw new ConvexError("Match has no result to correct");

      if (!correcting && match.winnerTeamId !== null)
        throw new ConvexError("Match already has a result; correct it instead");

      if (match.winnerTeamId === winnerTeamId) return null;

      const now = Date.now();
      if (correcting) {
        for (const dependent of downstreamMatches(matches, id)) {
          if (dependent.winnerTeamId === null && dependent.completedAt === null) continue;

          await ctx.db.patch("beerpongMatch", dependent._id, {
            winnerTeamId: null, completedAt: null, updatedAt: now,
          });
        }
      }

      await ctx.db.patch("beerpongMatch", id, {
        winnerTeamId, completedAt: now, updatedAt: now,
      });
      await ctx.db.patch("beerpongTournament", tournament._id, { updatedAt: now });

      return null;
    });
}

export const recordResult = resultMutation(false);
export const correctResult = resultMutation(true);
