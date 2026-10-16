import { questScheduler } from "../support/quest_scheduler.mjs";
import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import test from "node:test";
import { build } from "esbuild";

const { outputFiles } = await build({
  stdin: { contents: `export * as mutations from "./convex/partyQuest/mutation";
    export * as scheduled from "./convex/partyQuest";
    export * as sessions from "./convex/session/mutation";
    export { deleteUserData } from "./convex/user/deletion";
    export * as queries from "./convex/partyQuest/query";
    export { builtInQuests } from "./convex/partyQuest/catalog";
    export { drinkScoreUnits } from "./convex/party/scoring";
    export { eligiblePairs, memberPair } from "./convex/partyQuest/eligibility";`, resolveDir: process.cwd() },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "authenticated-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authQuery = createBuilder().query(); export const authMutation = createBuilder().mutation();', loader: "ts",
    }));
  } }],
});
const { mutations: m, queries: q, scheduled, sessions, deleteUserData, builtInQuests, eligiblePairs, drinkScoreUnits, memberPair } = await import(
  `data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`,
);

function fixture() {
  const now = Date.now();
  const tables = {
    user: ["owner", "admin", "a", "b", "c", "invitee", "other"].map(_id => ({ _id, username: _id, accentColor: "amber", authUserId: `auth-${_id}` })),
    session: [{ _id: "party", kind: "party", ownerId: "owner", deletedAt: null, endedAt: null,
      modules: { socialQuestsEnabled: false, partyChallengesEnabled: false, beerpongEnabled: false },
      questSchedule: { minIntervalMinutes: 15, maxIntervalMinutes: 45, defaultDurationMinutes: 15, nextQuestAt: null, scheduledFunctionId: null } }],
    sessionMember: ["owner", "admin", "a", "b", "c", "invitee"].map(userId => ({
      _id: `member-${userId}`, sessionId: "party", userId, kind: "partyMember",
      sessionMemberStatus: { kind: userId === "invitee" ? "invited" : "joined" },
      sessionMemberRole: { kind: ["owner", "admin"].includes(userId) ? "admin" : "member" },
      selectedClass: ["a", "b", "c"].includes(userId) ? { kind: "beer" } : null,
      beerpongOptIn: false,
    })),
    partyChallenge: [], partyQuest: [], drinkLog: [], drink: [], friendship: [], leaderboard: [], leaderboardMember: [], badge: [],
    beerpongTournament: [], beerpongTeam: [], beerpongMatch: [],
  };
  const reads = [];
  const clock = questScheduler();
  const ctx = userId => ({ user: tables.user.find(user => user._id === userId), db, scheduler: clock.scheduler });
  const db = {
    async delete(table, id) { tables[table] = tables[table].filter(row => row._id !== id); },
    async get(table, id) { reads.push(`${table}:${id}`); return structuredClone(tables[table].find(row => row._id === id) ?? null); },
    async insert(table, fields) { const id = `${table}-${tables[table].length}`; tables[table].push({ _id: id, _creationTime: now, ...structuredClone(fields) }); return id; },
    async patch(table, id, fields) { const row = tables[table].find(row => row._id === id); assert.ok(row); Object.assign(row, structuredClone(fields)); },
    query(table) {
      let rows = tables[table];
      return {
        withIndex(name, range) {
          const at = (row, field) => field.split(".").reduce((value, key) => value?.[key], row);
          const index = { eq(field, value) { rows = rows.filter(row => at(row, field) === value); return index; } };
          range(index);
          if (name === "by_sessionId_and_startsAt") rows = [...rows].sort((a, b) => a.startsAt - b.startsAt || a._creationTime - b._creationTime);
          return this;
        },
        order(direction) { if (direction === "desc") rows = [...rows].reverse(); return this; },
        async first() { return structuredClone(rows[0] ?? null); },
        async collect() { return structuredClone(rows); },
        async unique() { assert.ok(rows.length <= 1); return structuredClone(rows[0] ?? null); },
      };
    },
  };
  const enable = (random = 0.51) => withRandom(random, () => m.setEnabled(ctx("owner"), { sessionId: "party", enabled: true }));
  const start = () => m.startNext(ctx("owner"), { sessionId: "party" });
  const select = (questId, actor, partner) => m.selectPartner(ctx(actor), { questId, selectedUserId: partner });
  const player = id => tables.sessionMember.find(member => member.userId === id);
  return { tables, ctx, db, reads, enable, start, select, player, ...clock, run: (job, at) => clock.execute(job, ctx("owner"), scheduled, at) };
}

async function withRandom(value, action) {
  const original = Math.random;
  Math.random = () => value;
  try { return await action(); } finally { Math.random = original; }
}

