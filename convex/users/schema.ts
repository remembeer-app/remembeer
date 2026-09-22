import { defineTable } from "convex/server";
import { v } from "convex/values";

export const usersTable = defineTable({
  authUserId: v.string(),
}).index("by_authUserId", ["authUserId"]);
