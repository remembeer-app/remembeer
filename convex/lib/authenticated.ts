import type { MutationCtx, QueryCtx } from "fluent-convex";
import { getCurrentUser } from "../user/currentUser";
import { convex } from "./builder";
import type { DataModel } from "../_generated/dataModel";

type CurrentUserContext = Awaited<ReturnType<typeof getCurrentUser>>;

export type AuthQueryCtx = QueryCtx<DataModel> & CurrentUserContext;
export type AuthMutationCtx = MutationCtx<DataModel> & CurrentUserContext;

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
