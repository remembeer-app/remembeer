import 'package:remembeer/common/controller/members_crud_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/model/session_create.dart';

class SessionController extends MembersCrudController<Session, SessionCreate> {
  SessionController({required super.authService})
    : super(collectionPath: 'sessions', fromJson: Session.fromJson);

  Stream<List<Session>> get sessionsStreamWhereCurrentUserIsMember =>
      entitiesStreamWhereCurrentUserIsMember.map(
        (sessions) =>
            List<Session>.from(sessions)
              ..sort((a, b) => b.startedAt.compareTo(a.startedAt)),
      );

  Future<List<Session>> sessionsActiveAt(DateTime at) =>
      sessionsStreamWhereCurrentUserIsMember.first.then((sessions) {
        return sessions.where((session) => session.isActiveAt(at)).toList();
      });
}
