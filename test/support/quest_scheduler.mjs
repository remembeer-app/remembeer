import assert from "node:assert/strict";
import { getFunctionName } from "convex/server";

export function questScheduler() {
  const jobs = [];
  const scheduler = {
    async runAt(at, reference, args) {
      const id = `job-${jobs.length}`;
      jobs.push({ id, at, name: getFunctionName(reference), args: structuredClone(args), state: "pending" });
      return id;
    },
    async cancel(id) {
      const job = jobs.find(job => job.id === id);
      assert.ok(job, `Missing job ${id}`);
      if (job.state === "pending") job.state = "cancelled";
    },
  };
  async function execute(job, ctx, handlers, at = job.at) {
    assert.equal(job.state, "pending");
    const original = Date.now;
    Date.now = () => at;
    job.state = "running";
    try {
      await handlers[job.name.split(":")[1]]._handler(ctx, job.args);
      job.state = "success";
    } finally { Date.now = original; }
  }
  return { scheduler, jobs, execute };
}
