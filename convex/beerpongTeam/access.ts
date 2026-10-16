import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";

export async function loadTeam(
    ctx: AuthQueryCtx,
    { id }: { id: Id<"beerpongTeam"> },
) {
    const team = await ctx.db.get("beerpongTeam", id);
    if (!team) {
        throw new ConvexError("Team not found");
    }

    return { team };
}

export function requireEditableTeamStatus(ctx: {
    tournament: Doc<"beerpongTournament">;
}) {
    if (ctx.tournament.status !== "setup" && ctx.tournament.status !== "active") {
        throw new ConvexError("Teams can only be edited during setup or active play");
    }

    return {};
}
