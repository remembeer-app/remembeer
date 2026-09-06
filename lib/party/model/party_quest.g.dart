// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartyQuest _$PartyQuestFromJson(Map<String, dynamic> json) => _PartyQuest(
  id: json['id'] as String,
  templateId: json['templateId'] as String,
  titleSnapshot: json['titleSnapshot'] as String,
  instructionsSnapshot: json['instructionsSnapshot'] as String,
  pointsUnits: (json['pointsUnits'] as num).toInt(),
  startsAt: const TimestampConverter().fromJson(json['startsAt'] as Timestamp),
  endsAt: const TimestampConverter().fromJson(json['endsAt'] as Timestamp),
  status: $enumDecode(_$PartyQuestStatusEnumMap, json['status']),
  eligibleMemberIds:
      (json['eligibleMemberIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  completedPairKeys:
      (json['completedPairKeys'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  createdAt: const TimestampConverterOptimistic().fromJson(
    json['createdAt'] as Timestamp?,
  ),
);

Map<String, dynamic> _$PartyQuestToJson(
  _PartyQuest instance,
) => <String, dynamic>{
  'id': instance.id,
  'templateId': instance.templateId,
  'titleSnapshot': instance.titleSnapshot,
  'instructionsSnapshot': instance.instructionsSnapshot,
  'pointsUnits': instance.pointsUnits,
  'startsAt': const TimestampConverter().toJson(instance.startsAt),
  'endsAt': const TimestampConverter().toJson(instance.endsAt),
  'status': _$PartyQuestStatusEnumMap[instance.status]!,
  'eligibleMemberIds': instance.eligibleMemberIds,
  'completedPairKeys': instance.completedPairKeys,
  'createdAt': const TimestampConverterOptimistic().toJson(instance.createdAt),
};

const _$PartyQuestStatusEnumMap = {
  PartyQuestStatus.active: 'active',
  PartyQuestStatus.expired: 'expired',
  PartyQuestStatus.cancelled: 'cancelled',
};
