import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import test from "node:test";
import { build } from "esbuild";

const { outputFiles } = await build({
  stdin: {
    contents: `export { builtInQuests } from "./convex/partyQuest/catalog";
      import { partyQuestTable } from "./convex/partyQuest/schema";
      import { convexToZod } from "convex-helpers/server/zod4";
      import { z } from "zod";
      export const questValidator = z.union(
        partyQuestTable.validator.members.map(member => convexToZod(member).strict())
      );`,
    resolveDir: process.cwd(),
  },
  bundle: true, platform: "node", format: "esm", write: false,
});
const { builtInQuests, questValidator } = await import(
  `data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`,
);

function issuedQuest(definition) {
  const { availability, ...fields } = definition;
  return {
    ...fields, sessionId: "party", startsAt: 1000, endsAt: 2000,
    status: "active", updatedAt: 1000,
    selections: [{ userId: "a", selectedUserId: "b", selectedAt: 1200 }],
    results: [{ firstUserId: "a", secondUserId: "b", completedAt: 1500 }],
  };
}

test("built-in catalog preserves all existing definitions and availability stages", () => {
  const legacy = JSON.parse(execFileSync("python3", ["-c", `
import json
from party_quest_catalog import BUILT_IN_QUEST_CATALOG
print(json.dumps([
    dict(kind="toastWithClass", drinkCategory={"kind": quest.eligibility_rule.split(":")[1]},
         title=quest.title, instructions=quest.instructions,
         pointsUnits=quest.points_units, availability=quest.availability)
    if quest.eligibility_rule.startswith("oneMemberClass:") else
    dict(kind=quest.eligibility_rule, title=quest.title, instructions=quest.instructions,
         pointsUnits=quest.points_units, availability=quest.availability)
    for quest in BUILT_IN_QUEST_CATALOG
]))`,], { cwd: "functions", encoding: "utf8" }));
  assert.deepEqual(builtInQuests, legacy);
  assert.equal(builtInQuests.length, 18);
  const identities = builtInQuests.map(quest => `${quest.kind}:${quest.drinkCategory?.kind ?? ""}`);
  assert.equal(new Set(identities).size, builtInQuests.length);
});

test("every built-in quest accepts embedded selections and results", () => {
  for (const definition of builtInQuests) {
    const quest = issuedQuest(definition);
    assert.deepEqual(questValidator.parse(quest), quest);
    assert.ok(Number.isInteger(quest.pointsUnits) && quest.pointsUnits > 0);
    for (const status of ["expired", "cancelled"]) {
      assert.equal(questValidator.parse({ ...quest, status }).status, status);
    }
  }
});

test("quest union rejects unknown kinds and incorrect variant or result shapes", () => {
  const toast = issuedQuest(builtInQuests[0]);
  const { drinkCategory, ...withoutTarget } = toast;
  const invalid = [
    withoutTarget,
    { ...toast, kind: "custom" },
    { ...toast, drinkCategory: { kind: "water" } },
    { ...toast, kind: "sameClass" },
    { ...toast, status: "completed" },
    { ...toast, eligibleMemberIds: ["a", "b"] },
    { ...toast, eligiblePairs: [{ firstUserId: "a", secondUserId: "b" }] },
    { ...toast, results: [{ firstUserId: "a", secondUserId: "b" }] },
    { ...toast, selections: [{ userId: "a", selectedAt: 1200 }] },
  ];
  for (const quest of invalid) assert.equal(questValidator.safeParse(quest).success, false);
});
