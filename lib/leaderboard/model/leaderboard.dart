import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/entity_with_members.dart';

part 'leaderboard.freezed.dart';
part 'leaderboard.g.dart';

@freezed
abstract class Leaderboard with _$Leaderboard implements EntityWithMembers {
  const factory Leaderboard({
    required String id,
    required String userId,
    @TimestampConverterOptimistic() required DateTime createdAt,
    @TimestampConverterOptimistic() required DateTime updatedAt,
    @TimestampConverter() DateTime? deletedAt,
    required Set<String> memberIds,
    required Set<String> bannedMemberIds,

    required String name,
    required String iconName,
    required String inviteCode,
  }) = _Leaderboard;

  factory Leaderboard.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardFromJson(json);
}
