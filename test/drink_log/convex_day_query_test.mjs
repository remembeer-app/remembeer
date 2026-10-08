import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";

const { outputFiles } = await build({
  stdin: { contents: 'export { listForDay } from "./convex/drinkLog/query"; export { update } from "./convex/drinkLog/mutation"; export { deleteUserData } from "./convex/user/deletion";', resolveDir: process.cwd() },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "authenticated-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authQuery = createBuilder().query(); export const authMutation = createBuilder().mutation();', loader: "ts",
    }));
  } }],
});
const { listForDay, update, deleteUserData } = await import(`data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`);

test("daily reads use live catalogue data and keep missing or deleted drinks visible", async () => {
  const start = Date.parse("2026-01-01T05:00Z");
  const end = Date.parse("2026-01-02T05:00Z");
  const drink = { name: "Beer", alcoholPercentage: 4.5, deletedAt: null };
  let catalogueDrink = drink;
  const logs = [
    { _id: "before", userId: "owner", consumedAt: start - 1, deletedAt: null },
    { _id: "first", userId: "owner", consumedAt: start, deletedAt: null },
    { _id: "last", userId: "owner", consumedAt: end - 1, deletedAt: null },
    { _id: "next", userId: "owner", consumedAt: end, deletedAt: null },
    { _id: "other", userId: "other", consumedAt: start, deletedAt: null },
    { _id: "deleted", userId: "owner", consumedAt: start, deletedAt: 1 },
  ].map((log) => ({ ...log, drinkId: "drink", sessionId: null, volumeMl: 500, location: null }));
  const ctx = { user: { _id: "owner", timeZone: "Europe/Prague", endOfDayBoundary: 360, drinkLogSortOrder: "asc" }, db: {
    async get(table, id) { assert.equal(table, "drink"); assert.equal(id, "drink"); return catalogueDrink; },
    query(table) {
      assert.equal(table, "drinkLog");
      let rows = logs;
      return {
        withIndex(name, range) {
          assert.equal(name, "by_userId_and_deletedAt_and_consumedAt");
          const q = {
            eq(field, value) { rows = rows.filter((row) => row[field] === value); return q; },
            gte(field, value) { rows = rows.filter((row) => row[field] >= value); return q; },
            lt(field, value) { rows = rows.filter((row) => row[field] < value); return q; },
          };
          range(q); return this;
        },
        order(direction) { rows = [...rows].sort((a, b) => (a.consumedAt - b.consumedAt) * (direction === "asc" ? 1 : -1)); return this; },
        async collect() { return rows; },
      };
    },
  } };
  const input = { date: "2026-01-01", at: Date.parse("2026-01-02T04:59:59Z") };
  let result = await listForDay(ctx, input);
  assert.equal(result.today, "2026-01-01");
  assert.equal(result.date, "2026-01-01");
  assert.deepEqual(await listForDay(ctx, { at: input.at }), result);
  assert.deepEqual(await listForDay(ctx, { ...input, date: "2026-01-03" }), result);
  assert.deepEqual(result.logs.map((log) => log._id), ["first", "last"]);
  assert.equal(result.logs[0].consumedAtLocal, "2026-01-01T06:00:00");
  drink.name = "Edited beer"; drink.alcoholPercentage = 7; drink.deletedAt = 1;
  result = await listForDay(ctx, input);
  assert.equal(result.logs[0].drink.name, "Edited beer");
  assert.equal(result.logs[0].drink.alcoholPercentage, 7);
  catalogueDrink = null;
  result = await listForDay(ctx, input);
  assert.equal(result.logs.length, 2);
  assert.equal(result.logs[0].drink, null);
  await assert.rejects(listForDay(ctx, { ...input, date: "2026-02-30" }));
});

test("Today respects account timezone, exact boundaries, DST gaps and overlaps", async () => {
  const ctx = { user: { _id: "owner", timeZone: "Europe/Prague", endOfDayBoundary: 360, drinkLogSortOrder: "asc" }, db: {
    query() { return { withIndex() { return this; }, order() { return this; }, async collect() { return []; } }; },
  } };
  const day = async (instant) => listForDay(ctx, { at: Date.parse(instant) });
  assert.equal((await day("2026-01-02T04:59:59Z")).today, "2026-01-01");
  assert.equal((await day("2026-01-02T05:00:00Z")).today, "2026-01-02");
  const empty = await day("2026-03-28T05:00:00Z");
  assert.deepEqual(empty, { today: "2026-03-28", date: "2026-03-28", logs: [] });
  const past = await listForDay(ctx, { at: Date.parse("2026-01-02T05:00:00Z"), date: "2026-01-01" });
  assert.equal(past.today, "2026-01-02");
  assert.equal(past.date, "2026-01-01");
  ctx.user.endOfDayBoundary = 150;
  assert.equal((await day("2026-03-29T01:15:00Z")).today, "2026-03-28");
  assert.equal((await day("2026-03-29T01:30:00Z")).today, "2026-03-29");
  assert.equal((await day("2026-10-25T01:15:00Z")).today, "2026-10-25");
  ctx.user.timeZone = "Asia/Kathmandu"; ctx.user.endOfDayBoundary = 360;
  assert.equal((await day("2026-01-02T00:00:00Z")).today, "2026-01-01");
  assert.equal((await day("2026-01-02T00:15:00Z")).today, "2026-01-02");
});

test("editing an existing removed drink preserves its reference but cannot select a new removed drink", async () => {
  const log = { _id: "log", userId: "owner", drinkId: "removed", sessionId: null, consumedAt: 1000, volumeMl: 500, location: null, deletedAt: null };
  const ctx = { user: { _id: "owner" }, db: {
    async get(table) { return table === "drinkLog" ? log : { deletedAt: 1 }; },
    async patch(table, id, fields) { Object.assign(log, fields); },
  } };
  await update(ctx, { id: "log", drinkId: "removed", volumeMl: 250 });
  assert.equal(log.volumeMl, 250);
  assert.equal(log.drinkId, "removed");
  await assert.rejects(update(ctx, { id: "log", drinkId: "different-removed" }), /Drink not found/);
});

test("account deletion removes all owned logs, including soft-deleted ones", async () => {
  const tables = {
    user: [{ _id: "owner", authUserId: "auth-owner" }],
    drinkLog: [{ _id: "active", userId: "owner", deletedAt: null }, { _id: "deleted", userId: "owner", deletedAt: 1 }, { _id: "other-log", userId: "other" }],
    drink: [{ _id: "custom", ownerId: "owner" }, { _id: "global", ownerId: null }],
    badge: [{ _id: "badge", userId: "owner" }],
  };
  const ctx = { db: {
    query(table) {
      let rows = tables[table];
      return {
        withIndex(name, range) { const q = { eq(field, value) { rows = rows.filter((row) => row[field] === value); return q; } }; range(q); return this; },
        async unique() { return rows[0] ?? null; },
        async collect() { return rows; },
      };
    },
    async delete(table, id) { tables[table] = tables[table].filter((row) => row._id !== id); },
  } };
  await deleteUserData(ctx, "auth-owner");
  assert.deepEqual(tables.drinkLog.map((log) => log._id), ["other-log"]);
  assert.deepEqual(tables.drink.map((drink) => drink._id), ["global"]);
  assert.equal(tables.user.length, 0);
});
