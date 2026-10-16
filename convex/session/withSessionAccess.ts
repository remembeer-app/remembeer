import type { Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { requireSessionAccess } from "./access";

type SessionAccess = Awaited<ReturnType<typeof requireSessionAccess>>;
type SessionPermission = NonNullable<
  Parameters<typeof requireSessionAccess>[2]
>;
type AsyncHandler<TContext, TInput, TResult> = (
  ctx: TContext,
  input: TInput,
) => Promise<TResult>;

// .use() cannot read input, so adapt the handler after input/return validation
// has been configured. The builder still handles authentication and Zod parsing.
export function withSessionAccess(permission: SessionPermission) {
  return function extendSessionBuilder<
    TContext extends AuthQueryCtx,
    TInput extends { id: Id<"session"> },
    TResult,
    TRegisteredFunction,
  >(
    builder: {
      handler: (
        callback: AsyncHandler<TContext, TInput, TResult>,
      ) => TRegisteredFunction;
    },
  ) {
    function registerSessionHandler(
      sessionHandler: AsyncHandler<TContext & SessionAccess, TInput, TResult>,
    ) {
      return builder.handler(async (ctx, input) => {
        const access = await requireSessionAccess(ctx, input.id, permission);

        return await sessionHandler({ ...ctx, ...access }, input);
      });
    }

    return { handler: registerSessionHandler };
  };
}
