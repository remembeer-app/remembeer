import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/value_object.dart';

part 'friend_request_create.g.dart';

@JsonSerializable(createFactory: false)
class FriendRequestCreate extends ValueObject {
  final String toUserId;
  final String senderUsername;

  FriendRequestCreate({required this.toUserId, required this.senderUsername});

  @override
  Map<String, dynamic> toJson() => _$FriendRequestCreateToJson(this);
}
