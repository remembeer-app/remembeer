import type { GenericDatabaseWriter, TableNamesInDataModel } from "convex/server";
import { createBuilder } from "fluent-convex";
import { triggers } from "../event/trigger";
import type { DataModel } from "../_generated/dataModel";

type DatabaseWriter = GenericDatabaseWriter<DataModel>;

const builder = createBuilder<DataModel>();

// The trigger wrapper reads the document before and after every patch,
// replace and delete, even on tables without triggers, so writes that name
// such a table go straight to the raw database.
function bypassUntriggered<M extends "patch" | "replace" | "delete">(
  raw: DatabaseWriter,
  wrapped: DatabaseWriter,
  method: M,
  argsWithTable: number,
) {
  return ((...args: unknown[]) => {
    const table = args[0] as TableNamesInDataModel<DataModel>;
    const target = args.length === argsWithTable && !triggers.registered[table] ? raw : wrapped;
    return (target[method] as (...args: unknown[]) => Promise<void>).apply(target, args);
  }) as DatabaseWriter[M];
}

const triggersMiddleware = builder.mutation().createMiddleware(async (ctx, next) => {
  const { db } = triggers.wrapDB(ctx);

  return next({
    ...ctx,
    db: {
      ...db,
      patch: bypassUntriggered(ctx.db, db, "patch", 3),
      replace: bypassUntriggered(ctx.db, db, "replace", 3),
      delete: bypassUntriggered(ctx.db, db, "delete", 2),
    },
  });
});

export const convex = {
  query: () => builder.query(),
  mutation: () => builder.mutation().use(triggersMiddleware),
};
