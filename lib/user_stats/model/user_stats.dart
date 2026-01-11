import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';

@freezed
abstract class UserStats with _$UserStats {
  const factory UserStats({
    required double totalBeersConsumed,
    required double totalAlcoholConsumed,
    required double beersConsumedLast30Days,
    required double alcoholConsumedLast30Days,
    required int streakDays,
    required bool isStreakActive,
  }) = _UserStats;
}
