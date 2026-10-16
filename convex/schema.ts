import { defineSchema } from "convex/server";
import { badgeTable } from "./badge/schema";
import { beerpongMatchTable } from "./beerpongMatch/schema";
import { beerpongTeamTable } from "./beerpongTeam/schema";
import { beerpongTournamentTable } from "./beerpongTournament/schema";
import { drinkTable } from "./drink/schema";
import { drinkLogTable } from "./drinkLog/schema";
import { friendshipTable } from "./friendship/schema";
import { sessionTable } from "./session/schema";
import { sessionMemberTable } from "./sessionMember/schema";
import { partyQuestTable } from "./partyQuest/schema";
import { partyChallengeTable } from "./partyChallenge/schema";
import { leaderboardTable } from "./leaderboard/schema";
import { leaderboardMemberTable } from "./leaderboardMember/schema";
import { userTable } from "./user/schema";

export const schema = defineSchema({
  user: userTable,
  leaderboard: leaderboardTable,
  leaderboardMember: leaderboardMemberTable,
  drink: drinkTable,
  drinkLog: drinkLogTable,
  badge: badgeTable,
  session: sessionTable,
  sessionMember: sessionMemberTable,
  partyQuest: partyQuestTable,
  partyChallenge: partyChallengeTable,
  beerpongTournament: beerpongTournamentTable,
  beerpongTeam: beerpongTeamTable,
  beerpongMatch: beerpongMatchTable,
  friendship: friendshipTable,
});

export default schema;
