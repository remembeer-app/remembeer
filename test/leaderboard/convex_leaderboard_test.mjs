import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";

const { outputFiles } = await build({
  stdin: { contents: `export * as mutations from "./convex/leaderboard/mutation";
    export * as queries from "./convex/leaderboard/query";
    export { deleteUserData } from "./convex/user/deletion";`, resolveDir: process.cwd() },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "authenticated-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authQuery = createBuilder().query(); export const authMutation = createBuilder().mutation();', loader: "ts",
    }));
  } }],
});
const { mutations: m, queries: q, deleteUserData } = await import(
  `data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`,
);

function fixture() {
  const tables = {
    user: ["a", "b", "c", "d"].map(_id => ({ _id, username: _id, accentColor: "amber", authUserId: `auth-${_id}`, timeZone: "Asia/Tokyo", endOfDayBoundary: 0 })),
    leaderboard: [], leaderboardMember: [], drinkLog: [], drink: [], friendship: [], badge: [], session: [], sessionMember: [],
  };
  let sequence = 0;
  const reads = new Map();
  const db = {
    async get(table, id) {
      reads.set(`${table}:${id}`, (reads.get(`${table}:${id}`) ?? 0) + 1);
      return structuredClone(tables[table].find(row => row._id === id) ?? null);
    },
    async insert(table, fields) {
      const id = `${table}-${++sequence}`;
      tables[table].push({ _id: id, _creationTime: sequence, ...structuredClone(fields) });
      return id;
    },
    async patch(table, id, fields) {
      const row = tables[table].find(row => row._id === id);
      assert.ok(row); Object.assign(row, structuredClone(fields));
    },
    async delete(table, id) { tables[table] = tables[table].filter(row => row._id !== id); },
    query(table) {
      assert.ok(tables[table], `Unknown table ${table}`);
      let rows = tables[table];
      return {
        withIndex(name, range) {
          const index = {
            eq(field, value) { rows = rows.filter(row => row[field] === value); return index; },
            gte(field, value) { rows = rows.filter(row => row[field] >= value); return index; },
            lt(field, value) { rows = rows.filter(row => row[field] < value); return index; },
          };
          range(index); return this;
        },
        async unique() { assert.ok(rows.length <= 1); return structuredClone(rows[0] ?? null); },
        async collect() { return structuredClone(rows); },
      };
    },
  };
  const ctx = id => ({ db, user: tables.user.find(user => user._id === id) ?? { _id: id }, storage: {
    async getUrl(id) { return `https://example.com/${id}`; }, async delete() {},
  } });
  const create = () => m.create(ctx("a"), { name: "Our board", iconName: "trophy" });
  const log = (userId, consumedAt, volumeMl = 500, drinkId = "beer", deletedAt = null) => tables.drinkLog.push({
    _id: `log-${tables.drinkLog.length}`, userId, drinkId, consumedAt: Date.parse(consumedAt), volumeMl, deletedAt, sessionId: null, location: null,
  });
  tables.drink.push({ _id: "beer", name: "Beer", drinkCategory: { kind: "beer" }, alcoholPercentage: 5, deletedAt: null });
  return { tables, reads, ctx, create, log };
}

function at(instant, action) {
  const original = Date.now;
  Date.now = () => Date.parse(instant);
  return Promise.resolve().then(action).finally(() => { Date.now = original; });
}

test("creation, validation, invite previews and unique invite codes", async () => {
  const f = fixture();
  const id = await f.create();
  const board = f.tables.leaderboard[0];
  assert.equal(board.timeZone, "Europe/Prague"); assert.equal(board.endOfDayBoundary, 360);
  assert.match(board.inviteCode, /^[ABCDEFGHJKLMNPQRSTUVWXYZ23456789]{8}$/);
  assert.deepEqual(f.tables.leaderboardMember.map(row => [row.userId, row.status]), [["a", "joined"]]);
  const preview = await q.findByInviteCode(f.ctx("b"), { inviteCode: ` ${board.inviteCode.toLowerCase()} ` });
  assert.deepEqual(preview, { id, name: "Our board", iconName: "trophy", memberCount: 1 });
  const absentCode = board.inviteCode === "ZZZZZZZZ" ? "YYYYYYYY" : "ZZZZZZZZ";
  assert.equal(await q.findByInviteCode(f.ctx("b"), { inviteCode: absentCode }), null);
  await assert.rejects(m.create(f.ctx("a"), { name: "ab", iconName: "trophy" }));
  await assert.rejects(m.create(f.ctx("a"), { name: "Valid", iconName: "invalid" }));
  await assert.rejects(q.findByInviteCode(f.ctx("b"), { inviteCode: "invalid!" }));
  const originalRandom = Math.random;
  let calls = 0;
  Math.random = () => calls++ < 8 ? 0 : 0.5;
  try {
    board.inviteCode = "AAAAAAAA";
    const other = await f.create();
    assert.notEqual(f.tables.leaderboard.find(row => row._id === other).inviteCode, board.inviteCode);
    assert.equal(calls, 16);
  } finally { Math.random = originalRandom; }
});

