import * as mutation from "./leaderboard/mutation";
import * as query from "./leaderboard/query";

export const create = mutation.create.public();
export const update = mutation.update.public();
export const softDelete = mutation.softDelete.public();
export const join = mutation.join.public();
export const leave = mutation.leave.public();
export const remove = mutation.remove.public();
export const ban = mutation.ban.public();
export const unban = mutation.unban.public();
export const listCurrent = query.listCurrent.public();
export const get = query.get.public();
export const findByInviteCode = query.findByInviteCode.public();
export const standings = query.standings.public();
