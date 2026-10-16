import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";

export async function loadMatch(
  ctx: AuthQueryCtx,
  { id }: { id: Id<"beerpongMatch"> },
) {
  const match = await ctx.db.get("beerpongMatch", id);
  if (!match) {
    throw new ConvexError("Match not found");
  }

  return { match };
}
