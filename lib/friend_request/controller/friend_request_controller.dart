import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/common/controller/crud_controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/extension/query_firestore_helper.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/friend_request/model/friend_request.dart';
import 'package:remembeer/friend_request/model/friend_request_create.dart';

const toUserIdField = 'toUserId';

class FriendRequestController
    extends CrudController<FriendRequest, FriendRequestCreate> {
  FriendRequestController({required super.authService})
    : super(
        collectionPath: 'friend_requests',
        fromJson: FriendRequest.fromJson,
      );

  Stream<List<FriendRequest>> pendingFriendRequests() => nonDeletedEntities
      .where(toUserIdField, isEqualTo: authService.authenticatedUser.uid)
      .mapToStreamList();

  Stream<FriendRequest?> getRequestBetween(String otherUserId) {
    final currentUserId = authService.authenticatedUser.uid;
    return nonDeletedEntities
        .where(
          Filter.or(
            Filter.and(
              Filter(userIdField, isEqualTo: currentUserId),
              Filter(toUserIdField, isEqualTo: otherUserId),
            ),
            Filter.and(
              Filter(userIdField, isEqualTo: otherUserId),
              Filter(toUserIdField, isEqualTo: currentUserId),
            ),
          ),
        )
        .snapshots()
        .map((snapshot) {
          invariant(
            snapshot.docs.length <= 1,
            'Found ${snapshot.docs.length} pending friend requests between $currentUserId and $otherUserId. Expected at most 1.',
          );

          if (snapshot.docs.isEmpty) {
            return null;
          }
          return snapshot.docs.first.data();
        });
  }
}