test("all built-in pair rules match the existing eligibility engine, including tied rankings", () => {
  const players = Array.from({ length: 8 }, (_, i) => ({
    userId: String.fromCharCode(97 + i), username: `Player ${i}`,
    selectedClass: i % 2 ? "wine" : "beer", accentColor: i % 3 ? "amber" : "rose",
    scoreUnits: [100, 100, 80, 70, 60, 50, 40, 30][i], beerpongTeamId: i < 4 ? "team-a" : "team-b",
  }));
  const previous = new Set([JSON.stringify(memberPair("a", "b"))]);
  const legacy = JSON.parse(execFileSync("python3", ["-c", `
import json, sys
from party_quest_catalog import BUILT_IN_QUEST_CATALOG
from party_quest_eligibility import QuestMember, build_eligibility_context, is_eligible_pair, canonical_pair_key
players = [QuestMember(user_id=p["userId"], username=p["username"], score_units=p["scoreUnits"],
    is_active=True, selected_class=p["selectedClass"], accent_color_key=p["accentColor"],
    beerpong_team_id=p["beerpongTeamId"]) for p in json.loads(sys.argv[1])]
context = build_eligibility_context(players, completed_pair_keys={canonical_pair_key("a", "b")}, finalist_team_ids={"team-b"})
print(json.dumps([[dict(firstUserId=a.user_id, secondUserId=b.user_id)
    for i, a in enumerate(players) for b in players[i+1:]
    if is_eligible_pair(quest.eligibility_rule, a, b, context)] for quest in BUILT_IN_QUEST_CATALOG]))`, JSON.stringify(players)], { cwd: "functions", encoding: "utf8" }));
  builtInQuests.forEach((definition, index) => {
    assert.deepEqual(eligiblePairs(definition, players, previous, new Set(["team-b"])), legacy[index], definition.kind);
  });
  assert.deepEqual(memberPair("b", "a"), memberPair("a", "b"));
});

test("drink points use integer rewards and a retroactive matching-class bonus", () => {
  assert.equal(drinkScoreUnits(500, 5, false), 25000);
  assert.equal(drinkScoreUnits(500, 5, true), 27500);
  assert.equal(drinkScoreUnits(1, 5.05, true), 56);
  assert.throws(() => drinkScoreUnits(Infinity, 5, true), /supported range/);
});

test("admins enable and issue a single quest with server-owned snapshots", async () => {
  const f = fixture();
  await assert.rejects(f.start(), /disabled/);
  for (const actor of ["a", "invitee", "other"]) {
    await assert.rejects(m.setEnabled(f.ctx(actor), { sessionId: "party", enabled: true }), /permission/);
    await assert.rejects(m.startNext(f.ctx(actor), { sessionId: "party" }), /permission/);
  }
  await f.enable();
  const id = await withRandom(0, () => m.startNext(f.ctx("admin"), { sessionId: "party" }));
  const quest = f.tables.partyQuest[0];
  assert.equal(quest._id, id);
  assert.equal(quest.kind, "sameAccent");
  assert.equal("eligibleMemberIds" in quest, false);
  assert.equal("eligiblePairs" in quest, false);
  assert.equal(quest.endsAt - quest.startsAt, 15 * 60000);
  assert.deepEqual(quest.results, []);
  assert.deepEqual(quest.selections, []);
  assert.equal("availability" in quest, false);
  assert.equal(await f.start(), id);
  assert.equal(f.tables.partyQuest.length, 1);
});

test("pending selections are private and mutual selection records one immutable pair", async () => {
  const f = fixture(); await f.enable();
  const id = await withRandom(0, f.start);
  assert.equal(await f.select(id, "a", "b"), false);
  assert.equal((await q.get(f.ctx("b"), { id })).selections.length, 0);
  assert.equal((await q.get(f.ctx("owner"), { id })).selections.length, 0);
  assert.equal((await q.get(f.ctx("a"), { id })).selections[0].selectedUserId, "b");
  assert.equal(await f.select(id, "a", "c"), false);
  assert.equal(await f.select(id, "a", "b"), false);
  assert.equal(f.tables.partyQuest[0].selections.length, 1);
  assert.equal(await f.select(id, "b", "a"), true);
  const completed = structuredClone(f.tables.partyQuest[0]);
  assert.equal(completed.results.length, 1);
  assert.equal(completed.results[0].firstUserId, "a");
  assert.equal(completed.results[0].secondUserId, "b");
  assert.ok(completed.results[0].completedAt >= completed.startsAt);
  assert.equal(await f.select(id, "a", "b"), true);
  assert.equal(await f.select(id, "b", "a"), true);
  assert.deepEqual(f.tables.partyQuest[0], completed);
  await assert.rejects(f.select(id, "a", "c"), /already completed/);
  await assert.rejects(f.select(id, "c", "b"), /already completed/);
  const listed = await q.listForSession(f.ctx("a"), { sessionId: "party" });
  assert.equal(listed[0].results.length, 1);
  assert.deepEqual(listed[0].selections.map(selection => selection.userId), ["a"]);
});

test("class eligibility is checked only on confirmation and failed choices remain editable", async () => {
  const f = fixture(); await f.enable(0);
  f.player("b").selectedClass = { kind: "wine" };
  f.player("c").selectedClass = null;
  const id = await withRandom(0, f.start);
  assert.equal(f.tables.partyQuest[0].kind, "toastWithClass");
  assert.equal(await f.select(id, "a", "b"), false);
  f.player("b").selectedClass = { kind: "beer" };
  await assert.rejects(f.select(id, "b", "a"), /does not currently qualify/);
  assert.deepEqual(f.tables.partyQuest[0].results, []);
  assert.deepEqual(f.tables.partyQuest[0].selections.map(s => s.userId), ["a"]);
  assert.equal(await f.select(id, "b", "c"), false);
  f.player("b").selectedClass = { kind: "wine" };
  assert.equal(await f.select(id, "b", "a"), true);
  const completed = structuredClone(f.tables.partyQuest[0]);
  f.player("a").selectedClass = { kind: "wine" };
  assert.equal(await f.select(id, "a", "b"), true);
  assert.deepEqual(f.tables.partyQuest[0], completed);
  await assert.rejects(f.select(id, "c", "a"), /already completed/);
});

