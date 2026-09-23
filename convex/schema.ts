import { defineSchema } from "convex/server";
import { drinkTable } from "./drink/schema";
import { userTable } from "./user/schema";

export const schema = defineSchema({
  user: userTable,
  drink: drinkTable,
});

export default schema;
