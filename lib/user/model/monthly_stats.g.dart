// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyStats _$MonthlyStatsFromJson(Map<String, dynamic> json) =>
    _MonthlyStats(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      beersConsumed: (json['beersConsumed'] as num).toDouble(),
      alcoholConsumedMl: (json['alcoholConsumedMl'] as num).toDouble(),
      dailyStats:
          (json['dailyStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              int.parse(k),
              DailyStats.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const {},
    );

Map<String, dynamic> _$MonthlyStatsToJson(_MonthlyStats instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'beersConsumed': instance.beersConsumed,
      'alcoholConsumedMl': instance.alcoholConsumedMl,
      'dailyStats': instance.dailyStats.map(
        (k, e) => MapEntry(k.toString(), e.toJson()),
      ),
    };
