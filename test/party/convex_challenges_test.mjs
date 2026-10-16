import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";
import { fixture } from "../support/party_fixture.mjs";
import { questScheduler } from "../support/quest_scheduler.mjs";

const { outputFiles } = await build({
  stdin: { contents: `export * as m from "./convex/partyChallenge/mutation";
    export * as q from "./convex/partyChallenge/query";
    export * as scheduled from "./convex/partyChallenge";
    export * as sessions from "./convex/session/mutation";
    export { standings } from "./convex/party/query";
    export { activity } from "./convex/party/activity";
    export { loadQuestContext } from "./convex/partyQuest/context";`, resolveDir: process.cwd() },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "authenticated-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authQuery = createBuilder().query(); export const authMutation = createBuilder().mutation();', loader: "ts",
    }));
  } }],
});
const { m, q, scheduled, sessions, standings, activity, loadQuestContext } = await import(
  `data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`,
);

function setup() {
  const f = fixture(standings);
  const clock = questScheduler();
  const db = f.ctx("owner").db;
  db.insert = async (table, fields) => {
    const id = `${table}-${f.tables[table].length}`;
    f.tables[table].push({ _id: id, _creationTime: f.now, ...structuredClone(fields) });
    return id;
  };
  db.patch = async (table, id, fields) => {
    const row = f.tables[table].find(row => row._id === id);
    assert.ok(row); Object.assign(row, structuredClone(fields));
  };
  const originalQuery = db.query;
  db.query = table => {
    const query = originalQuery(table);
    const collect = query.collect;
    let descending = false;
    query.order = direction => { descending = direction === "desc"; return query; };
    query.collect = async () => { const rows = await collect(); return descending ? rows.reverse() : rows; };
    return query;
  };
  Object.assign(f.tables.session[0], {
    startedAt: 0,
    modules: { socialQuestsEnabled: false, partyChallengesEnabled: true, beerpongEnabled: false },
    questSchedule: { scheduledFunctionId: null, nextQuestAt: null },
  });
  f.member("b").sessionMemberRole.kind = "admin";
  const ctx = actor => ({ ...f.ctx(actor), scheduler: clock.scheduler });
  const run = async (handler, args, actor = "owner", at = f.now) => {
    const original = Date.now; Date.now = () => at;
    try { return await handler(ctx(actor), args); } finally { Date.now = original; }
  };
  const create = (extra = {}, actor = "owner", at = f.now) => run(m.create, {
    sessionId: "party", title: "  Dance  ", instructions: "  Dance together  ", pointsUnits: 10000, durationMinutes: 5, ...extra,
  }, actor, at);
  return { ...f, ...clock, ctx, run, create };
}

test("challenge reads and writes enforce party access, admins, and ended/deleted state", async () => {
  const f = setup(); const id = await f.create();
  for (const actor of ["invited", "left", "banned", "other"]) {
    await assert.rejects(f.run(q.get, { id }, actor), /permission/);
    await assert.rejects(f.run(q.listForSession, { sessionId: "party" }, actor), /permission/);
  }
  const writes = [
    [m.update, { id, title: "Changed" }], [m.addWinner, { id, userId: "a" }],
    [m.removeWinner, { id, userId: "a" }], [m.complete, { id }], [m.cancel, { id }],
    [m.setEnabled, { sessionId: "party", enabled: false }],
  ];
  await assert.rejects(f.create({}, "a"), /permission/);
  for (const [handler, args] of writes) await assert.rejects(f.run(handler, args, "a"), /permission/);
  assert.equal((await f.run(q.get, { id }, "a")).title, "Dance");
  await f.run(m.update, { id, title: "Admin edit" }, "b");
  f.tables.session[0].endedAt = f.now;
  for (const [handler, args] of writes) await assert.rejects(f.run(handler, args), /read-only/);
  await assert.rejects(f.create(), /read-only/);
  assert.equal((await f.run(q.get, { id })).status, "cancelled");
  f.tables.session[0].deletedAt = f.now;
  await assert.rejects(f.run(q.get, { id }), /not found/);
});

