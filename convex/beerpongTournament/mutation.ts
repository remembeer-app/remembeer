import { ConvexError, v } from "convex/values";
import { convexToZod } from "convex-helpers/server/zod4";
import { WithZod } from "fluent-convex/zod";
import { z } from "zod";
import { authMutation } from "../lib/authenticated";
import { requireEnabledPartyAdmin } from "./access";
import {
  maxTournamentNameLength,
  minTeamCount,
  maxTeamCount,
  minPlacementPointsUnits,
  maxPlacementPointsUnits,
  defaultTeamNamePrefix,
} from "./constants";

const placementPoints = z
  .number()
  .int()
  .min(minPlacementPointsUnits)
  .max(maxPlacementPointsUnits);

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
  .handler(async (ctx, { sessionId, ...input }) => {
    await requireEnabledPartyAdmin(ctx, sessionId);
    if (
      input.firstPlacePointsUnits < input.secondPlacePointsUnits ||
      input.secondPlacePointsUnits < input.thirdPlacePointsUnits
    )
      throw new ConvexError(
        "Placement points must not increase for lower placements",
      );
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
  .handler(async (ctx, { id }) => {
    const tournament = await ctx.db.get("beerpongTournament", id);
    if (!tournament) throw new ConvexError("Tournament not found");
    await requireEnabledPartyAdmin(ctx, tournament.sessionId);
    if (tournament.status !== "enrollment")
      throw new ConvexError("Only an enrollment tournament can be drawn");

    const members = await ctx.db
      .query("sessionMember")
      .withIndex("by_sessionId_and_sessionMemberStatus_kind", (q) =>
        q.eq("sessionId", tournament.sessionId)
          .eq("sessionMemberStatus.kind", "joined"),
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
      const seed = index + 1;
      await ctx.db.insert("beerpongTeam", {
        tournamentId: id,
        name: `${defaultTeamNamePrefix} ${seed}`,
        memberUserIds: players.filter(
          (_, position) => position % tournament.teamCount === index,
        ),
        seed,
        updatedAt: now,
      });
    }
    await ctx.db.patch("beerpongTournament", id, {
      status: "setup",
      updatedAt: now,
    });
    return null;
  });