test("profile changes are evaluated on confirmation and newly joined members can participate", async () => {
  const f = fixture(); await f.enable();
  const id = await withRandom(0, f.start);
  assert.equal(await f.select(id, "a", "b"), false);
  f.tables.user.find(user => user._id === "b").accentColor = "rose";
  await assert.rejects(f.select(id, "b", "a"), /does not currently qualify/);
  f.tables.user.find(user => user._id === "b").accentColor = "amber";
  assert.equal(await f.select(id, "b", "a"), true);
  f.player("invitee").sessionMemberStatus.kind = "joined";
  f.player("invitee").selectedClass = { kind: "beer" };
  assert.equal(await f.select(id, "invitee", "c"), false);
  assert.equal(await f.select(id, "c", "invitee"), true);
  assert.equal(f.tables.partyQuest[0].results.length, 2);
});

test("rank changes before confirmation invalidate a pair until it qualifies again", async () => {
  const f = fixture(); await f.enable();
  const id = await withRandom(0, f.start);
  Object.assign(f.tables.partyQuest[0], builtInQuests.find(q => q.kind === "leader"));
  f.tables.drink.push({ _id: "beer", drinkCategory: { kind: "beer" }, alcoholPercentage: 5 });
  const log = { sessionId: "party", drinkId: "beer", consumedAt: Date.now() - 1000, deletedAt: null };
  f.tables.drinkLog.push({ ...log, userId: "a", volumeMl: 500 });
  assert.equal(await f.select(id, "a", "b"), false);
  f.tables.drinkLog.push({ ...log, userId: "c", volumeMl: 1000 });
  await assert.rejects(f.select(id, "b", "a"), /does not currently qualify/);
  assert.equal(f.tables.partyQuest[0].results.length, 0);
  f.tables.drinkLog[1].deletedAt = Date.now();
  assert.equal(await f.select(id, "b", "a"), true);
});

test("eligibility is evaluated before the completion's own points change ranks", async () => {
  const f = fixture(); await f.enable();
  const id = await withRandom(0, f.start);
  Object.assign(f.tables.partyQuest[0], builtInQuests.find(q => q.kind === "topThree"));
  f.player("owner").selectedClass = { kind: "beer" };
  f.tables.drink.push({ _id: "beer", drinkCategory: { kind: "beer" }, alcoholPercentage: 5 });
  const log = { sessionId: "party", drinkId: "beer", consumedAt: Date.now() - 1000, deletedAt: null };
  for (const [userId, volumeMl] of [["a", 400], ["c", 300], ["owner", 200]]) {
    f.tables.drinkLog.push({ ...log, userId, volumeMl });
  }
  assert.equal(await f.select(id, "owner", "b"), false);
  assert.equal(await f.select(id, "b", "owner"), true);
  // Both recipients move into the top three after their rewards; the completed result stays valid.
  assert.equal(await f.select(id, "owner", "b"), true);
  assert.equal(f.tables.partyQuest[0].results.length, 1);
});

test("self-selection, missing quests, ineligible and inactive members cannot complete", async () => {
  const f = fixture(); await f.enable(); const id = await withRandom(0, f.start);
  await assert.rejects(f.select("missing", "a", "b"), /not found/);
  await assert.rejects(f.select(id, "a", "a"), /yourself/);
  assert.equal(await f.select(id, "owner", "a"), false);
  await assert.rejects(f.select(id, "a", "owner"), /does not currently qualify/);
  await assert.rejects(f.select(id, "a", "invitee"), /joined party member/);
  await assert.rejects(f.select(id, "invitee", "a"), /permission/);
  await assert.rejects(f.select(id, "other", "a"), /permission/);
  for (const status of ["left", "banned", "declined"]) {
    f.player("b").sessionMemberStatus.kind = status;
    await assert.rejects(f.select(id, "a", "b"), /joined party member/);
    await assert.rejects(f.select(id, "b", "a"), /permission/);
  }
  await assert.rejects(q.get(f.ctx("invitee"), { id }), /permission/);
  await assert.rejects(q.listForSession(f.ctx("other"), { sessionId: "party" }), /permission/);
  assert.deepEqual(f.tables.partyQuest[0].results, []);
});

test("deadlines, cancellation and party lifecycle stop selections and allow the next quest", async () => {
  const f = fixture(); await f.enable(); const id = await withRandom(0, f.start);
  const quest = f.tables.partyQuest[0];
  const originalNow = Date.now;
  Date.now = () => quest.endsAt;
  try {
    await assert.rejects(f.select(id, "a", "b"), /not active/);
    assert.equal((await q.get(f.ctx("a"), { id })).status, "expired");
    const nextId = await f.start();
    assert.notEqual(nextId, id);
    assert.equal(quest.status, "expired");
    assert.notEqual(f.tables.partyQuest[1].kind, quest.kind);
    await m.setEnabled(f.ctx("admin"), { sessionId: "party", enabled: false });
    assert.equal(f.tables.partyQuest[1].status, "cancelled");
    await assert.rejects(f.select(nextId, "a", "b"), /disabled/);
    await f.enable();
    await assert.rejects(f.select(nextId, "a", "b"), /not active/);
  } finally { Date.now = originalNow; }
  f.tables.session[0].endedAt = originalNow();
  assert.equal((await q.get(f.ctx("a"), { id })).status, "expired");
  await assert.rejects(f.start(), /ongoing/);
  await assert.rejects(f.select(id, "a", "b"), /ongoing/);
  f.tables.session[0].deletedAt = originalNow();
  await assert.rejects(f.start(), /not found/);
  await assert.rejects(q.get(f.ctx("a"), { id }), /not found/);
});

