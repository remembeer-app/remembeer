/* eslint-disable */
/**
 * Generated `api` utility.
 *
 * THIS CODE IS AUTOMATICALLY GENERATED.
 *
 * To regenerate, run `npx convex dev`.
 * @module
 */

import type * as auth from "../auth.js";
import type * as badge from "../badge.js";
import type * as badge_mutation from "../badge/mutation.js";
import type * as badge_query from "../badge/query.js";
import type * as drink from "../drink.js";
import type * as drink_mutation from "../drink/mutation.js";
import type * as drink_query from "../drink/query.js";
import type * as drink_seed from "../drink/seed.js";
import type * as drink_seedData from "../drink/seedData.js";
import type * as drinkLog from "../drinkLog.js";
import type * as drinkLog_mutation from "../drinkLog/mutation.js";
import type * as drinkLog_query from "../drinkLog/query.js";
import type * as http from "../http.js";
import type * as lib_auth from "../lib/auth.js";
import type * as lib_authenticated from "../lib/authenticated.js";
import type * as lib_builder from "../lib/builder.js";
import type * as lib_logicalDay from "../lib/logicalDay.js";
import type * as user from "../user.js";
import type * as user_constants from "../user/constants.js";
import type * as user_currentUser from "../user/currentUser.js";
import type * as user_deletion from "../user/deletion.js";
import type * as user_mutation from "../user/mutation.js";
import type * as user_query from "../user/query.js";

import type {
  ApiFromModules,
  FilterApi,
  FunctionReference,
} from "convex/server";

declare const fullApi: ApiFromModules<{
  auth: typeof auth;
  badge: typeof badge;
  "badge/mutation": typeof badge_mutation;
  "badge/query": typeof badge_query;
  drink: typeof drink;
  "drink/mutation": typeof drink_mutation;
  "drink/query": typeof drink_query;
  "drink/seed": typeof drink_seed;
  "drink/seedData": typeof drink_seedData;
  drinkLog: typeof drinkLog;
  "drinkLog/mutation": typeof drinkLog_mutation;
  "drinkLog/query": typeof drinkLog_query;
  http: typeof http;
  "lib/auth": typeof lib_auth;
  "lib/authenticated": typeof lib_authenticated;
  "lib/builder": typeof lib_builder;
  "lib/logicalDay": typeof lib_logicalDay;
  user: typeof user;
  "user/constants": typeof user_constants;
  "user/currentUser": typeof user_currentUser;
  "user/deletion": typeof user_deletion;
  "user/mutation": typeof user_mutation;
  "user/query": typeof user_query;
}>;

/**
 * A utility for referencing Convex functions in your app's public API.
 *
 * Usage:
 * ```js
 * const myFunctionReference = api.myModule.myFunction;
 * ```
 */
export declare const api: FilterApi<
  typeof fullApi,
  FunctionReference<any, "public">
>;

/**
 * A utility for referencing Convex functions in your app's internal API.
 *
 * Usage:
 * ```js
 * const myFunctionReference = internal.myModule.myFunction;
 * ```
 */
export declare const internal: FilterApi<
  typeof fullApi,
  FunctionReference<any, "internal">
>;

export declare const components: {
  betterAuth: import("@convex-dev/better-auth/_generated/component.js").ComponentApi<"betterAuth">;
};
