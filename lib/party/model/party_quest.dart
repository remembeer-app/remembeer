import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/document.dart';

part 'party_quest.freezed.dart';
part 'party_quest.g.dart';

enum PartyQuestStatus { active, expired, cancelled }

@freezed
abstract class PartyQuest with _$PartyQuest implements Document {
  const factory PartyQuest({
    required String id,
    required String templateId,
    required String titleSnapshot,
    required String instructionsSnapshot,
    required int pointsUnits,
    @TimestampConverter() required DateTime startsAt,
    @TimestampConverter() required DateTime endsAt,
    required PartyQuestStatus status,
    @Default(<String>[]) List<String> eligibleMemberIds,
    @Default(<String>[]) List<String> eligiblePairKeys,
    @Default(<String>[]) List<String> completedPairKeys,
    @TimestampConverterOptimistic() required DateTime createdAt,
  }) = _PartyQuest;

  factory PartyQuest.fromJson(Map<String, dynamic> json) =>
      _$PartyQuestFromJson(json);
}
