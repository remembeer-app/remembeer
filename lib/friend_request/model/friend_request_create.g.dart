// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendRequestCreate _$FriendRequestCreateFromJson(Map<String, dynamic> json) =>
    _FriendRequestCreate(
      toUserId: json['toUserId'] as String,
      senderUsername: json['senderUsername'] as String,
    );

Map<String, dynamic> _$FriendRequestCreateToJson(
  _FriendRequestCreate instance,
) => <String, dynamic>{
  'toUserId': instance.toUserId,
  'senderUsername': instance.senderUsername,
};