test("creation validates input, requires enabled module and permits only one live challenge", async () => {
  const f = setup();
  for (const extra of [
    { title: " " }, { title: "x".repeat(121) }, { instructions: " " }, { instructions: "x".repeat(1001) },
    { pointsUnits: 999 }, { pointsUnits: 500001 }, { pointsUnits: 1000.5 },
    { durationMinutes: 0 }, { durationMinutes: 61 }, { durationMinutes: 1.5 },
  ]) await assert.rejects(f.create(extra));
  f.tables.session[0].modules.partyChallengesEnabled = false;
  await assert.rejects(f.create(), /disabled/);
  await f.run(m.setEnabled, { sessionId: "party", enabled: true });
  const id = await f.create();
  assert.equal(f.jobs[0].name, "partyChallenge:expire");
  await assert.rejects(f.create(), /already active/);
  const endsAt = f.tables.partyChallenge[0].endsAt;
  const next = await f.create({ title: "Next" }, "owner", endsAt);
  assert.equal(f.tables.partyChallenge[0].status, "expired");
  assert.equal((await f.run(q.get, { id })).status, "expired");
  assert.deepEqual((await f.run(q.listForSession, { sessionId: "party" })).map(c => c._id), [next, id]);
});

test("winner changes and point/title edits update standings, quest ranks, activity, filters and pagination", async () => {
  const f = setup(); const id = await f.create();
  for (const userId of ["invited", "left", "banned", "other", "missing"])
    await assert.rejects(f.run(m.addWinner, { id, userId }), /joined party member/);
  await f.run(m.addWinner, { id, userId: "a" });
  await f.run(m.addWinner, { id, userId: "a" });
  await f.run(m.addWinner, { id, userId: "unclassed" });
  assert.equal(f.tables.partyChallenge[0].winners.length, 2);
  const row = async () => (await f.read()).entries.find(e => e.userId === "a");
  assert.equal((await row()).challengeScoreUnits, 10000);
  assert.equal((await row()).wonChallengeCount, 1);
  await f.run(m.update, { id, title: "New title", pointsUnits: 20000 });
  assert.equal((await row()).scoreUnits, 20000);
  const context = await f.run((ctx) => loadQuestContext(ctx, "party", f.now), {});
  assert.equal(context.players.find(p => p.userId === "a").scoreUnits, 20000);
  const readActivity = (args = {}) => f.run(activity, {
    sessionId: "party", paginationOpts: { numItems: 25, cursor: null }, ...args,
  });
  const page = await readActivity({ kinds: ["partyChallenge"], paginationOpts: { numItems: 1, cursor: null } });
  assert.equal(page.page[0].entry.challengeTitle, "New title");
  assert.equal(page.page[0].entry.scoreUnits, 20000);
  assert.equal(page.isDone, false);
  const next = await readActivity({ paginationOpts: { numItems: 1, cursor: page.continueCursor } });
  assert.equal(next.page.length, 1); assert.notEqual(next.page[0].entry.id, page.page[0].entry.id);
  assert.equal((await readActivity({ participantIds: ["a"] })).page.length, 1);
  assert.equal((await readActivity({ kinds: ["drinkLog"] })).page.length, 0);
  await f.run(m.removeWinner, { id, userId: "a" });
  await f.run(m.removeWinner, { id, userId: "a" });
  assert.equal((await row()).scoreUnits, 0);
  assert.equal((await readActivity({ participantIds: ["a"] })).page.length, 0);
  await f.run(m.addWinner, { id, userId: "a" });
  assert.equal((await row()).scoreUnits, 20000);
  f.member("a").sessionMemberStatus.kind = "left";
  await f.run(m.removeWinner, { id, userId: "a" });
});