test("issuance requires no player qualifications or profiles", async () => {
  const f = fixture();
  f.tables.sessionMember = [];
  f.tables.user = [];
  // Auth middleware is stubbed; retaining the actor suffices to test issuance reads.
  f.tables.user.push({ _id: "owner" });
  f.tables.sessionMember.push({ _id: "owner-member", sessionId: "party", userId: "owner", sessionMemberRole: { kind: "admin" }, sessionMemberStatus: { kind: "joined" }, kind: "partyMember", selectedClass: null });
  await f.enable(0);
  assert.equal(f.tables.partyQuest.length, 1);
  assert.equal(f.tables.partyQuest[0].kind, "toastWithClass");
  assert.equal(f.reads.some(read => read.startsWith("user:")), false);
  f.tables.session[0].kind = "session";
  await assert.rejects(f.enable(), /ongoing party/);
});

test("new ally history excludes previous partners and future or deleted drinks do not affect ranks", async () => {
  const f = fixture(); await f.enable();
  const history = builtInQuests.find(definition => definition.kind === "sameAccent");
  const now = Date.now();
  for (let i = 0; i < 5; i++) {
    f.tables.partyQuest.push({ ...history, _id: `old-${i}`, sessionId: "party", startsAt: now - 10000 + i, endsAt: now - 5000,
      status: "expired", selections: [], results: i === 0 ? [{ ...memberPair("a", "b"), completedAt: now - 6000 }] : [] });
  }
  const prior = new Set([JSON.stringify(memberPair("a", "b"))]);
  const definition = builtInQuests.find(quest => quest.kind === "newAlly");
  const players = ["a", "b", "c"].map(userId => ({ userId, username: userId, selectedClass: "beer", accentColor: "amber", scoreUnits: 0, beerpongTeamId: null }));
  assert.equal(eligiblePairs(definition, players, prior).some(pair => pair.firstUserId === "a" && pair.secondUserId === "b"), false);
  f.tables.drink.push({ _id: "beer", drinkCategory: { kind: "beer" }, alcoholPercentage: 5, deletedAt: 1 });
  const log = { sessionId: "party", drinkId: "beer", volumeMl: 500, consumedAt: now - 1000, deletedAt: null };
  f.tables.drinkLog.push({ ...log, userId: "c" }, { ...log, userId: "a", consumedAt: now + 10000 }, { ...log, userId: "b", deletedAt: 1 });
  const newAllyId = await withRandom(0, f.start);
  const newAlly = f.tables.partyQuest.find(quest => quest._id === newAllyId);
  Object.assign(newAlly, builtInQuests.find(q => q.kind === "newAlly"));
  assert.equal(await f.select(newAllyId, "a", "b"), false);
  await assert.rejects(f.select(newAllyId, "b", "a"), /does not currently qualify/);
  assert.equal(await f.select(newAllyId, "c", "a"), false);
  assert.equal(await f.select(newAllyId, "a", "c"), true);
  await f.db.patch("partyQuest", newAllyId, { status: "expired" });
  const id = await withRandom(0.4, f.start);
  const issued = f.tables.partyQuest.find(quest => quest._id === id);
  Object.assign(issued, builtInQuests.find(q => q.kind === "leader"));
  assert.equal(await f.select(id, "a", "b"), false);
  await assert.rejects(f.select(id, "b", "a"), /does not currently qualify/);
  assert.equal(await f.select(id, "c", "a"), false);
  assert.equal(await f.select(id, "a", "c"), true);
  assert.ok(f.tables.partyQuest.every(quest => !quest.kind.includes("Beerpong") && quest.kind !== "finalistTeam"));
});

test("quest availability resets after a full cycle without reading scores", async () => {
  const f = fixture();
  const now = Date.now();
  const definition = builtInQuests.find(quest => quest.kind === "sameAccent");
  for (let i = 0; i < 16; i++) {
    f.tables.partyQuest.push({ ...definition, _id: `old-${i}`, sessionId: "party", startsAt: now - 10000 + i, endsAt: now - 5000,
      status: "expired", selections: [], results: [] });
  }
  f.tables.drink.push({ _id: "beer", drinkCategory: { kind: "beer" }, alcoholPercentage: 5, deletedAt: null });
  const log = { sessionId: "party", drinkId: "beer", volumeMl: 500, consumedAt: now - 1000, deletedAt: null };
  f.tables.drinkLog.push({ ...log, userId: "a" }, { ...log, userId: "b" });
  await f.enable(0.99);
  const id = await f.start();
  assert.equal(f.tables.partyQuest.find(quest => quest._id === id).kind, "sameClass");
  assert.equal(f.reads.filter(read => read === "drink:beer").length, 0);
});

