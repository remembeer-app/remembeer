import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'daily_stats.g.dart';

@JsonSerializable()
class DailyStats {
  final int day;
  final double beersConsumed;
  final double alcoholConsumedMl;
  final double beersAfter6pm;

  const DailyStats({
    required this.day,
    this.beersConsumed = 0,
    this.alcoholConsumedMl = 0,
    this.beersAfter6pm = 0,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) =>
      _$DailyStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DailyStatsToJson(this);

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

  DailyStats copyWith({
    double? beersConsumed,
    double? alcoholConsumedMl,
    double? beersAfter6pm,
  }) {
    return DailyStats(
      day: day,
      beersConsumed: beersConsumed ?? this.beersConsumed,
      alcoholConsumedMl: alcoholConsumedMl ?? this.alcoholConsumedMl,
      beersAfter6pm: beersAfter6pm ?? this.beersAfter6pm,
    );
  }
}
