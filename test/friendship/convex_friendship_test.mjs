import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";

const { outputFiles } = await build({
  stdin: {
    contents: `export * as mutations from "./convex/friendship/mutation";
      export * as queries from "./convex/friendship/query";
      export * as userQueries from "./convex/user/query";
      export { deleteUserData } from "./convex/user/deletion";`,
    resolveDir: process.cwd(),
  },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "authenticated-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authQuery = createBuilder().query(); export const authMutation = createBuilder().mutation();', loader: "ts",
    }));
  } }],
});
const { mutations, queries, userQueries, deleteUserData } = await import(
  `data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`
);

function fixture() {
  const tables = {
    user: ["a", "b", "c", "d"].map((_id) => ({
      _id, username: _id, normalizedUsername: _id, accentColor: "amber", authUserId: `auth-${_id}`,
      avatarStorageId: _id === "b" ? "avatar-b" : null,
      timeZone: "Europe/Prague", defaultDrink: null,
    })),
    friendship: [], drinkLog: [], drink: [], badge: [], session: [], sessionMember: [], leaderboard: [], leaderboardMember: [],
  };
  let sequence = 0;
  const db = {
    async get(table, id) { return structuredClone(tables[table].find((row) => row._id === id) ?? null); },
    async insert(table, fields) {
      const id = `${table}-${++sequence}`;
      tables[table].push({ _id: id, _creationTime: sequence, ...structuredClone(fields) });
      return id;
    },
    async patch(table, id, fields) {
      const row = tables[table].find((row) => row._id === id);
      assert.ok(row);
      Object.assign(row, structuredClone(fields));
    },
    async delete(table, id) { tables[table] = tables[table].filter((row) => row._id !== id); },
    query(table) {
      let rows = tables[table];
      return {
        withIndex(name, range) {
          const q = { eq(field, value) { rows = rows.filter((row) => row[field] === value); return q; } };
          range(q); return this;
        },
        async unique() { assert.ok(rows.length <= 1); return rows[0] ?? null; },
        async collect() { return rows; },
        async take(count) { return rows.slice(0, count); },
      };
    },
  };
  const ctx = (id) => ({ db, user: { _id: id }, storage: {
    async getUrl(id) { return `https://example.com/${id}`; },
    async delete() {},
  } });
  return { tables, db, ctx };
}

test("public profiles and username lookup expose only public data and exclude the current user", async () => {
  const f = fixture();
  const fields = ["_id", "accentColor", "avatarUrl", "username"];
  assert.deepEqual(Object.keys(await userQueries.get(f.ctx("a"), { userId: "b" })).sort(), fields);
  await assert.rejects(userQueries.get(f.ctx("a"), { userId: "missing" }), /User not found/);
  f.tables.user.find((user) => user._id === "b").normalizedUsername = "friend";
  f.tables.user.find((user) => user._id === "a").normalizedUsername = "friend";
  const matches = await userQueries.search(f.ctx("a"), { username: "  Fríend  " });
  assert.deepEqual(matches.map((user) => user._id), ["b"]);
  assert.deepEqual(Object.keys(matches[0]).sort(), fields);
  assert.deepEqual(await userQueries.search(f.ctx("a"), { username: "missing" }), []);
  await assert.rejects(userQueries.search(f.ctx("a"), { username: "ab" }));
  await assert.rejects(userQueries.search(f.ctx("a"), { username: "a".repeat(21) }));
});

test("requests use one canonical pair, require explicit acceptance and preserve timestamps on retries", async () => {
  const f = fixture();
  assert.equal(await queries.getStatus(f.ctx("b"), { userId: "a" }), "notFriends");
  await assert.rejects(mutations.sendRequest(f.ctx("b"), { userId: "b" }));
  await assert.rejects(mutations.sendRequest(f.ctx("b"), { userId: "missing" }));
  await mutations.sendRequest(f.ctx("b"), { userId: "a" });
  const pending = structuredClone(f.tables.friendship[0]);
  assert.equal(pending.userAId, "a");
  assert.equal(pending.userBId, "b");
  assert.equal(pending.requestedById, "b");
  await mutations.sendRequest(f.ctx("b"), { userId: "a" });
  await assert.rejects(mutations.sendRequest(f.ctx("a"), { userId: "b" }));
  assert.deepEqual(f.tables.friendship, [pending]);
  assert.equal(await queries.getStatus(f.ctx("b"), { userId: "a" }), "requestSent");
  assert.equal(await queries.getStatus(f.ctx("a"), { userId: "b" }), "requestReceived");
  await assert.rejects(mutations.accept(f.ctx("b"), { userId: "a" }));
  await assert.rejects(mutations.accept(f.ctx("c"), { userId: "b" }));
  await mutations.accept(f.ctx("a"), { userId: "b" });
  const accepted = structuredClone(f.tables.friendship[0]);
  await mutations.accept(f.ctx("a"), { userId: "b" });
  await mutations.sendRequest(f.ctx("b"), { userId: "a" });
  assert.deepEqual(f.tables.friendship, [accepted]);
  for (const [actor, other] of [["a", "b"], ["b", "a"]]) {
    assert.equal(await queries.getStatus(f.ctx(actor), { userId: other }), "friends");
  }
});

