import type { AuthQueryCtx } from "./authenticated";

type AsyncHandler<TContext, TInput, TResult> = (
  ctx: TContext,
  input: TInput,
) => Promise<TResult>;

type AccessStep<TContext, TInput, TAdded extends object> = (
  ctx: TContext,
  input: TInput,
) => TAdded | Promise<TAdded>;

class AccessChain<TInput, TAccess extends object> {
  constructor(
    private readonly resolve: (
      ctx: AuthQueryCtx,
      input: TInput,
    ) => Promise<TAccess>,
  ) {}

  use<TAdded extends object>(
    step: AccessStep<AuthQueryCtx & TAccess, TInput, TAdded>,
  ): AccessChain<TInput, TAccess & TAdded> {
    return new AccessChain(async (ctx, input) => {
      const loaded = await this.resolve(ctx, input);
      const added = await step({ ...ctx, ...loaded }, input);

      return { ...loaded, ...added };
    });
  }

  // Use after .input() and .returns(). Fluent Convex still owns authentication,
  // input parsing and registration; the access chain runs before the handler.
  readonly extend = <
    TContext extends AuthQueryCtx,
    THandlerInput extends TInput,
    TResult,
    TRegisteredFunction,
  >(
    builder: {
      handler: (
        callback: AsyncHandler<TContext, THandlerInput, TResult>,
      ) => TRegisteredFunction;
    },
  ) => {
    const registerHandler = (
      handler: AsyncHandler<TContext & TAccess, THandlerInput, TResult>,
    ) => builder.handler(async (ctx, input) => {
      const loaded = await this.resolve(ctx, input);

      return await handler({ ...ctx, ...loaded }, input);
    });

    return { handler: registerHandler };
  };
}

/**
 * Build an ordered, input-aware access chain. Each step returns context fields
 * for later steps and the handler. A thrown error stops the chain.
 *
 * Apply with `.extend(chain.extend)` after `.input()` and `.returns()`.
 * `.use()` creates a new chain, so a shared base can have stricter variants.
 */
export function access<TInput>() {
  return new AccessChain<TInput, Record<never, never>>(async () => ({}));
}
