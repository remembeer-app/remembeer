import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/user/model/daily_stats.dart';

part 'monthly_stats.g.dart';

@JsonSerializable(explicitToJson: true)
class MonthlyStats {
  final int year;
  final int month;
  final double beersConsumed;
  final double alcoholConsumedMl;
  final Map<int, DailyStats> dailyStats;

  const MonthlyStats({
    required this.year,
    required this.month,
    required this.beersConsumed,
    required this.alcoholConsumedMl,
    this.dailyStats = const {},
  });

  factory MonthlyStats.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStatsFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyStatsToJson(this);

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

  MonthlyStats copyWith({
    double? beersConsumed,
    double? alcoholConsumedMl,
    Map<int, DailyStats>? dailyStats,
  }) {
    return MonthlyStats(
      year: year,
      month: month,
      beersConsumed: beersConsumed ?? this.beersConsumed,
      alcoholConsumedMl: alcoholConsumedMl ?? this.alcoholConsumedMl,
      dailyStats: dailyStats ?? this.dailyStats,
    );
  }
}
