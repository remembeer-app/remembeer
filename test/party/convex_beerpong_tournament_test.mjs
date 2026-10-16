import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";
import { fixture } from "../support/party_fixture.mjs";

const { outputFiles } = await build({
  stdin: {
    contents: 'export { create, draw, start, finalize, setEnabled, get as getTournament, listForSession } from "./convex/beerpongTournament"; export * as teams from "./convex/beerpongTeam"; export * as results from "./convex/beerpongMatch"; export { standings } from "./convex/party/query"; export { activity } from "./convex/party/activity"; export { loadQuestContext } from "./convex/partyQuest/context";',
    resolveDir: process.cwd(),
  },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "authenticated-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authMutation = createBuilder().mutation(); export const authQuery = createBuilder().query();',
      loader: "ts",
    }));
  } }],
});
const { create, draw, start, finalize, setEnabled, getTournament, listForSession, teams, results, standings, activity, loadQuestContext } = await import(
  `data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`,
);

function setup() {
  const f = fixture(standings);
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
  const originalQuery = f.ctx("owner").db.query;
  f.ctx("owner").db.query = table => {
    const query = originalQuery(table);
    const collect = query.collect;
    let direction = "asc";
    query.order = value => { direction = value; return query; };
    query.collect = async () => {
      const rows = await collect();
      return direction === "desc" ? rows.reverse() : rows;
    };
    query.first = async () => (await query.collect())[0] ?? null;
    return query;
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
  f.tables.user.push({ _id: userId, username: userId, accentColor: "amber" });
  f.tables.sessionMember.push({
    _id: `member-${userId}`, sessionId: "party", userId, kind: "partyMember",
    sessionMemberStatus: { kind: "joined" },
    sessionMemberRole: { kind: "member" }, beerpongOptIn: true, selectedClass: null,
  });
}

const runDraw = (f, id, actor = "owner") => draw._handler(f.ctx(actor), { id });
const runStart = (f, id, actor = "owner") => start._handler(f.ctx(actor), { id });
const runFinalize = (f, id, actor = "owner") => finalize._handler(f.ctx(actor), { id });
const readActivity = (f, args = {}) => activity(f.ctx("owner"), { sessionId: "party", ...args });
const readTournament = (f, id, actor = "owner") => getTournament._handler(f.ctx(actor), { id });
const listTournaments = (f, sessionId = "party", actor = "owner") => listForSession._handler(f.ctx(actor), { sessionId });

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

async function matchSetup(teamCount = 4, thirdPlaceEnabled = true, settings = {}) {
  const f = setup();
  const tournamentId = await f.run({ teamCount, thirdPlaceEnabled, ...settings });
  for (let index = 0; index < teamCount; index++) enroll(f, `p${index}`);
  await runDraw(f, tournamentId);
  await runStart(f, tournamentId);
  const runResult = (action, id, winnerTeamId, actor = "owner") =>
    results[action]._handler(f.ctx(actor), { id, winnerTeamId });
  return { ...f, tournamentId, runResult };
}

function matchOpponents(f, match) {
  const resolve = slot => {
    if (slot.kind === "team") return slot.teamId;
    if (slot.kind === "bye") return null;
    const source = f.tables.beerpongMatch.find(row => row._id === slot.matchId);
    if (!source.winnerTeamId) return undefined;
    if (slot.kind === "winner") return source.winnerTeamId;
    return matchOpponents(f, source).find(id => id !== source.winnerTeamId);
  };
  return [resolve(match.slotA), resolve(match.slotB)];
}

async function playAll(f) {
  for (const match of f.tables.beerpongMatch) {
    if (match.winnerTeamId !== null) continue;
    const [a, b] = matchOpponents(f, match);
    assert.ok(a && b);
    await f.runResult("recordResult", match._id, a, "b");
  }
}

test("recording results plays through every bracket size, resolving winners, losers and byes", async () => {
  for (let count = 2; count <= 16; count++) {
    for (const thirdPlace of [false, true]) {
      const f = await matchSetup(count, thirdPlace);
      const before = Date.now();
      await playAll(f);
      for (const match of f.tables.beerpongMatch) {
        const opponents = matchOpponents(f, match);
        assert.ok(opponents.includes(match.winnerTeamId));
        assert.ok(match.completedAt !== null);
        assert.ok(match.updatedAt >= match.completedAt);
      }
      const final = f.tables.beerpongMatch.filter(match => match.kind === "main").at(-1);
      assert.ok(final.completedAt >= before);
      const bronze = f.tables.beerpongMatch.find(match => match.kind === "thirdPlace");
      if (bronze) {
        assert.ok(!matchOpponents(f, final).includes(bronze.winnerTeamId));
        assert.notEqual(bronze.winnerTeamId, final.winnerTeamId);
      }
      assert.equal(f.tables.beerpongTournament[0].status, "active");
      assert.equal(f.tables.beerpongTournament[0].completedAt, null);
    }
  }
});

test("results require resolved opponents, a valid winner, and the appropriate record/correct operation", async () => {
  const f = await matchSetup();
  const first = f.tables.beerpongMatch[0];
  const other = f.tables.beerpongMatch[1];
  const final = f.tables.beerpongMatch.find(match => match.round === 2 && match.kind === "main");
  const [a, b] = matchOpponents(f, first);
  await assert.rejects(f.runResult("recordResult", final._id, a), /Both opponents/);
  await assert.rejects(f.runResult("correctResult", first._id, a), /no result/);
  for (const winner of [other.slotA.teamId, "missing-team"])
    await assert.rejects(f.runResult("recordResult", first._id, winner), /match opponents/);
  await f.runResult("recordResult", first._id, b);
  const saved = structuredClone(f.tables);
  await assert.rejects(f.runResult("recordResult", first._id, b), /already has a result/);
  await assert.rejects(f.runResult("recordResult", first._id, a), /already has a result/);
  await assert.rejects(f.runResult("recordResult", final._id, b), /Both opponents/);
  assert.deepEqual(f.tables, saved);
  await f.runResult("correctResult", first._id, a);
  assert.equal(first.winnerTeamId, a);
  assert.ok(first.completedAt !== null);
});

test("correcting early results clears all dependent results including bronze, preserving unrelated matches", async () => {
  const f = await matchSetup(8);
  await playAll(f);
  const source = f.tables.beerpongMatch[0];
  const semifinal = f.tables.beerpongMatch.find(match => match.slotA.matchId === source._id);
  const final = f.tables.beerpongMatch.find(match => match.kind === "main" && match.round === 3);
  const bronze = f.tables.beerpongMatch.find(match => match.kind === "thirdPlace");
  const affected = new Set([source._id, semifinal._id, final._id, bronze._id]);
  const unrelated = structuredClone(f.tables.beerpongMatch.filter(match => !affected.has(match._id)));
  const previous = source.winnerTeamId;
  const replacement = matchOpponents(f, source).find(id => id !== previous);
  await f.runResult("correctResult", source._id, replacement, "b");
  assert.equal(source.winnerTeamId, replacement);
  for (const match of [semifinal, final, bronze]) {
    assert.equal(match.winnerTeamId, null);
    assert.equal(match.completedAt, null);
    assert.equal(match.updatedAt, source.updatedAt);
  }
  assert.deepEqual(f.tables.beerpongMatch.filter(match => !affected.has(match._id)), unrelated);
  assert.equal(f.tables.beerpongTournament[0].updatedAt, source.updatedAt);
  await assert.rejects(f.runResult("recordResult", final._id, replacement), /Both opponents/);
  await assert.rejects(f.runResult("recordResult", bronze._id, replacement), /Both opponents/);
  await playAll(f);
  assert.ok(final.winnerTeamId);
  assert.ok(bronze.winnerTeamId);
});

test("same-winner correction preserves results and correcting finals leaves other matches intact", async () => {
  const f = await matchSetup(); await playAll(f);
  const first = f.tables.beerpongMatch[0];
  const saved = structuredClone(f.tables);
  await f.runResult("correctResult", first._id, first.winnerTeamId);
  assert.deepEqual(f.tables, saved);
  for (const kind of ["main", "thirdPlace"]) {
    const match = f.tables.beerpongMatch.find(row => row.round === 2 && row.kind === kind);
    const unrelated = structuredClone(f.tables.beerpongMatch.filter(row => row._id !== match._id));
    const replacement = matchOpponents(f, match).find(id => id !== match.winnerTeamId);
    await f.runResult("correctResult", match._id, replacement);
    assert.equal(match.winnerTeamId, replacement);
    assert.deepEqual(f.tables.beerpongMatch.filter(row => row._id !== match._id), unrelated);
  }
});

test("bye results cannot be manually recorded or corrected", async () => {
  const f = await matchSetup(5);
  for (const match of f.tables.beerpongMatch.filter(match => match.slotA.kind === "bye" || match.slotB.kind === "bye")) {
    const saved = structuredClone(f.tables);
    for (const action of ["recordResult", "correctResult"])
      await assert.rejects(f.runResult(action, match._id, match.winnerTeamId), /advance automatically/);
    assert.deepEqual(f.tables, saved);
  }
});

test("result writes enforce admins, active tournaments, ongoing parties and tournament ownership", async () => {
  const f = await matchSetup();
  const match = f.tables.beerpongMatch[0];
  const winner = match.slotA.teamId;
  await f.runResult("recordResult", match._id, winner);
  for (const actor of ["a", "other", "invited", "left", "banned"]) {
    if (["invited", "left", "banned"].includes(actor)) f.member(actor).sessionMemberRole.kind = "admin";
    for (const action of ["recordResult", "correctResult"])
      await assert.rejects(f.runResult(action, match._id, winner, actor), /permission/);
  }
  for (const status of ["enrollment", "setup", "completed", "cancelled"]) {
    f.tables.beerpongTournament[0].status = status;
    const saved = structuredClone(f.tables);
    for (const action of ["recordResult", "correctResult"])
      await assert.rejects(f.runResult(action, match._id, winner), /active tournament/);
    assert.deepEqual(f.tables, saved);
  }
  f.tables.beerpongTournament[0].status = "active";
  for (const [field, value, error] of [
    ["endedAt", 1, /read-only/], ["deletedAt", 1, /not found/],
    ["modules", { beerpongEnabled: false }, /disabled/], ["kind", "session", /party/],
  ]) {
    const party = f.tables.session[0]; const original = party[field];
    party[field] = value;
    for (const action of ["recordResult", "correctResult"])
      await assert.rejects(f.runResult(action, match._id, winner), error);
    party[field] = original;
  }
  await assert.rejects(f.runResult("recordResult", "missing", winner), /Match not found/);
  f.tables.session.push({ ...f.tables.session[0], _id: "private", ownerId: "other" });
  f.tables.beerpongTournament[0].sessionId = "private";
  await assert.rejects(f.runResult("correctResult", match._id, winner), /permission/);
  f.tables.beerpongTournament = [];
  await assert.rejects(f.runResult("correctResult", match._id, winner), /Tournament not found/);
});

test("results reject missing, cyclic, and foreign bracket source references without writes", async () => {
  for (const source of ["missing", "self", "foreign"]) {
    const f = await matchSetup();
    const final = f.tables.beerpongMatch.find(match => match.round === 2 && match.kind === "main");
    const winner = f.tables.beerpongTeam[0]._id;
    if (source === "foreign")
      f.tables.beerpongMatch.push({ ...f.tables.beerpongMatch[0], _id: "foreign", tournamentId: "another" });
    final.slotA = { kind: "winner", matchId: source === "self" ? final._id : source };
    const saved = structuredClone(f.tables);
    await assert.rejects(f.runResult("recordResult", final._id, winner), source === "self" ? /cycle/ : /source match not found/);
    assert.deepEqual(f.tables, saved);
  }
});

test("finalization derives podium points across all bracket sizes, with tied third without a playoff", async () => {
  for (let count = 2; count <= 16; count++) {
    for (const thirdPlace of [false, true]) {
      const f = await matchSetup(count, thirdPlace);
      await playAll(f);
      assert.ok((await f.read()).entries.every(entry => entry.beerpongScoreUnits === 0));
      assert.deepEqual((await readActivity(f)).entries, []);
      const savedTeams = structuredClone(f.tables.beerpongTeam);
      const savedMatches = structuredClone(f.tables.beerpongMatch);
      const before = Date.now();
      assert.equal(await runFinalize(f, f.tournamentId, "b"), null);
      const tournament = f.tables.beerpongTournament[0];
      assert.equal(tournament.status, "completed");
      assert.ok(tournament.completedAt >= before && tournament.completedAt <= Date.now());
      assert.equal(tournament.updatedAt, tournament.completedAt);
      assert.ok(!("results" in tournament));
      assert.deepEqual(f.tables.beerpongTeam, savedTeams);
      assert.deepEqual(f.tables.beerpongMatch, savedMatches);
      const entries = (await readActivity(f)).entries;
      const rank = (await f.read()).entries;
      const expectedThird = count === 2 ? 0 : (thirdPlace || count === 3) ? 1 : 2;
      assert.equal(entries.filter(entry => entry.placement === 1).length, 1);
      assert.equal(entries.filter(entry => entry.placement === 2).length, 1);
      assert.equal(entries.filter(entry => entry.placement === 3).length, expectedThird);
      assert.equal(entries.reduce((sum, entry) => sum + entry.scoreUnits, 0), 50000 + 10000 * expectedThird);
      for (const award of entries) {
        const row = rank.find(entry => entry.userId === award.userId);
        assert.equal(award.kind, "beerpongPlacement");
        assert.equal(award.tournamentId, f.tournamentId);
        assert.equal(award.tournamentName, "Friday cup");
        assert.equal(award.occurredAt, tournament.completedAt);
        assert.equal(award.scoreUnits, row.beerpongScoreUnits);
        assert.equal(row.scoreUnits, row.beerpongScoreUnits);
      }
      const saved = structuredClone(f.tables);
      await runFinalize(f, f.tournamentId);
      assert.deepEqual(f.tables, saved);
      assert.deepEqual((await readActivity(f)).entries, entries);
    }
  }
});

test("final rosters receive deterministic integer splits shared by standings, activity and quest ranks", async () => {
  const f = await matchSetup(4, true, {
    firstPlacePointsUnits: 30001, secondPlacePointsUnits: 20002, thirdPlacePointsUnits: 10003,
  });
  await playAll(f);
  const final = f.tables.beerpongMatch.find(match => match.round === 2 && match.kind === "main");
  const champion = f.tables.beerpongTeam.find(team => team._id === final.winnerTeamId);
  const originalPlayer = champion.memberUserIds[0];
  for (const userId of ["p4", "p5"]) enroll(f, userId);
  await teams.removeMember._handler(f.ctx("owner"), { id: champion._id, userId: originalPlayer });
  for (const userId of ["p5", "a", "p4"])
    await teams.addMember._handler(f.ctx("owner"), { id: champion._id, userId });
  await runFinalize(f, f.tournamentId);
  const awards = (await readActivity(f)).entries;
  const winners = awards.filter(award => award.teamId === champion._id);
  assert.deepEqual(winners.map(award => [award.userId, award.scoreUnits]).toSorted(),
    [["a", 10001], ["p4", 10000], ["p5", 10000]]);
  assert.ok(awards.every(award => award.userId !== originalPlayer));
  assert.equal(awards.reduce((sum, award) => sum + award.scoreUnits, 0), 60006);
  const rank = (await f.read()).entries;
  for (const entry of rank) {
    assert.equal(entry.beerpongScoreUnits,
      awards.filter(award => award.userId === entry.userId).reduce((sum, award) => sum + award.scoreUnits, 0));
  }
  assert.equal(rank.find(entry => entry.userId === originalPlayer).beerpongScoreUnits, 0);
  const context = await loadQuestContext(f.ctx("owner"), "party", f.now);
  assert.equal(context.players.find(player => player.userId === "a").scoreUnits, 10001);
  assert.equal(context.players.find(player => player.userId === "a").beerpongTeamId, champion._id);
  assert.ok(context.finalistTeamIds.has(champion._id));
  // Source order never decides who receives remainder units.
  champion.memberUserIds.reverse();
  assert.deepEqual((await readActivity(f)).entries, awards);
});

test("finalization requires all results, including bronze, and rejects incomplete brackets and invalid rosters", async () => {
  const f = await matchSetup();
  await assert.rejects(runFinalize(f, f.tournamentId), /All matches/);
  for (const match of f.tables.beerpongMatch.filter(match => match.kind === "main")) {
    await f.runResult("recordResult", match._id, matchOpponents(f, match)[0]);
  }
  await assert.rejects(runFinalize(f, f.tournamentId), /All matches/);
  assert.equal(f.tables.beerpongTournament[0].status, "active");
  assert.ok((await f.read()).entries.every(entry => entry.beerpongScoreUnits === 0));
  for (const [change, error] of [
    [f => { f.tables.beerpongTeam[0].memberUserIds = []; }, /at least one/],
    [f => { f.tables.beerpongTeam.pop(); }, /team count/],
    [f => { f.tables.beerpongTeam[1].memberUserIds.push(f.tables.beerpongTeam[0].memberUserIds[0]); }, /multiple teams/],
    [f => { f.tables.beerpongMatch.pop(); }, /incomplete/],
    [f => { f.tables.beerpongMatch[0].winnerTeamId = "foreign-team"; }, /invalid/],
    [f => { f.tables.beerpongMatch[0].completedAt = null; }, /All matches/],
  ]) {
    const g = await matchSetup(); await playAll(g); change(g);
    const saved = structuredClone(g.tables);
    await assert.rejects(runFinalize(g, g.tournamentId), error);
    assert.deepEqual(g.tables, saved);
  }
});

test("finalization enforces admin and party lifecycle guards and locks every roster/result mutation", async () => {
  const f = await matchSetup(); await playAll(f);
  for (const actor of ["a", "other", "invited", "left", "banned"]) {
    if (["invited", "left", "banned"].includes(actor)) f.member(actor).sessionMemberRole.kind = "admin";
    await assert.rejects(runFinalize(f, f.tournamentId, actor), /permission/);
  }
  await assert.rejects(runFinalize(f, "missing"), /Tournament not found/);
  for (const status of ["enrollment", "setup", "cancelled"]) {
    f.tables.beerpongTournament[0].status = status;
    await assert.rejects(runFinalize(f, f.tournamentId), /active/);
  }
  f.tables.beerpongTournament[0].status = "active";
  for (const [field, value, error] of [
    ["endedAt", 1, /read-only/], ["deletedAt", 1, /not found/],
    ["modules", { beerpongEnabled: false }, /disabled/], ["kind", "session", /party/],
  ]) {
    const original = f.tables.session[0][field]; f.tables.session[0][field] = value;
    await assert.rejects(runFinalize(f, f.tournamentId), error);
    f.tables.session[0][field] = original;
  }
  await runFinalize(f, f.tournamentId);
  const saved = structuredClone(f.tables);
  const [first, second] = f.tables.beerpongTeam;
  for (const [action, args] of teamActions({ first, second }))
    await assert.rejects(teams[action]._handler(f.ctx("owner"), args), /setup or active/);
  for (const action of ["recordResult", "correctResult"]) {
    const match = f.tables.beerpongMatch[0];
    await assert.rejects(f.runResult(action, match._id, match.winnerTeamId), /active/);
  }
  await assert.rejects(runDraw(f, f.tournamentId), /enrollment/);
  await assert.rejects(runStart(f, f.tournamentId), /setup/);
  assert.deepEqual(f.tables, saved);
});

test("beerpong history supports filters and stable pagination; awards survive membership changes and party end", async () => {
  const f = await matchSetup(); await playAll(f);
  const champion = f.tables.beerpongTeam.find(team => team._id === f.tables.beerpongMatch
    .find(match => match.kind === "main" && match.round === 2).winnerTeamId);
  await teams.addMember._handler(f.ctx("owner"), { id: champion._id, userId: "a" });
  await runFinalize(f, f.tournamentId);
  const all = (await readActivity(f, { kinds: ["beerpongPlacement"] })).entries;
  assert.equal(all.length, 4);
  assert.equal(new Set(all.map(entry => entry.id)).size, all.length);
  const teamAwards = await readActivity(f, { participantIds: ["a"], kinds: ["beerpongPlacement"] });
  assert.equal(teamAwards.entries.length, 2);
  assert.ok(teamAwards.entries.every(entry => entry.teamId === champion._id));
  assert.equal((await readActivity(f, { kinds: ["drinkLog"] })).entries.length, 0);
  const paged = []; let cursor;
  do {
    const page = await readActivity(f, { pageSize: 1, ...(cursor ? { cursor } : {}) });
    paged.push(...page.entries); cursor = page.nextCursor;
  } while (cursor);
  assert.deepEqual(paged, all);
  f.member("a").sessionMemberStatus.kind = "left";
  f.tables.user = f.tables.user.filter(user => user._id !== "a");
  f.tables.session[0].endedAt = Date.now();
  f.tables.session[0].modules.beerpongEnabled = false;
  assert.deepEqual((await readActivity(f)).entries, all);
  assert.ok(!(await f.read()).entries.some(entry => entry.userId === "a"));
  const teammate = champion.memberUserIds.find(userId => userId !== "a");
  assert.equal((await f.read()).entries.find(entry => entry.userId === teammate).beerpongScoreUnits, 15000);
});

test("completed tournaments accumulate points while unfinished, cancelled and foreign tournaments do not", async () => {
  const f = await matchSetup(); await playAll(f); await runFinalize(f, f.tournamentId);
  const initial = (await readActivity(f)).entries;
  const id = await f.run(); await runDraw(f, id); await runStart(f, id); await playAll(f);
  assert.deepEqual((await readActivity(f)).entries, initial);
  f.tables.beerpongTournament[1].status = "cancelled";
  assert.deepEqual((await readActivity(f)).entries, initial);
  f.tables.beerpongTournament[1].status = "active";
  await runFinalize(f, id);
  const all = (await readActivity(f)).entries;
  assert.equal(all.length, initial.length * 2);
  assert.equal((await f.read()).entries.reduce((sum, entry) => sum + entry.beerpongScoreUnits, 0), 120000);
  f.tables.beerpongTournament[1].sessionId = "foreign";
  assert.deepEqual((await readActivity(f)).entries, initial);
});

test("tournament list is newest first, includes every lifecycle state, and is scoped to its party", async () => {
  const f = setup();
  assert.deepEqual(await listTournaments(f), []);
  const ids = [];
  for (const status of ["completed", "cancelled", "active", "setup", "enrollment"]) {
    const id = await f.run({ name: status }); ids.push(id);
    f.tables.beerpongTournament.at(-1).status = status;
  }
  f.tables.beerpongTournament.push({ ...f.tables.beerpongTournament[0], _id: "foreign", sessionId: "other" });
  const saved = structuredClone(f.tables);
  const rows = await listTournaments(f, "party", "a");
  assert.deepEqual(rows.map(row => row._id), ids.toReversed());
  assert.deepEqual(f.tables, saved);
});

test("tournament detail exposes enrollment and setup teams without inventing matches or placements", async () => {
  const f = setup(); const id = await f.run({ teamCount: 2 });
  assert.deepEqual(await readTournament(f, id, "a"), {
    tournament: f.tables.beerpongTournament[0], teams: [], matches: [], placements: [],
  });
  enroll(f, "p0"); enroll(f, "p1"); await runDraw(f, id);
  const detail = await readTournament(f, id);
  assert.equal(detail.tournament.status, "setup");
  assert.deepEqual(detail.teams, f.tables.beerpongTeam);
  assert.deepEqual(detail.matches, []);
  assert.deepEqual(detail.placements, []);
});

test("detail resolves pending winners and losers, playable matches, and corrections without writing source rows", async () => {
  const f = await matchSetup();
  const [first, second] = f.tables.beerpongMatch;
  const saved = structuredClone(f.tables);
  let detail = await readTournament(f, f.tournamentId, "a");
  assert.deepEqual(detail.matches.map(match => match.status), ["ready", "ready", "pending", "pending"]);
  assert.deepEqual(f.tables, saved);
  const final = f.tables.beerpongMatch.find(match => match.kind === "main" && match.round === 2);
  const bronze = f.tables.beerpongMatch.find(match => match.kind === "thirdPlace");
  await f.runResult("recordResult", first._id, first.slotA.teamId);
  detail = await readTournament(f, f.tournamentId);
  assert.equal(detail.matches.find(match => match._id === first._id).status, "completed");
  const projectedFinal = detail.matches.find(match => match._id === final._id);
  assert.equal(projectedFinal.teamAId, first.winnerTeamId);
  assert.equal(projectedFinal.teamBId, null);
  assert.equal(projectedFinal.status, "pending");
  assert.equal(detail.matches.find(match => match._id === bronze._id).teamAId, first.slotB.teamId);
  await f.runResult("recordResult", second._id, second.slotA.teamId);
  detail = await readTournament(f, f.tournamentId);
  assert.equal(detail.matches.find(match => match._id === final._id).status, "ready");
  assert.equal(detail.matches.find(match => match._id === bronze._id).status, "ready");
  await playAll(f);
  detail = await readTournament(f, f.tournamentId);
  assert.ok(detail.matches.every(match => match.status === "completed"));
  assert.deepEqual(detail.placements, []);
  await f.runResult("correctResult", first._id, first.slotB.teamId);
  detail = await readTournament(f, f.tournamentId);
  assert.equal(detail.matches.find(match => match._id === final._id).teamAId, first.slotB.teamId);
  assert.equal(detail.matches.find(match => match._id === final._id).status, "ready");
  assert.equal(detail.matches.find(match => match._id === bronze._id).teamAId, first.slotA.teamId);
  assert.ok(detail.matches.filter(match => match.round === 2).every(match => match.winnerTeamId === null));
  assert.equal(JSON.stringify(detail).includes('"teamAId":null'), false);
});

test("detail reports automatic byes and every final placement, including fourth and shared lower places", async () => {
  for (let count = 2; count <= 16; count++) {
    for (const thirdPlace of [false, true]) {
      const f = await matchSetup(count, thirdPlace);
      let detail = await readTournament(f, f.tournamentId);
      const bracketSize = 2 ** Math.ceil(Math.log2(count));
      assert.equal(detail.matches.filter(match => match.status === "bye").length, bracketSize - count);
      for (const match of detail.matches.filter(match => match.status === "bye")) {
        assert.ok(match.teamAId === null || match.teamBId === null);
        assert.equal(match.winnerTeamId, match.teamAId ?? match.teamBId);
      }
      await playAll(f); await runFinalize(f, f.tournamentId);
      detail = await readTournament(f, f.tournamentId);
      assert.equal(detail.placements.length, count);
      assert.equal(new Set(detail.placements.map(placement => placement.teamId)).size, count);
      assert.deepEqual(detail.placements.map(row => row.placement),
        detail.placements.map(row => row.placement).toSorted((a, b) => a - b));
      const awards = (await readActivity(f)).entries;
      for (const award of awards)
        assert.equal(detail.placements.find(row => row.teamId === award.teamId).placement, award.placement);
      if (thirdPlace && count >= 4)
        assert.equal(detail.placements.filter(row => row.placement === 4).length, 1);
      if (count > 4)
        assert.ok(detail.placements.some(row => row.placement >= 5));
    }
  }
});

test("tournament reads enforce party membership and deletion but remain available for disabled modules and ended parties", async () => {
  const f = await matchSetup(); await playAll(f); await runFinalize(f, f.tournamentId);
  for (const actor of ["invited", "left", "banned", "other"]) {
    await assert.rejects(readTournament(f, f.tournamentId, actor), /permission/);
    await assert.rejects(listTournaments(f, "party", actor), /permission/);
  }
  await assert.rejects(readTournament(f, "missing"), /Tournament not found/);
  await assert.rejects(listTournaments(f, "missing"), /Session not found/);
  f.tables.sessionMember = f.tables.sessionMember.filter(member => member.userId !== "owner");
  const expected = await readTournament(f, f.tournamentId);
  f.tables.session[0].endedAt = Date.now();
  f.tables.session[0].modules.beerpongEnabled = false;
  assert.deepEqual(await readTournament(f, f.tournamentId, "a"), expected);
  assert.equal((await listTournaments(f, "party", "a")).length, 1);
  assert.deepEqual(await readTournament(f, f.tournamentId), expected);
  f.tables.session[0].kind = "session";
  await assert.rejects(readTournament(f, f.tournamentId), /party/);
  await assert.rejects(listTournaments(f), /party/);
  f.tables.session[0].kind = "party";
  f.tables.session[0].deletedAt = Date.now();
  await assert.rejects(readTournament(f, f.tournamentId), /not found/);
  await assert.rejects(listTournaments(f), /not found/);
});

test("detail never includes teams or matches from another tournament, and rejects cross-party access", async () => {
  const f = await matchSetup();
  const id = await f.run(); await runDraw(f, id); await runStart(f, id);
  const detail = await readTournament(f, id);
  assert.ok(detail.teams.every(team => team.tournamentId === id));
  assert.ok(detail.matches.every(match => match.tournamentId === id));
  f.tables.session.push({ ...f.tables.session[0], _id: "private", ownerId: "other" });
  f.tables.beerpongTournament[1].sessionId = "private";
  await assert.rejects(readTournament(f, id, "a"), /permission/);
  await assert.rejects(listTournaments(f, "private", "a"), /permission/);
  assert.equal((await listTournaments(f)).length, 1);
});


test("quest finalists follow recorded semifinal results and corrections", async () => {
  const f = await matchSetup(4);
  const context = () => loadQuestContext(f.ctx("owner"), "party", f.now);
  assert.equal((await context()).finalistTeamIds.size, 0);
  const semi = f.tables.beerpongMatch.find(match => match.kind === "main" && match.round === 1);
  const [first, second] = matchOpponents(f, semi);
  await f.runResult("recordResult", semi._id, first);
  assert.deepEqual([...(await context()).finalistTeamIds], [first]);
  await f.runResult("correctResult", semi._id, second);
  assert.deepEqual([...(await context()).finalistTeamIds], [second]);
});


test("beerpong module toggles require an ongoing party admin and preserve other modules", async () => {
  const f = setup();
  Object.assign(f.tables.session[0].modules, { socialQuestsEnabled: true, partyChallengesEnabled: true });
  const input = { sessionId: "party", enabled: false };
  for (const actor of ["a", "other", "invited", "left", "banned"])
    await assert.rejects(setEnabled._handler(f.ctx(actor), input), /permission/);
  await setEnabled._handler(f.ctx("owner"), input);
  assert.deepEqual(f.tables.session[0].modules, { beerpongEnabled: false, socialQuestsEnabled: true, partyChallengesEnabled: true });
  await setEnabled._handler(f.ctx("b"), { ...input, enabled: true });
  assert.equal(f.tables.session[0].modules.beerpongEnabled, true);
  for (const patch of [{ kind: "session" }, { endedAt: 1 }]) {
    const saved = structuredClone(f.tables.session[0]);
    Object.assign(f.tables.session[0], patch);
    await assert.rejects(setEnabled._handler(f.ctx("owner"), input), /ongoing party/);
    Object.assign(f.tables.session[0], saved);
  }
  f.tables.session[0].deletedAt = 1;
  await assert.rejects(setEnabled._handler(f.ctx("owner"), input), /not found/);
});
