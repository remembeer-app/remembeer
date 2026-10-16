import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { QueryCtx } from "../_generated/server";
import { matchResolver } from "../beerpongMatch/resolution";
import { minTeamCount, maxTeamCount } from "./constants";

export function tournamentPlacements(
  tournament: Doc<"beerpongTournament">,
  teams: Doc<"beerpongTeam">[],
  matches: Doc<"beerpongMatch">[],
) {
  if (
    teams.length !== tournament.teamCount ||
    teams.length < minTeamCount ||
    teams.length > maxTeamCount
  )
    throw new ConvexError("Tournament teams must match the configured team count");

  if (teams.some((team) => team.memberUserIds.length === 0))
    throw new ConvexError("Every team must have at least one player");

  const players = teams.flatMap((team) => team.memberUserIds);
  if (new Set(players).size !== players.length)
    throw new ConvexError("A player cannot belong to multiple teams");

  const roundCount = Math.ceil(Math.log2(teams.length));
  const main = matches.filter((match) => match.kind === "main");
  const bronze = matches.filter((match) => match.kind === "thirdPlace");
  if (
    main.length !== 2 ** roundCount - 1 ||
    bronze.length !== (tournament.thirdPlaceEnabled && teams.length >= 4 ? 1 : 0)
  )
    throw new ConvexError("Tournament bracket is incomplete");

  if (matches.some((match) => match.winnerTeamId === null || match.completedAt === null))
    throw new ConvexError("All matches must be completed before finalization");

  const teamIds = new Set(teams.map((team) => team._id));
  const resolve = matchResolver(matches);
  const placements = new Map<Id<"beerpongTeam">, number>();

  for (const match of matches) {
    const { teamAId, teamBId } = resolve(match._id);
    if (
      teamAId === undefined ||
      teamBId === undefined ||
      (teamAId !== null && !teamIds.has(teamAId)) ||
      (teamBId !== null && !teamIds.has(teamBId)) ||
      match.winnerTeamId === null ||
      (match.winnerTeamId !== teamAId && match.winnerTeamId !== teamBId) ||
      (teamAId !== null && teamAId === teamBId) ||
      (match.kind === "thirdPlace" && (teamAId === null || teamBId === null))
    )
      throw new ConvexError("Tournament has an invalid match result");

    const loser = match.winnerTeamId === teamAId ? teamBId : teamAId;
    if (match.kind === "main" && loser !== null)
      placements.set(loser, 2 ** (roundCount - match.round) + 1);
  }

  const finals = main.filter((match) => match.round === roundCount);
  const final = finals[0];
  if (finals.length !== 1 || !final || final.winnerTeamId === null)
    throw new ConvexError("Tournament final is missing");

  placements.set(final.winnerTeamId, 1);

  const thirdPlace = bronze[0];
  if (thirdPlace && thirdPlace.winnerTeamId !== null) {
    const { teamAId, teamBId } = resolve(thirdPlace._id);
    const loser = thirdPlace.winnerTeamId === teamAId ? teamBId : teamAId;
    if (!loser) throw new ConvexError("Third-place match has no loser");

    placements.set(thirdPlace.winnerTeamId, 3);
    placements.set(loser, 4);
  }

  if (placements.size !== teams.length || teams.some((team) => !placements.has(team._id)))
    throw new ConvexError("Tournament placements are incomplete");

  return placements;
}

export function tournamentAwards(
  tournament: Doc<"beerpongTournament">,
  teams: Doc<"beerpongTeam">[],
  matches: Doc<"beerpongMatch">[],
) {
  const placements = tournamentPlacements(tournament, teams, matches);

  return teams.flatMap((team) => {
    const placement = placements.get(team._id)!;
    const points =
      placement === 1
        ? tournament.firstPlacePointsUnits
        : placement === 2
          ? tournament.secondPlacePointsUnits
          : placement === 3
            ? tournament.thirdPlacePointsUnits
            : 0;
    if (!Number.isSafeInteger(points) || points < 0)
      throw new ConvexError("Placement points are outside the supported range");

    if (placement > 3) return [];

    const memberIds = [...team.memberUserIds].sort();
    const base = Math.floor(points / memberIds.length);
    const remainder = points % memberIds.length;

    return memberIds.map((userId, index) => ({
      teamId: team._id,
      teamName: team.name,
      participantIds: memberIds,
      userId,
      placement,
      scoreUnits: base + (index < remainder ? 1 : 0),
    }));
  });
}

export async function loadTournamentAwards(ctx: QueryCtx, tournament: Doc<"beerpongTournament">) {
  const [teams, matches] = await Promise.all([
    ctx.db
      .query("beerpongTeam")
      .withIndex("by_tournamentId", (q) => q.eq("tournamentId", tournament._id))
      .collect(),
    ctx.db
      .query("beerpongMatch")
      .withIndex("by_tournamentId_and_round_and_position", (q) =>
        q.eq("tournamentId", tournament._id),
      )
      .collect(),
  ]);

  return tournamentAwards(tournament, teams, matches);
}

export async function loadBeerpongAwards(ctx: QueryCtx, sessionId: Id<"session">) {
  const tournaments = await ctx.db
    .query("beerpongTournament")
    .withIndex("by_sessionId", (q) => q.eq("sessionId", sessionId))
    .collect();

  const awards = await Promise.all(
    tournaments
      .filter((tournament) => tournament.status === "completed")
      .map(async (tournament) => {
        const occurredAt = tournament.completedAt;
        if (occurredAt === null)
          throw new ConvexError("Completed tournament has no completion time");

        return (await loadTournamentAwards(ctx, tournament)).map((award) => ({
          ...award,
          tournamentId: tournament._id,
          tournamentName: tournament.name,
          occurredAt,
        }));
      }),
  );

  return awards.flat();
}
