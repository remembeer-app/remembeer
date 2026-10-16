import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";
import { fixture } from "../support/party_fixture.mjs";

const { outputFiles } = await build({
  stdin: {
    contents: 'export { create, draw } from "./convex/beerpongTournament";',
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
const { create, draw } = await import(
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
  f.ctx("owner").db.patch = async (table, id, fields) => {
    const row = f.tables[table].find(row => row._id === id);
    assert.ok(row);
    Object.assign(row, structuredClone(fields));
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

function enroll(f, userId) {
  f.tables.user.push({ _id: userId });
  f.tables.sessionMember.push({
    _id: `member-${userId}`, sessionId: "party", userId, kind: "partyMember",
    sessionMemberStatus: { kind: "joined" },
    sessionMemberRole: { kind: "member" }, beerpongOptIn: true,
  });
}

const runDraw = (f, id, actor = "owner") => draw._handler(f.ctx(actor), { id });

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

test("draw assigns every eligible member once, balances teams, and enters setup without matches", async () => {
  for (const [teamCount, playerCount] of [[2, 2], [3, 7], [4, 8], [16, 33]]) {
    const f = setup();
    const id = await f.run({ teamCount });
    for (let index = 0; index < playerCount; index++) enroll(f, `player-${index}`);
    const before = Date.now();
    assert.equal(await runDraw(f, id, "b"), null);
    const teams = f.tables.beerpongTeam;
    assert.equal(teams.length, teamCount);
    const assigned = teams.flatMap(team => team.memberUserIds);
    assert.equal(new Set(assigned).size, playerCount);
    assert.deepEqual(assigned.toSorted(),
      Array.from({ length: playerCount }, (_, index) => `player-${index}`).toSorted());
    const sizes = teams.map(team => team.memberUserIds.length);
    assert.ok(Math.min(...sizes) > 0);
    assert.ok(Math.max(...sizes) - Math.min(...sizes) <= 1);
    for (const [index, team] of teams.entries()) {
      assert.equal(team.tournamentId, id);
      assert.equal(team.seed, index + 1);
      assert.equal(team.name, `Team ${index + 1}`);
      assert.ok(team.updatedAt >= before && team.updatedAt <= Date.now());
    }
    const tournament = f.tables.beerpongTournament[0];
    assert.equal(tournament.status, "setup");
    assert.equal(tournament.completedAt, null);
    assert.equal(tournament.updatedAt, teams[0].updatedAt);
    assert.deepEqual(f.tables.beerpongMatch, []);
    const saved = structuredClone(teams);
    await assert.rejects(runDraw(f, id), /enrollment/);
    assert.deepEqual(teams, saved);
  }
});

test("draw uses current opt-ins and excludes non-joined members, ordinary members, and other parties", async () => {
  const f = setup();
  const id = await f.run({ teamCount: 2 });
  for (const member of f.tables.sessionMember) member.beerpongOptIn = true;
  f.member("a").beerpongOptIn = false;
  f.member("unclassed").kind = "sessionMember";
  enroll(f, "elsewhere");
  f.member("elsewhere").sessionId = "different-party";
  await runDraw(f, id);
  assert.deepEqual(f.tables.beerpongTeam.flatMap(team => team.memberUserIds).toSorted(), ["b", "owner"]);
  const saved = structuredClone(f.tables.beerpongTeam);
  f.member("a").beerpongOptIn = true;
  f.member("b").beerpongOptIn = false;
  assert.deepEqual(f.tables.beerpongTeam, saved);
});

test("draw shuffles players rather than keeping membership query order", async () => {
  const f = setup();
  const id = await f.run({ teamCount: 2 });
  for (const userId of ["p0", "p1", "p2", "p3"]) enroll(f, userId);
  const original = Math.random;
  let calls = 0;
  Math.random = () => { calls++; return 0; };
  try { await runDraw(f, id); } finally { Math.random = original; }
  assert.equal(calls, 3);
  assert.deepEqual(f.tables.beerpongTeam.map(team => team.memberUserIds), [["p1", "p3"], ["p2", "p0"]]);
});

test("insufficient opt-ins leave enrollment untouched and can be retried after members opt in", async () => {
  const f = setup();
  const id = await f.run({ teamCount: 2 });
  for (const count of [0, 1]) {
    if (count) f.member("a").beerpongOptIn = true;
    const before = structuredClone(f.tables.beerpongTournament);
    await assert.rejects(runDraw(f, id), /Not enough/);
    assert.deepEqual(f.tables.beerpongTournament, before);
    assert.deepEqual(f.tables.beerpongTeam, []);
  }
  f.member("b").beerpongOptIn = true;
  await runDraw(f, id);
  assert.equal(f.tables.beerpongTeam.length, 2);
});

test("draw rejects unauthorized callers and tournaments outside enrollment", async () => {
  const f = setup();
  const id = await f.run({ teamCount: 2 });
  enroll(f, "p0"); enroll(f, "p1");
  for (const actor of ["a", "other", "invited", "left", "banned"]) {
    if (["invited", "left", "banned"].includes(actor)) f.member(actor).sessionMemberRole.kind = "admin";
    await assert.rejects(runDraw(f, id, actor), /permission/);
  }
  await assert.rejects(runDraw(f, "missing"), /Tournament not found/);
  for (const status of ["setup", "active", "completed", "cancelled"]) {
    f.tables.beerpongTournament[0].status = status;
    await assert.rejects(runDraw(f, id), /enrollment/);
  }
  assert.deepEqual(f.tables.beerpongTeam, []);
});

test("draw requires ongoing, non-deleted parties with beerpong enabled and checks the tournament's party", async () => {
  for (const [fields, error] of [
    [{ kind: "session" }, /party/],
    [{ endedAt: 1000 }, /read-only/],
    [{ deletedAt: 1000 }, /not found/],
    [{ modules: { beerpongEnabled: false } }, /disabled/],
  ]) {
    const f = setup();
    const id = await f.run({ teamCount: 2 });
    enroll(f, "p0"); enroll(f, "p1");
    Object.assign(f.tables.session[0], fields);
    await assert.rejects(runDraw(f, id), error);
    assert.deepEqual(f.tables.beerpongTeam, []);
    assert.equal(f.tables.beerpongTournament[0].status, "enrollment");
  }
  const f = setup();
  const id = await f.run();
  f.tables.session.push({ ...f.tables.session[0], _id: "private", ownerId: "other" });
  f.tables.beerpongTournament[0].sessionId = "private";
  await assert.rejects(runDraw(f, id), /permission/);
});
