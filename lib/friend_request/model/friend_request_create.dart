import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/model/value_object.dart';

part 'friend_request_create.freezed.dart';
part 'friend_request_create.g.dart';

@freezed
abstract class FriendRequestCreate
    with _$FriendRequestCreate
    implements ValueObject {
  const factory FriendRequestCreate({
    required String toUserId,
    required String senderUsername,
  }) = _FriendRequestCreate;

  factory FriendRequestCreate.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestCreateFromJson(json);
}
