import type { Id } from "../_generated/dataModel";
import { access } from "../lib/access";
import { partyAccess, ongoingPartyAccess } from "../party/access";
import {
  loadTournament,
  tournamentSessionAccess,
  beerpongEnabledAccess,
} from "./access";

export function withTournamentAccess(permission: "joined" | "admin") {
  const chain = access<{ id: Id<"beerpongTournament"> }>()
    .use(loadTournament)
    .use(tournamentSessionAccess(permission))
    .use(partyAccess);

  return permission === "admin"
    ? chain.use(ongoingPartyAccess).use(beerpongEnabledAccess).extend
    : chain.extend;
}
