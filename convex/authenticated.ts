import { convex } from "./lib";
import { getCurrentUser } from "./users";

const authQueryMiddleware = convex
  .query()
  .createMiddleware(async (ctx, next) => {
    const { user, authUser } = await getCurrentUser(ctx);

    return next({ ...ctx, user, authUser });
  });

const authMutationMiddleware = convex
  .mutation()
  .createMiddleware(async (ctx, next) => {
    const { user, authUser } = await getCurrentUser(ctx);

    return next({ ...ctx, user, authUser });
  });

export const authQuery = convex.query().use(authQueryMiddleware);
export const authMutation = convex.mutation().use(authMutationMiddleware);
