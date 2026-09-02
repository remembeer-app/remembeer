// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beerpong_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BeerpongMatch _$BeerpongMatchFromJson(Map<String, dynamic> json) =>
    _BeerpongMatch(
      id: json['id'] as String,
      round: (json['round'] as num).toInt(),
      position: (json['position'] as num).toInt(),
      kind: $enumDecode(_$BeerpongMatchKindEnumMap, json['kind']),
      teamAId: json['teamAId'] as String?,
      teamBId: json['teamBId'] as String?,
      winnerTeamId: json['winnerTeamId'] as String?,
      loserTeamId: json['loserTeamId'] as String?,
      status: $enumDecode(_$BeerpongMatchStatusEnumMap, json['status']),
      nextMatchId: json['nextMatchId'] as String?,
      nextSlot: $enumDecodeNullable(
        _$BeerpongMatchSlotEnumMap,
        json['nextSlot'],
      ),
    );

Map<String, dynamic> _$BeerpongMatchToJson(_BeerpongMatch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'round': instance.round,
      'position': instance.position,
      'kind': _$BeerpongMatchKindEnumMap[instance.kind]!,
      'teamAId': instance.teamAId,
      'teamBId': instance.teamBId,
      'winnerTeamId': instance.winnerTeamId,
      'loserTeamId': instance.loserTeamId,
      'status': _$BeerpongMatchStatusEnumMap[instance.status]!,
      'nextMatchId': instance.nextMatchId,
      'nextSlot': _$BeerpongMatchSlotEnumMap[instance.nextSlot],
    };

const _$BeerpongMatchKindEnumMap = {
  BeerpongMatchKind.main: 'main',
  BeerpongMatchKind.thirdPlace: 'thirdPlace',
};

const _$BeerpongMatchStatusEnumMap = {
  BeerpongMatchStatus.pending: 'pending',
  BeerpongMatchStatus.ready: 'ready',
  BeerpongMatchStatus.completed: 'completed',
  BeerpongMatchStatus.bye: 'bye',
};

const _$BeerpongMatchSlotEnumMap = {
  BeerpongMatchSlot.a: 'a',
  BeerpongMatchSlot.b: 'b',
};
