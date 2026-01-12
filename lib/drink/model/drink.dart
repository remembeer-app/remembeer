import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/geopoint_converter.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/converter/timestamp_converter_optimistic.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

part 'drink.freezed.dart';
part 'drink.g.dart';

@freezed
abstract class Drink with _$Drink implements Entity {
  const factory Drink({
    required String id,
    required String userId,
    @TimestampConverterOptimistic() required DateTime createdAt,
    @TimestampConverterOptimistic() required DateTime updatedAt,
    @TimestampConverter() DateTime? deletedAt,

    required DateTime consumedAt,
    required DrinkType drinkType,
    required int volumeInMilliliters,
    @GeoPointConverter() GeoPoint? location,
    String? sessionId,
  }) = _Drink;

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);
}
