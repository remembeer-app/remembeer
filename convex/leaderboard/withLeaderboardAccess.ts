import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { AuthQueryCtx } from "../lib/authenticated";
import { getMembership } from "./access";

export type LeaderboardAccess = {
  leaderboard: Doc<"leaderboard">;
  // Owners are authorized directly, without loading their membership.
  member: Doc<"leaderboardMember"> | null;
  isOwner: boolean;
};
type AsyncHandler<TContext, TInput, TResult> = (
  ctx: TContext,
  input: TInput,
) => Promise<TResult>;

// .use() cannot read input, so adapt the handler after input/return validation
// has been configured. The builder still handles authentication and Zod parsing.
export function withLeaderboardAccess(permission: "member" | "owner") {
  return function extendLeaderboardBuilder<
    TContext extends AuthQueryCtx,
    TInput extends { id: Id<"leaderboard"> },
    TResult,
    TRegisteredFunction,
  >(
    builder: {
      handler: (
        callback: AsyncHandler<TContext, TInput, TResult>,
      ) => TRegisteredFunction;
    },
  ) {
    function registerLeaderboardHandler(
      leaderboardHandler: AsyncHandler<TContext & LeaderboardAccess, TInput, TResult>,
    ) {
      return builder.handler(async (ctx, input) => {
        const leaderboard = await ctx.db.get("leaderboard", input.id);
        if (!leaderboard || leaderboard.deletedAt !== null) {
          throw new ConvexError("Leaderboard not found");
        }

        const isOwner = leaderboard.ownerId === ctx.user._id;
        if (permission === "owner" && !isOwner) {
          throw new ConvexError(
            "You do not have permission to access this leaderboard",
          );
        }

        const member = isOwner
          ? null
          : await getMembership(ctx, input.id, ctx.user._id);
        if (!isOwner && member?.status !== "joined") {
          throw new ConvexError(
            "You do not have permission to access this leaderboard",
          );
        }

        return await leaderboardHandler(
          { ...ctx, leaderboard, member, isOwner },
          input,
        );
      });
    }

    return { handler: registerLeaderboardHandler };
  };
}