test("expiry follows edited deadlines and stale/early jobs cannot close challenges", async () => {
  const f = setup(); const id = await f.create(); const original = f.jobs[0];
  await f.run(m.update, { id, durationMinutes: 10 });
  const updated = f.jobs[1];
  await f.execute(original, f.ctx("owner"), scheduled);
  assert.equal(f.tables.partyChallenge[0].status, "active");
  await f.run(scheduled.expire._handler, updated.args, "owner", updated.at - 1);
  assert.equal(f.tables.partyChallenge[0].status, "active");
  assert.equal((await f.run(q.get, { id }, "a", updated.at)).status, "expired");
  await assert.rejects(f.run(m.complete, { id }, "owner", updated.at), /not active/);
  await f.execute(updated, f.ctx("owner"), scheduled);
  assert.equal(f.tables.partyChallenge[0].status, "expired");
  await f.run(m.update, { id, pointsUnits: 30000 });
  await f.run(m.addWinner, { id, userId: "a" });
  await assert.rejects(f.run(m.update, { id, durationMinutes: 20 }), /Only an active/);
  assert.equal((await f.read()).entries.find(e => e.userId === "a").scoreUnits, 30000);
});

test("completion, cancellation and disabling retain awards and allow corrections", async () => {
  for (const action of [m.complete, m.cancel, null]) {
    const f = setup(); const id = await f.create();
    await f.run(m.addWinner, { id, userId: "a" });
    if (action) { await f.run(action, { id }); await f.run(action, { id }); }
    else await f.run(m.setEnabled, { sessionId: "party", enabled: false });
    await f.execute(f.jobs[0], f.ctx("owner"), scheduled);
    assert.equal(f.tables.partyChallenge[0].status, action === m.complete ? "completed" : "cancelled");
    assert.equal((await f.read()).entries.find(e => e.userId === "a").scoreUnits, 10000);
    await f.run(m.removeWinner, { id, userId: "a" });
    assert.equal((await f.read()).entries.find(e => e.userId === "a").scoreUnits, 0);
  }
});

test("ending or deleting a party closes challenges, preserves awards, and prevents later edits", async () => {
  for (const deleted of [false, true]) {
    const f = setup(); const id = await f.create();
    await f.run(m.addWinner, { id, userId: "a" });
    if (deleted) await f.run(sessions.softDelete, { id: "party" });
    else await f.run(sessions.update, { id: "party", endedAt: f.now });
    assert.equal(f.tables.partyChallenge[0].status, "cancelled");
    await f.execute(f.jobs[0], f.ctx("owner"), scheduled);
    assert.equal(f.tables.partyChallenge[0].status, "cancelled");
    await assert.rejects(f.run(m.update, { id, title: "Forbidden" }), deleted ? /not found/ : /read-only/);
    if (!deleted) assert.equal((await f.read()).entries.find(e => e.userId === "a").scoreUnits, 10000);
  }
});

test("missing challenges, ordinary sessions, cross-party access, and invalid edits are rejected", async () => {
  const f = setup();
  await assert.rejects(f.run(q.get, { id: "missing" }), /not found/);
  const id = await f.create();
  await assert.rejects(f.run(m.update, { id, pointsUnits: -1 }));
  await assert.rejects(f.run(m.update, { id, durationMinutes: 1 }, "owner", f.now + 60000), /deadline/);
  f.tables.session[0].kind = "session";
  await assert.rejects(f.run(q.get, { id }), /party/);
  await assert.rejects(f.create(), /party/);
  f.tables.session[0].kind = "party";
  f.tables.session.push({ ...f.tables.session[0], _id: "private", ownerId: "other" });
  f.tables.partyChallenge[0].sessionId = "private";
  await assert.rejects(f.run(q.get, { id }, "a"), /permission/);
  assert.equal((await f.run(q.listForSession, { sessionId: "party" })).length, 0);
});
