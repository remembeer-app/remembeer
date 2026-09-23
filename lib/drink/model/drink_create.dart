import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/model/value_object.dart';
import 'package:remembeer/drink/model/drink_category.dart';

part 'drink_create.freezed.dart';
part 'drink_create.g.dart';

@freezed
abstract class DrinkCreate with _$DrinkCreate implements ValueObject {
  const factory DrinkCreate({
    required String name,
    required DrinkCategory category,
    required double alcoholPercentage,
  }) = _DrinkCreate;

  factory DrinkCreate.fromJson(Map<String, dynamic> json) =>
      _$DrinkCreateFromJson(json);
}
