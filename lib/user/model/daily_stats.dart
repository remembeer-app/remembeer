import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_stats.freezed.dart';
part 'daily_stats.g.dart';

@freezed
abstract class DailyStats with _$DailyStats {
  const DailyStats._();

  const factory DailyStats({
    required int day,
    @Default(0) double beersConsumed,
    @Default(0) double alcoholConsumedMl,
    @Default(0) double beersAfter6pm,
  }) = _DailyStats;

  factory DailyStats.fromJson(Map<String, dynamic> json) =>
      _$DailyStatsFromJson(json);

  DailyStats addDrink({
    required double beersEquivalent,
    required double alcoholMl,
    required bool after6pm,
  }) {
    return copyWith(
      beersConsumed: beersConsumed + beersEquivalent,
      alcoholConsumedMl: alcoholConsumedMl + alcoholMl,
      beersAfter6pm: beersAfter6pm + (after6pm ? beersEquivalent : 0),
    );
  }

  DailyStats removeDrink({
    required double beersEquivalent,
    required double alcoholMl,
    required bool after6pm,
  }) {
    return copyWith(
      beersConsumed: max(0, beersConsumed - beersEquivalent),
      alcoholConsumedMl: max(0, alcoholConsumedMl - alcoholMl),
      beersAfter6pm: max(0, beersAfter6pm - (after6pm ? beersEquivalent : 0)),
    );
  }
}
