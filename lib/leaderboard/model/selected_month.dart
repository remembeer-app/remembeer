import 'package:remembeer/common/formatter/time_formatter.dart';

class SelectedMonth {
  const SelectedMonth({
    required this.year,
    required this.month,
    required this.isCurrentMonth,
  });

  final int year;
  final int month;
  final bool isCurrentMonth;

  String get displayName => formatMonthYear(year, month);
}
