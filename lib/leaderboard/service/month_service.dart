import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/leaderboard/model/selected_month.dart';
import 'package:rxdart/rxdart.dart';

class MonthService {
  MonthService() {
    _lifecycleListener = AppLifecycleListener(onResume: refresh);
  }

  final _requestedMonth = BehaviorSubject<String?>.seeded(null);
  final _selectedMonth = BehaviorSubject<SelectedMonth>();
  final _refreshAt = BehaviorSubject<int>.seeded(
    DateTime.now().millisecondsSinceEpoch,
  );
  late final AppLifecycleListener _lifecycleListener;
  String? _currentMonth;
  int? _nextMonthAt;
  Timer? _rollover;

  Stream<String?> get requestedMonthStream => _requestedMonth.stream;
  Stream<SelectedMonth> get selectedMonthStream => _selectedMonth.stream;
  Stream<int> get refreshAtStream => _refreshAt.stream;

  void updateReportingMonth(String currentMonth, int nextMonthAt) {
    _currentMonth = currentMonth;
    _publishSelection();
    if (_nextMonthAt == nextMonthAt) return;
    _nextMonthAt = nextMonthAt;
    _rollover?.cancel();
    final delay = nextMonthAt - DateTime.now().millisecondsSinceEpoch;
    _rollover = Timer(Duration(milliseconds: delay > 0 ? delay : 0), refresh);
  }

  void _publishSelection() {
    final month = _requestedMonth.valueOrNull ?? _currentMonth;
    if (month == null) return;
    final date = DateFormat('yyyy-MM').parseStrict(month);
    _selectedMonth.add(
      SelectedMonth(
        year: date.year,
        month: date.month,
        isCurrentMonth: month == _currentMonth,
      ),
    );
  }

  void previousMonth() {
    final current = _selectedMonth.valueOrNull;
    if (current == null || current.year == 0 && current.month == 1) return;
    _select(DateTime(current.year, current.month - 1));
  }

  void nextMonth() {
    final current = _selectedMonth.valueOrNull;
    if (current == null || current.isCurrentMonth) return;
    _select(DateTime(current.year, current.month + 1));
  }

  void _select(DateTime date) {
    final month = DateFormat('yyyy-MM').format(date);
    _requestedMonth.add(month == _currentMonth ? null : month);
    _publishSelection();
  }

  void resetToCurrentMonth() {
    _requestedMonth.add(null);
    _publishSelection();
    refresh();
  }

  void refresh() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _refreshAt.add(now > _refreshAt.value ? now : _refreshAt.value + 1);
  }

  void dispose() {
    _rollover?.cancel();
    _lifecycleListener.dispose();
    unawaited(_requestedMonth.close());
    unawaited(_selectedMonth.close());
    unawaited(_refreshAt.close());
  }
}
