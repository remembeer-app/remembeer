// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionCreate _$SessionCreateFromJson(Map<String, dynamic> json) =>
    _SessionCreate(
      name: json['name'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      memberIds: (json['memberIds'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
    );

Map<String, dynamic> _$SessionCreateToJson(_SessionCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'memberIds': instance.memberIds.toList(),
    };
