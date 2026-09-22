/* eslint-disable */
/**
 * Generated `api` utility.
 *
 * THIS CODE IS AUTOMATICALLY GENERATED.
 *
 * To regenerate, run `npx convex dev`.
 * @module
 */

import type * as drinks from "../drinks.js";
import type * as drinks_crud from "../drinks/crud.js";
import type * as http from "../http.js";
import type * as lib_auth from "../lib/auth.js";
import type * as lib_authenticated from "../lib/authenticated.js";
import type * as lib_builder from "../lib/builder.js";
import type * as users from "../users.js";
import type * as users_crud from "../users/crud.js";
import type * as users_currentUser from "../users/currentUser.js";

import type {
  ApiFromModules,
  FilterApi,
  FunctionReference,
} from "convex/server";

declare const fullApi: ApiFromModules<{
  drinks: typeof drinks;
  "drinks/crud": typeof drinks_crud;
  http: typeof http;
  "lib/auth": typeof lib_auth;
  "lib/authenticated": typeof lib_authenticated;
  "lib/builder": typeof lib_builder;
  users: typeof users;
  "users/crud": typeof users_crud;
  "users/currentUser": typeof users_currentUser;
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