test("expiry preserves results, waits a whole-minute break, and delayed issuance starts fresh", async () => {
  const f = fixture(); await f.enable();
  const quest = f.tables.partyQuest[0];
  await f.select(quest._id, "a", "b"); await f.select(quest._id, "b", "a");
  const results = structuredClone(quest.results);
  const nextAt = f.tables.session[0].questSchedule.nextQuestAt;
  assert.equal((nextAt - quest.endsAt) % 60000, 0);
  assert.ok(nextAt - quest.endsAt >= 15 * 60000 && nextAt - quest.endsAt <= 45 * 60000);
  assert.equal(f.jobs[0].at, quest.endsAt);
  await f.run(f.jobs[0]);
  assert.equal(quest.status, "expired");
  assert.deepEqual(quest.results, results);
  assert.equal(f.jobs[1].at, nextAt);
  await scheduled.expire._handler(f.ctx("owner"), f.jobs[0].args);
  assert.equal(f.jobs.length, 2);
  const delayed = nextAt + 24 * 60 * 60000;
  await f.run(f.jobs[1], delayed);
  assert.equal(f.tables.partyQuest.length, 2);
  assert.equal(f.tables.partyQuest[1].startsAt, delayed);
  assert.equal(f.tables.partyQuest[1].endsAt, delayed + 15 * 60000);
  assert.equal(f.jobs.filter(j => j.state === "pending").length, 1);
  assert.equal(f.jobs[2].state, "pending");
  await scheduled.issue._handler(f.ctx("owner"), f.jobs[1].args);
  assert.equal(f.tables.partyQuest.length, 2);
});

test("manual start skips the break and stale callbacks cannot restart an old quest", async () => {
  const f = fixture(); await f.enable();
  const id = await f.start();
  assert.equal(f.jobs.length, 1);
  await f.run(f.jobs[0]);
  const waiting = f.jobs[1];
  const nextId = await f.start();
  assert.notEqual(nextId, id);
  assert.equal(waiting.state, "cancelled");
  const before = structuredClone(f.tables);
  await scheduled.issue._handler(f.ctx("owner"), waiting.args);
  await scheduled.expire._handler(f.ctx("owner"), f.jobs[0].args);
  assert.deepEqual(f.tables, before);
});

test("settings validate admin access and whole-minute ranges and store while disabled", async () => {
  const f = fixture();
  const settings = { sessionId: "party", minIntervalMinutes: 5, maxIntervalMinutes: 180, defaultDurationMinutes: 60 };
  for (const actor of ["a", "invitee", "other"])
    await assert.rejects(m.setSchedule(f.ctx(actor), settings), /permission/);
  for (const invalid of [
    { minIntervalMinutes: 4 }, { maxIntervalMinutes: 181 }, { minIntervalMinutes: 6, maxIntervalMinutes: 5 },
    { minIntervalMinutes: 5.5 }, { maxIntervalMinutes: 15.5 }, { defaultDurationMinutes: 0 },
    { defaultDurationMinutes: 61 }, { defaultDurationMinutes: 1.5 },
  ]) await assert.rejects(m.setSchedule(f.ctx("admin"), { ...settings, ...invalid }));
  assert.equal(await m.setSchedule(f.ctx("admin"), settings), null);
  assert.equal(f.jobs.length, 0);
  await f.enable(0);
  assert.equal(f.tables.partyQuest[0].endsAt - f.tables.partyQuest[0].startsAt, 60 * 60000);
  assert.equal(f.tables.session[0].questSchedule.nextQuestAt - f.tables.partyQuest[0].endsAt, 5 * 60000);
  const g = fixture();
  await m.setSchedule(g.ctx("owner"), settings); await g.enable(0.99999);
  assert.equal(g.tables.session[0].questSchedule.nextQuestAt - g.tables.partyQuest[0].endsAt, 180 * 60000);
});

test("settings preserve a running deadline and replace a waiting break from now", async () => {
  const f = fixture(); await f.enable();
  const quest = f.tables.partyQuest[0]; const endsAt = quest.endsAt;
  const settings = { sessionId: "party", minIntervalMinutes: 5, maxIntervalMinutes: 5, defaultDurationMinutes: 1 };
  await m.setSchedule(f.ctx("admin"), settings);
  assert.equal(quest.endsAt, endsAt);
  assert.equal(f.jobs[0].state, "cancelled");
  assert.equal(f.tables.session[0].questSchedule.nextQuestAt, endsAt + 5 * 60000);
  await scheduled.expire._handler(f.ctx("owner"), f.jobs[0].args);
  assert.equal(quest.status, "active");
  await f.run(f.jobs[1]);
  const original = Date.now;
  const changedAt = endsAt + 60000;
  Date.now = () => changedAt;
  try { await m.setSchedule(f.ctx("owner"), { ...settings, minIntervalMinutes: 6, maxIntervalMinutes: 6 }); }
  finally { Date.now = original; }
  assert.equal(f.jobs[2].state, "cancelled");
  assert.equal(f.jobs[3].at, changedAt + 6 * 60000);
  await f.run(f.jobs[3]);
  assert.equal(f.tables.partyQuest[1].endsAt - f.tables.partyQuest[1].startsAt, 60000);
});

