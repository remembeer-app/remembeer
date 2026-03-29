import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/model/user_model.dart';

part 'session_with_members.freezed.dart';

@freezed
abstract class SessionWithMembers with _$SessionWithMembers {
  const SessionWithMembers._();

  const factory SessionWithMembers({
    required Session session,
    required Map<String, UserModel> members,
  }) = _SessionWithMembers;

  List<UserModel> get membersList => members.values.toList();

  int get memberCount => members.length;
}
