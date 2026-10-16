import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";

const { outputFiles } = await build({
  stdin: {
    contents: `export * as queries from "./convex/drink/query";
      export * as mutations from "./convex/drink/mutation";`,
    resolveDir: process.cwd(),
  },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "authenticated-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authQuery = createBuilder().query(); export const authMutation = createBuilder().mutation();',
      loader: "ts",
    }));
  } }],
});
const { queries, mutations } = await import(
  `data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`
);

function fixture() {
  const drink = {
    _id: "drink-1", _creationTime: 1, ownerId: "owner", name: "Lager",
    drinkCategory: { kind: "beer" }, alcoholPercentage: 5,
    updatedAt: 1, deletedAt: null,
  };
  const reads = [];
  const writes = [];
  const ctx = {
    user: { _id: "owner" },
    db: {
      async get(table, id) {
        reads.push({ table, id });
        return id === drink._id ? structuredClone(drink) : null;
      },
      async patch(table, id, fields) {
        writes.push({ table, id, fields });
        Object.assign(drink, fields);
      },
    },
  };
  return { drink, ctx, reads, writes };
}

for (const registered of [false, true]) {
  const invoke = (endpoint, ctx, input) => registered
    ? endpoint.public()._handler(ctx, input)
    : endpoint(ctx, input);
  const mode = registered ? "registered" : "direct";

  test(`${mode} drink handlers load once and preserve partial updates and soft deletion`, async () => {
    const f = fixture();
    const input = { id: f.drink._id };
    assert.deepEqual(await invoke(queries.get, f.ctx, input), f.drink);
    assert.equal(f.reads.length, 1);

    assert.equal(await invoke(mutations.update, f.ctx, {
      ...input, name: "Renamed",
    }), null);
    assert.equal(f.reads.length, 2);
    assert.equal(f.drink.name, "Renamed");
    assert.equal(f.drink.alcoholPercentage, 5);
    assert.deepEqual(f.drink.drinkCategory, { kind: "beer" });
    assert.equal(f.drink.deletedAt, null);

    assert.equal(await invoke(mutations.softDelete, f.ctx, input), null);
    assert.equal(f.reads.length, 3);
    assert.equal(typeof f.drink.deletedAt, "number");
    assert.equal(f.drink.deletedAt, f.drink.updatedAt);
  });

  test(`${mode} drink handlers reject missing, foreign, global and deleted drinks before writing`, async () => {
    for (const endpoint of [queries.get, mutations.update, mutations.softDelete]) {
      for (const state of ["missing", "foreign", "global", "deleted"]) {
        const f = fixture();
        if (state === "foreign") f.drink.ownerId = "other";
        if (state === "global") f.drink.ownerId = null;
        if (state === "deleted") f.drink.deletedAt = 2;
        const before = structuredClone(f.drink);
        const error = state === "missing" ? /Drink not found/
          : state === "deleted" ? /Drink has been deleted/ : /permission/;

        await assert.rejects(invoke(endpoint, f.ctx, {
          id: state === "missing" ? "missing" : f.drink._id,
        }), error);
        assert.equal(f.reads.length, 1);
        assert.deepEqual(f.writes, []);
        assert.deepEqual(f.drink, before);
      }
    }
  });

  test(`${mode} drink updates validate input before loading a drink`, async () => {
    const f = fixture();
    await assert.rejects(invoke(mutations.update, f.ctx, {
      id: f.drink._id, alcoholPercentage: 100,
    }));
    assert.deepEqual(f.reads, []);
    assert.deepEqual(f.writes, []);
  });
}
