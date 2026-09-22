import { defineSchema } from "convex/server";
import { drinksTable } from "./drinks/schema";
import { usersTable } from "./users/schema";

const schema = defineSchema({
  users: usersTable,
  drinks: drinksTable,
});

export default schema;
