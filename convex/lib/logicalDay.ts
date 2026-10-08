export function isValidTimeZone(timeZone: string) {
  if (!/^[A-Za-z]/.test(timeZone)) return false;
  try {
    logicalDayBoundaries("2000-01-01", 0, timeZone);
    return true;
  } catch {
    return false;
  }
}

export function logicalDayBoundaries(
  date: string,
  endOfDayBoundary: number,
  timeZone: string,
) {
  const day = Temporal.PlainDate.from(date);
  const options = {
    timeZone,
    plainTime: {
      hour: Math.floor(endOfDayBoundary / 60),
      minute: endOfDayBoundary % 60,
    },
  };
  return {
    start: day.toZonedDateTime(options).epochMilliseconds,
    end: day.add({ days: 1 }).toZonedDateTime(options).epochMilliseconds,
  };
}

export function logicalDayAt(at: number, endOfDayBoundary: number, timeZone: string) {
  const local = Temporal.Instant.fromEpochMilliseconds(at).toZonedDateTimeISO(timeZone);
  const date = at < logicalDayBoundaries(local.toPlainDate().toString(), endOfDayBoundary, timeZone).start
    ? local.toPlainDate().subtract({ days: 1 })
    : local.toPlainDate();
  return date.toString();
}
