import assert from 'node:assert/strict';
import test from 'node:test';
import { build } from 'esbuild';

const { outputFiles } = await build({
  stdin: { contents: 'export { stats } from "./convex/user/query";', resolveDir: process.cwd() },
  bundle: true, platform: 'node', format: 'esm', write: false,
  plugins: [{ name: 'authenticated-context', setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authQuery = createBuilder().query();', loader: 'ts',
    }));
  } }],
});
const { stats } = await import(`data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString('base64')}`);

function fixture(timeZone = 'UTC', endOfDayBoundary = 360) {
  const user = { _id: 'target', timeZone, endOfDayBoundary };
  const drinks = {
    beer: { drinkCategory: { kind: 'beer' }, alcoholPercentage: 5 },
    wine: { drinkCategory: { kind: 'wine' }, alcoholPercentage: 12 },
    sober: { drinkCategory: { kind: 'beer' }, alcoholPercentage: 0 },
  };
  const logs = [];
  const reads = new Map();
  const ctx = { user: { _id: 'viewer' }, db: {
    async get(table, id) {
      reads.set(id, (reads.get(id) ?? 0) + 1);
      return table === 'user' ? (id === 'target' ? user : null) : drinks[id] ?? null;
    },
    query(table) {
      assert.equal(table, 'drinkLog');
      let rows = logs;
      return {
        withIndex(name, filter) {
          assert.equal(name, 'by_userId_and_deletedAt_and_consumedAt');
          const range = { eq(field, value) { rows = rows.filter(row => row[field] === value); return range; } };
          filter(range); return this;
        },
        async collect() { return rows; },
      };
    },
  } };
  return { reads, logs, drinks,
    log(at, drinkId = 'beer', volumeMl = 500, extra = {}) {
      logs.push({ consumedAt: Date.parse(at), drinkId, volumeMl, userId: 'target', deletedAt: null, ...extra });
    },
    async run(at, userId = 'target') {
      const original = Date.now;
      Date.now = () => Date.parse(at);
      try { return await stats(ctx, { userId }); } finally { Date.now = original; }
    },
  };
}

test('empty history and nonexistent users', async () => {
  const f = fixture();
  assert.deepEqual(await f.run('2026-10-12T12:00Z'), {
    totalBeersConsumed: 0, totalAlcoholConsumed: 0,
    beersConsumedLast30Days: 0, alcoholConsumedLast30Days: 0,
    streakDays: 0, isStreakActive: false, nextRefreshAt: Date.parse('2026-10-13T06:00Z'),
  });
  await assert.rejects(f.run('2026-10-12T12:00Z', 'missing'), /User not found/);
});

test('totals, inclusive 30 logical days, future/deleted logs, user isolation and cached drinks', async () => {
  const f = fixture();
  f.log('2026-09-13T05:59Z'); // outside the window
  f.log('2026-09-13T06:00Z'); // first included logical day
  f.log('2026-10-12T07:00Z', 'wine', 100);
  f.log('2026-10-12T08:00Z', 'sober');
  f.log('2026-10-12T13:00Z'); // future
  f.log('2026-10-12T09:00Z', 'beer', 500, { deletedAt: 1 });
  f.log('2026-10-12T09:00Z', 'beer', 500, { userId: 'viewer' });
  const result = await f.run('2026-10-12T12:00Z');
  assert.equal(result.totalBeersConsumed, 3);
  assert.equal(result.totalAlcoholConsumed, 62);
  assert.equal(result.beersConsumedLast30Days, 2);
  assert.equal(result.alcoholConsumedLast30Days, 37);
  assert.equal(result.nextRefreshAt, Date.parse('2026-10-12T13:00Z'));
  assert.equal(f.reads.get('beer'), 1);
  assert.equal((await f.run('2026-10-12T13:00Z')).totalBeersConsumed, 4);
});

test('active and yesterday-ending streaks, gaps and zero alcohol', async () => {
  const f = fixture();
  f.log('2026-10-10T07:00Z');
  f.log('2026-10-11T07:00Z');
  f.log('2026-10-11T08:00Z');
  f.log('2026-10-12T07:00Z', 'sober');
  let result = await f.run('2026-10-12T12:00Z');
  assert.equal(result.streakDays, 2);
  assert.equal(result.isStreakActive, false);
  f.log('2026-10-12T08:00Z');
  result = await f.run('2026-10-12T12:00Z');
  assert.equal(result.streakDays, 3);
  assert.equal(result.isStreakActive, true);
  assert.equal((await f.run('2026-10-14T12:00Z')).streakDays, 0);
});

test('target timezone, custom day boundary and DST rollover', async () => {
  const f = fixture('Europe/Prague', 360);
  f.log('2026-03-27T12:00Z');
  f.log('2026-03-28T12:00Z');
  f.log('2026-03-29T03:59Z'); // still March 28
  let result = await f.run('2026-03-29T03:59Z');
  assert.equal(result.streakDays, 2);
  assert.equal(result.isStreakActive, true);
  assert.equal(result.nextRefreshAt, Date.parse('2026-03-29T04:00Z'));
  result = await f.run('2026-03-29T04:00Z');
  assert.equal(result.streakDays, 2);
  assert.equal(result.isStreakActive, false);
  assert.equal(result.nextRefreshAt, Date.parse('2026-03-30T04:00Z'));
  const tokyo = fixture('Asia/Tokyo', 90);
  tokyo.log('2026-10-11T16:29Z');
  assert.equal((await tokyo.run('2026-10-11T16:30Z')).isStreakActive, false);
});

test('missing drinks fail explicitly and catalog changes affect totals', async () => {
  const f = fixture();
  f.log('2026-10-12T07:00Z');
  f.drinks.beer.alcoholPercentage = 10;
  assert.equal((await f.run('2026-10-12T12:00Z')).totalAlcoholConsumed, 50);
  delete f.drinks.beer;
  await assert.rejects(f.run('2026-10-12T12:00Z'), /logged drink is missing/);
});
