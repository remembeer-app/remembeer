import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";
import { fixture } from "../support/party_fixture.mjs";

const { outputFiles } = await build({
  stdin: { contents: `export { activity } from "./convex/party/activity";
    export { standings } from "./convex/party/query";`, resolveDir: process.cwd() },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "authenticated-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authQuery = createBuilder().query();', loader: "ts",
    }));
  } }],
});
const { activity, standings } = await import(`data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`);
function setup() {
  const f = fixture(standings);
  f.activity = async (args = {}, actor = "owner") => {
    const original = Date.now; Date.now = () => f.now;
    try { return await activity(f.ctx(actor), { sessionId: "party", ...args }); }
    finally { Date.now = original; }
  };
  return f;
}

test("access requires owner or joined membership of a non-deleted party; archives remain readable", async () => {
  const f = setup();
  assert.deepEqual(await f.activity(), { entries: [], users: [], nextCursor: null, hasMore: false });
  for (const actor of ["invited", "left", "banned", "other"])
    await assert.rejects(f.activity({}, actor), /permission/);
  await f.activity({}, "a");
  f.tables.sessionMember = f.tables.sessionMember.filter(m => m.userId !== "owner");
  f.tables.session[0].endedAt = f.now;
  await f.activity();
  f.tables.session[0].kind = "session";
  await assert.rejects(f.activity(), /party/);
  f.tables.session[0].deletedAt = f.now;
  await assert.rejects(f.activity(), /not found/);
  f.tables.session = [];
  await assert.rejects(f.activity(), /not found/);
});

test("page size defaults to 25 and only accepts integers 1–100", async () => {
  const f = setup();
  for (let i = 0; i < 101; i++) f.log("a");
  assert.equal((await f.activity()).entries.length, 25);
  for (const pageSize of [0, -1, 101, 1.5, NaN, Infinity])
    await assert.rejects(f.activity({ pageSize }), /integer/);
  assert.equal((await f.activity({ pageSize: 100 })).entries.length, 100);
});

test("timestamp ties paginate by descending stable ID without duplicates and cursors survive deletion", async () => {
  const f = setup();
  for (let i = 0; i < 12; i++) f.log("a", 500, "beer", { consumedAt: f.now - (i % 3) });
  f.quest("expired", [{ firstUserId: "a", secondUserId: "b", completedAt: f.now }]);
  const all = (await f.activity()).entries;
  const ids = [];
  let cursor;
  do {
    const page = await f.activity({ pageSize: 2, ...(cursor ? { cursor } : {}) });
    ids.push(...page.entries.map(e => e.id));
    assert.equal(page.hasMore, page.nextCursor !== null);
    cursor = page.nextCursor;
  } while (cursor);
  assert.deepEqual(ids, all.map(e => e.id));
  assert.equal(new Set(ids).size, ids.length);
  for (let i = 1; i < all.length; i++) {
    const a = all[i - 1], b = all[i];
    assert.ok(a.occurredAt > b.occurredAt || (a.occurredAt === b.occurredAt && a.id > b.id));
  }
  const first = await f.activity({ kinds: ["drinkLog"], pageSize: 1 });
  f.tables.drinkLog = f.tables.drinkLog.filter(l => l._id !== first.entries[0].drinkLogId);
  assert.ok((await f.activity({ cursor: first.nextCursor })).entries.every(e => e.id !== first.entries[0].id));
});

test("kind OR and participant OR filters combine with AND before pagination; empty arrays are unrestricted", async () => {
  const f = setup(); f.log("a"); f.log("b"); f.log("owner");
  f.quest("active", [{ firstUserId: "a", secondUserId: "b", completedAt: f.now }]);
  assert.equal((await f.activity({ kinds: [], participantIds: [] })).entries.length, 4);
  assert.equal((await f.activity({ kinds: ["drinkLog"], participantIds: ["a", "b"] })).entries.length, 2);
  assert.equal((await f.activity({ kinds: ["drinkLog", "socialQuest"], participantIds: ["b"] })).entries.length, 2);
  assert.equal((await f.activity({ kinds: ["socialQuest"], participantIds: ["a"] })).entries.length, 1);
  assert.deepEqual((await f.activity({ participantIds: ["other"] })).entries, []);
  const page = await f.activity({ kinds: ["drinkLog"], participantIds: ["a"], pageSize: 1 });
  assert.equal(page.entries[0].userId, "a");
  assert.equal(page.hasMore, false);
});

