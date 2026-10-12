import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";

const { outputFiles } = await build({
  stdin: { contents: 'export { LogicalDay } from "./convex/lib/logicalDay"; export { isValidTimeZone } from "./convex/lib/timeZone";', resolveDir: process.cwd() },
  bundle: true, platform: "node", format: "esm", write: false,
});
const { LogicalDay, isValidTimeZone } = await import(
  `data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`,
);

test("timezone validation accepts named zones and rejects invalid names and offsets", () => {
  for (const timeZone of ["UTC", "Europe/Prague", "Asia/Kathmandu"]) {
    assert.equal(isValidTimeZone(timeZone), true, timeZone);
  }
  for (const timeZone of ["", "Invalid/Zone", "+01:00", "-05:00"]) {
    assert.equal(isValidTimeZone(timeZone), false, timeZone);
  }
});

test("logical days include their start and exclude their end across DST", () => {
  const day = new LogicalDay({ timeZone: "Europe/Prague", endOfDayBoundary: 360 });
  for (const [date, start, end] of [
    ["2026-01-02", "2026-01-02T05:00Z", "2026-01-03T05:00Z"],
    ["2026-03-28", "2026-03-28T05:00Z", "2026-03-29T04:00Z"],
    ["2026-10-24", "2026-10-24T04:00Z", "2026-10-25T05:00Z"],
  ]) {
    const boundaries = day.boundaries(date);
    assert.deepEqual(boundaries, { start: Date.parse(start), end: Date.parse(end) });
    assert.notEqual(day.at(boundaries.start - 1), date);
    assert.equal(day.at(boundaries.start), date);
    assert.equal(day.at(boundaries.end - 1), date);
    assert.notEqual(day.at(boundaries.end), date);
  }
});

test("boundaries in DST gaps and overlaps retain Temporal disambiguation", () => {
  const day = new LogicalDay({ timeZone: "Europe/Prague", endOfDayBoundary: 150 });
  for (const [date, start] of [
    ["2026-03-29", "2026-03-29T01:30Z"],
    ["2026-10-25", "2026-10-25T00:30Z"],
  ]) {
    const timestamp = Date.parse(start);
    assert.equal(day.boundaries(date).start, timestamp);
    assert.notEqual(day.at(timestamp - 1), date);
    assert.equal(day.at(timestamp), date);
  }
  assert.equal(day.at(Date.parse("2026-10-25T01:15Z")), "2026-10-25");
});

test("helpers bind independent timezone and boundary settings", () => {
  const prague = new LogicalDay({ timeZone: "Europe/Prague", endOfDayBoundary: 360 });
  const kathmandu = new LogicalDay({ timeZone: "Asia/Kathmandu", endOfDayBoundary: 360 });
  const midnight = new LogicalDay({ timeZone: "Europe/Prague", endOfDayBoundary: 0 });
  const timestamp = Date.parse("2026-01-02T00:15Z");
  assert.equal(prague.at(timestamp), "2026-01-01");
  assert.equal(kathmandu.at(timestamp), "2026-01-02");
  assert.equal(midnight.at(timestamp), "2026-01-02");
  assert.equal(prague.at(timestamp), "2026-01-01");
});
