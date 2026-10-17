import 'package:remembeer/convex_api/types.dart';

extension SessionMemberStatusLabel on SessionMemberStatus {
  String get label => switch (this) {
    Invited() => 'Invited',
    Joined() => 'Joined',
    Left() => 'Left',
    Banned() => 'Banned',
    Declined() => 'Declined',
  };
}
