// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beerpong_tournament.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BeerpongTournament _$BeerpongTournamentFromJson(Map<String, dynamic> json) =>
    _BeerpongTournament(
      id: json['id'] as String,
      status: $enumDecode(_$BeerpongTournamentStatusEnumMap, json['status']),
      participantIds:
          (json['participantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      teamCount: (json['teamCount'] as num).toInt(),
      thirdPlaceEnabled: json['thirdPlaceEnabled'] as bool? ?? false,
      firstPlacePointsUnits: (json['firstPlacePointsUnits'] as num).toInt(),
      secondPlacePointsUnits: (json['secondPlacePointsUnits'] as num).toInt(),
      thirdPlacePointsUnits: (json['thirdPlacePointsUnits'] as num).toInt(),
      randomSeedHash: json['randomSeedHash'] as String,
      randomSeedReveal: json['randomSeedReveal'] as String?,
      createdByUserId: json['createdByUserId'] as String,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      completedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
        json['completedAt'],
        const TimestampConverter().fromJson,
      ),
    );

Map<String, dynamic> _$BeerpongTournamentToJson(_BeerpongTournament instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$BeerpongTournamentStatusEnumMap[instance.status]!,
      'participantIds': instance.participantIds,
      'teamCount': instance.teamCount,
      'thirdPlaceEnabled': instance.thirdPlaceEnabled,
      'firstPlacePointsUnits': instance.firstPlacePointsUnits,
      'secondPlacePointsUnits': instance.secondPlacePointsUnits,
      'thirdPlacePointsUnits': instance.thirdPlacePointsUnits,
      'randomSeedHash': instance.randomSeedHash,
      'randomSeedReveal': instance.randomSeedReveal,
      'createdByUserId': instance.createdByUserId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'completedAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.completedAt,
        const TimestampConverter().toJson,
      ),
    };

const _$BeerpongTournamentStatusEnumMap = {
  BeerpongTournamentStatus.enrollment: 'enrollment',
  BeerpongTournamentStatus.active: 'active',
  BeerpongTournamentStatus.completed: 'completed',
  BeerpongTournamentStatus.cancelled: 'cancelled',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
