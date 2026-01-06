import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/extension/query_firestore_helper.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/common/model/value_object.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/user/constants.dart';

abstract class CrudController<T extends Entity, U extends ValueObject>
    extends Controller<T, U> {
  @protected
  final AuthService authService;

  CrudController({
    required this.authService,
    required super.collectionPath,
    required super.fromJson,
  });

  Stream<List<T>> get entitiesStreamForCurrentUser => nonDeletedEntities
      .where(userIdField, isEqualTo: authService.authenticatedUser.uid)
      .mapToStreamList();

  Future<void> createSingle(U dto) {
    return writeCollection.add(
      dto.toJson().withServerCreateTimestamps().withUserId(
        authService.authenticatedUser,
      ),
    );
  }

  Future<void> updateSingle(T entity) {
    _assertNotGlobal(entity);
    return writeCollection
        .doc(entity.id)
        .set(entity.toJson().withServerUpdateTimestamp());
  }

  Future<void> deleteSingle(T entity) {
    _assertNotGlobal(entity);
    return writeCollection
        .doc(entity.id)
        .set(entity.toJson().withServerDeleteTimestamps());
  }

  void createSingleInBatch(U dto, WriteBatch batch) {
    final docRef = writeCollection.doc();
    batch.set(
      docRef,
      dto.toJson().withServerCreateTimestamps().withUserId(
        authService.authenticatedUser,
      ),
    );
  }

  void updateSingleInBatch(T entity, WriteBatch batch) {
    _assertNotGlobal(entity);
    final docRef = writeCollection.doc(entity.id);
    batch.set(docRef, entity.toJson().withServerUpdateTimestamp());
  }

  void deleteSingleInBatch(T entity, WriteBatch batch) {
    _assertNotGlobal(entity);
    final docRef = writeCollection.doc(entity.id);
    batch.set(docRef, entity.toJson().withServerDeleteTimestamps());
  }

  void _assertNotGlobal(T entity) {
    invariant(
      entity.userId != globalUserId,
      'Cannot modify a global entity (${entity.id}) from the app.',
    );
  }
}
