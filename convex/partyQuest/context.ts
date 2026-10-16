import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { loadPartyScores } from "../party/scores";
import { maxQuestPlayers } from "./constants";
import { memberPair, type QuestPlayer } from "./eligibility";

export async function loadQuestContext(
  ctx: AuthQueryCtx,
  sessionId: Id<"session">,
  now: number,
) {
  const { entries, quests } = await loadPartyScores(ctx, sessionId, now);
  const players: QuestPlayer[] = entries.flatMap(
    ({ member, user, scoreUnits }) =>
      member.selectedClass !== null && user
        ? [
            {
              userId: user._id,
              username: user.username,
              selectedClass: member.selectedClass.kind,
              accentColor: user.accentColor,
              scoreUnits,
              // shortcut: beerpong quests stay unavailable until Convex tournament data exists.
              beerpongTeamId: null,
            },
          ]
        : [],
  );
  if (players.length > maxQuestPlayers)
    throw new ConvexError(`Quests support at most ${maxQuestPlayers} players`);
  const previousPairs = new Set<string>();
  for (const quest of quests) {
    for (const result of quest.results) {
      previousPairs.add(
        JSON.stringify(memberPair(result.firstUserId, result.secondUserId)),
      );
    }
  }
  return { players, previousPairs, quests };
}
