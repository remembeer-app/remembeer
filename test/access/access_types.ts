import { customDrinkAccess } from "../../convex/drink/access";
import { sessionAccess } from "../../convex/session/access";
import { leaderboardAccess } from "../../convex/leaderboard/access";
import { editableTournamentAccess } from "../../convex/beerpongTournament/access";
import { editableTeamAccess } from "../../convex/beerpongTeam/access";
import { editableMatchAccess } from "../../convex/beerpongMatch/access";
import { editableChallengeAccess } from "../../convex/partyChallenge/access";
import type { RegisteredQuery, RegisteredMutation } from "convex/server";
import { v } from "convex/values";
import type { Id } from "../../convex/_generated/dataModel";
import { questAccess } from "../../convex/partyQuest/access";
import { access } from "../../convex/lib/access";
import { authMutation, authQuery } from "../../convex/lib/authenticated";
import { ongoingPartyAccess, partyAccess } from "../../convex/party/access";

const drinkAccess = access<{ id: Id<"drink"> }>()
  .use(async (ctx, input) => {
    const drink = await ctx.db.get("drink", input.id);
    if (!drink) throw new Error("Missing drink");

    return { drink };
  })
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
type QueryArgs = typeof registeredQuery extends RegisteredQuery<"public", infer TArgs, unknown> ? TArgs : never;
type MutationArgs = typeof registeredMutation extends RegisteredMutation<"public", infer TArgs, unknown> ? TArgs : never;
type QueryResult = typeof registeredQuery extends RegisteredQuery<"public", QueryArgs, infer TResult> ? Awaited<TResult> : never;
const publicQueryInput: QueryArgs = { id: "drink" as Id<"drink"> };
// @ts-expect-error Extra mutation input fields must remain required.
const publicMutationInput: MutationArgs = publicQueryInput;
const publicQueryOutput: QueryResult = "name";
// @ts-expect-error Returns must retain their validator-derived type.
const invalidQueryOutput: QueryResult = 123;

const loadedSession = access<{ id: Id<"session"> }>()
  .use(async (ctx, { id }) => {
    const session = await ctx.db.get("session", id);
    if (!session) throw new Error("Missing session");

    return { session };
  });

loadedSession
  .use(partyAccess)
  .use(ongoingPartyAccess)
  .use((ctx) => {
    const kind: "party" = ctx.session.kind;
    const enabled: boolean = ctx.session.modules.beerpongEnabled;

    return { kind, enabled };
  });

// @ts-expect-error Party-only steps require the party narrowing step first.
loadedSession.use(ongoingPartyAccess);
// @ts-expect-error A step cannot access a resource before it has been loaded.
access<{ id: Id<"drink"> }>().use((ctx) => ({ drink: ctx.drink }));

const wrongInput = authQuery
  .input({ id: v.id("session") })
  .returns(v.string());
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

// Quest chains support both endpoint ID names without weakening table types.
const questById = authQuery
  .input({ id: v.id("partyQuest") })
  .returns(v.string())
  .extend(questAccess("id").extend)
  .handler(async (ctx) => ctx.quest.title);
const questByQuestId = authQuery
  .input({ questId: v.id("partyQuest") })
  .returns(v.string())
  .extend(questAccess("questId").extend)
  .handler(async (ctx) => ctx.quest.title);
// @ts-expect-error A questId chain must not accept an endpoint using only id.
authQuery.input({ id: v.id("partyQuest") }).returns(v.string()).extend(questAccess("questId").extend);
// @ts-expect-error Quest references must retain their table-specific ID type.
authQuery.input({ id: v.id("drink") }).returns(v.string()).extend(questAccess("id").extend);
void questById;
void questByQuestId;

// Feature factories all return chains that can be extended before registration.
customDrinkAccess().use((ctx) => ({ drinkName: ctx.drink.name }));
sessionAccess("admin").use((ctx) => ({ sessionName: ctx.session.name }));
leaderboardAccess("owner").use((ctx) => ({ boardName: ctx.leaderboard.name }));
editableTeamAccess().use((ctx) => ({ teamName: ctx.team.name }));
editableMatchAccess().use((ctx) => ({ matchRound: ctx.match.round }));
editableChallengeAccess().use((ctx) => ({ challengeTitle: ctx.challenge.title }));
editableTournamentAccess().use((ctx) => {
  const partyKind: "party" = ctx.session.kind;

  return { partyKind, tournamentName: ctx.tournament.name };
});