test("permissions, joining, bans, removal, leaving, and owner restrictions", async () => {
  const f = fixture(); const id = await f.create();
  for (const operation of [q.get, q.standings, m.update, m.softDelete]) {
    await assert.rejects(operation(f.ctx("b"), { id }), /permission/);
  }
  assert.deepEqual(await q.listCurrent(f.ctx("b"), {}), []);
  assert.equal(await m.join(f.ctx("b"), { id }), "success");
  assert.equal(await m.join(f.ctx("b"), { id }), "alreadyMember");
  assert.equal((await q.listCurrent(f.ctx("b"), {})).length, 1);
  await m.update(f.ctx("a"), { id, name: " Renamed ", iconName: "beer" });
  assert.equal((await q.get(f.ctx("b"), { id })).leaderboard.name, "Renamed");
  for (const operation of [m.remove, m.ban, m.unban]) {
    await assert.rejects(operation(f.ctx("b"), { id, userId: "c" }), /permission/);
    await assert.rejects(operation(f.ctx("a"), { id, userId: "a" }), /owner/);
  }
  await assert.rejects(m.leave(f.ctx("a"), { id }), /owner/);
  await m.ban(f.ctx("a"), { id, userId: "b" });
  assert.equal(await m.join(f.ctx("b"), { id }), "banned");
  await assert.rejects(q.get(f.ctx("b"), { id }), /permission/);
  await m.join(f.ctx("c"), { id });
  const ownerDetails = await q.get(f.ctx("a"), { id });
  assert.deepEqual(ownerDetails.bannedMembers.map(user => user._id), ["b"]);
  assert.deepEqual((await q.get(f.ctx("c"), { id })).bannedMembers, []);
  assert.deepEqual(Object.keys(ownerDetails.members[0]).sort(), ["_id", "accentColor", "avatarUrl", "username"]);
  await m.remove(f.ctx("a"), { id, userId: "b" });
  assert.equal(await m.join(f.ctx("b"), { id }), "banned", "removal cannot bypass a ban");
  await m.unban(f.ctx("a"), { id, userId: "b" });
  assert.deepEqual(await q.listCurrent(f.ctx("b"), {}), []);
  assert.equal(await m.join(f.ctx("b"), { id }), "success");
  await m.remove(f.ctx("a"), { id, userId: "b" });
  assert.equal(await m.join(f.ctx("b"), { id }), "success");
  await m.leave(f.ctx("b"), { id });
  assert.deepEqual(await q.listCurrent(f.ctx("b"), {}), []);
  await assert.rejects(m.ban(f.ctx("a"), { id, userId: "missing" }), /User not found/);
});

test("capacity counts only joined members, and soft deletion hides every entry point", async () => {
  const f = fixture(); const id = await f.create();
  for (let i = 0; i < 198; i++) f.tables.leaderboardMember.push({ _id: `member-${i}`, leaderboardId: id, userId: `extra-${i}`, status: "joined" });
  await m.ban(f.ctx("a"), { id, userId: "c" });
  assert.equal(await m.join(f.ctx("b"), { id }), "success");
  assert.equal(await m.join(f.ctx("d"), { id }), "full");
  assert.equal(await m.join(f.ctx("a"), { id }), "alreadyMember");
  assert.equal(await m.join(f.ctx("c"), { id }), "banned");
  await m.softDelete(f.ctx("a"), { id });
  assert.deepEqual(await q.listCurrent(f.ctx("a"), {}), []);
  assert.equal(await q.findByInviteCode(f.ctx("d"), { inviteCode: f.tables.leaderboard[0].inviteCode }), null);
  for (const operation of [m.join, q.get, q.standings, m.update]) await assert.rejects(operation(f.ctx("a"), { id }), /not found/);
});

test("month windows are shared, include pre-join logs, and exclude deleted logs and endpoints", async () => {
  const f = fixture(); const id = await f.create();
  f.log("a", "2026-01-01T04:59:59.999Z", 1000);
  f.log("a", "2026-01-01T05:00:00Z", 500);
  f.log("a", "2026-02-01T04:59:59.999Z", 250);
  f.log("a", "2026-02-01T05:00:00Z", 1000);
  f.log("a", "2026-01-05T05:00:00Z", 1000, "beer", 1);
  f.log("b", "2026-01-10T05:00:00Z", 500);
  await m.join(f.ctx("b"), { id }); await m.join(f.ctx("c"), { id });
  f.tables.user[1].timeZone = "America/New_York"; f.tables.user[1].endOfDayBoundary = 120;
  await at("2026-02-01T04:59:59.999Z", async () => {
    const result = await q.standings(f.ctx("a"), { id });
    assert.equal(result.currentMonth, "2026-01"); assert.equal(result.month, "2026-01");
    assert.equal(result.nextMonthAt, Date.parse("2026-02-01T05:00:00Z"));
    assert.deepEqual(result.entries.map(entry => [entry.user._id, entry.beersConsumed, entry.alcoholConsumedMl]), [["a", 1.5, 37.5], ["b", 1, 25], ["c", 0, 0]]);
    assert.deepEqual(await q.standings(f.ctx("b"), { id }), result);
    await assert.rejects(q.standings(f.ctx("a"), { id, month: "2026-02" }), /future/);
  });
  await at("2026-02-01T05:00:00Z", async () => {
    assert.equal((await q.standings(f.ctx("a"), { id })).currentMonth, "2026-02");
  });
  await assert.rejects(q.standings(f.ctx("a"), { id, month: "2026-13" }));
});

