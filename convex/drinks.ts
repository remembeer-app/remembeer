import * as query from "./drinks/query";
import * as mutation from "./drinks/mutation";

export const listCustom = query.listCustom.public();
export const listAvailable = query.listAvailable.public();
export const get = query.get.public();
export const create = mutation.create.public();
export const update = mutation.update.public();
export const softDelete = mutation.softDelete.public();
