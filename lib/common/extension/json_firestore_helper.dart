import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const idField = 'id';
const userIdField = 'userId';
const createdAtField = 'createdAt';
const updatedAtField = 'updatedAt';
const deletedAtField = 'deletedAt';
const memberIdsField = 'memberIds';
const bannedMemberIdsField = 'bannedMemberIds';

extension JsonFirestoreHelper on Map<String, dynamic> {
  Map<String, dynamic> withId(String id) {
    this[idField] = id;
    return this;
  }

  Map<String, dynamic> withoutId() {
    remove(idField);
    return this;
  }

  Map<String, dynamic> withUserId(User user) {
    this[userIdField] = user.uid;
    return this;
  }

  Map<String, dynamic> withServerCreateTimestamps() {
    this[createdAtField] = FieldValue.serverTimestamp();
    this[updatedAtField] = FieldValue.serverTimestamp();
    this[deletedAtField] = null;
    return this;
  }

  Map<String, dynamic> withServerUpdateTimestamp() {
    this[updatedAtField] = FieldValue.serverTimestamp();
    return this;
  }

  Map<String, dynamic> withServerDeleteTimestamps() {
    this[updatedAtField] = FieldValue.serverTimestamp();
    this[deletedAtField] = FieldValue.serverTimestamp();
    return this;
  }
}
