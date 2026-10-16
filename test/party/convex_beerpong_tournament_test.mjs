import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";
import { fixture } from "../support/party_fixture.mjs";

const { outputFiles } = await build({
  stdin: {
    contents: 'export { create } from "./convex/beerpongTournament";',
    resolveDir: process.cwd(),
  },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "authenticated-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authMutation = createBuilder().mutation();',
      loader: "ts",
    }));
  } }],
});
const { create } = await import(
  `data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`,
);

function setup() {
  const f = fixture();
  f.tables.beerpongTournament = [];
  f.tables.beerpongTeam = [];
  f.tables.beerpongMatch = [];
  f.tables.session[0].modules = { beerpongEnabled: true };
  f.member("b").sessionMemberRole.kind = "admin";
  f.ctx("owner").db.insert = async (table, fields) => {
    const id = `${table}-${f.tables[table].length}`;
    f.tables[table].push({ _id: id, ...structuredClone(fields) });
    return id;
  };
  const input = {
    sessionId: "party", name: "  Friday cup  ", teamCount: 4,
    thirdPlaceEnabled: true,
    firstPlacePointsUnits: 30000, secondPlacePointsUnits: 20000,
    thirdPlacePointsUnits: 10000,
  };
  const run = (extra = {}, actor = "owner") =>
    create._handler(f.ctx(actor), { ...input, ...extra });
  return { ...f, input, run };
}

test("owner and joined admins create enrollment tournaments without drawing teams", async () => {
  const f = setup();
  for (const actor of ["owner", "b"]) {
    const before = Date.now();
    const id = await f.run({}, actor);
    const row = f.tables.beerpongTournament.find(row => row._id === id);
    assert.deepEqual(row, {
      _id: id, ...f.input, name: "Friday cup", status: "enrollment",
      createdByUserId: actor, updatedAt: row.updatedAt, completedAt: null,
    });
    assert.ok(row.updatedAt >= before && row.updatedAt <= Date.now());
  }
  assert.deepEqual(f.tables.beerpongTeam, []);
  assert.deepEqual(f.tables.beerpongMatch, []);
});

test("members, outsiders, and non-joined admins cannot create tournaments", async () => {
  const f = setup();
  for (const actor of ["a", "other", "invited", "left", "banned"]) {
    if (actor !== "other") f.member(actor).sessionMemberRole.kind = "admin";
    if (actor === "a") f.member(actor).sessionMemberRole.kind = "member";
    await assert.rejects(f.run({}, actor), /permission/);
  }
  assert.deepEqual(f.tables.beerpongTournament, []);
});

test("creation requires an existing, ongoing party with beerpong enabled", async () => {
  const cases = [
    [{ kind: "session" }, /party/],
    [{ endedAt: 1000 }, /read-only/],
    [{ deletedAt: 1000 }, /not found/],
    [{ modules: { beerpongEnabled: false } }, /disabled/],
  ];
  for (const [fields, error] of cases) {
    const f = setup();
    Object.assign(f.tables.session[0], fields);
    await assert.rejects(f.run(), error);
    assert.deepEqual(f.tables.beerpongTournament, []);
  }
  const f = setup();
  await assert.rejects(f.run({ sessionId: "missing" }), /not found/);
});

test("creation validates names, integer team counts, and placement point bounds and order", async () => {
  const f = setup();
  const invalid = [
    { name: " " }, { name: "x".repeat(121) },
    { teamCount: 1 }, { teamCount: 17 }, { teamCount: 2.5 },
    { thirdPlaceEnabled: "true" },
    { firstPlacePointsUnits: 10000, secondPlacePointsUnits: 20000 },
    { secondPlacePointsUnits: 5000, thirdPlacePointsUnits: 10000 },
  ];
  for (const field of ["firstPlacePointsUnits", "secondPlacePointsUnits", "thirdPlacePointsUnits"])
    for (const value of [0, 999, 500001, 1000.5, NaN, Infinity])
      invalid.push({ [field]: value });
  for (const extra of invalid) await assert.rejects(f.run(extra));
  assert.deepEqual(f.tables.beerpongTournament, []);
  for (const teamCount of [2, 16])
    for (const points of [1000, 500000])
      await f.run({
        teamCount, thirdPlaceEnabled: false,
        firstPlacePointsUnits: points, secondPlacePointsUnits: points,
        thirdPlacePointsUnits: points,
      });
  assert.equal(f.tables.beerpongTournament.length, 4);
});
