import { defineTable } from "convex/server";
import { v } from "convex/values";

export const beerpongMatchSlotValidator = v.union(
  v.object({ kind: v.literal("team"), teamId: v.id("beerpongTeam") }),
  v.object({ kind: v.literal("winner"), matchId: v.id("beerpongMatch") }),
  v.object({ kind: v.literal("loser"), matchId: v.id("beerpongMatch") }),
  v.object({ kind: v.literal("bye") }),
);

export const beerpongMatchTable = defineTable({
  tournamentId: v.id("beerpongTournament"),
  round: v.number(),
  position: v.number(),
  kind: v.union(v.literal("main"), v.literal("thirdPlace")),
  slotA: beerpongMatchSlotValidator,
  slotB: beerpongMatchSlotValidator,
  winnerTeamId: v.nullable(v.id("beerpongTeam")),
  completedAt: v.nullable(v.number()),
  updatedAt: v.number(),
}).index("by_tournamentId_and_round_and_position", ["tournamentId", "round", "position"]);
