import { createBuilder } from "fluent-convex";
import { triggers } from "../event/trigger";
import type { DataModel } from "../_generated/dataModel";

const builder = createBuilder<DataModel>();

const triggersMiddleware = builder
  .mutation()
  .createMiddleware(async (ctx, next) => next(triggers.wrapDB(ctx)));

export const convex = {
  query: () => builder.query(),
  mutation: () => builder.mutation().use(triggersMiddleware),
};
