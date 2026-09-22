import { defineSchema } from "convex/server";
import { drinksTable } from "./drinks/schema";
import { usersTable } from "./users/schema";

export default defineSchema({
  users: usersTable,
  drinks: drinksTable,
});
