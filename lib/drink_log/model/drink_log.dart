import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/geopoint_converter.dart';
import 'package:remembeer/common/converter/local_date_time_converter.dart';
import 'package:remembeer/common/model/document.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';

part 'drink_log.freezed.dart';
part 'drink_log.g.dart';

@freezed
abstract class DrinkLog with _$DrinkLog implements Document {
  const DrinkLog._();

  const factory DrinkLog({
    required String id,

    required String consumedByUserId,
    @LocalDateTimeConverter() required DateTime consumedAt,
    required DrinkSnapshot drink,
    @JsonKey(name: 'drinkId', includeIfNull: false) String? catalogDrinkId,
    required int volumeInMilliliters,
    @GeoPointConverter() GeoPoint? location,
    @JsonKey(includeToJson: false) @Default(1) int partyRevision,
  }) = _DrinkLog;

  factory DrinkLog.fromJson(Map<String, dynamic> json) =>
      _$DrinkLogFromJson(json);

  double get alcoholMl => volumeInMilliliters * drink.alcoholPercentage / 100;
}
