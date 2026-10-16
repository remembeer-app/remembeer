import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { requireSessionAccess } from "../session/access";
import { partyAccess, ongoingPartyAccess } from "../party/access";

export async function requirePartyMember(
  ctx: AuthQueryCtx,
  sessionId: Id<"session">,
) {
  const { session } = await requireSessionAccess(ctx, sessionId, "joined");

  return partyAccess({ session }).session;
}

export async function requireEnabledPartyAdmin(
  ctx: AuthQueryCtx,
  sessionId: Id<"session">,
) {
  const { session } = await requireSessionAccess(ctx, sessionId, "admin");
  const party = partyAccess({ session });
  ongoingPartyAccess(party);
  beerpongEnabledAccess(party);

  return party.session;
}

export function beerpongEnabledAccess(ctx: {
  session: Extract<Doc<"session">, { kind: "party" }>;
}) {
  if (!ctx.session.modules.beerpongEnabled) {
    throw new ConvexError("Beerpong is disabled");
  }

  return {};
}
