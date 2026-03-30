import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/common/controller/members_crud_controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/session/constants.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/model/session_create.dart';
import 'package:rxdart/rxdart.dart';

class SessionController extends MembersCrudController<Session, SessionCreate> {
  SessionController({required super.authService})
    : super(collectionPath: 'sessions', fromJson: Session.fromJson);

  String generateId() => writeCollection.doc().id;

  Stream<List<Session>> get sessionsStreamWhereCurrentUserIsMember =>
      entitiesStreamWhereCurrentUserIsMember.map(
        (sessions) =>
            List<Session>.from(sessions)
              ..sort((a, b) => b.startedAt.compareTo(a.startedAt)),
      );

  Stream<List<Session>> sessionsForMemberIdsStream(
    Set<String> memberIds, {
    required int limit,
  }) {
    if (memberIds.isEmpty) {
      return Stream.value([]);
    }

    final idList = memberIds.toList();
    const batchSize = arrayContainsFirebaseLimit;
    final batchStreams = <Stream<List<Session>>>[];

    for (var i = 0; i < idList.length; i += batchSize) {
      final batch = idList.sublist(i, (i + batchSize).clamp(0, idList.length));
      batchStreams.add(
        nonDeletedEntities
            .where('isSoloSession', isEqualTo: false)
            .where(memberIdsField, arrayContainsAny: batch)
            .where('endedAt', isNull: false)
            .orderBy('endedAt', descending: true)
            .limit(limit)
            .snapshots()
            .map(
              (qs) => List<Session>.unmodifiable(
                qs.docs.map((d) => d.data()).toList(),
              ),
            ),
      );
    }

    return Rx.combineLatestList(batchStreams).map((batchResults) {
      return ({
            for (final s in batchResults.expand((list) => list)) s.id: s,
          }.values.toList()..sort((a, b) => b.endedAt!.compareTo(a.endedAt!)))
          .take(limit)
          .toList();
    });
  }

  Future<List<Session>> sessionsActiveAt(DateTime at) =>
      sessionsStreamWhereCurrentUserIsMember.first.then((sessions) {
        return sessions
            .where(
              (session) => !session.isSoloSession && session.isActiveAt(at),
            )
            .toList();
      });

  void addDrinkInBatch(String sessionId, Drink drink, WriteBatch batch) {
    batch.update(writeCollection.doc(sessionId), {
      'drinks': FieldValue.arrayUnion([drink.toJson()]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  void createSoloSessionWithDrinkInBatch(Drink drink, WriteBatch batch) {
    final userId = authService.authenticatedUser.uid;
    // TODO(metju-ac): Refactor to not set all values for solo sessions
    final sessionCreate = SessionCreate(
      name: '',
      startedAt: drink.consumedAt,
      endedAt: drink.consumedAt,
      memberIds: {userId},
      drinks: [drink],
    );

    final docRef = writeCollection.doc();
    batch.set(
      docRef,
      sessionCreate.toJson().withServerCreateTimestamps().withUserId(
        authService.authenticatedUser,
      ),
    );
  }

  void removeDrinkInBatch(String sessionId, Drink drink, WriteBatch batch) {
    batch.update(writeCollection.doc(sessionId), {
      'drinks': FieldValue.arrayRemove([drink.toJson()]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  void updateSessionFieldsInBatch({
    required WriteBatch batch,
    required String sessionId,
    required String name,
    required DateTime startedAt,
    required List<Drink> drinksToRemove,
    DateTime? endedAt,
  }) {
    final displacedJson = drinksToRemove.map((d) => d.toJson()).toList();

    batch.update(writeCollection.doc(sessionId), {
      'name': name,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'drinks': FieldValue.arrayRemove(displacedJson),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
