import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { access } from "../lib/access";
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

function loadChallenge() {
  return access<{ id: Id<"partyChallenge"> }>()
    .use(async (ctx, { id }) => {
      const challenge = await ctx.db.get("partyChallenge", id);
      if (!challenge) {
        throw new ConvexError("Challenge not found");
      }

      return { challenge };
    });
}

export function challengeAccess() {
  return loadChallenge()
    .use((ctx) => requireSessionAccess(ctx, ctx.challenge.sessionId, "joined"))
    .use(partyAccess);
}

export function editableChallengeAccess() {
  return loadChallenge()
    .use((ctx) => requireSessionAccess(ctx, ctx.challenge.sessionId, "admin"))
    .use(partyAccess)
    .use(ongoingPartyAccess);
}
