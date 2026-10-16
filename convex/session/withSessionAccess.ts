import type { Id } from "../_generated/dataModel";
import { access } from "../lib/access";
import { requireSessionAccess } from "./access";

type SessionPermission = NonNullable<
  Parameters<typeof requireSessionAccess>[2]
>;

export function withSessionAccess(permission: SessionPermission) {
  return access<{ id: Id<"session"> }>()
    .use((ctx, { id }) => requireSessionAccess(ctx, id, permission))
    .extend;
}
