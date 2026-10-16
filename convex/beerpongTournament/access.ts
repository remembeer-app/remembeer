import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { access } from "../lib/access";
import { requireSessionAccess } from "../session/access";
import { partyAccess, ongoingPartyAccess } from "../party/access";

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

// Shared edit policy for tournaments, teams, matches, and tournament creation.
export async function requireEditableBeerpongParty(
  ctx: AuthQueryCtx,
  sessionId: Id<"session">,
) {
  const membership = await requireSessionAccess(ctx, sessionId, "admin");
  const party = partyAccess(membership);
  ongoingPartyAccess(party);

  if (!party.session.modules.beerpongEnabled) {
    throw new ConvexError("Beerpong is disabled");
  }

  return { ...membership, ...party };
}

export function tournamentAccess() {
  return access<{ id: Id<"beerpongTournament"> }>()
    .use(loadTournament)
    .use((ctx) => requireSessionAccess(ctx, ctx.tournament.sessionId, "joined"))
    .use(partyAccess);
}

export function editableTournamentAccess() {
  return access<{ id: Id<"beerpongTournament"> }>()
    .use(loadTournament)
    .use((ctx) => requireEditableBeerpongParty(ctx, ctx.tournament.sessionId));
}

export function beerpongPartyAccess() {
  return access<{ sessionId: Id<"session"> }>()
    .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "joined"))
    .use(partyAccess);
}

export function editableBeerpongPartyAccess() {
  return access<{ sessionId: Id<"session"> }>()
    .use((ctx, { sessionId }) => requireEditableBeerpongParty(ctx, sessionId));
}
