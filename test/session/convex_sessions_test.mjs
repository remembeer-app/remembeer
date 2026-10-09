import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";

const { outputFiles } = await build({
  stdin: { contents: `export * as sessions from "./convex/session/mutation";
    export * as sessionQueries from "./convex/session/query";
    export * as members from "./convex/sessionMember/mutation";
    export * as memberQueries from "./convex/sessionMember/query";
    export * as logs from "./convex/drinkLog/mutation";
    export { deleteUserData } from "./convex/user/deletion";`, resolveDir: process.cwd() },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "authenticated-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authQuery = createBuilder().query(); export const authMutation = createBuilder().mutation();', loader: "ts",
    }));
  } }],
});
const { sessions, sessionQueries, members, memberQueries, logs, deleteUserData } =
  await import(`data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`);

function fixture() {
  const tables = { user: ["owner", "admin", "member", "invitee", "other"].map((_id) => ({ _id, username: _id, normalizedUsername: _id, authUserId: `auth-${_id}` })), session: [], sessionMember: [], drinkLog: [], drink: [], badge: [] };
  let sequence = 0;
  const db = {
    async get(table, id) { return tables[table].find((row) => row._id === id) ?? null; },
    async insert(table, fields) { const id = `${table}-${++sequence}`; tables[table].push({ _id: id, _creationTime: 1, ...structuredClone(fields) }); return id; },
    async patch(table, id, fields) { const row = await this.get(table, id); assert.ok(row); Object.assign(row, structuredClone(fields)); },
    async delete(table, id) { tables[table] = tables[table].filter((row) => row._id !== id); },
    query(table) {
      let rows = tables[table];
      return {
        withIndex(name, range) {
          const q = { eq(field, value) { rows = rows.filter((row) => field.split(".").reduce((v, key) => v[key], row) === value); return q; } };
          range(q); return this;
        },
        async unique() { assert.ok(rows.length <= 1); return rows[0] ?? null; },
        async collect() { return rows; },
        async take(count) { return rows.slice(0, count); },
      };
    },
  };
  const ctx = (id) => ({ db, user: { _id: id, drinkLogSortOrder: "desc" } });
  const owner = ctx("owner");
  const create = () => sessions.create(owner, { name: " Evening ", description: " Test ", startedAt: 1000 });
  const member = (sessionId, userId) => tables.sessionMember.find((row) => row.sessionId === sessionId && row.userId === userId);
  const join = async (sessionId, userId) => { await members.invite(owner, { sessionId, userId }); await members.accept(ctx(userId), { sessionId }); };
  return { tables, db, ctx, owner, create, member, join };
}

const target = (sessionId, userId) => ({ sessionId, userId });

test("creation validates fields and atomically constructs the owner membership", async () => {
  const f = fixture();
  const id = await f.create();
  const session = await sessionQueries.get(f.owner, { id });
  assert.equal(session.name, "Evening");
  assert.equal(session.description, "Test");
  assert.equal(session.kind, "session");
  assert.equal(session.endedAt, null);
  assert.equal(session.deletedAt, null);
  assert.equal(f.member(id, "owner").sessionMemberStatus.kind, "joined");
  assert.equal(f.member(id, "owner").sessionMemberRole.kind, "admin");
  const input = { name: "Name", description: "", startedAt: 1 };
  for (const invalid of [ { name: "  a " }, { name: "a".repeat(31) }, { description: "a".repeat(501) }, { startedAt: 1.5 }, { startedAt: Infinity }, { startedAt: 8640000000000001 } ]) {
    await assert.rejects(sessions.create(f.owner, { ...input, ...invalid }));
  }
  assert.equal(f.tables.session.length, 1);
});

test("shared session CRUD and promotion enforce roles, ranges and union kinds", async () => {
  const f = fixture(); const id = await f.create();
  await f.join(id, "admin"); await f.join(id, "member");
  await members.setRole(f.owner, { ...target(id, "admin"), role: { kind: "admin" } });
  for (const actor of ["member", "other"]) {
    await assert.rejects(sessions.update(f.ctx(actor), { id, name: "Changed" }));
    await assert.rejects(sessions.promoteToParty(f.ctx(actor), { id }));
    await assert.rejects(sessions.softDelete(f.ctx(actor), { id }));
  }
  await assert.rejects(sessions.softDelete(f.ctx("admin"), { id }));
  await sessions.update(f.ctx("admin"), { id, endedAt: 1000 });
  await assert.rejects(sessions.update(f.owner, { id, startedAt: 1001 }));
  await assert.rejects(sessions.update(f.owner, { id, endedAt: 999 }));
  await assert.rejects(sessions.update(f.owner, { id, startedAt: 0.5 }));
  await assert.rejects(sessions.update(f.owner, { id, endedAt: 8640000000000001 }));
  await assert.rejects(sessions.promoteToParty(f.owner, { id }));
  await sessions.update(f.owner, { id, endedAt: null });
  await sessions.promoteToParty(f.ctx("admin"), { id });
  const party = structuredClone(await f.db.get("session", id));
  assert.equal(party.kind, "party");
  await sessions.promoteToParty(f.owner, { id });
  assert.deepEqual(await f.db.get("session", id), party);
  await sessions.update(f.ctx("admin"), { id, name: "Party renamed", endedAt: 2000 });
  assert.equal((await sessionQueries.get(f.ctx("member"), { id })).kind, "party");
  assert.equal((await sessionQueries.listCurrent(f.ctx("member"), {})).length, 1);
  assert.equal((await sessionQueries.listCurrent(f.ctx("other"), {})).length, 0);
  await assert.rejects(sessionQueries.get(f.ctx("other"), { id }));
  await assert.rejects(sessionQueries.get(f.owner, { id: "missing" }));
});

