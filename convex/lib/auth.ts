import {
  createClient,
  type AuthFunctions,
  type GenericCtx,
} from "@convex-dev/better-auth";
import { convex } from "@convex-dev/better-auth/plugins";
import { betterAuth } from "better-auth";
import { bearer } from "better-auth/plugins";
import type { DataModel } from "../_generated/dataModel";
import { components, internal } from "../_generated/api";
import authConfig from "../auth.config";
import { deleteUserData } from "../user/deletion";

const authFunctions: AuthFunctions = internal.auth;

export const authComponent = createClient<DataModel>(components.betterAuth, {
  authFunctions,
  triggers: {
    user: {
      onDelete: async (ctx, authUser) => {
        await deleteUserData(ctx, authUser._id);
      },
    },
  },
});

export const createAuth = (ctx: GenericCtx<DataModel>) =>
  betterAuth({
    database: authComponent.adapter(ctx),
    secret: process.env["BETTER_AUTH_SECRET"],
    baseURL: process.env["CONVEX_SITE_URL"]!,
    user: { deleteUser: { enabled: true } },
    emailAndPassword: {
      enabled: true,
      requireEmailVerification: false,
    },
    plugins: [convex({ authConfig }), bearer()],
  });
