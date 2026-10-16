import * as mutation from "./beerpongTournament/mutation";
import * as query from "./beerpongTournament/query";

export const create = mutation.create.public();
export const draw = mutation.draw.public();
export const start = mutation.start.public();
export const finalize = mutation.finalize.public();
export const get = query.get.public();
export const listForSession = query.listForSession.public();