test("invitations, acceptance, decline, leave and re-invitation keep one row and reset roles", async () => {
  const f = fixture(); const id = await f.create(); const input = target(id, "invitee");
  await assert.rejects(members.invite(f.ctx("other"), input));
  await assert.rejects(members.invite(f.owner, target(id, "missing")));
  await members.invite(f.owner, input);
  const invited = structuredClone(f.member(id, "invitee"));
  await members.invite(f.owner, input);
  assert.deepEqual(f.member(id, "invitee"), invited);
  assert.equal((await memberQueries.listInvitations(f.ctx("invitee"), {}))[0].session._id, id);
  assert.equal((await sessionQueries.get(f.ctx("invitee"), { id }))._id, id);
  assert.deepEqual(await sessionQueries.listCurrent(f.ctx("invitee"), {}), []);
  await assert.rejects(memberQueries.listForSession(f.ctx("invitee"), { sessionId: id }));
  await assert.rejects(members.accept(f.ctx("other"), { sessionId: id }));
  await assert.rejects(members.leave(f.ctx("invitee"), { sessionId: id }));
  await members.decline(f.ctx("invitee"), { sessionId: id });
  await members.decline(f.ctx("invitee"), { sessionId: id });
  await assert.rejects(members.accept(f.ctx("invitee"), { sessionId: id }));
  await assert.rejects(sessionQueries.get(f.ctx("invitee"), { id }));
  await members.invite(f.owner, input);
  await members.accept(f.ctx("invitee"), { sessionId: id });
  const joined = structuredClone(f.member(id, "invitee"));
  await members.accept(f.ctx("invitee"), { sessionId: id });
  await members.invite(f.owner, input);
  assert.deepEqual(f.member(id, "invitee"), joined);
  assert.deepEqual(await memberQueries.listInvitations(f.ctx("invitee"), {}), []);
  await members.setRole(f.owner, { ...input, role: { kind: "admin" } });
  await members.leave(f.ctx("invitee"), { sessionId: id });
  await members.leave(f.ctx("invitee"), { sessionId: id });
  assert.equal(f.member(id, "invitee").sessionMemberRole.kind, "member");
  await members.invite(f.owner, input);
  assert.equal(f.member(id, "invitee")._id, invited._id);
  assert.equal(f.tables.sessionMember.length, 2);
});

test("moderation and roles protect owners and admins and enforce valid transitions", async () => {
  const f = fixture(); const id = await f.create();
  await f.join(id, "admin"); await f.join(id, "member");
  await members.setRole(f.owner, { ...target(id, "admin"), role: { kind: "admin" } });
  const admin = f.ctx("admin"); const input = target(id, "member");
  for (const operation of [members.leave, members.decline, members.accept]) {
    await assert.rejects(operation(f.owner, { sessionId: id }));
  }
  for (const operation of [members.remove, members.ban, members.unban]) {
    await assert.rejects(operation(f.owner, target(id, "owner")));
    await assert.rejects(operation(admin, target(id, "owner")));
    await assert.rejects(operation(admin, target(id, "admin")));
    await assert.rejects(operation(f.ctx("member"), target(id, "admin")));
  }
  await assert.rejects(members.setRole(f.owner, { ...target(id, "owner"), role: { kind: "member" } }));
  await assert.rejects(members.setRole(admin, { ...input, role: { kind: "admin" } }));
  await assert.rejects(members.unban(admin, input));
  await members.remove(admin, input);
  await members.remove(admin, input);
  await members.ban(admin, input);
  await members.ban(admin, input);
  await assert.rejects(members.invite(f.owner, input));
  await assert.rejects(members.accept(f.ctx("member"), { sessionId: id }));
  await members.unban(admin, input);
  await members.unban(admin, input);
  assert.equal(f.member(id, "member").sessionMemberStatus.kind, "left");
  await members.invite(admin, input);
  await assert.rejects(members.setRole(f.owner, { ...input, role: { kind: "admin" } }));
  await members.remove(admin, input);
  await members.invite(admin, input);
  await members.decline(f.ctx("member"), { sessionId: id });
  await assert.rejects(members.remove(admin, input));
  await members.ban(admin, input);
  await members.unban(admin, input);
  await f.join(id, "member");
  await members.setRole(f.owner, { ...input, role: { kind: "admin" } });
  await assert.rejects(members.ban(admin, input));
  await members.ban(f.owner, input);
  assert.equal(f.member(id, "member").sessionMemberRole.kind, "member");
  await members.remove(f.owner, target(id, "admin"));
  await assert.rejects(sessions.update(admin, { id, name: "No longer admin" }));
  await assert.rejects(members.invite(admin, input));
});

