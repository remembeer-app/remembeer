import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/geopoint_converter.dart';
import 'package:remembeer/common/converter/local_date_time_converter.dart';
import 'package:remembeer/common/model/document.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';

part 'drink.freezed.dart';
part 'drink.g.dart';

@freezed
abstract class Drink with _$Drink implements Document {
  const Drink._();

  const factory Drink({
    required String id,

    required String consumedByUserId,
    @LocalDateTimeConverter() required DateTime consumedAt,
    required DrinkTypeCore drinkType,
    @JsonKey(includeIfNull: false) String? drinkTypeId,
    required int volumeInMilliliters,
    @GeoPointConverter() GeoPoint? location,
    @JsonKey(includeToJson: false) @Default(1) int partyRevision,
  }) = _Drink;

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);

  double get alcoholMl =>
      volumeInMilliliters * drinkType.alcoholPercentage / 100;
}
