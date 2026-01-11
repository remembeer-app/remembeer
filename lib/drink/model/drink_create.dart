import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/converter/geopoint_converter.dart';
import 'package:remembeer/common/model/value_object.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

part 'drink_create.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: false)
@GeoPointConverter()
class DrinkCreate extends ValueObject {
  final DateTime consumedAt;
  final DrinkType drinkType;
  final int volumeInMilliliters;
  final GeoPoint? location;

  DrinkCreate({
    required this.consumedAt,
    required this.drinkType,
    required this.volumeInMilliliters,
    this.location,
  });

  @override
  Map<String, dynamic> toJson() => _$DrinkCreateToJson(this);
}
