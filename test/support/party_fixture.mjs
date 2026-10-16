import assert from "node:assert/strict";

export function fixture(standings) {
  const now = 1000000;
  const tables = {
    user: ["owner", "a", "b", "unclassed", "invited", "left", "banned", "other"].map(_id => ({ _id, username: _id, accentColor: "amber", authUserId: `private-${_id}` })),
    session: [{ _id: "party", ownerId: "owner", kind: "party", deletedAt: null, endedAt: null }],
    sessionMember: ["owner", "a", "b", "unclassed", "invited", "left", "banned"].map(userId => ({
      _id: `member-${userId}`, sessionId: "party", userId, kind: "partyMember",
      selectedClass: userId === "unclassed" ? null : { kind: "beer" },
      sessionMemberStatus: { kind: ["invited", "left", "banned"].includes(userId) ? userId : "joined" },
      sessionMemberRole: { kind: "member" },
    })),
    drink: [{ _id: "beer", name: "Beer", drinkCategory: { kind: "beer" }, alcoholPercentage: 5, deletedAt: null },
      { _id: "wine", name: "Wine", drinkCategory: { kind: "wine" }, alcoholPercentage: 12, deletedAt: null }],
    drinkLog: [], partyChallenge: [], partyQuest: [],
  };
  const reads = [];
  const db = {
    async get(table, id) { reads.push(`${table}:${id}`); return structuredClone(tables[table].find(row => row._id === id) ?? null); },
    query(table) {
      let rows = tables[table];
      return {
        withIndex(name, range) {
          const index = { eq(field, value) {
            rows = rows.filter(row => field.split(".").reduce((v, key) => v?.[key], row) === value); return index;
          } };
          range(index);
          if (name === "by_sessionId_and_startsAt") rows = [...rows].sort((a, b) => a.startsAt - b.startsAt);
          return this;
        },
        async collect() { return structuredClone(rows); },
        async unique() { assert.ok(rows.length <= 1); return structuredClone(rows[0] ?? null); },
      };
    },
  };
  const ctx = userId => ({ db, user: { _id: userId }, storage: { async getUrl(id) { return `https://example.com/${id}`; } } });
  const read = async (actor = "owner", at = now) => {
    const original = Date.now; Date.now = () => at;
    try { return await standings(ctx(actor), { sessionId: "party" }); }
    finally { Date.now = original; }
  };
  const log = (userId, volumeMl = 500, drinkId = "beer", extra = {}) => tables.drinkLog.push({
    _id: `log-${tables.drinkLog.length}`, sessionId: "party", userId, volumeMl, drinkId, consumedAt: now, deletedAt: null, ...extra,
  });
  const quest = (status, results) => tables.partyQuest.push({
    _id: `quest-${tables.partyQuest.length}`, sessionId: "party", startsAt: now - 100, endsAt: now + 100,
    title: "Toast", status, pointsUnits: 25000, results, selections: [],
  });
  const member = id => tables.sessionMember.find(m => m.userId === id);
  return { now, tables, reads, ctx, read, log, quest, member };
}
