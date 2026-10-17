import * as mutation from "./friendship/mutation";
import * as query from "./friendship/query";

export const sendRequest = mutation.sendRequest.public();
export const accept = mutation.accept.public();
export const decline = mutation.decline.public();
export const cancel = mutation.cancel.public();
export const remove = mutation.remove.public();
export const listCurrent = query.listCurrent.public();
export const listRequests = query.listRequests.public();
export const getStatus = query.getStatus.public();
