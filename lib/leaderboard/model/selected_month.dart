import 'package:remembeer/common/formatter/time_formatter.dart';

class SelectedMonth {
  final int year;
  final int month;

  const SelectedMonth({required this.year, required this.month});

  String get displayName => formatMonthYear(year, month);

  bool get isCurrentMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }
}
