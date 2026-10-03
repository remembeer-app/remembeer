import { authQuery } from "../lib/authenticated";
import { schema } from "../schema";

export const current = authQuery
  .returns(schema.doc("user"))
  .handler(async (ctx) => ctx.user);
