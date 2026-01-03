import 'package:json_annotation/json_annotation.dart';

part 'unlocked_badge.g.dart';

@JsonSerializable()
class UnlockedBadge {
  final String badgeId;
  final DateTime? unlockedAt;

  const UnlockedBadge({required this.badgeId, this.unlockedAt});

  factory UnlockedBadge.fromJson(Map<String, dynamic> json) =>
      _$UnlockedBadgeFromJson(json);

  Map<String, dynamic> toJson() => _$UnlockedBadgeToJson(this);
}
