import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";

export async function loadTournament(
  ctx: AuthQueryCtx,
  { id }: { id: Id<"beerpongTournament"> },
) {
  const tournament = await ctx.db.get("beerpongTournament", id);
  if (!tournament) {
    throw new ConvexError("Tournament not found");
  }

  return { tournament };
}

export function beerpongEnabledAccess(ctx: {
  session: Extract<Doc<"session">, { kind: "party" }>;
}) {
  if (!ctx.session.modules.beerpongEnabled) {
    throw new ConvexError("Beerpong is disabled");
  }

  return {};
}
