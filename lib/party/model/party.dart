import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/document.dart';
import 'package:remembeer/party/constants.dart';

part 'party.freezed.dart';
part 'party.g.dart';

enum PartyStatus { active, archived }

@freezed
abstract class PartyModuleSettings with _$PartyModuleSettings {
  const factory PartyModuleSettings({
    @Default(false) bool socialQuestsEnabled,
    @Default(false) bool adminChallengesEnabled,
    @Default(false) bool beerpongEnabled,
  }) = _PartyModuleSettings;

  factory PartyModuleSettings.fromJson(Map<String, dynamic> json) =>
      _$PartyModuleSettingsFromJson(json);
}

@freezed
abstract class PartyQuestSchedule with _$PartyQuestSchedule {
  const factory PartyQuestSchedule({
    @Default(defaultPartyQuestMinIntervalMinutes) int minIntervalMinutes,
    @Default(defaultPartyQuestMaxIntervalMinutes) int maxIntervalMinutes,
    @Default(defaultPartyQuestDurationMinutes) int defaultDurationMinutes,
    @TimestampConverter() DateTime? nextQuestAt,
  }) = _PartyQuestSchedule;

  factory PartyQuestSchedule.fromJson(Map<String, dynamic> json) =>
      _$PartyQuestScheduleFromJson(json);
}

@freezed
abstract class Party with _$Party implements Document {
  const factory Party({
    required String id,
    required String sessionId,
    required PartyStatus status,
    @TimestampConverter() required DateTime activatedAt,
    required String activatedByUserId,
    @TimestampConverter() DateTime? archivedAt,
    @Default(PartyModuleSettings()) PartyModuleSettings moduleSettings,
    @Default(PartyQuestSchedule()) PartyQuestSchedule questSchedule,
    String? activeQuestId,
    String? activeChallengeId,
    String? activeTournamentId,
    @Default(partySchemaVersion) int schemaVersion,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Party;

  factory Party.fromJson(Map<String, dynamic> json) => _$PartyFromJson(json);
}
