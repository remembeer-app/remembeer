import type { Id } from "../_generated/dataModel";
import { access } from "../lib/access";
import { partyAccess, ongoingPartyAccess } from "../party/access";
import { requireSessionAccess } from "../session/access";
import { beerpongEnabledAccess } from "./access";

export function withBeerpongPartyAccess(permission: "joined" | "admin") {
  const chain = access<{ sessionId: Id<"session"> }>()
    .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, permission))
    .use(partyAccess);

  return permission === "admin"
    ? chain.use(ongoingPartyAccess).use(beerpongEnabledAccess).extend
    : chain.extend;
}