test("drinks share standings scores, retain former member classes and omit private fields; reads are cached", async () => {
  const f = setup(); f.log("a"); f.log("a", 125, "wine"); f.log("left"); f.log("banned");
  f.log("other"); f.log("unclassed");
  f.tables.user.find(u => u._id === "a").avatarStorageId = "avatar";
  f.tables.drinkLog[0].location = { latitude: 1, longitude: 2, accuracy: null };
  const page = await f.activity();
  const logs = id => page.entries.filter(e => e.userId === id);
  for (const id of ["a", "left", "banned"]) assert.equal(logs(id)[0].classBonusScoreUnits, id === "a" ? 0 : 2500);
  for (const id of ["other", "unclassed"]) assert.equal(logs(id)[0].classBonusScoreUnits, 0);
  assert.equal(f.reads.filter(r => r === "drink:beer").length, 1);
  assert.equal(f.reads.filter(r => r === "user:a").length, 1);
  assert.equal(page.users.find(u => u._id === "a").avatarUrl, "https://example.com/avatar");
  assert.ok(!JSON.stringify(page).includes("private-"));
  assert.ok(page.entries.every(e => !("location" in e)));
  const score = (await f.read()).entries.find(e => e.userId === "a");
  for (const key of ["scoreUnits", "baseDrinkScoreUnits", "classBonusScoreUnits", "alcoholMl", "volumeMl"])
    assert.equal(logs("a").reduce((sum, e) => sum + e[key], 0), score[key]);
});

test("activity follows drink edits, deletes, reassignment and current catalogue/class values", async () => {
  const f = setup(); f.log("a");
  const initial = (await f.activity()).entries[0];
  assert.equal(initial.scoreUnits, 27500);
  f.tables.drinkLog[0].volumeMl = 1000;
  f.tables.drinkLog[0].consumedAt--;
  let e = (await f.activity()).entries[0];
  assert.equal(e.id, initial.id); assert.equal(e.scoreUnits, 55000); assert.equal(e.occurredAt, f.now - 1);
  f.member("a").selectedClass = { kind: "wine" };
  assert.equal((await f.activity()).entries[0].scoreUnits, 50000);
  Object.assign(f.tables.drink[0], { name: "New wine", drinkCategory: { kind: "wine" }, alcoholPercentage: 10, deletedAt: f.now });
  e = (await f.activity()).entries[0];
  assert.equal(e.drinkName, "New wine"); assert.equal(e.scoreUnits, 110000);
  f.tables.drinkLog[0].sessionId = null;
  assert.equal((await f.activity()).entries.length, 0);
  f.tables.drinkLog[0].sessionId = "other";
  assert.equal((await f.activity()).entries.length, 0);
  f.tables.drinkLog[0].sessionId = "party";
  f.tables.drinkLog[0].deletedAt = f.now;
  assert.equal((await f.activity()).entries.length, 0);
  f.tables.drinkLog[0].deletedAt = null;
  f.tables.drinkLog[0].consumedAt = f.now + 1;
  assert.equal((await f.activity()).entries.length, 0);
});

test("one quest entry per canonical pair, per-participant reward, independent of expiry/cancellation/eligibility", async () => {
  const f = setup();
  for (const status of ["active", "expired", "cancelled"])
    f.quest(status, [{ firstUserId: "b", secondUserId: "a", completedAt: f.now - 5 },
      { firstUserId: "a", secondUserId: "b", completedAt: f.now - 5 },
      { firstUserId: "a", secondUserId: "left", completedAt: f.now - 4 }]);
  f.quest("active", []);
  f.tables.partyQuest.at(-1).selections = [{ userId: "a", selectedUserId: "owner", selectedAt: f.now }];
  f.member("a").selectedClass = null;
  const result = await f.activity();
  assert.equal(result.entries.length, 6);
  for (const e of result.entries) {
    assert.equal(e.kind, "socialQuest"); assert.equal(e.questTitle, "Toast");
    assert.equal(e.scoreUnits, 25000); assert.equal(e.firstUserId, "a");
    assert.equal(e.occurredAt, e.secondUserId === "b" ? f.now - 5 : f.now - 4);
  }
  assert.ok(!JSON.stringify(result).includes("selections"));
  assert.ok(!result.users.some(u => u._id === "owner"));
});

test("missing memberships/profiles and account deletion preserve surviving quest participant IDs", async () => {
  const f = setup(); f.log("a"); f.log("b");
  f.quest("expired", [{ firstUserId: "a", secondUserId: "b", completedAt: f.now }]);
  f.tables.sessionMember = f.tables.sessionMember.filter(m => m.userId !== "a");
  f.tables.user = f.tables.user.filter(u => u._id !== "a");
  let page = await f.activity();
  assert.equal(page.entries.find(e => e.kind === "drinkLog" && e.userId === "a").classBonusScoreUnits, 0);
  assert.ok(!page.users.some(u => u._id === "a"));
  // Account deletion removes owned logs but does not rewrite quest results.
  f.tables.drinkLog = f.tables.drinkLog.filter(l => l.userId !== "a");
  page = await f.activity();
  assert.equal(page.entries.length, 2);
  assert.deepEqual(page.entries.find(e => e.kind === "socialQuest").participantIds, ["a", "b"]);
});
