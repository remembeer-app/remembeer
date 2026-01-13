import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/common/controller/crud_controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/extension/query_firestore_helper.dart';
import 'package:remembeer/common/model/entity_with_members.dart';
import 'package:remembeer/common/model/value_object.dart';

abstract class MembersCrudController<
  T extends EntityWithMembers,
  U extends ValueObject
>
    extends CrudController<T, U> {
  MembersCrudController({
    required super.authService,
    required super.collectionPath,
    required super.fromJson,
  });

  Stream<List<T>> get entitiesStreamWhereCurrentUserIsMember =>
      nonDeletedEntities
          .where(
            memberIdsField,
            arrayContains: authService.authenticatedUser.uid,
          )
          .mapToStreamList();

  Future<void> addMemberAtomic(String entityId, String memberId) {
    return writeCollection.doc(entityId).update({
      memberIdsField: FieldValue.arrayUnion([memberId]),
      updatedAtField: FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeMemberAtomic(String entityId, String memberId) {
    return writeCollection.doc(entityId).update({
      memberIdsField: FieldValue.arrayRemove([memberId]),
      updatedAtField: FieldValue.serverTimestamp(),
    });
  }

  Future<void> banMemberAtomic(String entityId, String memberId) {
    return writeCollection.doc(entityId).update({
      bannedMemberIdsField: FieldValue.arrayUnion([memberId]),
      updatedAtField: FieldValue.serverTimestamp(),
    });
  }

  Future<void> unbanMemberAtomic(String entityId, String memberId) {
    return writeCollection.doc(entityId).update({
      bannedMemberIdsField: FieldValue.arrayRemove([memberId]),
      updatedAtField: FieldValue.serverTimestamp(),
    });
  }
}
