import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/common/model/entity.dart';

extension QueryFirestoreHelper on Query<Entity> {
  Stream<List<T>> mapToStreamList<T extends Entity>() {
    return snapshots().map(
      (querySnapshot) => List.unmodifiable(
        querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList(),
      ),
    );
  }
}
