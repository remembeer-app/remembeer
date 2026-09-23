/* eslint-disable */
/**
 * Generated `api` utility.
 *
 * THIS CODE IS AUTOMATICALLY GENERATED.
 *
 * To regenerate, run `npx convex dev`.
 * @module
 */

import type * as drink from "../drink.js";
import type * as drink_mutation from "../drink/mutation.js";
import type * as drink_query from "../drink/query.js";
import type * as http from "../http.js";
import type * as lib_auth from "../lib/auth.js";
import type * as lib_authenticated from "../lib/authenticated.js";
import type * as lib_builder from "../lib/builder.js";
import type * as user from "../user.js";
import type * as user_currentUser from "../user/currentUser.js";
import type * as user_mutation from "../user/mutation.js";

import type {
  ApiFromModules,
  FilterApi,
  FunctionReference,
} from "convex/server";

declare const fullApi: ApiFromModules<{
  drink: typeof drink;
  "drink/mutation": typeof drink_mutation;
  "drink/query": typeof drink_query;
  http: typeof http;
  "lib/auth": typeof lib_auth;
  "lib/authenticated": typeof lib_authenticated;
  "lib/builder": typeof lib_builder;
  user: typeof user;
  "user/currentUser": typeof user_currentUser;
  "user/mutation": typeof user_mutation;
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
