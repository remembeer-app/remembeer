import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/date/util/date_utils.dart';

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
  final timeFormat = DateFormat('H:mm');
  final dateFormat = DateFormat('d. MMM');

  final effectiveToday = effectiveDate(now, endOfDayBoundary);
  final effectiveSessionStart = effectiveDate(start, endOfDayBoundary);

  final isStartToday = DateUtils.isSameDay(
    effectiveSessionStart,
    effectiveToday,
  );

  final startDatePart = isStartToday ? '' : '${dateFormat.format(start)}, ';
  final startTime = timeFormat.format(start);

  if (end == null) {
    return '$startDatePart$startTime – still going';
  }

  final isEndToday =
      end.year == now.year && end.month == now.month && end.day == now.day;

  final endDatePart = isEndToday ? '' : '${dateFormat.format(end)}, ';
  final endTime = timeFormat.format(end);

  return '$startDatePart$startTime – $endDatePart$endTime';
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
/// - "Mar 15" (older than 7 days)
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
    return DateFormat("'Yesterday at' HH:mm").format(dateTime);
  }
  if (daysDifference < 7) return DateFormat('EEEE HH:mm').format(dateTime);

  if (dateTime.year != now.year) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  return DateFormat('MMM d').format(dateTime);
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
