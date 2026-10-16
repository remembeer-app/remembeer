import {
  loadTargetMember,
  requireTargetMember,
  requireCanModerateTarget,
  requireJoinedTargetPartyMember,
} from "../../convex/sessionMember/access";
import { loadDrink, requireDrinkOwner, requireUndeletedDrink } from "../../convex/drink/access";
import { loadQuest } from "../../convex/partyQuest/access";
import { requireSessionAccess } from "../../convex/session/access";
import { loadTournament, requireBeerpongEnabled } from "../../convex/beerpongTournament/access";
import type { RegisteredQuery, RegisteredMutation } from "convex/server";
import { v } from "convex/values";
import type { Id } from "../../convex/_generated/dataModel";
import { access } from "../../convex/lib/access";
import { authMutation, authQuery } from "../../convex/lib/authenticated";
import { requireOngoingParty, requireParty } from "../../convex/party/access";

const drinkAccess = access<{ id: Id<"drink"> }>()
  .use(loadDrink)
  .use(requireDrinkOwner)
  .use(requireUndeletedDrink)
  .use((ctx) => ({ ownerId: ctx.drink.ownerId }));

const query = authQuery
  .input({ id: v.id("drink") })
  .returns(v.string())
  .extend(drinkAccess.extend)
  .handler(async (ctx, input) => {
    const id: Id<"drink"> = input.id;
    const ownerId: Id<"user"> | null = ctx.ownerId;
    // @ts-expect-error Query context must not acquire database write access.
    ctx.db.patch("drink", id, {});
    // @ts-expect-error Input must retain its table-specific ID type.
    const sessionId: Id<"session"> = input.id;
    // @ts-expect-error Unloaded entities must not appear in handler context.
    ctx.session;

    return `${ctx.drink.name}:${ownerId}:${sessionId}`;
  });

const mutation = authMutation
  .input({ id: v.id("drink"), name: v.string() })
  .returns(v.null())
  .extend(drinkAccess.extend)
  .handler(async (ctx, input) => {
    await ctx.db.patch("drink", input.id, { name: input.name });

    return null;
  });

// Registered endpoints must retain their input and output contracts.
const registeredQuery = query.public();
const registeredMutation = mutation.public();
type QueryArgs =
  typeof registeredQuery extends RegisteredQuery<"public", infer TArgs, unknown> ? TArgs : never;
type MutationArgs =
  typeof registeredMutation extends RegisteredMutation<"public", infer TArgs, unknown>
    ? TArgs
    : never;
type QueryResult =
  typeof registeredQuery extends RegisteredQuery<"public", QueryArgs, infer TResult>
    ? Awaited<TResult>
    : never;
const publicQueryInput: QueryArgs = { id: "drink" as Id<"drink"> };
// @ts-expect-error Extra mutation input fields must remain required.
const publicMutationInput: MutationArgs = publicQueryInput;
const publicQueryOutput: QueryResult = "name";
// @ts-expect-error Returns must retain their validator-derived type.
const invalidQueryOutput: QueryResult = 123;

const loadedSession = access<{ id: Id<"session"> }>().use(async (ctx, { id }) => {
  const session = await ctx.db.get("session", id);
  if (!session) throw new Error("Missing session");

  return { session };
});

loadedSession
  .use(requireParty)
  .use(requireOngoingParty)
  .use((ctx) => {
    const kind: "party" = ctx.session.kind;
    const enabled: boolean = ctx.session.modules.beerpongEnabled;

    return { kind, enabled };
  });

// @ts-expect-error Party-only steps require the party narrowing step first.
loadedSession.use(requireOngoingParty);
// @ts-expect-error A step cannot access a resource before it has been loaded.
access<{ id: Id<"drink"> }>().use((ctx) => ({ drink: ctx.drink }));

const wrongInput = authQuery.input({ id: v.id("session") }).returns(v.string());
// @ts-expect-error The endpoint's input must satisfy the chain's input contract.
wrongInput.extend(drinkAccess.extend);

const checkedQuery = authQuery
  .input({ id: v.id("drink") })
  .returns(v.string())
  .extend(drinkAccess.extend);
// @ts-expect-error The chain must preserve handler return validation.
checkedQuery.handler(async () => 123);

void publicMutationInput;
void publicQueryOutput;
void invalidQueryOutput;

// Loaders preserve table-specific IDs, including explicit input adapters.
const questById = access<{ id: Id<"partyQuest"> }>()
  .use(loadQuest)
  .use((ctx) => requireSessionAccess(ctx, ctx.quest.sessionId, "joined"));
const questByQuestId = access<{ questId: Id<"partyQuest"> }>()
  .use((ctx, { questId }) => loadQuest(ctx, { id: questId }))
  .use((ctx) => requireSessionAccess(ctx, ctx.quest.sessionId, "joined"));
authQuery
  .input({ id: v.id("partyQuest") })
  .returns(v.string())
  // @ts-expect-error A questId chain must not accept an endpoint using only id.
  .extend(questByQuestId.extend);
authQuery
  .input({ id: v.id("drink") })
  .returns(v.string())
  // @ts-expect-error Quest references must retain their table-specific ID type.
  .extend(questById.extend);
// @ts-expect-error A loader must not accept the wrong input ID type.
access<{ id: Id<"drink"> }>().use(loadQuest);

