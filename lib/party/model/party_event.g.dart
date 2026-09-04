// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartyEvent _$PartyEventFromJson(Map<String, dynamic> json) => _PartyEvent(
  id: json['id'] as String,
  kind: $enumDecode(_$PartyEventKindEnumMap, json['kind']),
  recipientUserId: json['recipientUserId'] as String,
  participantIds: (json['participantIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  pointsUnits: (json['pointsUnits'] as num).toInt(),
  sourceCollection: $enumDecode(
    _$PartyEventSourceCollectionEnumMap,
    json['sourceCollection'],
  ),
  sourceId: json['sourceId'] as String,
  reversesEventId: json['reversesEventId'] as String?,
  actorUserId: json['actorUserId'] as String?,
  occurredAt: const TimestampConverter().fromJson(
    json['occurredAt'] as Timestamp,
  ),
  createdAt: const TimestampConverterOptimistic().fromJson(
    json['createdAt'] as Timestamp?,
  ),
  payload:
      json['payload'] as Map<String, dynamic>? ?? const <String, Object?>{},
);

Map<String, dynamic> _$PartyEventToJson(
  _PartyEvent instance,
) => <String, dynamic>{
  'id': instance.id,
  'kind': _$PartyEventKindEnumMap[instance.kind]!,
  'recipientUserId': instance.recipientUserId,
  'participantIds': instance.participantIds,
  'pointsUnits': instance.pointsUnits,
  'sourceCollection':
      _$PartyEventSourceCollectionEnumMap[instance.sourceCollection]!,
  'sourceId': instance.sourceId,
  'reversesEventId': instance.reversesEventId,
  'actorUserId': instance.actorUserId,
  'occurredAt': const TimestampConverter().toJson(instance.occurredAt),
  'createdAt': const TimestampConverterOptimistic().toJson(instance.createdAt),
  'payload': instance.payload,
};

const _$PartyEventKindEnumMap = {
  PartyEventKind.drink: 'drink',
  PartyEventKind.socialQuest: 'socialQuest',
  PartyEventKind.adminChallenge: 'adminChallenge',
  PartyEventKind.beerpongPlacement: 'beerpongPlacement',
  PartyEventKind.reversal: 'reversal',
};

const _$PartyEventSourceCollectionEnumMap = {
  PartyEventSourceCollection.drinks: 'drinks',
  PartyEventSourceCollection.quests: 'quests',
  PartyEventSourceCollection.challenges: 'challenges',
  PartyEventSourceCollection.tournaments: 'tournaments',
};
