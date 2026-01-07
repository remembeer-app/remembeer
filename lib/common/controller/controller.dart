import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/model/document.dart';
import 'package:remembeer/common/util/invariant.dart';

abstract class Controller<T extends Document> {
  @protected
  final CollectionReference<T> readCollection;
  @protected
  final CollectionReference<Map<String, dynamic>> writeCollection;

  Controller({
    required String collectionPath,
    required T Function(Map<String, dynamic> json) fromJson,
  }) : readCollection = FirebaseFirestore.instance
           .collection(collectionPath)
           .withConverter(
             fromFirestore: (snapshot, _) {
               final json = snapshot.data() ?? {};
               return fromJson(json.withId(snapshot.id));
             },
             toFirestore: (_, _) =>
                 never('Invalid write to a read-only ${T}s collection.'),
           ),
       writeCollection = FirebaseFirestore.instance
           .collection(collectionPath)
           .withConverter(
             fromFirestore: (_, _) =>
                 never('Invalid read from a write-only ${T}s collection.'),
             toFirestore: (json, _) => json.withoutId(),
           );

  WriteBatch get batch => FirebaseFirestore.instance.batch();

  Query<T> get nonDeletedEntities =>
      readCollection.where(deletedAtField, isNull: true);

  Future<T> findById(String id) async {
    final doc = await readCollection.doc(id).get();
    final entity = doc.data();
    invariant(entity != null, '$T with id $id not found.');

    return entity!;
  }

  Stream<T> streamById(String id) {
    return readCollection.doc(id).snapshots().map((snapshot) {
      final entity = snapshot.data();
      invariant(entity != null, '$T with id $id not found.');

      return entity!;
    });
  }
}