test("repeated enabling preserves jobs and repairs missing lifecycle metadata", async () => {
  const f = fixture(); await f.enable();
  const quest = f.tables.partyQuest[0];
  await f.enable(); assert.equal(f.jobs.length, 1); assert.equal(f.tables.partyQuest.length, 1);
  const party = f.tables.session[0];
  party.questSchedule.nextQuestAt = null;
  await f.enable();
  assert.equal(f.jobs[0].state, "cancelled");
  assert.equal(f.tables.partyQuest.length, 1);
  assert.equal(f.jobs[1].args.questId, quest._id);
  await f.run(f.jobs[1]);
  const waitingId = party.questSchedule.scheduledFunctionId;
  await f.enable(); assert.equal(party.questSchedule.scheduledFunctionId, waitingId);
  await f.scheduler.cancel(waitingId);
  party.questSchedule.scheduledFunctionId = null;
  await f.enable();
  assert.equal(f.jobs.at(-1).name, "partyQuest:issue");
  assert.equal(f.tables.partyQuest.length, 1);
  await f.run(f.jobs.at(-1));
  assert.equal(f.tables.partyQuest.length, 2);
});

for (const action of ["disable", "end", "delete", "deleteOwner"]) {
  for (const phase of ["running", "break", "elapsed"]) {
    test(`${action} during ${phase} cancels lifecycle work and preserves completed results`, async () => {
      const f = fixture(); await f.enable();
      const quest = f.tables.partyQuest[0];
      await f.select(quest._id, "a", "b"); await f.select(quest._id, "b", "a");
      const results = structuredClone(quest.results);
      if (phase === "break") await f.run(f.jobs[0]);
      const original = Date.now;
      const now = phase === "running" ? quest.startsAt + 1 : quest.endsAt + 1;
      Date.now = () => now;
      try {
        if (action === "disable") await m.setEnabled(f.ctx("owner"), { sessionId: "party", enabled: false });
        if (action === "end") await sessions.update(f.ctx("owner"), { id: "party", endedAt: now });
        if (action === "delete") await sessions.softDelete(f.ctx("owner"), { id: "party" });
        if (action === "deleteOwner") await deleteUserData(f.ctx("owner"), "auth-owner");
      } finally { Date.now = original; }
      const party = f.tables.session[0];
      assert.equal(party.modules.socialQuestsEnabled, false);
      assert.equal(party.questSchedule.scheduledFunctionId, null);
      assert.equal(party.questSchedule.nextQuestAt, null);
      assert.equal(quest.status, phase === "running" ? "cancelled" : "expired");
      assert.deepEqual(quest.results, results);
      assert.equal(f.jobs.filter(j => j.state === "pending").length, 0);
      if (action === "end") {
        await sessions.update(f.ctx("owner"), { id: "party", endedAt: null });
        await assert.rejects(f.start(), /disabled/);
      }
      const before = structuredClone(f.tables);
      for (const job of f.jobs) await scheduled[job.name.split(":")[1]]._handler(f.ctx("admin"), job.args);
      assert.deepEqual(f.tables, before);
      if (["disable", "end"].includes(action)) {
        await f.enable();
        assert.equal(f.tables.partyQuest.length, 2);
        assert.notEqual(f.tables.partyQuest[1]._id, quest._id);
        assert.deepEqual(quest.results, results);
      }
    });
  }
}

test("callbacks ignore missing, ended, deleted, disabled parties and premature execution", async () => {
  const f = fixture(); await f.enable();
  const job = f.jobs[0]; const party = f.tables.session[0];
  for (const patch of [{ endedAt: 1 }, { deletedAt: 1 }, { modules: { socialQuestsEnabled: false } }, { kind: "session" }]) {
    const saved = structuredClone(party); Object.assign(party, patch);
    await scheduled.expire._handler(f.ctx("owner"), job.args);
    await scheduled.issue._handler(f.ctx("owner"), { sessionId: "party", nextQuestAt: party.questSchedule.nextQuestAt });
    Object.assign(party, saved);
  }
  await scheduled.expire._handler(f.ctx("owner"), job.args);
  assert.equal(f.jobs.length, 1);
  f.tables.session = [];
  await scheduled.expire._handler(f.ctx("owner"), job.args);
  await scheduled.issue._handler(f.ctx("owner"), { sessionId: "party", nextQuestAt: 0 });
  assert.equal(f.jobs.length, 1);
});

test("automatic cycles preserve stages and avoid repeats while excluding beerpong", async () => {
  const f = fixture(); await f.enable(0);
  const identity = q => `${q.kind}:${q.drinkCategory?.kind ?? ""}`;
  for (let index = 0; index < 32; index++) {
    const quest = f.tables.partyQuest[index];
    const definition = builtInQuests.find(q => identity(q) === identity(quest));
    if (index % 16 < 5) assert.equal(definition.availability, "early");
    assert.ok(!["differentBeerpongTeam", "sameBeerpongTeam", "finalistTeam"].includes(quest.kind));
    const earlier = f.tables.partyQuest.slice(index - index % 16, index).map(identity);
    const available = builtInQuests.filter(q => q.availability === "early" || q.availability === "regular" && index % 16 >= 5)
      .filter(q => !q.kind.includes("Beerpong"));
    if (available.some(q => !earlier.includes(identity(q)))) assert.ok(!earlier.includes(identity(quest)));
    await f.run(f.jobs.at(-1));
    await withRandom(0.999, () => f.run(f.jobs.at(-1)));
  }
  assert.equal(f.tables.partyQuest.length, 33);
  assert.equal(f.tables.partyQuest.filter(q => q.status === "active").length, 1);
  assert.equal(f.jobs.filter(j => j.state === "pending").length, 1);
});

