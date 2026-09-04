// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beerpong_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BeerpongTeam _$BeerpongTeamFromJson(Map<String, dynamic> json) =>
    _BeerpongTeam(
      id: json['id'] as String,
      name: json['name'] as String,
      memberIds:
          (json['memberIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      seed: (json['seed'] as num).toInt(),
      placement: (json['placement'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BeerpongTeamToJson(_BeerpongTeam instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'memberIds': instance.memberIds,
      'seed': instance.seed,
      'placement': instance.placement,
    };
