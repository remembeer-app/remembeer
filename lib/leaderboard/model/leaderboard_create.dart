import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/model/value_object.dart';

part 'leaderboard_create.freezed.dart';
part 'leaderboard_create.g.dart';

@freezed
abstract class LeaderboardCreate
    with _$LeaderboardCreate
    implements ValueObject {
  const factory LeaderboardCreate({
    required String name,
    required String iconName,
    required Set<String> memberIds,
    @Default({}) Set<String> bannedMemberIds,
    required String inviteCode,
  }) = _LeaderboardCreate;

  factory LeaderboardCreate.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardCreateFromJson(json);
}