test("current catalog edits, log updates/deletion, caching, and deterministic independent ranks", async () => {
  const f = fixture(); const id = await f.create();
  await m.join(f.ctx("b"), { id }); await m.join(f.ctx("c"), { id });
  f.tables.drink.push({ _id: "spirit", drinkCategory: { kind: "spirit" }, alcoholPercentage: 50, deletedAt: null });
  f.log("a", "2026-01-10T05:00:00Z", 500);
  f.log("b", "2026-01-10T05:00:00Z", 500);
  f.log("b", "2026-01-10T05:00:00Z", 100, "spirit");
  let result = await q.standings(f.ctx("a"), { id, month: "2026-01" });
  assert.deepEqual(result.entries.map(e => [e.user._id, e.rankByBeers, e.rankByAlcohol]), [["b", 2, 1], ["a", 1, 2], ["c", 3, 3]]);
  assert.equal(f.reads.get("drink:beer"), 1);
  f.tables.drink[0].alcoholPercentage = 10; f.tables.drink[0].deletedAt = 1;
  result = await q.standings(f.ctx("a"), { id, month: "2026-01" });
  assert.equal(result.entries.find(e => e.user._id === "a").alcoholConsumedMl, 50);
  f.tables.drink[0].drinkCategory.kind = "wine";
  f.tables.drinkLog[0].volumeMl = 250;
  result = await q.standings(f.ctx("a"), { id, month: "2026-01" });
  assert.equal(result.entries.find(e => e.user._id === "a").beersConsumed, 0);
  assert.equal(result.entries.find(e => e.user._id === "a").alcoholConsumedMl, 25);
  f.tables.drinkLog[0].deletedAt = 1;
  result = await q.standings(f.ctx("a"), { id, month: "2026-01" });
  assert.equal(result.entries.find(e => e.user._id === "a").alcoholConsumedMl, 0);
  f.tables.drink = [];
  await assert.rejects(q.standings(f.ctx("a"), { id, month: "2026-01" }), /logged drink is missing/);
});

test("year rollover, leap February and DST month boundaries use Prague wall time", async () => {
  for (const [month, start, end] of [
    ["2025-12", "2025-12-01T05:00:00Z", "2026-01-01T05:00:00Z"],
    ["2024-02", "2024-02-01T05:00:00Z", "2024-03-01T05:00:00Z"],
    ["2026-03", "2026-03-01T05:00:00Z", "2026-04-01T04:00:00Z"],
    ["2025-10", "2025-10-01T04:00:00Z", "2025-11-01T05:00:00Z"],
  ]) {
    const f = fixture(); const id = await f.create();
    f.log("a", new Date(Date.parse(start) - 1).toISOString(), 1000);
    f.log("a", start, 500); f.log("a", new Date(Date.parse(end) - 1).toISOString(), 500); f.log("a", end, 1000);
    const result = await q.standings(f.ctx("a"), { id, month });
    assert.equal(result.entries[0].beersConsumed, 2, month);
  }
});

test("account deletion soft-deletes owned boards and removes memberships and bans elsewhere", async () => {
  const f = fixture(); const ownedId = await f.create();
  const otherId = await m.create(f.ctx("b"), { name: "Other board", iconName: "star" });
  await m.join(f.ctx("a"), { id: otherId });
  const bannedId = await m.create(f.ctx("c"), { name: "Third board", iconName: "star" });
  await m.ban(f.ctx("c"), { id: bannedId, userId: "a" });
  await deleteUserData(f.ctx("a"), "auth-a");
  assert.notEqual(f.tables.leaderboard.find(board => board._id === ownedId).deletedAt, null);
  assert.equal(f.tables.leaderboard.find(board => board._id === otherId).deletedAt, null);
  assert.ok(f.tables.leaderboardMember.every(member => member.userId !== "a"));
  assert.deepEqual((await q.get(f.ctx("b"), { id: otherId })).members.map(user => user._id), ["b"]);
});


test("200 members with daily logs produce standings and share catalog reads", async () => {
  const f = fixture(); const id = await f.create();
  for (let i = 0; i < 199; i++) {
    const userId = `load-${String(i).padStart(3, "0")}`;
    f.tables.user.push({ _id: userId, username: userId, accentColor: "amber" });
    await m.join(f.ctx(userId), { id });
  }
  for (const member of f.tables.leaderboardMember) {
    for (let day = 1; day <= 31; day++) f.log(member.userId, `2026-01-${String(day).padStart(2, "0")}T12:00:00Z`);
  }
  const result = await q.standings(f.ctx("a"), { id, month: "2026-01" });
  assert.equal(result.entries.length, 200);
  assert.ok(result.entries.every(entry => entry.beersConsumed === 31 && entry.alcoholConsumedMl === 775));
  assert.equal(f.reads.get("drink:beer"), 1);
});
