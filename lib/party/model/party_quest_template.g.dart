// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_quest_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartyQuestTemplate _$PartyQuestTemplateFromJson(Map<String, dynamic> json) =>
    _PartyQuestTemplate(
      id: json['id'] as String,
      source: $enumDecode(_$PartyQuestTemplateSourceEnumMap, json['source']),
      builtInKey: json['builtInKey'] as String?,
      title: json['title'] as String,
      instructions: json['instructions'] as String,
      pointsUnits: (json['pointsUnits'] as num).toInt(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      eligibilityRule: json['eligibilityRule'] as String,
      enabled: json['enabled'] as bool? ?? true,
      catalogVersion: (json['catalogVersion'] as num).toInt(),
      createdByUserId: json['createdByUserId'] as String?,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$PartyQuestTemplateToJson(_PartyQuestTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': _$PartyQuestTemplateSourceEnumMap[instance.source]!,
      'builtInKey': instance.builtInKey,
      'title': instance.title,
      'instructions': instance.instructions,
      'pointsUnits': instance.pointsUnits,
      'durationMinutes': instance.durationMinutes,
      'eligibilityRule': instance.eligibilityRule,
      'enabled': instance.enabled,
      'catalogVersion': instance.catalogVersion,
      'createdByUserId': instance.createdByUserId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$PartyQuestTemplateSourceEnumMap = {
  PartyQuestTemplateSource.builtIn: 'builtIn',
  PartyQuestTemplateSource.custom: 'custom',
};
