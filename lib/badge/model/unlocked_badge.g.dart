// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unlocked_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnlockedBadge _$UnlockedBadgeFromJson(Map<String, dynamic> json) =>
    _UnlockedBadge(
      badgeId: json['badgeId'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      isShown: json['isShown'] as bool,
    );

Map<String, dynamic> _$UnlockedBadgeToJson(_UnlockedBadge instance) =>
    <String, dynamic>{
      'badgeId': instance.badgeId,
      'unlockedAt': instance.unlockedAt.toIso8601String(),
      'isShown': instance.isShown,
    };
