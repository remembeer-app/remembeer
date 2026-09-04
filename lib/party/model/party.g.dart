// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartyModuleSettings _$PartyModuleSettingsFromJson(Map<String, dynamic> json) =>
    _PartyModuleSettings(
      socialQuestsEnabled: json['socialQuestsEnabled'] as bool? ?? false,
      adminChallengesEnabled: json['adminChallengesEnabled'] as bool? ?? false,
      beerpongEnabled: json['beerpongEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$PartyModuleSettingsToJson(
  _PartyModuleSettings instance,
) => <String, dynamic>{
  'socialQuestsEnabled': instance.socialQuestsEnabled,
  'adminChallengesEnabled': instance.adminChallengesEnabled,
  'beerpongEnabled': instance.beerpongEnabled,
};

_PartyQuestSchedule _$PartyQuestScheduleFromJson(Map<String, dynamic> json) =>
    _PartyQuestSchedule(
      minIntervalMinutes:
          (json['minIntervalMinutes'] as num?)?.toInt() ??
          defaultPartyQuestMinIntervalMinutes,
      maxIntervalMinutes:
          (json['maxIntervalMinutes'] as num?)?.toInt() ??
          defaultPartyQuestMaxIntervalMinutes,
      defaultDurationMinutes:
          (json['defaultDurationMinutes'] as num?)?.toInt() ??
          defaultPartyQuestDurationMinutes,
      nextQuestAt: _$JsonConverterFromJson<Timestamp, DateTime>(
        json['nextQuestAt'],
        const TimestampConverter().fromJson,
      ),
    );

Map<String, dynamic> _$PartyQuestScheduleToJson(_PartyQuestSchedule instance) =>
    <String, dynamic>{
      'minIntervalMinutes': instance.minIntervalMinutes,
      'maxIntervalMinutes': instance.maxIntervalMinutes,
      'defaultDurationMinutes': instance.defaultDurationMinutes,
      'nextQuestAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.nextQuestAt,
        const TimestampConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_Party _$PartyFromJson(Map<String, dynamic> json) => _Party(
  id: json['id'] as String,
  sessionId: json['sessionId'] as String,
  status: $enumDecode(_$PartyStatusEnumMap, json['status']),
  activatedAt: const TimestampConverter().fromJson(
    json['activatedAt'] as Timestamp,
  ),
  activatedByUserId: json['activatedByUserId'] as String,
  archivedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['archivedAt'],
    const TimestampConverter().fromJson,
  ),
  moduleSettings: json['moduleSettings'] == null
      ? const PartyModuleSettings()
      : PartyModuleSettings.fromJson(
          json['moduleSettings'] as Map<String, dynamic>,
        ),
  questSchedule: json['questSchedule'] == null
      ? const PartyQuestSchedule()
      : PartyQuestSchedule.fromJson(
          json['questSchedule'] as Map<String, dynamic>,
        ),
  activeQuestId: json['activeQuestId'] as String?,
  activeChallengeId: json['activeChallengeId'] as String?,
  activeTournamentId: json['activeTournamentId'] as String?,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? partySchemaVersion,
  createdAt: const TimestampConverterOptimistic().fromJson(
    json['createdAt'] as Timestamp?,
  ),
  updatedAt: const TimestampConverterOptimistic().fromJson(
    json['updatedAt'] as Timestamp?,
  ),
);

Map<String, dynamic> _$PartyToJson(_Party instance) => <String, dynamic>{
  'id': instance.id,
  'sessionId': instance.sessionId,
  'status': _$PartyStatusEnumMap[instance.status]!,
  'activatedAt': const TimestampConverter().toJson(instance.activatedAt),
  'activatedByUserId': instance.activatedByUserId,
  'archivedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.archivedAt,
    const TimestampConverter().toJson,
  ),
  'moduleSettings': instance.moduleSettings.toJson(),
  'questSchedule': instance.questSchedule.toJson(),
  'activeQuestId': instance.activeQuestId,
  'activeChallengeId': instance.activeChallengeId,
  'activeTournamentId': instance.activeTournamentId,
  'schemaVersion': instance.schemaVersion,
  'createdAt': const TimestampConverterOptimistic().toJson(instance.createdAt),
  'updatedAt': const TimestampConverterOptimistic().toJson(instance.updatedAt),
};

const _$PartyStatusEnumMap = {
  PartyStatus.active: 'active',
  PartyStatus.archived: 'archived',
};