access<{ id: Id<"beerpongTournament"> }>()
  .use(loadTournament)
  .use((ctx) => requireSessionAccess(ctx, ctx.tournament.sessionId, "admin"))
  .use(requireParty)
  .use(requireOngoingParty)
  .use(requireBeerpongEnabled)
  .use((ctx) => {
    const partyKind: "party" = ctx.session.kind;

    return { partyKind, tournamentName: ctx.tournament.name };
  });

// Object spreads replace fields; a replacement must not become an intersection.
const replacedValue = access<Record<never, never>>()
  .use(() => ({ value: 123, retained: true }))
  .use(() => ({ value: "replacement" }))
  .use((ctx) => {
    const value: string = ctx.value;
    const retained: boolean = ctx.retained;
    // @ts-expect-error The earlier numeric value has been replaced.
    const oldValue: number = ctx.value;
    // @ts-expect-error A valid replacement must not be inferred as never.
    const impossible: never = ctx.value;

    return { value, retained, oldValue, impossible };
  });

authQuery
  .input({})
  .returns(v.string())
  .extend(replacedValue.extend)
  .handler(async (ctx) => {
    // @ts-expect-error Replaced field types must also reach the final handler.
    const oldValue: number = ctx.value;

    return `${ctx.value}:${oldValue}`;
  });

// Steps cannot replace built-in authentication or Convex capabilities.
// @ts-expect-error Database context is reserved.
access<Record<never, never>>().use(() => ({ db: {} }));
// @ts-expect-error Even a type-compatible replacement of user is forbidden.
access<Record<never, never>>().use((ctx) => ({ user: ctx.user }));
// @ts-expect-error Auth user context is reserved.
access<Record<never, never>>().use((ctx) => ({ authUser: ctx.authUser }));
// @ts-expect-error Mutation capabilities are reserved even in a read-only step.
access<Record<never, never>>().use(() => ({ scheduler: {} }));
// @ts-expect-error Optional built-in replacements must also be rejected.
access<Record<never, never>>().use((): { db?: object } => ({}));
// @ts-expect-error Async steps must obey the same reserved-key constraint.
access<Record<never, never>>().use(async () => ({ runMutation: () => null }));

// Fields added by earlier builder middleware must follow replacement semantics.
const withLabel = authQuery.use(async (ctx, next) => next({ ...ctx, label: 123 }));
withLabel
  .input({})
  .returns(v.string())
  .extend(access<Record<never, never>>().use(() => ({ label: "replacement" })).extend)
  .handler(async (ctx) => {
    const label: string = ctx.label;
    // @ts-expect-error The access chain replaced the earlier middleware's label.
    const oldLabel: number = ctx.label;

    return `${label}:${oldLabel}`;
  });

// An optional replacement can be absent, leaving the previous value in place.
access<Record<never, never>>()
  .use(() => ({ value: 123 }))
  .use((): { value?: string } => ({}))
  .use((ctx) => {
    const value: number | string = ctx.value;
    // @ts-expect-error An absent optional replacement retains the number.
    const onlyString: string | undefined = ctx.value;

    return { value, onlyString };
  });

// Explicit undefined is a real replacement, unlike an absent optional field.
access<Record<never, never>>()
  .use(() => ({ value: 123 }))
  .use((): { value?: string | undefined } => ({ value: undefined }))
  .use((ctx) => {
    const value: number | string | undefined = ctx.value;
    // @ts-expect-error A present undefined value must remain in the inferred type.
    const defined: number | string = ctx.value;

    return { value, defined };
  });

// A step's union branches must not leave the previous field type on both sides.
access<Record<never, never>>()
  .use(() => ({ value: 123 }))
  .use((): { value: string; kind: "replaced" } | { kind: "retained" } => ({ kind: "retained" }))
  .use((ctx) => {
    if (ctx.kind === "replaced") {
      const value: string = ctx.value;
      // @ts-expect-error The replacement branch contains a string.
      const oldValue: number = ctx.value;

      return { value, oldValue };
    }

    const retained: number = ctx.value;

    return { retained };
  });

// Reserved fields cannot be hidden in just one branch or in a dictionary.
// @ts-expect-error Every return branch must respect the reserved context keys.
access<Record<never, never>>().use((): { safe: true } | { db: object } => ({ safe: true }));
// @ts-expect-error Arbitrary dictionary keys could overwrite the base context.
access<Record<never, never>>().use((): Record<string, unknown> => ({}));
// @ts-expect-error Existing context objects must not be returned as access additions.
access<Record<never, never>>().use((ctx) => ctx);

// Target guards narrow the target without changing the caller's membership.
const targetMemberAccess = access<{
  sessionId: Id<"session">;
  userId: Id<"user">;
}>()
  .use((ctx, { sessionId }) => requireSessionAccess(ctx, sessionId, "admin"))
  .use(loadTargetMember);
// @ts-expect-error The target may be missing until its existence is checked.
targetMemberAccess.use(requireCanModerateTarget);
// @ts-expect-error Target loading requires a loaded session and caller membership.
access<{ userId: Id<"user"> }>().use(loadTargetMember);

targetMemberAccess
  .use(requireTargetMember)
  .use(requireCanModerateTarget)
  .use(requireJoinedTargetPartyMember)
  .use((ctx) => {
    const targetId: Id<"sessionMember"> = ctx.targetMember._id;
    const kind: "partyMember" = ctx.targetMember.kind;
    const selectedClass = ctx.targetMember.selectedClass;
    // @ts-expect-error Proving the target exists does not prove the caller does.
    const callerId: Id<"sessionMember"> = ctx.member._id;

    return { targetId, kind, selectedClass, callerId };
  });
