import 'package:flutter/material.dart';
import 'package:remembeer/date/type/date_state.dart';
import 'package:remembeer/date/util/date_utils.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:rxdart/rxdart.dart';

class DateService {
  final UserController userController;

  DateService({required this.userController});

  final _selectedDateSubject = BehaviorSubject<DateTime>.seeded(DateTime.now());

  Stream<DateState> get selectedDateStateStream => Rx.combineLatest2(
    _selectedDateSubject.stream,
    userController.currentUserStream,
    (selectedDate, user) {
      final effectiveSelectedDate = effectiveDate(
        selectedDate,
        user.endOfDayBoundary,
      );
      final effectiveNow = effectiveDate(DateTime.now(), user.endOfDayBoundary);

      return (
        selectedDate: effectiveSelectedDate,
        effectiveToday: effectiveNow,
      );
    },
  );

  DateTime get _selectedDate => _selectedDateSubject.value;

  void setDate(DateTime date) {
    _selectedDateSubject.add(date);
  }

  void nextDay() {
    final now = DateTime.now();
    final nextDate = _selectedDate.add(const Duration(days: 1));

    if (nextDate.isAfter(now) && !DateUtils.isSameDay(nextDate, now)) {
      return;
    }

    _selectedDateSubject.add(nextDate);
  }

  void previousDay() {
    _selectedDateSubject.add(_selectedDate.subtract(const Duration(days: 1)));
  }

  void goToToday() {
    _selectedDateSubject.add(DateTime.now());
  }

  void dispose() {
    _selectedDateSubject.close();
  }

  // TODO(ohtenkay): try injecting settings here
  (DateTime, DateTime) selectedDateBoundaries(TimeOfDay endOfDayBoundary) {
    final logicalDate = effectiveDate(_selectedDate, endOfDayBoundary);

    final startTime = DateTime(
      logicalDate.year,
      logicalDate.month,
      logicalDate.day,
      endOfDayBoundary.hour,
      endOfDayBoundary.minute,
    );

    final endTime = startTime.add(const Duration(days: 1));

    return (startTime, endTime);
  }
}
