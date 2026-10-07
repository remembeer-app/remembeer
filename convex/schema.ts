import { defineSchema } from "convex/server";
import { badgeTable } from "./badge/schema";
import { drinkTable } from "./drink/schema";
import { sessionTable } from "./session/schema";
import { sessionMemberTable } from "./sessionMember/schema";
import { userTable } from "./user/schema";

export const schema = defineSchema({
  user: userTable,
  drink: drinkTable,
  badge: badgeTable,
  session: sessionTable,
  sessionMember: sessionMemberTable,
});

export default schema;
