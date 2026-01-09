import 'package:flutter/material.dart';

/// Calculates the effective logical date based on a custom end-of-day boundary.
///
/// This is used to determine if a specific [originalDate] should technically
/// belong to the previous day. For example, if the [endOfDayBoundary] is set
/// to 06:00 AM, a drink logged at 02:00 AM on Jan 2nd will be returned as
/// Jan 1st.
///
/// * [originalDate]: The specific timestamp to adjust.
/// * [endOfDayBoundary]: The time of day that marks the start of a new logical day.
///
/// Returns the adjusted [DateTime].
DateTime effectiveDate(DateTime originalDate, TimeOfDay endOfDayBoundary) {
  final boundaryTime = DateTime(
    originalDate.year,
    originalDate.month,
    originalDate.day,
    endOfDayBoundary.hour,
    endOfDayBoundary.minute,
  );

  if (originalDate.isBefore(boundaryTime)) {
    return originalDate.subtract(const Duration(days: 1));
  }
  return originalDate;
}
