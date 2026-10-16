import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";
import { fixture } from "../support/party_fixture.mjs";

const { outputFiles } = await build({
  stdin: {
    contents: 'export { create, draw, start } from "./convex/beerpongTournament"; export * as teams from "./convex/beerpongTeam";',
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
const { create, draw, start, teams } = await import(
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
const runStart = (f, id, actor = "owner") => start._handler(f.ctx(actor), { id });

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

async function teamSetup() {
  const f = setup();
  const tournamentId = await f.run({ teamCount: 2 });
  enroll(f, "p0"); enroll(f, "p1");
  await runDraw(f, tournamentId);
  const [first, second] = f.tables.beerpongTeam;
  const runTeam = (name, args, actor = "owner") => teams[name]._handler(f.ctx(actor), args);
  return { ...f, tournamentId, first, second, runTeam };
}

test("admins can rename, add opted-out members, move, and remove players during setup and active play", async () => {
  for (const status of ["setup", "active"]) {
    const f = await teamSetup();
    f.tables.beerpongTournament[0].status = status;
    f.tables.beerpongMatch.push({ _id: "match", winnerTeamId: f.first._id });
    const savedMatches = structuredClone(f.tables.beerpongMatch);
    await f.runTeam("rename", { id: f.first._id, name: "  The Bees  " }, "b");
    assert.equal(f.first.name, "The Bees");
    assert.equal(f.member("a").beerpongOptIn, undefined);
    await f.runTeam("addMember", { id: f.first._id, userId: "a" }, "b");
    await f.runTeam("addMember", { id: f.first._id, userId: "a" });
    assert.equal(f.first.memberUserIds.filter(id => id === "a").length, 1);
    const saved = structuredClone(f.tables.beerpongTeam);
    await assert.rejects(f.runTeam("addMember", { id: f.second._id, userId: "a" }), /another team/);
    assert.deepEqual(f.tables.beerpongTeam, saved);
    await f.runTeam("moveMember", { id: f.first._id, userId: "a", targetTeamId: f.second._id });
    assert.ok(!f.first.memberUserIds.includes("a"));
    assert.equal(f.second.memberUserIds.filter(id => id === "a").length, 1);
    assert.equal(f.first.updatedAt, f.second.updatedAt);
    assert.equal(f.second.updatedAt, f.tables.beerpongTournament[0].updatedAt);
    // A departure must not prevent an admin from removing the old roster entry.
    f.member("a").sessionMemberStatus.kind = "left";
    await f.runTeam("removeMember", { id: f.second._id, userId: "a" });
    await f.runTeam("removeMember", { id: f.second._id, userId: "a" });
    assert.ok(!f.second.memberUserIds.includes("a"));
    assert.deepEqual(f.tables.beerpongMatch, savedMatches);
    assert.equal(f.tables.beerpongTournament[0].status, status);
  }
});

test("team edits require admin access and leave all teams unchanged on rejected calls", async () => {
  const f = await teamSetup();
  for (const actor of ["a", "other", "invited", "left", "banned"]) {
    if (["invited", "left", "banned"].includes(actor)) f.member(actor).sessionMemberRole.kind = "admin";
    for (const [name, args] of teamActions(f)) {
      const saved = structuredClone(f.tables);
      await assert.rejects(f.runTeam(name, args, actor), /permission/);
      assert.deepEqual(f.tables, saved);
    }
  }
});

function teamActions(f) {
  return [
    ["rename", { id: f.first._id, name: "New name" }],
    ["addMember", { id: f.first._id, userId: "a" }],
    ["removeMember", { id: f.first._id, userId: f.first.memberUserIds[0] }],
    ["moveMember", { id: f.first._id, userId: f.first.memberUserIds[0], targetTeamId: f.second._id }],
  ];
}

test("all team edits lock outside setup/active and when the party ends, is deleted, or disables beerpong", async () => {
  for (const status of ["enrollment", "completed", "cancelled"]) {
    const f = await teamSetup();
    f.tables.beerpongTournament[0].status = status;
    const saved = structuredClone(f.tables);
    for (const [name, args] of teamActions(f))
      await assert.rejects(f.runTeam(name, args), /setup or active/);
    assert.deepEqual(f.tables, saved);
  }
  for (const [fields, error] of [
    [{ endedAt: 1000 }, /read-only/], [{ deletedAt: 1000 }, /not found/],
    [{ modules: { beerpongEnabled: false } }, /disabled/], [{ kind: "session" }, /party/],
  ]) {
    const f = await teamSetup();
    Object.assign(f.tables.session[0], fields);
    const saved = structuredClone(f.tables);
    for (const [name, args] of teamActions(f)) await assert.rejects(f.runTeam(name, args), error);
    assert.deepEqual(f.tables, saved);
  }
});

test("adding and moving require current joined party membership and an existing user", async () => {
  const f = await teamSetup();
  for (const userId of ["invited", "left", "banned", "other", "missing"]) {
    await assert.rejects(f.runTeam("addMember", { id: f.first._id, userId }), /joined party member/);
  }
  f.member("a").kind = "sessionMember";
  await assert.rejects(f.runTeam("addMember", { id: f.first._id, userId: "a" }), /joined party member/);
  f.member("a").kind = "partyMember";
  f.member("a").sessionId = "another-party";
  await assert.rejects(f.runTeam("addMember", { id: f.first._id, userId: "a" }), /joined party member/);
  f.member("a").sessionId = "party";
  f.tables.user = f.tables.user.filter(user => user._id !== "a");
  await assert.rejects(f.runTeam("addMember", { id: f.first._id, userId: "a" }), /joined party member/);
  const player = f.first.memberUserIds[0];
  f.member(player).sessionMemberStatus.kind = "left";
  const saved = structuredClone(f.tables.beerpongTeam);
  await assert.rejects(f.runTeam("moveMember", { id: f.first._id, userId: player, targetTeamId: f.second._id }), /joined party member/);
  assert.deepEqual(f.tables.beerpongTeam, saved);
});

test("moving rejects missing players, missing teams, and other tournaments without changing either roster", async () => {
  const f = await teamSetup();
  const otherTournamentId = await f.run({ teamCount: 2 });
  await runDraw(f, otherTournamentId);
  const foreign = f.tables.beerpongTeam.find(team => team.tournamentId === otherTournamentId);
  const saved = structuredClone(f.tables.beerpongTeam);
  for (const [targetTeamId, userId, error] of [
    [foreign._id, f.first.memberUserIds[0], /same tournament/],
    ["missing", f.first.memberUserIds[0], /Target team not found/],
    [f.second._id, "a", /source team/],
  ]) await assert.rejects(f.runTeam("moveMember", { id: f.first._id, userId, targetTeamId }), error);
  await f.runTeam("moveMember", { id: f.first._id, userId: f.first.memberUserIds[0], targetTeamId: f.first._id });
  assert.deepEqual(f.tables.beerpongTeam, saved);
  // The same player may participate in separate tournaments.
  await f.runTeam("addMember", { id: f.first._id, userId: "a" });
  await f.runTeam("addMember", { id: foreign._id, userId: "a" });
});

test("team names are trimmed and bounded; missing teams/tournaments and foreign parties are rejected", async () => {
  const f = await teamSetup();
  for (const name of [" ", "x".repeat(31)])
    await assert.rejects(f.runTeam("rename", { id: f.first._id, name }));
  await f.runTeam("rename", { id: f.first._id, name: "x".repeat(30) });
  for (const [name, args] of teamActions(f))
    await assert.rejects(f.runTeam(name, { ...args, id: "missing" }), /Team not found/);
  f.tables.beerpongTournament[0].sessionId = "missing";
  await assert.rejects(f.runTeam("rename", { id: f.first._id, name: "New" }), /not found/);
  f.tables.session.push({ ...f.tables.session[0], _id: "private", ownerId: "other" });
  f.tables.beerpongTournament[0].sessionId = "private";
  for (const [name, args] of teamActions(f)) await assert.rejects(f.runTeam(name, args), /permission/);
  f.tables.beerpongTournament = [];
  await assert.rejects(f.runTeam("rename", { id: f.first._id, name: "New" }), /Tournament not found/);
});

test("start builds valid single-elimination brackets for every supported team count", async () => {
  for (let teamCount = 2; teamCount <= 16; teamCount++) {
    for (const thirdPlaceEnabled of [false, true]) {
      const f = setup();
      const id = await f.run({ teamCount, thirdPlaceEnabled });
      for (let index = 0; index < teamCount; index++) enroll(f, `p${index}`);
      await runDraw(f, id);
      const roster = structuredClone(f.tables.beerpongTeam);
      const before = Date.now();
      assert.equal(await runStart(f, id, "b"), null);
      const matches = f.tables.beerpongMatch;
      const size = 2 ** Math.ceil(Math.log2(teamCount));
      const rounds = Math.log2(size);
      const main = matches.filter(match => match.kind === "main");
      const bronze = matches.filter(match => match.kind === "thirdPlace");
      assert.equal(main.length, size - 1);
      assert.equal(bronze.length, thirdPlaceEnabled && teamCount >= 4 ? 1 : 0);
      assert.deepEqual(f.tables.beerpongTeam, roster);
      assert.equal(f.tables.beerpongTournament[0].status, "active");
      const timestamp = f.tables.beerpongTournament[0].updatedAt;
      assert.ok(timestamp >= before && timestamp <= Date.now());
      assert.equal(f.tables.beerpongTournament[0].completedAt, null);
      const firstRound = main.filter(match => match.round === 1);
      const slots = firstRound.flatMap(match => [match.slotA, match.slotB]);
      assert.deepEqual(slots.filter(slot => slot.kind === "team").map(slot => slot.teamId).toSorted(),
        roster.map(team => team._id).toSorted());
      assert.equal(slots.filter(slot => slot.kind === "bye").length, size - teamCount);
      assert.equal(main.filter(match => match.winnerTeamId !== null).length, size - teamCount);
      const byId = new Map(matches.map(match => [match._id, match]));
      const positions = new Set();
      for (const match of matches) {
        assert.equal(match.tournamentId, id);
        assert.equal(match.updatedAt, timestamp);
        const key = `${match.round}:${match.position}`;
        assert.ok(!positions.has(key)); positions.add(key);
        for (const slot of [match.slotA, match.slotB]) {
          if (slot.kind === "winner" || slot.kind === "loser") {
            const source = byId.get(slot.matchId);
            assert.ok(source);
            assert.equal(source.round, match.round - 1);
            assert.equal(source.kind, "main");
          }
        }
        if ([match.slotA, match.slotB].some(slot => slot.kind === "bye")) {
          const opponent = [match.slotA, match.slotB].find(slot => slot.kind === "team");
          assert.ok(opponent);
          assert.equal(match.winnerTeamId, opponent.teamId);
          assert.equal(match.completedAt, timestamp);
        } else {
          assert.equal(match.winnerTeamId, null);
          assert.equal(match.completedAt, null);
        }
      }
      for (let round = 1; round <= rounds; round++)
        assert.equal(main.filter(match => match.round === round).length, size / (2 ** round));
      if (bronze.length) {
        assert.equal(bronze[0].round, rounds);
        const final = main.find(match => match.round === rounds);
        assert.deepEqual([bronze[0].slotA, bronze[0].slotB],
          [final.slotA, final.slotB].map(slot => ({ ...slot, kind: "loser" })));
      }
      // Resolve a complete hypothetical tournament to verify every path is playable.
      const outcomes = new Map();
      const resolve = slot => slot.kind === "bye" ? null : slot.kind === "team"
        ? slot.teamId : outcomes.get(slot.matchId)[slot.kind];
      let games = 0;
      for (const match of matches) {
        const a = resolve(match.slotA); const b = resolve(match.slotB);
        assert.ok(a || b);
        if (a && b) { assert.notEqual(a, b); games++; }
        outcomes.set(match._id, { winner: a ?? b, loser: a && b ? b : null });
      }
      assert.equal(games, teamCount - 1 + bronze.length);
      const saved = structuredClone(f.tables);
      await assert.rejects(runStart(f, id), /setup/);
      assert.deepEqual(f.tables, saved);
    }
  }
});

test("start shuffles team positions independently of the earlier player draw", async () => {
  const f = setup();
  const id = await f.run({ teamCount: 4 });
  for (let index = 0; index < 4; index++) enroll(f, `p${index}`);
  await runDraw(f, id);
  const original = Math.random;
  let calls = 0;
  Math.random = () => { calls++; return 0; };
  try { await runStart(f, id); } finally { Math.random = original; }
  assert.equal(calls, 3);
  const ids = f.tables.beerpongTeam.map(team => team._id);
  const slots = f.tables.beerpongMatch.filter(match => match.round === 1)
    .flatMap(match => [match.slotA.teamId, match.slotB.teamId]);
  assert.deepEqual(slots, [ids[1], ids[0], ids[2], ids[3]]);
});

test("start enforces admin access, setup status, and ongoing enabled party state", async () => {
  const f = await teamSetup();
  for (const actor of ["a", "other", "invited", "left", "banned"]) {
    if (["invited", "left", "banned"].includes(actor)) f.member(actor).sessionMemberRole.kind = "admin";
    await assert.rejects(runStart(f, f.tournamentId, actor), /permission/);
  }
  await assert.rejects(runStart(f, "missing"), /Tournament not found/);
  for (const status of ["enrollment", "active", "completed", "cancelled"]) {
    f.tables.beerpongTournament[0].status = status;
    await assert.rejects(runStart(f, f.tournamentId), /setup/);
  }
  assert.deepEqual(f.tables.beerpongMatch, []);
  for (const [fields, error] of [
    [{ kind: "session" }, /party/], [{ endedAt: 1000 }, /read-only/],
    [{ deletedAt: 1000 }, /not found/], [{ modules: { beerpongEnabled: false } }, /disabled/],
  ]) {
    const f = await teamSetup();
    Object.assign(f.tables.session[0], fields);
    const saved = structuredClone(f.tables);
    await assert.rejects(runStart(f, f.tournamentId), error);
    assert.deepEqual(f.tables, saved);
  }
  const other = await teamSetup();
  other.tables.session.push({ ...other.tables.session[0], _id: "private", ownerId: "other" });
  other.tables.beerpongTournament[0].sessionId = "private";
  await assert.rejects(runStart(other, other.tournamentId), /permission/);
});

test("invalid rosters, team counts, or an existing bracket prevent start without writes", async () => {
  for (const [change, error] of [
    [f => { f.first.memberUserIds = []; }, /at least one/],
    [f => { f.tables.beerpongTeam.pop(); }, /team count/],
    [f => { f.second.memberUserIds.push(f.first.memberUserIds[0]); }, /multiple teams/],
    [f => { f.first.memberUserIds.push(f.first.memberUserIds[0]); }, /multiple teams/],
    [f => { f.member(f.first.memberUserIds[0]).sessionMemberStatus.kind = "left"; }, /joined party/],
    [f => { f.member(f.first.memberUserIds[0]).kind = "sessionMember"; }, /joined party/],
    [f => { f.tables.beerpongMatch.push({ _id: "existing", tournamentId: f.tournamentId }); }, /already has a bracket/],
  ]) {
    const f = await teamSetup(); change(f);
    const saved = structuredClone(f.tables);
    await assert.rejects(runStart(f, f.tournamentId), error);
    assert.deepEqual(f.tables, saved);
  }
});

test("start isolates tournaments and ignores opt-in changes after the draw", async () => {
  const f = await teamSetup();
  const other = await f.run({ teamCount: 2 });
  await runDraw(f, other);
  for (const member of f.tables.sessionMember) member.beerpongOptIn = false;
  await runStart(f, f.tournamentId);
  assert.ok(f.tables.beerpongMatch.every(match => match.tournamentId === f.tournamentId));
  assert.equal(f.tables.beerpongTournament.find(row => row._id === other).status, "setup");
  await runStart(f, other);
  assert.equal(f.tables.beerpongMatch.filter(match => match.tournamentId === other).length, 1);
});
