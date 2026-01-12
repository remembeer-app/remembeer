// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardCreate _$LeaderboardCreateFromJson(Map<String, dynamic> json) =>
    _LeaderboardCreate(
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      memberIds: (json['memberIds'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      bannedMemberIds:
          (json['bannedMemberIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
      inviteCode: json['inviteCode'] as String,
    );

Map<String, dynamic> _$LeaderboardCreateToJson(_LeaderboardCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'iconName': instance.iconName,
      'memberIds': instance.memberIds.toList(),
      'bannedMemberIds': instance.bannedMemberIds.toList(),
      'inviteCode': instance.inviteCode,
    };
