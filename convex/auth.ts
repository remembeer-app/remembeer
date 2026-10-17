import { v } from "convex/values";
import { internalAction } from "./_generated/server";
import { authComponent, createAuth } from "./lib/auth";

export const { onDelete } = authComponent.triggersApi();

// Static JWKS for deployments whose backend cannot fetch its own site URL
// (e.g. the k3d cluster, where *.localhost resolves to the pod itself).
// Store the result in the JWKS environment variable: npm run auth:jwks
// TODO: remove in prod deployment
export const getLatestJwks = internalAction({
  args: {},
  returns: v.string(),
  handler: async (ctx) => JSON.stringify(await createAuth(ctx).api.getLatestJwks()),
});
