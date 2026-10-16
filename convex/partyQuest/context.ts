import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { QueryCtx } from "../_generated/server";
import { matchResolver } from "../beerpongMatch/resolution";
import { loadPartyScores } from "../party/scores";
import { maxQuestPlayers } from "./constants";
import { memberPair, type QuestPlayer } from "./eligibility";

export async function loadQuestContext(
  ctx: QueryCtx,
  sessionId: Id<"session">,
  now: number,
) {
  const { entries, quests } = await loadPartyScores(ctx, sessionId, now);

  const session = await ctx.db.get("session", sessionId);

  const { teamByUserId, finalistTeamIds } = await loadBeerpongQuestContext(
    ctx,
    session,
  );

  const players: QuestPlayer[] = entries.flatMap(
    ({ member, user, scoreUnits }) =>
      member.selectedClass !== null && user
        ? [
            {
              userId: user._id,
              username: user.username,
              selectedClass: member.selectedClass.kind,
              accentColor: user.accentColor,
              scoreUnits,
              beerpongTeamId: teamByUserId.get(user._id) ?? null,
            },
          ]
        : [],
  );
  if (players.length > maxQuestPlayers)
    throw new ConvexError(`Quests support at most ${maxQuestPlayers} players`);

  const previousPairs = new Set<string>();

  for (const quest of quests) {
    for (const result of quest.results) {
      previousPairs.add(
        JSON.stringify(memberPair(result.firstUserId, result.secondUserId)),
      );
    }
  }

  return { players, previousPairs, quests, finalistTeamIds };
}

// The newest tournament owns the team context, including during enrollment or
// after cancellation, so old assignments cannot leak into a new tournament.
async function loadBeerpongQuestContext(
  ctx: QueryCtx,
  session: Doc<"session"> | null,
) {
  const teamByUserId = new Map<Id<"user">, Id<"beerpongTeam">>();
  const finalistTeamIds = new Set<Id<"beerpongTeam">>();
  const context = { teamByUserId, finalistTeamIds };
  if (session?.kind !== "party" || !session.modules.beerpongEnabled)
    return context;

  const tournament = await ctx.db
    .query("beerpongTournament")
    .withIndex("by_sessionId", (q) => q.eq("sessionId", session._id))
    .order("desc")
    .first();
  if (
    !tournament ||
    tournament.status === "enrollment" ||
    tournament.status === "cancelled"
  )
    return context;

  const teams = await ctx.db
    .query("beerpongTeam")
    .withIndex("by_tournamentId", (q) => q.eq("tournamentId", tournament._id))
    .collect();

  for (const team of teams) {
    for (const userId of team.memberUserIds) teamByUserId.set(userId, team._id);
  }

  if (tournament.status === "setup") return context;

  const matches = await ctx.db
    .query("beerpongMatch")
    .withIndex("by_tournamentId_and_round_and_position", (q) =>
      q.eq("tournamentId", tournament._id),
    )
    .collect();

  const final = matches
    .filter((match) => match.kind === "main")
    .sort((a, b) => b.round - a.round)[0];
  if (final) {
    const { teamAId, teamBId } = matchResolver(matches)(final._id);

    // A finalist qualifies as soon as their path to the final is resolved.
    for (const teamId of [teamAId, teamBId]) {
      if (teamId && teams.some((team) => team._id === teamId))
        finalistTeamIds.add(teamId);
    }
  }

  return context;
}
