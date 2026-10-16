import { defineTable } from "convex/server";
import { v } from "convex/values";

export const beerpongTeamTable = defineTable({
  tournamentId: v.id("beerpongTournament"),
  name: v.string(),
  memberUserIds: v.array(v.id("user")),
  updatedAt: v.number(),
}).index("by_tournamentId", ["tournamentId"]);
