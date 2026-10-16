import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";

// null is an empty (bye) slot; undefined means an earlier result is pending.
type ResolvedTeam = Id<"beerpongTeam"> | null | undefined;
type Opponents = { teamAId: ResolvedTeam; teamBId: ResolvedTeam };

export function matchResolver(matches: Doc<"beerpongMatch">[]) {
  const byId = new Map(matches.map((match) => [match._id, match]));
  const resolved = new Map<Id<"beerpongMatch">, Opponents>();
  const visiting = new Set<Id<"beerpongMatch">>();

  function resolveSlot(slot: Doc<"beerpongMatch">["slotA"]): ResolvedTeam {
    if (slot.kind === "team") return slot.teamId;
    if (slot.kind === "bye") return null;
    const source = byId.get(slot.matchId);
    if (!source) throw new ConvexError("Bracket source match not found");
    const { teamAId, teamBId } = resolve(source._id);
    if (source.winnerTeamId === null) return undefined;
    if (
      source.winnerTeamId !== teamAId &&
      source.winnerTeamId !== teamBId
    )
      throw new ConvexError("Bracket source has an invalid winner");
    if (slot.kind === "winner") return source.winnerTeamId;
    return source.winnerTeamId === teamAId ? teamBId : teamAId;
  }

  function resolve(id: Id<"beerpongMatch">): Opponents {
    const cached = resolved.get(id);
    if (cached) return cached;
    if (visiting.has(id)) throw new ConvexError("Bracket contains a cycle");
    const match = byId.get(id);
    if (!match) throw new ConvexError("Match not found in bracket");
    visiting.add(id);
    const opponents = {
      teamAId: resolveSlot(match.slotA),
      teamBId: resolveSlot(match.slotB),
    };
    visiting.delete(id);
    resolved.set(id, opponents);
    return opponents;
  }

  return resolve;
}

export function downstreamMatches(
  matches: Doc<"beerpongMatch">[],
  sourceId: Id<"beerpongMatch">,
) {
  const affected = new Set([sourceId]);
  let changed = true;
  while (changed) {
    changed = false;
    for (const match of matches) {
      if (affected.has(match._id)) continue;
      if ([match.slotA, match.slotB].some((slot) =>
        (slot.kind === "winner" || slot.kind === "loser") && affected.has(slot.matchId),
      )) {
        affected.add(match._id);
        changed = true;
      }
    }
  }
  return matches.filter((match) => match._id !== sourceId && affected.has(match._id));
}
