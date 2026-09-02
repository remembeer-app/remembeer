// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartyChallenge _$PartyChallengeFromJson(
  Map<String, dynamic> json,
) => _PartyChallenge(
  id: json['id'] as String,
  title: json['title'] as String,
  instructions: json['instructions'] as String,
  pointsUnits: (json['pointsUnits'] as num).toInt(),
  startsAt: const TimestampConverter().fromJson(json['startsAt'] as Timestamp),
  endsAt: const TimestampConverter().fromJson(json['endsAt'] as Timestamp),
  status: $enumDecode(_$PartyChallengeStatusEnumMap, json['status']),
  winnerIds:
      (json['winnerIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdByUserId: json['createdByUserId'] as String,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$PartyChallengeToJson(_PartyChallenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'instructions': instance.instructions,
      'pointsUnits': instance.pointsUnits,
      'startsAt': const TimestampConverter().toJson(instance.startsAt),
      'endsAt': const TimestampConverter().toJson(instance.endsAt),
      'status': _$PartyChallengeStatusEnumMap[instance.status]!,
      'winnerIds': instance.winnerIds,
      'createdByUserId': instance.createdByUserId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$PartyChallengeStatusEnumMap = {
  PartyChallengeStatus.active: 'active',
  PartyChallengeStatus.completed: 'completed',
  PartyChallengeStatus.expired: 'expired',
  PartyChallengeStatus.cancelled: 'cancelled',
};
