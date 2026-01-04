// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unlocked_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnlockedBadge _$UnlockedBadgeFromJson(Map<String, dynamic> json) =>
    UnlockedBadge(
      badgeId: json['badgeId'] as String,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
      isShown: json['isShown'] as bool,
    );

Map<String, dynamic> _$UnlockedBadgeToJson(UnlockedBadge instance) =>
    <String, dynamic>{
      'badgeId': instance.badgeId,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
      'isShown': instance.isShown,
    };
