import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/document.dart';

part 'party_quest_template.freezed.dart';
part 'party_quest_template.g.dart';

enum PartyQuestTemplateSource { builtIn, custom }

@freezed
abstract class PartyQuestTemplate
    with _$PartyQuestTemplate
    implements Document {
  const factory PartyQuestTemplate({
    required String id,
    required PartyQuestTemplateSource source,
    String? builtInKey,
    required String title,
    required String instructions,
    required int pointsUnits,
    required int durationMinutes,
    required String eligibilityRule,
    @Default(true) bool enabled,
    required int catalogVersion,
    String? createdByUserId,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _PartyQuestTemplate;

  factory PartyQuestTemplate.fromJson(Map<String, dynamic> json) =>
      _$PartyQuestTemplateFromJson(json);
}
