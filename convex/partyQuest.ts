import * as mutation from "./partyQuest/mutation";
import * as query from "./partyQuest/query";

export const setEnabled = mutation.setEnabled.public();
export const startNext = mutation.startNext.public();
export const selectPartner = mutation.selectPartner.public();
export const get = query.get.public();
export const listForSession = query.listForSession.public();
