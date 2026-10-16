import * as activityQuery from "./party/activity";
import * as query from "./party/query";

export const standings = query.standings.public();
export const activity = activityQuery.activity.public();
