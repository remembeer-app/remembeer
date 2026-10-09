import { v } from "convex/values";
import { logicalDayBoundaries } from "./logicalDay";
import { convex } from "./builder";

const timeZoneSearchLimit = 20;

export function isValidTimeZone(timeZone: string) {
  if (!/^[A-Za-z]/.test(timeZone)) return false;
  try {
    logicalDayBoundaries("2000-01-01", 0, timeZone);
    return true;
  } catch {
    return false;
  }
}

export const searchTimeZones = convex
  .query()
  .input({ search: v.string() })
  .returns(v.array(v.string()))
  .handler(async (_, { search }) => {
    const normalizedSearch = search.trim().toLowerCase().replace(/[_/]/g, " ");
    if (!normalizedSearch) return [];

    return ["UTC", ...Intl.supportedValuesOf("timeZone")]
      .filter((timeZone) =>
        timeZone.toLowerCase().replace(/[_/]/g, " ").includes(normalizedSearch),
      )
      .slice(0, timeZoneSearchLimit);
  })
  .public();
