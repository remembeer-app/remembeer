import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";

type CustomDrinkAccess = {
  drink: Doc<"drink">;
};
type AsyncHandler<TContext, TInput, TResult> = (
  ctx: TContext,
  input: TInput,
) => Promise<TResult>;

// .use() cannot read input, so adapt the handler after input/return validation
// has been configured. The builder still handles authentication and Zod parsing.
export function withCustomDrinkAccess() {
  return function extendDrinkBuilder<
    TContext extends AuthQueryCtx,
    TInput extends { id: Id<"drink"> },
    TResult,
    TRegisteredFunction,
  >(
    builder: {
      handler: (
        callback: AsyncHandler<TContext, TInput, TResult>,
      ) => TRegisteredFunction;
    },
  ) {
    function registerDrinkHandler(
      drinkHandler: AsyncHandler<TContext & CustomDrinkAccess, TInput, TResult>,
    ) {
      return builder.handler(async (ctx, input) => {
        const drink = await ctx.db.get("drink", input.id);
        if (!drink) {
          throw new ConvexError("Drink not found");
        }

        if (drink.ownerId !== ctx.user._id) {
          throw new ConvexError("You do not have permission to access this drink");
        }

        if (drink.deletedAt !== null) {
          throw new ConvexError("Drink has been deleted");
        }

        return await drinkHandler({ ...ctx, drink }, input);
      });
    }

    return { handler: registerDrinkHandler };
  };
}