test("roster privacy exposes only joined rows to ordinary members", async () => {
  const f = fixture(); const id = await f.create();
  await f.join(id, "member"); await f.join(id, "admin");
  await members.setRole(f.owner, { ...target(id, "admin"), role: { kind: "admin" } });
  await members.invite(f.owner, target(id, "invitee"));
  assert.equal((await memberQueries.listForSession(f.owner, { sessionId: id })).length, 4);
  assert.equal((await memberQueries.listForSession(f.ctx("admin"), { sessionId: id })).length, 4);
  const roster = await memberQueries.listForSession(f.ctx("member"), { sessionId: id });
  assert.deepEqual(roster.map((row) => row.userId), ["owner", "member", "admin"]);
  assert.equal(roster.some((row) => "authUserId" in row), false);
  await assert.rejects(memberQueries.listForSession(f.ctx("other"), { sessionId: id }));
});

test("times stay descriptive; ended sessions accept members and logs; deletion preserves history", async () => {
  const f = fixture(); const id = await f.create();
  await sessions.update(f.owner, { id, endedAt: 1000 });
  await f.join(id, "member");
  f.tables.drink.push({ _id: "beer", ownerId: null, deletedAt: null });
  const input = { sessionId: id, drinkId: "beer", consumedAt: 0, volumeMl: 500, location: null };
  const logId = await logs.create(f.ctx("member"), input);
  await sessions.update(f.owner, { id, startedAt: 999, endedAt: 1001 });
  assert.equal((await f.db.get("drinkLog", logId)).sessionId, id);
  await members.invite(f.owner, target(id, "invitee"));
  await assert.rejects(logs.create(f.ctx("invitee"), input));
  await members.leave(f.ctx("member"), { sessionId: id });
  await assert.rejects(logs.create(f.ctx("member"), input));
  await logs.update(f.ctx("member"), { id: logId, volumeMl: 250 });
  await sessions.softDelete(f.owner, { id });
  assert.equal((await f.db.get("drinkLog", logId)).sessionId, id);
  assert.equal(f.tables.sessionMember.length, 3);
  assert.deepEqual(await sessionQueries.listCurrent(f.owner, {}), []);
  assert.deepEqual(await memberQueries.listInvitations(f.ctx("invitee"), {}), []);
  await assert.rejects(sessionQueries.get(f.owner, { id }));
  await assert.rejects(logs.create(f.owner, input));
  await assert.rejects(sessions.update(f.owner, { id, name: "Deleted" }));
  await assert.rejects(sessions.promoteToParty(f.owner, { id }));
  await assert.rejects(members.invite(f.owner, target(id, "other")));
  await assert.rejects(members.accept(f.ctx("invitee"), { sessionId: id }));
});

test("account deletion soft-deletes owned sessions and removes all of the user's memberships", async () => {
  const f = fixture(); const ownedId = await f.create();
  await f.join(ownedId, "member");
  const otherId = await sessions.create(f.ctx("other"), { name: "Other session", description: "", startedAt: 1 });
  await members.invite(f.ctx("other"), target(otherId, "owner"));
  await f.db.insert("drinkLog", { userId: "member", sessionId: ownedId });
  await deleteUserData(f.owner, "auth-owner");
  assert.ok((await f.db.get("session", ownedId)).deletedAt);
  assert.equal((await f.db.get("session", otherId)).deletedAt, null);
  assert.equal(f.tables.sessionMember.some((row) => row.userId === "owner"), false);
  assert.equal(f.tables.drinkLog.length, 1);
  assert.ok(f.member(ownedId, "member"));
  assert.equal(await f.db.get("user", "owner"), null);
  await assert.rejects(sessionQueries.get(f.ctx("member"), { id: ownedId }));
});


test("invitation lookup requires admin access and only returns public identifiers and names", async () => {
  const f = fixture(); const id = await f.create();
  await f.join(id, "member");
  await assert.rejects(memberQueries.findInvitee(f.ctx("member"), { sessionId: id, username: "other" }));
  await assert.rejects(memberQueries.findInvitee(f.ctx("other"), { sessionId: id, username: "owner" }));
  assert.deepEqual(await memberQueries.findInvitee(f.owner, { sessionId: id, username: "OTHER" }), [{ _id: "other", username: "other" }]);
  assert.deepEqual(await memberQueries.findInvitee(f.owner, { sessionId: id, username: "missing" }), []);
  const roster = await memberQueries.listForSession(f.owner, { sessionId: id });
  assert.equal(roster[0].username, "owner");
  assert.equal(roster.some((row) => "authUserId" in row), false);
});
