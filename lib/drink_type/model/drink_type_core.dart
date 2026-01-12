import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

part 'drink_type_core.freezed.dart';
part 'drink_type_core.g.dart';

@freezed
abstract class DrinkTypeCore with _$DrinkTypeCore {
  const factory DrinkTypeCore({
    required String name,
    required DrinkCategory category,
    required double alcoholPercentage,
  }) = _DrinkTypeCore;

  factory DrinkTypeCore.fromJson(Map<String, dynamic> json) =>
      _$DrinkTypeCoreFromJson(json);
}
