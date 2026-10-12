import { defineSchema } from "convex/server";
import { badgeTable } from "./badge/schema";
import { drinkTable } from "./drink/schema";
import { drinkLogTable } from "./drinkLog/schema";
import { friendshipTable } from "./friendship/schema";
import { sessionTable } from "./session/schema";
import { sessionMemberTable } from "./sessionMember/schema";
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
  friendship: friendshipTable,
});

export default schema;
