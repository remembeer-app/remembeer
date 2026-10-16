import type { AuthMutationCtx, AuthQueryCtx } from "./authenticated";

type AsyncHandler<TContext, TInput, TResult> = (
  ctx: TContext,
  input: TInput,
) => Promise<TResult>;

type AccessStep<TContext, TInput, TAdded extends object> = (
  ctx: TContext,
  input: TInput,
) => TAdded | Promise<TAdded>;

// Access data can refine or replace earlier access data, but cannot replace
// authentication or Convex capabilities (including mutation-only capabilities).
type ProtectedContextKeys = keyof AuthQueryCtx | keyof AuthMutationCtx;
type Keys<T> = T extends unknown ? keyof T : never;
type NoContextOverrides<T> =
  Extract<ProtectedContextKeys, Keys<T>> extends never ? unknown : never;

type RequiredKeys<T> = {
  [K in keyof T]-?: Record<never, never> extends Pick<T, K> ? never : K;
}[keyof T];

// Distribute over union branches. Required additions replace previous fields;
// optional additions may leave a previous value in place when absent.
type Merge<TPrevious, TAdded> = TPrevious extends unknown
  ? TAdded extends unknown
    ? {
        [K in keyof TPrevious as K extends RequiredKeys<TAdded> ? never : K]:
          K extends keyof TAdded
            ? TPrevious[K] | Required<TAdded>[K]
            : TPrevious[K];
      } & Omit<TAdded, keyof TPrevious> & Pick<TAdded, RequiredKeys<TAdded>>
    : never
  : never;

// The overload describes spread replacement; generic spread inference would
// otherwise produce an intersection. Runtime merging remains a plain spread.
function mergeFields<TPrevious extends object, TAdded extends object>(
  previous: TPrevious,
  added: TAdded,
): Merge<TPrevious, TAdded>;
function mergeFields(previous: object, added: object) {
  return { ...previous, ...added };
}

class AccessChain<TInput, TAccess extends object> {
  constructor(
    private readonly resolve: (
      ctx: AuthQueryCtx,
      input: TInput,
    ) => Promise<TAccess>,
  ) {}

  use<TAdded extends object>(
    step: AccessStep<AuthQueryCtx & TAccess, TInput, TAdded> & NoContextOverrides<TAdded>,
  ): AccessChain<TInput, Merge<TAccess, TAdded>> {
    return new AccessChain(async (ctx, input) => {
      const loaded: TAccess = await this.resolve(ctx, input);
      const added: TAdded = await step({ ...ctx, ...loaded }, input);

      return mergeFields(loaded, added);
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
      handler: AsyncHandler<Merge<TContext, TAccess>, THandlerInput, TResult>,
    ) => builder.handler(async (ctx, input) => {
      const loaded: TAccess = await this.resolve(ctx, input);

      return await handler(mergeFields(ctx, loaded), input);
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
