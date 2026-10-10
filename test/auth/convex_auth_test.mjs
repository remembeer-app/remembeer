import assert from "node:assert/strict";
import test from "node:test";
import { build } from "esbuild";

const { outputFiles } = await build({
  stdin: { contents: 'export { deleteCurrent } from "./convex/user/mutation";', resolveDir: process.cwd() },
  bundle: true, platform: "node", format: "esm", write: false,
  plugins: [{ name: "auth-context", setup(builder) {
    builder.onLoad({ filter: /convex\/lib\/authenticated\.ts$/ }, () => ({
      contents: 'import { createBuilder } from "fluent-convex"; export const authMutation = createBuilder().mutation();', loader: "ts",
    }));
    builder.onLoad({ filter: /convex\/lib\/auth\.ts$/ }, () => ({
      contents: 'export const authComponent = { getAuth: async (_, ctx) => ({ auth: ctx.auth, headers: ctx.headers }) }; export const createAuth = () => {};', loader: "ts",
    }));
  } }],
});
const { deleteCurrent } = await import(`data:text/javascript;base64,${Buffer.from(outputFiles[0].text).toString("base64")}`);

function fixture(providers, deletionError) {
  const calls = [];
  const headers = new Headers({ Authorization: "Bearer current-session" });
  return {
    calls,
    ctx: { headers, auth: { api: {
      async listUserAccounts(input) {
        assert.equal(input.headers, headers);
        return providers.map((providerId) => ({ providerId }));
      },
      async deleteUser(input) {
        assert.equal(input.headers, headers);
        if (deletionError) throw deletionError;
        calls.push(input.body);
      },
    } } },
  };
}

test("password confirmation remains mandatory for credential and linked accounts", async () => {
  for (const providers of [["credential"], ["credential", "google"]]) {
    const f = fixture(providers);
    for (const input of [{}, { password: "" }]) {
      await assert.rejects(deleteCurrent(f.ctx, input), /Please enter your password/);
    }
    assert.equal(f.calls.length, 0);
    await deleteCurrent(f.ctx, { password: "confirmed-password" });
    assert.deepEqual(f.calls, [{ password: "confirmed-password" }]);
  }
});

test("Google-only deletion delegates fresh session validation to Better Auth", async () => {
  const f = fixture(["google"]);
  await deleteCurrent(f.ctx, {});
  assert.deepEqual(f.calls, [{}]);
  const stale = fixture(["google"], new Error("Session expired"));
  await assert.rejects(deleteCurrent(stale.ctx, {}), /Session expired/);
});

test("unknown providers cannot delete without password confirmation", async () => {
  for (const providers of [[], ["other"]]) {
    const f = fixture(providers);
    await assert.rejects(deleteCurrent(f.ctx, {}), /Please sign in with Google again/);
    assert.equal(f.calls.length, 0);
  }
});
