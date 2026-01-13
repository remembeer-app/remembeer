import 'package:remembeer/common/model/entity.dart';

abstract class EntityWithMembers extends Entity {
  Set<String> get memberIds;
  Set<String> get bannedMemberIds;
}
