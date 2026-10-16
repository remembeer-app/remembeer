import { ConvexError } from "convex/values";
import type { Id } from "../_generated/dataModel";
import { access } from "../lib/access";

export function customDrinkAccess() {
  return access<{ id: Id<"drink"> }>()
    .use(async (ctx, input) => {
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

      return { drink };
    });
}
