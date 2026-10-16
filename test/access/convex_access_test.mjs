import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";

const { outputFiles } = await build({
  stdin: {
    contents: `
      import { createBuilder } from "fluent-convex";
      import { WithZod } from "fluent-convex/zod";
      import { v } from "convex/values";
      import { z } from "zod";
      import { access } from "./convex/lib/access";

      const chain = access()
        .use(async (ctx, input) => {
          ctx.trace.push("load");
          const resource = await ctx.db.get("resource", input.id);
          if (!resource) throw new Error("Missing resource");
          return { resource };
        })
        .use((ctx) => {
          ctx.trace.push("authorize");
          if (ctx.resource.ownerId !== ctx.user._id) throw new Error("Denied");
          return { authorized: true };
        });

      const authenticated = createBuilder().mutation().use(async (ctx, next) => {
        ctx.trace.push("auth");
        if (!ctx.actor) throw new Error("Unauthenticated");
        return next({ ...ctx, user: { _id: ctx.actor } });
      });

      export const endpoint = authenticated
        .extend(WithZod)
        .input(z.object({ id: z.string().trim().min(1) }))
        .returns(v.string())
        .extend(chain.extend)
        .handler(async (ctx, input) => {
          ctx.trace.push("handler");
          await ctx.db.patch("resource", input.id, { editedBy: ctx.user._id });
          return ctx.resource.ownerId + ":" + ctx.authorized;
        });

      // Extending a chain leaves the original available for less strict calls.
      export const strictEndpoint = authenticated
        .input({ id: v.string() })
        .returns(v.string())
        .extend(chain.use(() => { throw new Error("Strict guard"); }).extend)
        .handler(async () => { throw new Error("Handler must not run"); });
    `,
    resolveDir: process.cwd(),
  },
  bundle: true, platform: "node", format: "esm", write: false,
});
const { endpoint, strictEndpoint } = await import(
  `data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`
);

function fixture(actor = "alice") {
  const reads = [];
  const writes = [];
  const ctx = {
    actor, trace: [],
    db: {
      async get(table, id) {
        reads.push({ table, id });
        return id === "missing" ? null : { ownerId: id };
      },
      async patch(table, id, fields) { writes.push({ table, id, fields }); },
    },
  };
  return { ctx, reads, writes };
}

for (const registered of [false, true]) {
  const invoke = (fn, ctx, input) => registered
    ? fn.public()._handler(ctx, input)
    : fn(ctx, input);
  const mode = registered ? "registered" : "direct";

  test(`${mode} chains use parsed input, accumulate context, and preserve mutation capabilities`, async () => {
    const f = fixture();
    assert.equal(await invoke(endpoint, f.ctx, { id: " alice " }), "alice:true");
    assert.deepEqual(f.ctx.trace, ["auth", "load", "authorize", "handler"]);
    assert.deepEqual(f.reads, [{ table: "resource", id: "alice" }]);
    assert.deepEqual(f.writes, [{ table: "resource", id: "alice", fields: { editedBy: "alice" } }]);
    assert.equal("resource" in f.ctx, false);
    assert.equal("user" in f.ctx, false);
  });

  test(`${mode} chains stop on invalid input, failed auth, missing resources, or denied access`, async () => {
    for (const [actor, id, error, trace] of [
      ["alice", " ", undefined, []],
      [null, "alice", /Unauthenticated/, ["auth"]],
      ["alice", "missing", /Missing resource/, ["auth", "load"]],
      ["alice", "bob", /Denied/, ["auth", "load", "authorize"]],
    ]) {
      const f = fixture(actor);
      await assert.rejects(invoke(endpoint, f.ctx, { id }), error);
      assert.deepEqual(f.ctx.trace, trace);
      assert.deepEqual(f.writes, []);
    }
  });

  test(`${mode} chains stay independent across concurrent requests`, async () => {
    const alice = fixture("alice");
    const bob = fixture("bob");
    const results = await Promise.all([
      invoke(endpoint, alice.ctx, { id: "alice" }),
      invoke(endpoint, bob.ctx, { id: "bob" }),
    ]);
    assert.deepEqual(results, ["alice:true", "bob:true"]);
    assert.equal(alice.reads.length, 1);
    assert.equal(bob.reads.length, 1);
  });

  test(`${mode} extending a chain adds guards without changing the original`, async () => {
    const strict = fixture();
    await assert.rejects(invoke(strictEndpoint, strict.ctx, { id: "alice" }), /Strict guard/);
    assert.deepEqual(strict.writes, []);

    const ordinary = fixture();
    assert.equal(await invoke(endpoint, ordinary.ctx, { id: "alice" }), "alice:true");
  });
}