test("only the sender can cancel, only the recipient can decline, either friend can remove", async () => {
  const f = fixture();
  for (const action of ["cancel", "decline"]) {
    await mutations.sendRequest(f.ctx("a"), { userId: "b" });
    await assert.rejects(mutations.cancel(f.ctx("b"), { userId: "a" }));
    await assert.rejects(mutations.decline(f.ctx("a"), { userId: "b" }));
    await assert.rejects(mutations.remove(f.ctx("a"), { userId: "b" }));
    await mutations.remove(f.ctx("c"), { userId: "b" });
    assert.equal(f.tables.friendship.length, 1);
    const actor = action === "cancel" ? "a" : "b";
    const other = action === "cancel" ? "b" : "a";
    await mutations[action](f.ctx(actor), { userId: other });
    await mutations[action](f.ctx(actor), { userId: other });
    assert.equal(f.tables.friendship.length, 0);
  }
  for (const actor of ["a", "b"]) {
    await mutations.sendRequest(f.ctx("a"), { userId: "b" });
    await mutations.accept(f.ctx("b"), { userId: "a" });
    await assert.rejects(mutations.cancel(f.ctx("a"), { userId: "b" }));
    await assert.rejects(mutations.decline(f.ctx("b"), { userId: "a" }));
    await mutations.remove(f.ctx(actor), { userId: actor === "a" ? "b" : "a" });
    assert.equal(f.tables.friendship.length, 0);
  }
});

test("lists include both endpoints, separate pending from accepted and expose only public profiles", async () => {
  const f = fixture();
  await mutations.sendRequest(f.ctx("b"), { userId: "a" });
  await mutations.accept(f.ctx("a"), { userId: "b" });
  await mutations.sendRequest(f.ctx("b"), { userId: "c" });
  await mutations.sendRequest(f.ctx("d"), { userId: "b" });
  assert.deepEqual(await queries.listCurrent(f.ctx("a"), {}), [{
    _id: "b", username: "b", accentColor: "amber", avatarUrl: "https://example.com/avatar-b",
  }]);
  assert.deepEqual((await queries.listCurrent(f.ctx("b"), {})).map((user) => user._id), ["a"]);
  assert.deepEqual(await queries.listCurrent(f.ctx("c"), {}), []);
  const requests = await queries.listRequests(f.ctx("b"), {});
  assert.deepEqual(new Set(requests.map((request) => request.user._id)), new Set(["c", "d"]));
  for (const { user } of requests) {
    assert.deepEqual(Object.keys(user).sort(), ["_id", "accentColor", "avatarUrl", "username"]);
  }
  assert.deepEqual(await queries.listRequests(f.ctx("a"), {}), []);
});

test("account deletion removes pending and accepted relations at either endpoint", async () => {
  const f = fixture();
  await mutations.sendRequest(f.ctx("b"), { userId: "a" });
  await mutations.accept(f.ctx("a"), { userId: "b" });
  await mutations.sendRequest(f.ctx("b"), { userId: "c" });
  await mutations.sendRequest(f.ctx("d"), { userId: "b" });
  await mutations.sendRequest(f.ctx("c"), { userId: "d" });
  await deleteUserData(f.ctx("b"), "auth-b");
  assert.equal(await f.db.get("user", "b"), null);
  assert.equal(f.tables.friendship.length, 1);
  assert.equal(f.tables.friendship[0].userAId, "c");
  assert.deepEqual(await queries.listCurrent(f.ctx("a"), {}), []);
  await deleteUserData(f.ctx("b"), "auth-b");
});
