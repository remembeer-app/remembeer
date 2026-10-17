import { v } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { authQuery } from "../lib/authenticated";
import { access } from "../lib/access";
import { schema } from "../schema";
import { matchResolver } from "../beerpongMatch/resolution";
import { requireSessionAccess } from "../session/access";
import { requireParty } from "../party/access";
import { loadTournament } from "./access";
import { tournamentPlacements } from "./scoring";

export const listForSession = authQuery
  .input({ sessionId: v.id("session") })
  .returns(v.array(schema.doc("beerpongTournament")))
  .extend(
    access<{ sessionId: Id<"session"> }>()
      .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "joined"))
      .use(requireParty).extend,
  )
  .handler(async (ctx, { sessionId }) => {
    return await ctx.db
      .query("beerpongTournament")
      .withIndex("by_sessionId", (q) => q.eq("sessionId", sessionId))
      .order("desc")
      .collect();
  });

export const get = authQuery
  .input({ id: v.id("beerpongTournament") })
  .returns(
    v.object({
      tournament: schema.doc("beerpongTournament"),
      teams: v.array(schema.doc("beerpongTeam")),
      matches: v.array(
        schema.doc("beerpongMatch").extend({
          teamAId: v.nullable(v.id("beerpongTeam")),
          teamBId: v.nullable(v.id("beerpongTeam")),
          status: v.union(
            v.literal("pending"),
            v.literal("ready"),
            v.literal("completed"),
            v.literal("bye"),
          ),
        }),
      ),
      // Placements are final only after finalization, and include every team.
      placements: v.array(
        v.object({
          teamId: v.id("beerpongTeam"),
          placement: v.number(),
        }),
      ),
    }),
  )
  .extend(
    access<{ id: Id<"beerpongTournament"> }>()
      .use(loadTournament)
      .use((ctx) => requireSessionAccess(ctx, ctx.tournament.sessionId, "joined"))
      .use(requireParty).extend,
  )
  .handler(async (ctx, { id }) => {
    const { tournament } = ctx;

    const [teams, matches] = await Promise.all([
      ctx.db
        .query("beerpongTeam")
        .withIndex("by_tournamentId", (q) => q.eq("tournamentId", id))
        .collect(),
      ctx.db
        .query("beerpongMatch")
        .withIndex("by_tournamentId_and_round_and_position", (q) => q.eq("tournamentId", id))
        .collect(),
    ]);

    const resolve = matchResolver(matches);

    return {
      tournament,
      teams,
      matches: matches.map((match) => {
        const { teamAId, teamBId } = resolve(match._id);
        const status =
          match.winnerTeamId !== null
            ? teamAId === null || teamBId === null
              ? ("bye" as const)
              : ("completed" as const)
            : teamAId && teamBId
              ? ("ready" as const)
              : ("pending" as const);

        return { ...match, teamAId: teamAId ?? null, teamBId: teamBId ?? null, status };
      }),
      placements:
        tournament.status === "completed"
          ? [...tournamentPlacements(tournament, teams, matches)]
              .map(([teamId, placement]) => ({ teamId, placement }))
              .sort(
                (a, b) =>
                  a.placement - b.placement ||
                  (a.teamId < b.teamId ? -1 : a.teamId > b.teamId ? 1 : 0),
              )
          : [],
    };
  });
