import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";
import { fixture as createFixture } from "../support/party_fixture.mjs";

const { outputFiles } = await build({
  stdin: { contents: `export { standings } from "./convex/party/query";
    export { loadQuestContext } from "./convex/partyQuest/context";`, resolveDir: process.cwd() },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "authenticated-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authQuery = createBuilder().query();', loader: "ts",
    }));
  } }],
});
const { standings, loadQuestContext } = await import(`data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`);

const fixture = () => createFixture(standings);

const entry = (result, id) => result.entries.find(e => e.userId === id);

test("standings require joined access to an existing non-deleted party, including archives", async () => {
  const f = fixture();
  for (const actor of ["invited", "left", "banned", "other"])
    await assert.rejects(f.read(actor), /permission/);
  assert.equal((await f.read("a")).entries.length, 4);
  f.tables.session[0].endedAt = f.now;
  assert.equal((await f.read("a")).entries.length, 4);
  f.tables.session[0].kind = "session";
  await assert.rejects(f.read(), /party/);
  f.tables.session[0].deletedAt = f.now;
  await assert.rejects(f.read(), /not found/);
  f.tables.session = [];
  await assert.rejects(f.read(), /not found/);
});

test("drink totals and point breakdowns include unclassed members and count logs, not servings", async () => {
  const f = fixture();
  f.log("a"); f.log("a", 125, "wine"); f.log("unclassed");
  const result = await f.read();
  assert.deepEqual(entry(result, "a"), {
    userId: "a", user: { _id: "a", username: "a", accentColor: "amber", avatarUrl: null }, selectedClass: { kind: "beer" },
    rank: 1, scoreUnits: 42500, baseDrinkScoreUnits: 40000, classBonusScoreUnits: 2500,
    questScoreUnits: 0, challengeScoreUnits: 0, beerpongScoreUnits: 0, wonChallengeCount: 0, completedQuestCount: 0, drinkCount: 2, volumeMl: 625, alcoholMl: 40,
  });
  assert.equal(entry(result, "unclassed").scoreUnits, 25000);
  assert.equal(entry(result, "unclassed").classBonusScoreUnits, 0);
  assert.equal(entry(result, "owner").drinkCount, 0);
  assert.equal(entry(result, "owner").rank, 3);
  assert.equal(entry(result, "b").rank, 3);
  assert.equal(f.reads.filter(r => r === "drink:beer").length, 1);
  assert.equal(f.reads.filter(r => r === "drink:wine").length, 1);
});

test("only live, due logs attached to this party and joined members affect totals", async () => {
  const f = fixture();
  f.log("a", 500, "beer", { consumedAt: f.now - 1 });
  f.log("a", 500, "beer", { deletedAt: f.now });
  f.log("a", 500, "beer", { sessionId: "different-party" });
  f.log("a", 500, "beer", { sessionId: null });
  f.log("a", 500, "beer", { consumedAt: f.now + 1 });
  f.log("a", 500, "beer", { consumedAt: f.now + 10 });
  for (const id of ["invited", "left", "banned", "other"]) f.log(id, 500, "missing", { consumedAt: f.now + 1 });
  f.log("b", 500, "missing", { deletedAt: f.now, consumedAt: f.now + 1 });
  const result = await f.read();
  assert.equal(entry(result, "a").drinkCount, 1);
  const refreshed = await f.read("a", f.now + 1);
  assert.equal(entry(refreshed, "a").drinkCount, 2);
});

test("edits, deletion, moving logs and catalogue/class changes recalculate scores", async () => {
  const f = fixture(); f.log("a");
  assert.equal(entry(await f.read(), "a").scoreUnits, 27500);
  f.tables.drinkLog[0].volumeMl = 1000;
  assert.equal(entry(await f.read(), "a").scoreUnits, 55000);
  f.member("a").selectedClass = { kind: "wine" };
  assert.equal(entry(await f.read(), "a").scoreUnits, 50000);
  f.tables.drink[0].drinkCategory = { kind: "wine" };
  f.tables.drink[0].alcoholPercentage = 10;
  f.tables.drink[0].deletedAt = f.now;
  assert.equal(entry(await f.read(), "a").scoreUnits, 110000);
  f.tables.drinkLog[0].sessionId = null;
  assert.equal(entry(await f.read(), "a").scoreUnits, 0);
  f.tables.drinkLog[0].sessionId = "party";
  f.tables.drinkLog[0].deletedAt = f.now;
  assert.equal(entry(await f.read(), "a").drinkCount, 0);
});

