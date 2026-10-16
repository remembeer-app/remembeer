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
    try {
      const result = await activity(f.ctx(actor), {
        sessionId: "party", paginationOpts: { numItems: 25, cursor: null }, ...args,
      });
      // Flatten page-local profiles for existing scoring/privacy assertions.
      return { ...result, entries: result.page.map(item => item.entry),
        users: [...new Map(result.page.flatMap(item => item.users).map(user => [user._id, user])).values()] };
    }
    finally { Date.now = original; }
  };
  return f;
}

test("access requires owner or joined membership of a non-deleted party; archives remain readable", async () => {
  const f = setup();
  assert.deepEqual(await f.activity(), { page: [], entries: [], users: [], continueCursor: "", isDone: true });
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

test("page size accepts only integers 1–100", async () => {
  const f = setup();
  for (let i = 0; i < 101; i++) f.log("a");
  assert.equal((await f.activity()).entries.length, 25);
  for (const pageSize of [0, -1, 101, 1.5, NaN, Infinity])
    await assert.rejects(f.activity({ paginationOpts: { numItems: pageSize, cursor: null } }), /integer/);
  assert.equal((await f.activity({ paginationOpts: { numItems: 100, cursor: null } })).entries.length, 100);
});

test("timestamp ties paginate by descending stable ID without duplicates and cursors survive deletion", async () => {
  const f = setup();
  for (let i = 0; i < 12; i++) f.log("a", 500, "beer", { consumedAt: f.now - (i % 3) });
  f.quest("expired", [{ firstUserId: "a", secondUserId: "b", completedAt: f.now }]);
  const all = (await f.activity()).entries;
  const ids = [];
  let cursor = null;
  do {
    const page = await f.activity({ paginationOpts: { numItems: 2, cursor } });
    ids.push(...page.entries.map(e => e.id));
    assert.equal(page.isDone, page.continueCursor === "");
    cursor = page.continueCursor;
  } while (cursor);
  assert.deepEqual(ids, all.map(e => e.id));
  assert.equal(new Set(ids).size, ids.length);
  for (let i = 1; i < all.length; i++) {
    const a = all[i - 1], b = all[i];
    assert.ok(a.occurredAt > b.occurredAt || (a.occurredAt === b.occurredAt && a.id > b.id));
  }
  const first = await f.activity({ kinds: ["drinkLog"], paginationOpts: { numItems: 1, cursor: null } });
  f.tables.drinkLog = f.tables.drinkLog.filter(l => l._id !== first.entries[0].drinkLogId);
  assert.ok((await f.activity({ paginationOpts: { numItems: 25, cursor: first.continueCursor } })).entries.every(e => e.id !== first.entries[0].id));
});

test("kind OR and participant OR filters combine with AND before pagination; empty arrays are unrestricted", async () => {
  const f = setup(); f.log("a"); f.log("b"); f.log("owner");
  f.quest("active", [{ firstUserId: "a", secondUserId: "b", completedAt: f.now }]);
  assert.equal((await f.activity({ kinds: [], participantIds: [] })).entries.length, 4);
  assert.equal((await f.activity({ kinds: ["drinkLog"], participantIds: ["a", "b"] })).entries.length, 2);
  assert.equal((await f.activity({ kinds: ["drinkLog", "socialQuest"], participantIds: ["b"] })).entries.length, 2);
  assert.equal((await f.activity({ kinds: ["socialQuest"], participantIds: ["a"] })).entries.length, 1);
  assert.deepEqual((await f.activity({ participantIds: ["other"] })).entries, []);
  const page = await f.activity({ kinds: ["drinkLog"], participantIds: ["a"], paginationOpts: { numItems: 1, cursor: null } });
  assert.equal(page.entries[0].userId, "a");
  assert.equal(page.isDone, true);
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


test("split ranges stay adjacent during inserts, deletion and timestamp edits", async () => {
  const f = setup();
  for (let i = 0; i < 6; i++) f.log("a", 500, "beer", { consumedAt: f.now - i * 10 });
  const initial = await f.activity({ paginationOpts: { numItems: 3, cursor: null } });
  assert.equal(initial.pageStatus, "SplitRecommended");
  assert.ok(initial.splitCursor);
  const ranges = [
    { numItems: 3, cursor: null, endCursor: initial.splitCursor },
    { numItems: 3, cursor: initial.splitCursor, endCursor: initial.continueCursor },
    { numItems: 3, cursor: initial.continueCursor, endCursor: "" },
  ];
  const assertRanges = async () => {
    const pages = await Promise.all(ranges.map(paginationOpts => f.activity({ paginationOpts })));
    assert.ok(pages.every(page => page.pageStatus === undefined));
    assert.equal(pages[0].continueCursor, ranges[0].endCursor);
    assert.equal(pages[1].continueCursor, ranges[1].endCursor);
    const actual = pages.flatMap(page => page.entries);
    const all = (await f.activity()).entries;
    assert.deepEqual(actual, all);
    assert.equal(new Set(actual.map(entry => entry.id)).size, actual.length);
    assert.equal(pages.at(-1).isDone, true);
  };
  await assertRanges();
  f.log("b", 500, "beer", { consumedAt: f.now });
  f.log("b", 500, "beer", { consumedAt: f.now - 1000 });
  await assertRanges();
  f.tables.drinkLog[1].deletedAt = f.now;
  f.tables.drinkLog[4].consumedAt = f.now;
  await assertRanges();
});

test("activity rejects malformed cursors and supports a growing exhausted tail", async () => {
  const f = setup();
  for (const cursor of ["no-json", "null", "{}", '{"occurredAt":"now","id":"x"}'])
    await assert.rejects(f.activity({ paginationOpts: { numItems: 25, cursor } }), /Invalid activity cursor/);
  f.log("a");
  const first = await f.activity();
  assert.equal(first.continueCursor, "");
  assert.equal(first.isDone, true);
  const tail = { numItems: 25, cursor: first.splitCursor, endCursor: "" };
  assert.equal((await f.activity({ paginationOpts: tail })).entries.length, 0);
  f.log("b", 500, "beer", { consumedAt: f.now - 1 });
  const changed = await f.activity({ paginationOpts: tail });
  assert.equal(changed.entries.length, 1);
  assert.equal(changed.isDone, true);
  assert.equal(changed.continueCursor, "");
});
