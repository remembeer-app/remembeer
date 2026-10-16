import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { requireSessionAccess } from "../session/access";
import { partyAccess, ongoingPartyAccess } from "../party/access";

export async function requireParty(
  ctx: AuthQueryCtx,
  sessionId: Id<"session">,
  permission: "joined" | "admin",
) {
  const { session } = await requireSessionAccess(ctx, sessionId, permission);
  const party = partyAccess({ session });
  if (permission === "admin") {
    ongoingPartyAccess(party);
  }

  return party.session;
}