test("quest rewards count recorded completions per member and survive expiry, cancellation and lost eligibility", async () => {
  const f = fixture();
  for (const status of ["active", "expired", "cancelled"])
    f.quest(status, [{ firstUserId: "a", secondUserId: "b", completedAt: f.now }]);
  f.quest("expired", []);
  f.tables.partyQuest.push({ ...f.tables.partyQuest[0], _id: "other-quest", sessionId: "other" });
  f.member("b").selectedClass = null;
  const result = await f.read();
  for (const id of ["a", "b"]) {
    assert.equal(entry(result, id).questScoreUnits, 75000);
    assert.equal(entry(result, id).completedQuestCount, 3);
    assert.equal(entry(result, id).scoreUnits, 75000);
    assert.equal(entry(result, id).rank, 1);
  }
  assert.equal(entry(result, "owner").rank, 3);
  f.member("b").sessionMemberStatus.kind = "left";
  assert.equal(entry(await f.read(), "a").questScoreUnits, 75000);
  assert.equal(entry(await f.read(), "b"), undefined);
});

test("rank ties use case-insensitive username, exact username, then ID; profiles expose only public fields", async () => {
  const f = fixture();
  for (const user of f.tables.user) user.username = "Alice";
  f.tables.user.find(u => u._id === "a").username = "alice";
  f.tables.user.find(u => u._id === "b").avatarStorageId = "avatar";
  const result = await f.read();
  assert.deepEqual(result.entries.map(e => e.userId), ["a", "b", "owner", "unclassed"]);
  assert.ok(result.entries.every(e => e.rank === 1));
  assert.equal(entry(result, "b").user.avatarUrl, "https://example.com/avatar");
  assert.ok(result.entries.every(e => !JSON.stringify(e).includes("private-")));
});

test("missing user profiles retain scores, missing drinks fail explicitly, and score overflow is rejected", async () => {
  const f = fixture(); f.log("a");
  f.tables.user = f.tables.user.filter(u => u._id !== "a");
  const result = await f.read();
  assert.equal(entry(result, "a").user, null);
  assert.equal(entry(result, "a").scoreUnits, 27500);
  f.tables.drink = [];
  await assert.rejects(f.read(), /logged drink is missing/);
  const g = fixture();
  g.log("a", Number.MAX_SAFE_INTEGER / 100); g.log("a", Number.MAX_SAFE_INTEGER / 100);
  await assert.rejects(g.read(), /supported range/);
});

test("standings and completion context share scores, keeping unclassed members out of quest ranks", async () => {
  const f = fixture(); f.log("a"); f.log("b", 100); f.log("unclassed", 1000);
  f.quest("expired", [{ firstUserId: "a", secondUserId: "owner", completedAt: f.now }]);
  const result = await f.read();
  const context = await loadQuestContext(f.ctx("owner"), "party", f.now);
  assert.deepEqual(context.players.map(p => p.userId).sort(), ["a", "b", "owner"]);
  for (const player of context.players) assert.equal(player.scoreUnits, entry(result, player.userId).scoreUnits);
  assert.equal(context.previousPairs.size, 1);
});

test("fractional drinks round base and bonus separately and alcohol-free logs still count", async () => {
  const f = fixture();
  f.tables.drink[0].alcoholPercentage = 5.05;
  f.log("a", 1);
  f.tables.drink.push({ _id: "zero", drinkCategory: { kind: "beer" }, alcoholPercentage: 0 });
  f.log("a", 500, "zero");
  const a = entry(await f.read(), "a");
  assert.equal(a.baseDrinkScoreUnits, 51);
  assert.equal(a.classBonusScoreUnits, 5);
  assert.equal(a.scoreUnits, 56);
  assert.ok(Math.abs(a.alcoholMl - 0.0505) < 1e-12);
  assert.equal(a.drinkCount, 2);
});
