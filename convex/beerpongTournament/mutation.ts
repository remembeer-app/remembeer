import { ConvexError, v } from "convex/values";
import { convexToZod } from "convex-helpers/server/zod4";
import { WithZod } from "fluent-convex/zod";
import { z } from "zod";
import { authMutation } from "../lib/authenticated";
import { requireSessionAccess } from "../session/access";
import {
  maxTournamentNameLength,
  minTeamCount,
  maxTeamCount,
  minPlacementPointsUnits,
  maxPlacementPointsUnits,
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
    const { session } = await requireSessionAccess(ctx, sessionId, "admin");
    if (session.kind !== "party") throw new ConvexError("A party is required");
    if (session.endedAt !== null)
      throw new ConvexError("Ended parties are read-only");
    if (!session.modules.beerpongEnabled)
      throw new ConvexError("Beerpong is disabled");
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
