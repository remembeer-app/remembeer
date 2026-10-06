import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/convex_api/types.dart';
import 'package:remembeer/drink/converter/drink_category_converter.dart';

part 'drink_snapshot.freezed.dart';
part 'drink_snapshot.g.dart';

@freezed
abstract class DrinkSnapshot with _$DrinkSnapshot {
  const factory DrinkSnapshot({
    required String name,
    @DrinkCategoryConverter() required DrinkCategory category,
    required double alcoholPercentage,
  }) = _DrinkSnapshot;

  factory DrinkSnapshot.fromJson(Map<String, dynamic> json) =>
      _$DrinkSnapshotFromJson(json);
}
