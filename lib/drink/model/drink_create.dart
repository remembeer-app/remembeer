import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/geopoint_converter.dart';
import 'package:remembeer/common/model/value_object.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';

part 'drink_create.freezed.dart';
part 'drink_create.g.dart';

@freezed
abstract class DrinkCreate with _$DrinkCreate implements ValueObject {
  const factory DrinkCreate({
    required DateTime consumedAt,
    required DrinkTypeCore drinkType,
    required int volumeInMilliliters,
    @GeoPointConverter() GeoPoint? location,
  }) = _DrinkCreate;

  factory DrinkCreate.fromJson(Map<String, dynamic> json) =>
      _$DrinkCreateFromJson(json);
}