function beerpongFixture(stage = 5) {
  const f = fixture();
  f.tables.session[0].modules.beerpongEnabled = true;
  const definition = builtInQuests.find(quest => quest.kind === "sameAccent");
  for (let index = 0; index < stage; index++) f.tables.partyQuest.push({
    ...definition, _id: `past-${index}`, _creationTime: index, sessionId: "party",
    startsAt: index, endsAt: index + 1, status: "expired", selections: [], results: [],
  });
  f.tables.beerpongTournament.push({
    _id: "tournament", _creationTime: 1, sessionId: "party", status: "setup", teamCount: 2,
    thirdPlaceEnabled: false, firstPlacePointsUnits: 3000, secondPlacePointsUnits: 2000,
    thirdPlacePointsUnits: 1000, completedAt: null,
  });
  f.tables.beerpongTeam.push(
    { _id: "team-a", tournamentId: "tournament", memberUserIds: ["a", "b"] },
    { _id: "team-b", tournamentId: "tournament", memberUserIds: ["c"] },
  );
  return f;
}

function addFinal(f, slotA = { kind: "team", teamId: "team-a" }, slotB = { kind: "team", teamId: "team-b" }) {
  f.tables.beerpongTournament[0].status = "active";
  f.tables.beerpongMatch.push({
    _id: "final", tournamentId: "tournament", kind: "main", round: 2, position: 1,
    slotA, slotB, winnerTeamId: null, completedAt: null,
  });
}

for (const [kind, partner] of [["sameBeerpongTeam", "b"], ["differentBeerpongTeam", "c"]]) {
  test(`${kind} issues from assigned teams and validates mutual completion`, async () => {
    const f = beerpongFixture();
    if (kind === "differentBeerpongTeam") f.tables.beerpongTeam[0].memberUserIds = ["a"];
    await f.enable(0.99999);
    const quest = f.tables.partyQuest.at(-1);
    assert.equal(quest.kind, kind);
    assert.equal(await f.select(quest._id, "a", partner), false);
    assert.equal(await f.select(quest._id, partner, "a"), true);
    assert.deepEqual(quest.results.map(({ firstUserId, secondUserId }) => ({ firstUserId, secondUserId })), [memberPair("a", partner)]);
    // A retry cannot award the pair twice.
    assert.equal(await f.select(quest._id, partner, "a"), true);
    assert.equal(quest.results.length, 1);
  });
}

test("team changes are rechecked at completion and recorded results survive later changes", async () => {
  const f = beerpongFixture(); await f.enable(0.99999);
  const quest = f.tables.partyQuest.at(-1);
  await f.select(quest._id, "a", "b");
  f.tables.beerpongTeam[0].memberUserIds = ["a"];
  f.tables.beerpongTeam[1].memberUserIds = ["b", "c"];
  await assert.rejects(f.select(quest._id, "b", "a"), /does not currently qualify/);
  assert.equal(quest.results.length, 0);
  f.tables.beerpongTeam[0].memberUserIds = ["a", "b"];
  f.tables.beerpongTeam[1].memberUserIds = ["c"];
  assert.equal(await f.select(quest._id, "b", "a"), true);
  f.tables.beerpongTeam[0].memberUserIds = [];
  assert.equal(await f.select(quest._id, "b", "a"), true);
  assert.equal(quest.results.length, 1);
});

for (const state of ["disabled", "missing", "enrollment", "cancelled", "otherParty", "noEligiblePlayers"]) {
  test(`beerpong quests stay unavailable with ${state} context`, async () => {
    const f = beerpongFixture(10);
    if (state === "disabled") f.tables.session[0].modules.beerpongEnabled = false;
    if (state === "missing") f.tables.beerpongTournament = [];
    if (["enrollment", "cancelled"].includes(state)) {
      // A newer tournament must hide assignments from the older setup.
      f.tables.beerpongTournament.push({ _id: "new", _creationTime: 2, sessionId: "party", status: state });
    }
    if (state === "otherParty") f.tables.beerpongTournament[0].sessionId = "another-party";
    if (state === "noEligiblePlayers") {
      f.player("a").selectedClass = null;
      f.player("b").sessionMemberStatus.kind = "left";
      f.player("c").sessionMemberStatus.kind = "banned";
    }
    await f.enable(0.99999);
    const quest = f.tables.partyQuest.at(-1);
    assert.ok(!["sameBeerpongTeam", "differentBeerpongTeam", "finalistTeam"].includes(quest.kind));
    // Even a previously issued team quest cannot complete using stale context.
    Object.assign(quest, builtInQuests.find(q => q.kind === "sameBeerpongTeam"));
    if (state !== "noEligiblePlayers") {
      await f.select(quest._id, "a", "b");
      await assert.rejects(f.select(quest._id, "b", "a"), /does not currently qualify/);
      assert.equal(quest.results.length, 0);
    }
  });
}

test("scheduled issuance enables team quests after the early stage", async () => {
  const f = beerpongFixture(4); await f.enable(0.99999);
  assert.equal(f.tables.partyQuest.at(-1).kind, "sameClass");
  await f.run(f.jobs.at(-1));
  await withRandom(0.99999, () => f.run(f.jobs.at(-1)));
  assert.equal(f.tables.partyQuest.at(-1).kind, "sameBeerpongTeam");
});

