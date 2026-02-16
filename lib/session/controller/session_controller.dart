import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/common/controller/members_crud_controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/model/session_create.dart';

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
      isSoloSession: true,
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
}
