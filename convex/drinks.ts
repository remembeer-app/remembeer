import * as query from "./drinks/query";
import * as mutation from "./drinks/mutation";

export const listMine = query.listMine.public();
export const listAll = query.listAll.public();
export const get = query.get.public();
export const create = mutation.create.public();
export const update = mutation.update.public();
export const softDelete = mutation.softDelete.public();
