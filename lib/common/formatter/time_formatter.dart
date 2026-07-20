import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/date/util/date_utils.dart';

final _timeFormat = DateFormat('H:mm');
final _dayMonthFormat = DateFormat('d. MMM');
final _dayMonthYearFormat = DateFormat('d. MMM yyyy');
final _fullDateTimeFormat = DateFormat('dd MMM. yyyy, H:mm');
final _weekdayDateFormat = DateFormat('EEE, d MMM yyyy');
final _weekdayTimeFormat = DateFormat('EEEE H:mm');
final _yesterdayTimeFormat = DateFormat("'Yesterday at' H:mm");
final _monthYearFormat = DateFormat('MMMM yyyy');

/// Formats a time of day, e.g. "14:30".
String formatTime(DateTime dateTime) => _timeFormat.format(dateTime);

/// Formats a day and month, e.g. "28. Mar".
String formatDayMonth(DateTime dateTime) => _dayMonthFormat.format(dateTime);

/// Formats a day, month and time, e.g. "28. Mar, 14:30".
String formatDayMonthTime(DateTime dateTime) =>
    '${_dayMonthFormat.format(dateTime)}, ${_timeFormat.format(dateTime)}';

/// Formats a full timestamp, e.g. "28 Mar. 2026, 14:30".
///
/// Used by form fields and dialogs where the exact moment matters.
String formatFullDateTime(DateTime dateTime) =>
    _fullDateTimeFormat.format(dateTime);

/// Formats a month of a year, e.g. "March 2026".
String formatMonthYear(int year, int month) =>
    _monthYearFormat.format(DateTime(year, month));

/// Formats a date relative to [effectiveToday] (the current logical day):
/// "Today", "Yesterday", or a full date like "Sat, 28 Mar 2026".
///
/// Both arguments are compared by calendar day only; callers should pass
/// dates that already account for the end-of-day boundary.
String formatRelativeDay(DateTime date, DateTime effectiveToday) {
  final dateOnly = DateUtils.dateOnly(date);
  final todayOnly = DateUtils.dateOnly(effectiveToday);

  return switch (dateOnly.difference(todayOnly).inDays) {
    0 => 'Today',
    -1 => 'Yesterday',
    _ => _weekdayDateFormat.format(date),
  };
}

/// Format a session time range accounting for the user's end-of-day boundary.
///
/// This function determines whether session start/end times should display
/// dates based on the logical day (using [endOfDayBoundary]) rather than
/// calendar midnight.
///
/// Examples:
/// - Same logical day: "14:30 – 18:45"
/// - Started yesterday: "28. Mar, 23:30 – 02:15"
/// - Multi-day: "28. Mar, 14:30 – 29. Mar, 18:45"
/// - Ongoing: "14:30 – still going"
String formatSessionTimeRange(
  DateTime start,
  DateTime? end,
  TimeOfDay endOfDayBoundary,
) {
  final now = DateTime.now();

  final effectiveToday = effectiveDate(now, endOfDayBoundary);
  final effectiveSessionStart = effectiveDate(start, endOfDayBoundary);

  final isStartToday = DateUtils.isSameDay(
    effectiveSessionStart,
    effectiveToday,
  );

  final startPart = isStartToday
      ? formatTime(start)
      : formatDayMonthTime(start);

  if (end == null) {
    return '$startPart – still going';
  }

  final effectiveSessionEnd = effectiveDate(end, endOfDayBoundary);

  final isEndToday = DateUtils.isSameDay(effectiveSessionEnd, effectiveToday);

  final endPart = isEndToday ? formatTime(end) : formatDayMonthTime(end);

  return '$startPart – $endPart';
}

/// Formats a [dateTime] as a relative time string, accounting for the user's
/// end-of-day boundary when determining "yesterday".
///
/// The [endOfDayBoundary] is used to calculate logical days - for example,
/// with a 6:00 AM boundary, a timestamp at 2:00 AM on Jan 2nd is considered
/// part of Jan 1st.
///
/// Examples:
/// - "Just now" (< 1 minute)
/// - "5m ago" (< 60 minutes)
/// - "3h ago" (< 24 hours)
/// - "Yesterday at 23:30" (yesterday's logical day)
/// - "Monday 14:30" (within last 7 days)
/// - "15. Mar" (older than 7 days)
/// - "15. Mar 2025" (previous years)
String timeAgo(DateTime dateTime, TimeOfDay endOfDayBoundary) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) return 'Just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  if (difference.inHours < 24) return '${difference.inHours}h ago';

  final effectiveToday = effectiveDate(now, endOfDayBoundary);
  final effectiveDateTime = effectiveDate(dateTime, endOfDayBoundary);
  final daysDifference = effectiveToday.difference(effectiveDateTime).inDays;

  if (daysDifference == 1) {
    return _yesterdayTimeFormat.format(dateTime);
  }
  if (daysDifference < 7) return _weekdayTimeFormat.format(dateTime);

  if (dateTime.year != now.year) {
    return _dayMonthYearFormat.format(dateTime);
  }

  return formatDayMonth(dateTime);
}

/// Formats the difference between [start] and [end] into a human-readable string.
///
/// Returns 'Ongoing' if [end] is null.
///
/// The output is truncated to the two most significant adjacent units:
/// * If days > 0, returns "Xd Yh" (or just "Xd" if hours is 0).
/// * If hours > 0, returns "Xh Ym" (or just "Xh" if minutes is 0).
/// * Otherwise, returns "Xm" or "< 1m".
///
/// Example:
/// * `5d 3h` (Days and hours)
/// * `5d`    (Days only, even if minutes exist)
/// * `2h 15m` (Hours and minutes)
/// * `< 1m`  (Less than sixty seconds)
String formatDuration(DateTime start, DateTime? end) {
  if (end == null) return 'Ongoing';

  final duration = end.difference(start);
  final days = duration.inDays;
  final hours = duration.inHours % 24;
  final minutes = duration.inMinutes % 60;

  if (days > 0) {
    return hours > 0 ? '${days}d ${hours}h' : '${days}d';
  }

  if (hours > 0) {
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }

  if (minutes > 0) {
    return '${minutes}m';
  }

  return '< 1m';
}
