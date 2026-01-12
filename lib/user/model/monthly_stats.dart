import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/user/model/daily_stats.dart';

part 'monthly_stats.freezed.dart';
part 'monthly_stats.g.dart';

@freezed
abstract class MonthlyStats with _$MonthlyStats {
  const MonthlyStats._();

  const factory MonthlyStats({
    required int year,
    required int month,
    required double beersConsumed,
    required double alcoholConsumedMl,
    @Default({}) Map<int, DailyStats> dailyStats,
  }) = _MonthlyStats;

  factory MonthlyStats.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStatsFromJson(json);

  String get key => '${year}_$month';

  static String keyFor(int year, int month) => '${year}_$month';

  MonthlyStats addDrink({
    required int day,
    required double beersEquivalent,
    required double alcoholMl,
    required bool after6pm,
  }) {
    final currentDaily = dailyStats[day] ?? DailyStats(day: day);
    final updatedDaily = currentDaily.addDrink(
      beersEquivalent: beersEquivalent,
      alcoholMl: alcoholMl,
      after6pm: after6pm,
    );

    return copyWith(
      beersConsumed: beersConsumed + beersEquivalent,
      alcoholConsumedMl: alcoholConsumedMl + alcoholMl,
      dailyStats: {...dailyStats, day: updatedDaily},
    );
  }

  MonthlyStats removeDrink({
    required int day,
    required double beersEquivalent,
    required double alcoholMl,
    required bool after6pm,
  }) {
    final currentDaily = dailyStats[day] ?? DailyStats(day: day);
    final updatedDaily = currentDaily.removeDrink(
      beersEquivalent: beersEquivalent,
      alcoholMl: alcoholMl,
      after6pm: after6pm,
    );

    return copyWith(
      beersConsumed: max(0, beersConsumed - beersEquivalent),
      alcoholConsumedMl: max(0, alcoholConsumedMl - alcoholMl),
      dailyStats: {...dailyStats, day: updatedDaily},
    );
  }
}
