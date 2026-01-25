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

  Stream<List<Session>> sessionsActiveAtStream(DateTime at) =>
      sessionsStreamWhereCurrentUserIsMember.map((sessions) {
        bool isActive(Session session) {
          final hasStarted = session.startedAt.isBefore(at);
          final stillRunning =
              session.endedAt == null || session.endedAt!.isAfter(at);
          return hasStarted && stillRunning;
        }

        return sessions.where(isActive).toList();
      });
}
