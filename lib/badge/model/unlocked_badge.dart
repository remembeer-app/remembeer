import 'package:freezed_annotation/freezed_annotation.dart';

part 'unlocked_badge.freezed.dart';
part 'unlocked_badge.g.dart';

@freezed
abstract class UnlockedBadge with _$UnlockedBadge {
  const factory UnlockedBadge({
    required String badgeId,
    required DateTime unlockedAt,
    required bool isShown,
  }) = _UnlockedBadge;

  factory UnlockedBadge.fromJson(Map<String, dynamic> json) =>
      _$UnlockedBadgeFromJson(json);
}