test("finalist quests require the final stage and a resolved path to the main final", async () => {
  const early = beerpongFixture(5); addFinal(early); await early.enable(0.99999);
  assert.equal(early.tables.partyQuest.at(-1).kind, "sameBeerpongTeam");
  const f = beerpongFixture(10);
  addFinal(f, { kind: "winner", matchId: "semi-a" }, { kind: "winner", matchId: "semi-b" });
  f.tables.beerpongMatch.push(
    { _id: "semi-a", tournamentId: "tournament", kind: "main", round: 1, position: 1,
      slotA: { kind: "team", teamId: "team-a" }, slotB: { kind: "bye" }, winnerTeamId: null },
    { _id: "semi-b", tournamentId: "tournament", kind: "main", round: 1, position: 2,
      slotA: { kind: "team", teamId: "team-b" }, slotB: { kind: "team", teamId: "team-c" }, winnerTeamId: null },
    // A ready bronze match must not make its teams finalists.
    { _id: "bronze", tournamentId: "tournament", kind: "thirdPlace", round: 2, position: 2,
      slotA: { kind: "team", teamId: "team-a" }, slotB: { kind: "team", teamId: "team-b" }, winnerTeamId: null },
  );
  await f.enable(0.99999);
  assert.equal(f.tables.partyQuest.at(-1).kind, "sameBeerpongTeam");
  f.tables.partyQuest.at(-1).status = "expired";
  f.tables.beerpongMatch.find(m => m._id === "semi-a").winnerTeamId = "team-a";
  await withRandom(0.99999, f.start);
  const quest = f.tables.partyQuest.at(-1);
  assert.equal(quest.kind, "finalistTeam");
  // Only one partner needs a finalist team; the other can be unassigned.
  f.tables.beerpongTeam[1].memberUserIds = [];
  await f.select(quest._id, "a", "c");
  // Clearing/correcting the semifinal removes eligibility before completion.
  f.tables.beerpongMatch.find(m => m._id === "semi-a").winnerTeamId = null;
  await assert.rejects(f.select(quest._id, "c", "a"), /does not currently qualify/);
  f.tables.beerpongMatch.find(m => m._id === "semi-a").winnerTeamId = "team-a";
  assert.equal(await f.select(quest._id, "c", "a"), true);
});

test("completed tournaments retain finalist eligibility", async () => {
  const f = beerpongFixture(10); addFinal(f);
  Object.assign(f.tables.beerpongTournament[0], { status: "completed", completedAt: Date.now() - 1 });
  Object.assign(f.tables.beerpongMatch[0], { round: 1, winnerTeamId: "team-a", completedAt: Date.now() - 1 });
  await f.enable(0.99999);
  const quest = f.tables.partyQuest.at(-1);
  assert.equal(quest.kind, "finalistTeam");
  await f.select(quest._id, "a", "c");
  assert.equal(await f.select(quest._id, "c", "a"), true);
});

test("partner query uses live eligibility, hides completed participants, and never exposes private choices", async () => {
  const f = fixture(); await f.enable(0.99999);
  const quest = f.tables.partyQuest.at(-1);
  const partners = actor => q.partners(f.ctx(actor), { questId: quest._id });
  assert.deepEqual((await partners("a")).map(user => user._id), ["b", "c"]);
  assert.deepEqual(await partners("owner"), []); // No selected class.
  assert.ok((await partners("a")).every(user => Object.keys(user).sort().join() === "_id,accentColor,avatarUrl,username"));
  await f.select(quest._id, "b", "a");
  assert.deepEqual((await partners("a")).map(user => user._id), ["b", "c"]);
  await f.select(quest._id, "a", "b");
  assert.deepEqual(await partners("a"), []);
  assert.deepEqual(await partners("c"), []);
  await assert.rejects(partners("other"), /permission/);
  await assert.rejects(q.partners(f.ctx("a"), { questId: "missing" }), /not found/);
});

test("partner query reflects beerpong rosters and disables selection for inactive quests and parties", async () => {
  const f = beerpongFixture(); await f.enable(0.99999);
  const quest = f.tables.partyQuest.at(-1);
  const partners = () => q.partners(f.ctx("a"), { questId: quest._id });
  assert.deepEqual((await partners()).map(user => user._id), ["b"]);
  f.tables.beerpongTeam[0].memberUserIds = ["a"];
  assert.deepEqual(await partners(), []);
  f.tables.beerpongTeam[0].memberUserIds = ["a", "b"];
  f.player("b").sessionMemberStatus.kind = "left";
  assert.deepEqual(await partners(), []);
  f.player("b").sessionMemberStatus.kind = "joined";
  for (const status of ["expired", "cancelled"]) {
    quest.status = status;
    assert.deepEqual(await partners(), []);
  }
  quest.status = "active";
  quest.endsAt = Date.now() - 1;
  assert.deepEqual(await partners(), []);
  quest.endsAt = Date.now() + 60000;
  f.tables.session[0].modules.socialQuestsEnabled = false;
  assert.deepEqual(await partners(), []);
  f.tables.session[0].modules.socialQuestsEnabled = true;
  f.tables.session[0].endedAt = Date.now();
  assert.deepEqual(await partners(), []);
});
