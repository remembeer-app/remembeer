import * as mutation from "./partyQuest/mutation";
import * as query from "./partyQuest/query";
import * as scheduled from "./partyQuest/scheduled";

export const setEnabled = mutation.setEnabled.public();
export const startNext = mutation.startNext.public();
export const selectPartner = mutation.selectPartner.public();
export const get = query.get.public();
export const listForSession = query.listForSession.public();

export const setSchedule = mutation.setSchedule.public();
export const expire = scheduled.expire.internal();
export const issue = scheduled.issue.internal();

export const partners = query.partners.public();
