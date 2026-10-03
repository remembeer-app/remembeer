import * as mutation from "./user/mutation";
import * as query from "./user/query";

export const current = query.current.public();
export const ensureCurrent = mutation.ensureCurrent.public();
export const updateUsername = mutation.updateUsername.public();
export const updateAccentColor = mutation.updateAccentColor.public();
export const updateAvatarUrl = mutation.updateAvatarUrl.public();
export const updateEndOfDayBoundary = mutation.updateEndOfDayBoundary.public();
export const updateDefaultDrink = mutation.updateDefaultDrink.public();
export const updateDrinkLogSortOrder = mutation.updateDrinkLogSortOrder.public();
