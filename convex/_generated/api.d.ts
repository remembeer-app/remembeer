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
import type * as beerpongTeam from "../beerpongTeam.js";
import type * as beerpongTeam_access from "../beerpongTeam/access.js";
import type * as beerpongTeam_constants from "../beerpongTeam/constants.js";
import type * as beerpongTeam_mutation from "../beerpongTeam/mutation.js";
import type * as beerpongTournament from "../beerpongTournament.js";
import type * as beerpongTournament_access from "../beerpongTournament/access.js";
import type * as beerpongTournament_bracket from "../beerpongTournament/bracket.js";
import type * as beerpongTournament_constants from "../beerpongTournament/constants.js";
import type * as beerpongTournament_mutation from "../beerpongTournament/mutation.js";
import type * as drink from "../drink.js";
import type * as drink_mutation from "../drink/mutation.js";
import type * as drink_query from "../drink/query.js";
import type * as drink_seed from "../drink/seed.js";
import type * as drink_seedData from "../drink/seedData.js";
import type * as drinkLog from "../drinkLog.js";
import type * as drinkLog_mutation from "../drinkLog/mutation.js";
import type * as drinkLog_query from "../drinkLog/query.js";
import type * as friendship from "../friendship.js";
import type * as friendship_mutation from "../friendship/mutation.js";
import type * as friendship_query from "../friendship/query.js";
import type * as friendship_relation from "../friendship/relation.js";
import type * as http from "../http.js";
import type * as leaderboard from "../leaderboard.js";
import type * as leaderboard_access from "../leaderboard/access.js";
import type * as leaderboard_constants from "../leaderboard/constants.js";
import type * as leaderboard_mutation from "../leaderboard/mutation.js";
import type * as leaderboard_query from "../leaderboard/query.js";
import type * as lib_auth from "../lib/auth.js";
import type * as lib_authenticated from "../lib/authenticated.js";
import type * as lib_builder from "../lib/builder.js";
import type * as lib_logicalDay from "../lib/logicalDay.js";
import type * as lib_timeZone from "../lib/timeZone.js";
import type * as party from "../party.js";
import type * as party_activity from "../party/activity.js";
import type * as party_constants from "../party/constants.js";
import type * as party_query from "../party/query.js";
import type * as party_scores from "../party/scores.js";
import type * as party_scoring from "../party/scoring.js";
import type * as partyChallenge from "../partyChallenge.js";
import type * as partyChallenge_access from "../partyChallenge/access.js";
import type * as partyChallenge_constants from "../partyChallenge/constants.js";
import type * as partyChallenge_lifecycle from "../partyChallenge/lifecycle.js";
import type * as partyChallenge_mutation from "../partyChallenge/mutation.js";
import type * as partyChallenge_query from "../partyChallenge/query.js";
import type * as partyChallenge_scheduled from "../partyChallenge/scheduled.js";
import type * as partyQuest from "../partyQuest.js";
import type * as partyQuest_catalog from "../partyQuest/catalog.js";
import type * as partyQuest_constants from "../partyQuest/constants.js";
import type * as partyQuest_context from "../partyQuest/context.js";
import type * as partyQuest_eligibility from "../partyQuest/eligibility.js";
import type * as partyQuest_lifecycle from "../partyQuest/lifecycle.js";
import type * as partyQuest_mutation from "../partyQuest/mutation.js";
import type * as partyQuest_query from "../partyQuest/query.js";
import type * as partyQuest_scheduled from "../partyQuest/scheduled.js";
import type * as session from "../session.js";
import type * as session_access from "../session/access.js";
import type * as session_constants from "../session/constants.js";
import type * as session_mutation from "../session/mutation.js";
import type * as session_query from "../session/query.js";
import type * as sessionMember from "../sessionMember.js";
import type * as sessionMember_constants from "../sessionMember/constants.js";
import type * as sessionMember_mutation from "../sessionMember/mutation.js";
import type * as sessionMember_query from "../sessionMember/query.js";
import type * as sessionMember_sessionIndex from "../sessionMember/sessionIndex.js";
import type * as user from "../user.js";
import type * as user_currentUser from "../user/currentUser.js";
import type * as user_deletion from "../user/deletion.js";
import type * as user_mutation from "../user/mutation.js";
import type * as user_publicProfile from "../user/publicProfile.js";
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
  beerpongTeam: typeof beerpongTeam;
  "beerpongTeam/access": typeof beerpongTeam_access;
  "beerpongTeam/constants": typeof beerpongTeam_constants;
  "beerpongTeam/mutation": typeof beerpongTeam_mutation;
  beerpongTournament: typeof beerpongTournament;
  "beerpongTournament/access": typeof beerpongTournament_access;
  "beerpongTournament/bracket": typeof beerpongTournament_bracket;
  "beerpongTournament/constants": typeof beerpongTournament_constants;
  "beerpongTournament/mutation": typeof beerpongTournament_mutation;
  drink: typeof drink;
  "drink/mutation": typeof drink_mutation;
  "drink/query": typeof drink_query;
  "drink/seed": typeof drink_seed;
  "drink/seedData": typeof drink_seedData;
  drinkLog: typeof drinkLog;
  "drinkLog/mutation": typeof drinkLog_mutation;
  "drinkLog/query": typeof drinkLog_query;
  friendship: typeof friendship;
  "friendship/mutation": typeof friendship_mutation;
  "friendship/query": typeof friendship_query;
  "friendship/relation": typeof friendship_relation;
  http: typeof http;
  leaderboard: typeof leaderboard;
  "leaderboard/access": typeof leaderboard_access;
  "leaderboard/constants": typeof leaderboard_constants;
  "leaderboard/mutation": typeof leaderboard_mutation;
  "leaderboard/query": typeof leaderboard_query;
  "lib/auth": typeof lib_auth;
  "lib/authenticated": typeof lib_authenticated;
  "lib/builder": typeof lib_builder;
  "lib/logicalDay": typeof lib_logicalDay;
  "lib/timeZone": typeof lib_timeZone;
  party: typeof party;
  "party/activity": typeof party_activity;
  "party/constants": typeof party_constants;
  "party/query": typeof party_query;
  "party/scores": typeof party_scores;
  "party/scoring": typeof party_scoring;
  partyChallenge: typeof partyChallenge;
  "partyChallenge/access": typeof partyChallenge_access;
  "partyChallenge/constants": typeof partyChallenge_constants;
  "partyChallenge/lifecycle": typeof partyChallenge_lifecycle;
  "partyChallenge/mutation": typeof partyChallenge_mutation;
  "partyChallenge/query": typeof partyChallenge_query;
  "partyChallenge/scheduled": typeof partyChallenge_scheduled;
  partyQuest: typeof partyQuest;
  "partyQuest/catalog": typeof partyQuest_catalog;
  "partyQuest/constants": typeof partyQuest_constants;
  "partyQuest/context": typeof partyQuest_context;
  "partyQuest/eligibility": typeof partyQuest_eligibility;
  "partyQuest/lifecycle": typeof partyQuest_lifecycle;
  "partyQuest/mutation": typeof partyQuest_mutation;
  "partyQuest/query": typeof partyQuest_query;
  "partyQuest/scheduled": typeof partyQuest_scheduled;
  session: typeof session;
  "session/access": typeof session_access;
  "session/constants": typeof session_constants;
  "session/mutation": typeof session_mutation;
  "session/query": typeof session_query;
  sessionMember: typeof sessionMember;
  "sessionMember/constants": typeof sessionMember_constants;
  "sessionMember/mutation": typeof sessionMember_mutation;
  "sessionMember/query": typeof sessionMember_query;
  "sessionMember/sessionIndex": typeof sessionMember_sessionIndex;
  user: typeof user;
  "user/currentUser": typeof user_currentUser;
  "user/deletion": typeof user_deletion;
  "user/mutation": typeof user_mutation;
  "user/publicProfile": typeof user_publicProfile;
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
