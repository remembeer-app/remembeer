import { getAuthConfigProvider } from "@convex-dev/better-auth/auth-config";
import type { AuthConfig } from "convex/server";

const jwks = process.env["JWKS"];

export default {
  providers: [getAuthConfigProvider(jwks ? { jwks } : {})],
} satisfies AuthConfig;
