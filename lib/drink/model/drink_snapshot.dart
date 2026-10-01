import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/drink/model/drink_category.dart';

part 'drink_snapshot.freezed.dart';
part 'drink_snapshot.g.dart';

@freezed
abstract class DrinkSnapshot with _$DrinkSnapshot {
  const factory DrinkSnapshot({
    required String name,
    required DrinkCategory category,
    required double alcoholPercentage,
  }) = _DrinkSnapshot;

  factory DrinkSnapshot.fromJson(Map<String, dynamic> json) =>
      _$DrinkSnapshotFromJson(json);
}
