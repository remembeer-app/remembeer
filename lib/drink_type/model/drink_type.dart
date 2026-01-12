import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

part 'drink_type.freezed.dart';
part 'drink_type.g.dart';

@freezed
abstract class DrinkType with _$DrinkType implements Entity {
  const factory DrinkType({
    required String id,
    required String userId,
    @TimestampConverterOptimistic() required DateTime createdAt,
    @TimestampConverterOptimistic() required DateTime updatedAt,
    @TimestampConverter() DateTime? deletedAt,

    required String name,
    required DrinkCategory category,
    required double alcoholPercentage,
  }) = _DrinkType;

  factory DrinkType.fromJson(Map<String, dynamic> json) =>
      _$DrinkTypeFromJson(json);
}
