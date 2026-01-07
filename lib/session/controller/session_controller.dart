import 'package:remembeer/common/controller/crud_controller.dart';
import 'package:remembeer/common/extension/query_firestore_helper.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/model/session_create.dart';

class SessionController extends CrudController<Session, SessionCreate> {
  SessionController({required super.authService})
    : super(collectionPath: 'sessions', fromJson: Session.fromJson);

  Stream<List<Session>> get sessionsStreamWhereCurrentUserIsMember =>
      nonDeletedEntities
          .where('memberIds', arrayContains: authService.authenticatedUser.uid)
          .mapToStreamList();
}
