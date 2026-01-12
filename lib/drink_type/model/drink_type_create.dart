import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/model/value_object.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

part 'drink_type_create.freezed.dart';
part 'drink_type_create.g.dart';

@freezed
abstract class DrinkTypeCreate with _$DrinkTypeCreate implements ValueObject {
  const factory DrinkTypeCreate({
    required String name,
    required DrinkCategory category,
    required double alcoholPercentage,
  }) = _DrinkTypeCreate;

  factory DrinkTypeCreate.fromJson(Map<String, dynamic> json) =>
      _$DrinkTypeCreateFromJson(json);
}
