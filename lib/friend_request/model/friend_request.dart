import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/common/model/timestamp_converter.dart';

part 'friend_request.g.dart';

@JsonSerializable()
class FriendRequest extends Entity {
  final String toUserId;
  final String senderUsername;

  const FriendRequest({
    required super.id,
    required super.userId,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    required this.toUserId,
    required this.senderUsername,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);
}
