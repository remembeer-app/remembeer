import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/document.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

part 'party_member.freezed.dart';
part 'party_member.g.dart';

@freezed
abstract class PartyMember with _$PartyMember implements Document {
  const factory PartyMember({
    required String id,
    required String userId,
    DrinkCategory? selectedClass,
    @Default(0) int classVersion,
    @TimestampConverter() DateTime? classChangedAt,
    @Default(false) bool beerpongOptIn,
    @Default(0) int scoreUnits,
    @Default(0) int drinkCount,
    @Default(true) bool isActive,
    @TimestampConverter() required DateTime joinedAt,
    @TimestampConverterOptimistic() required DateTime updatedAt,
  }) = _PartyMember;

  factory PartyMember.fromJson(Map<String, dynamic> json) =>
      _$PartyMemberFromJson(json);
}
