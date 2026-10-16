import { ConvexError, v } from "convex/values";
import { convexToZod } from "convex-helpers/server/zod4";
import { WithZod } from "fluent-convex/zod";
import { z } from "zod";
import type { Id } from "../_generated/dataModel";
import { authMutation } from "../lib/authenticated";
import { access } from "../lib/access";
import { requireSessionAccess } from "../session/access";
import { requireParty, requireOngoingParty } from "../party/access";
import { loadTournament, requireBeerpongEnabled, requireOngoingBeerpongParty } from "./access";
import { createBracket } from "./bracket";
import { loadTournamentAwards } from "./scoring";
import {
  maxTournamentNameLength,
  minTeamCount,
  maxTeamCount,
  minPlacementPointsUnits,
  maxPlacementPointsUnits,
  defaultTeamNamePrefix,
} from "./constants";

const placementPoints = z.number().int().min(minPlacementPointsUnits).max(maxPlacementPointsUnits);

const tournamentAdminAccess = access<{ id: Id<"beerpongTournament"> }>()
  .use(loadTournament)
  .use((ctx) => requireSessionAccess(ctx, ctx.tournament.sessionId, "admin"))
  .use(requireParty)
  .use(requireOngoingParty)
  .use(requireBeerpongEnabled);

export const create = authMutation
  .extend(WithZod)
  .input(
    z.object({
      sessionId: convexToZod(v.id("session")),
      name: z.string().trim().min(1).max(maxTournamentNameLength),
      teamCount: z.number().int().min(minTeamCount).max(maxTeamCount),
      thirdPlaceEnabled: z.boolean(),
      firstPlacePointsUnits: placementPoints,
      secondPlacePointsUnits: placementPoints,
      thirdPlacePointsUnits: placementPoints,
    }),
  )
  .returns(v.id("beerpongTournament"))
  .extend(
    access<{ sessionId: Id<"session"> }>()
      .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "admin"))
      .use(requireParty)
      .use(requireOngoingParty)
      .use(requireBeerpongEnabled).extend,
  )
  .handler(async (ctx, { sessionId, ...input }) => {
    if (
      input.firstPlacePointsUnits < input.secondPlacePointsUnits ||
      input.secondPlacePointsUnits < input.thirdPlacePointsUnits
    )
      throw new ConvexError("Placement points must not increase for lower placements");

    return await ctx.db.insert("beerpongTournament", {
      ...input,
      sessionId,
      status: "enrollment",
      createdByUserId: ctx.user._id,
      updatedAt: Date.now(),
      completedAt: null,
    });
  });

export const draw = authMutation
  .input({ id: v.id("beerpongTournament") })
  .returns(v.null())
  .extend(tournamentAdminAccess.extend)
  .handler(async (ctx, { id }) => {
    const { tournament } = ctx;
    if (tournament.status !== "enrollment")
      throw new ConvexError("Only an enrollment tournament can be drawn");

    const members = await ctx.db
      .query("sessionMember")
      .withIndex("by_sessionId_and_sessionMemberStatus_kind", (q) =>
        q.eq("sessionId", tournament.sessionId).eq("sessionMemberStatus.kind", "joined"),
      )
      .collect();

    const players = members
      .filter((member) => member.kind === "partyMember" && member.beerpongOptIn)
      .map((member) => member.userId);
    if (players.length < tournament.teamCount)
      throw new ConvexError("Not enough opted-in members for the team count");

    // Fisher-Yates gives every player order equal probability.
    for (let index = players.length - 1; index > 0; index--) {
      const other = Math.floor(Math.random() * (index + 1));

      [players[index], players[other]] = [players[other]!, players[index]!];
    }

    const now = Date.now();

    for (let index = 0; index < tournament.teamCount; index++) {
      await ctx.db.insert("beerpongTeam", {
        tournamentId: id,
        name: `${defaultTeamNamePrefix} ${index + 1}`,
        memberUserIds: players.filter((_, position) => position % tournament.teamCount === index),
        updatedAt: now,
      });
    }

    await ctx.db.patch("beerpongTournament", id, {
      status: "setup",
      updatedAt: now,
    });

    return null;
  });

export const start = authMutation
  .input({ id: v.id("beerpongTournament") })
  .returns(v.null())
  .extend(tournamentAdminAccess.extend)
  .handler(async (ctx, { id }) => {
    const { tournament } = ctx;
    if (tournament.status !== "setup")
      throw new ConvexError("Only a setup tournament can be started");

    const teams = await ctx.db
      .query("beerpongTeam")
      .withIndex("by_tournamentId", (q) => q.eq("tournamentId", id))
      .collect();
    if (
      teams.length !== tournament.teamCount ||
      teams.length < minTeamCount ||
      teams.length > maxTeamCount
    )
      throw new ConvexError("Tournament teams must match the configured team count");

    if (teams.some((team) => team.memberUserIds.length === 0))
      throw new ConvexError("Every team must have at least one player");

    const members = await ctx.db
      .query("sessionMember")
      .withIndex("by_sessionId_and_sessionMemberStatus_kind", (q) =>
        q.eq("sessionId", tournament.sessionId).eq("sessionMemberStatus.kind", "joined"),
      )
      .collect();

    const eligible = new Set(
      members.filter((member) => member.kind === "partyMember").map((member) => member.userId),
    );
    const players = teams.flatMap((team) => team.memberUserIds);
    if (new Set(players).size !== players.length)
      throw new ConvexError("A player cannot belong to multiple teams");

    if (players.some((userId) => !eligible.has(userId)))
      throw new ConvexError("Players must be joined party members");

    const matches = await ctx.db
      .query("beerpongMatch")
      .withIndex("by_tournamentId_and_round_and_position", (q) => q.eq("tournamentId", id))
      .collect();
    if (matches.length > 0) throw new ConvexError("Tournament already has a bracket");

    const now = Date.now();
    await createBracket(
      ctx,
      tournament,
      teams.map((team) => team._id),
      now,
    );
    await ctx.db.patch("beerpongTournament", id, {
      status: "active",
      updatedAt: now,
    });

    return null;
  });

export const finalize = authMutation
  .input({ id: v.id("beerpongTournament") })
  .returns(v.null())
  .extend(tournamentAdminAccess.extend)
  .handler(async (ctx, { id }) => {
    const { tournament } = ctx;
    if (tournament.status === "completed") return null;

    if (tournament.status !== "active")
      throw new ConvexError("Only an active tournament can be finalized");

    await loadTournamentAwards(ctx, tournament);

    const now = Date.now();
    await ctx.db.patch("beerpongTournament", id, {
      status: "completed",
      completedAt: now,
      updatedAt: now,
    });

    return null;
  });

export const setEnabled = authMutation
  .input({ sessionId: v.id("session"), enabled: v.boolean() })
  .returns(v.null())
  .extend(
    access<{ sessionId: Id<"session"> }>()
      .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "admin"))
      .use(requireOngoingBeerpongParty).extend,
  )
  .handler(async (ctx, { sessionId, enabled }) => {
    const { session } = ctx;

    await ctx.db.patch("session", sessionId, {
      modules: { ...session.modules, beerpongEnabled: enabled },
      updatedAt: Date.now(),
    });

    return null;
  });
