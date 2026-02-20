import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/geopoint_converter.dart';
import 'package:remembeer/common/model/document.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';

part 'drink.freezed.dart';
part 'drink.g.dart';

@freezed
abstract class Drink with _$Drink implements Document {
  const factory Drink({
    required String id,

    required String consumedByUserId,
    required DateTime consumedAt,
    required DrinkTypeCore drinkType,
    required int volumeInMilliliters,
    @GeoPointConverter() GeoPoint? location,
  }) = _Drink;

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);
}
