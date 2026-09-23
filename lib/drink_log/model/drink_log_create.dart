import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/geopoint_converter.dart';
import 'package:remembeer/common/model/value_object.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';

part 'drink_log_create.freezed.dart';
part 'drink_log_create.g.dart';

@freezed
abstract class DrinkLogCreate with _$DrinkLogCreate implements ValueObject {
  const factory DrinkLogCreate({
    required DateTime consumedAt,
    required DrinkSnapshot drink,
    required int volumeInMilliliters,
    @GeoPointConverter() GeoPoint? location,
  }) = _DrinkLogCreate;

  factory DrinkLogCreate.fromJson(Map<String, dynamic> json) =>
      _$DrinkLogCreateFromJson(json);
}
