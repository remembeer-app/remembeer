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
