import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/entity.dart';

part 'leaderboard.g.dart';

@JsonSerializable()
class Leaderboard extends Entity {
  final String name;
  final String iconName;
  final Set<String> memberIds;
  final Set<String> bannedMemberIds;
  final String inviteCode;

  const Leaderboard({
    required super.id,
    required super.userId,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    required this.name,
    required this.iconName,
    required this.memberIds,
    required this.bannedMemberIds,
    required this.inviteCode,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LeaderboardToJson(this);

  Leaderboard copyWith({
    String? name,
    String? iconName,
    Set<String>? memberIds,
    Set<String>? bannedMemberIds,
  }) {
    return Leaderboard(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      userId: userId,
      inviteCode: inviteCode,

      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      memberIds: memberIds ?? this.memberIds,
      bannedMemberIds: bannedMemberIds ?? this.bannedMemberIds,
    );
  }
}
