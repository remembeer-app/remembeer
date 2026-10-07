import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/drink/converter/drink_category_converter.dart';

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

    required String name,
    @DrinkCategoryConverter() required DrinkCategory category,
    required double alcoholPercentage,
  }) = _Drink;

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);
}
