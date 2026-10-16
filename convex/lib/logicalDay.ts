export class LogicalDay {
  private readonly timeZone: string;
  private readonly endOfDayBoundary: number;

  constructor({ timeZone, endOfDayBoundary }: { timeZone: string; endOfDayBoundary: number }) {
    this.timeZone = timeZone;
    this.endOfDayBoundary = endOfDayBoundary;
  }

  at(timestamp: number) {
    const local = Temporal.Instant.fromEpochMilliseconds(timestamp)
      .toZonedDateTimeISO(this.timeZone)
      .toPlainDate();
    const date =
      timestamp < this.boundaries(local.toString()).start ? local.subtract({ days: 1 }) : local;

    return date.toString();
  }

  boundaries(date: string) {
    const day = Temporal.PlainDate.from(date);
    const options = {
      timeZone: this.timeZone,
      plainTime: {
        hour: Math.floor(this.endOfDayBoundary / 60),
        minute: this.endOfDayBoundary % 60,
      },
    };

    return {
      start: day.toZonedDateTime(options).epochMilliseconds,
      end: day.add({ days: 1 }).toZonedDateTime(options).epochMilliseconds,
    };
  }
}
