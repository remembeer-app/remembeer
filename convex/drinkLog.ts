import * as mutation from "./drinkLog/mutation";
import * as query from "./drinkLog/query";

export const listForDay = query.listForDay.public();
export const create = mutation.create.public();
export const update = mutation.update.public();
export const softDelete = mutation.softDelete.public();
