import 'package:remembeer/activity/constants.dart';
import 'package:remembeer/activity/model/session_with_members.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:rxdart/rxdart.dart';

class ActivityService {
  final AuthService authService;
  final SessionController sessionController;
  final UserController userController;

  final _limitSubject = BehaviorSubject<int>.seeded(sessionsFetchLimit);

  ActivityService({
    required this.authService,
    required this.sessionController,
    required this.userController,
  });

  void loadMore() {
    _limitSubject.add(_limitSubject.value + sessionsFetchLimit);
  }

  void resetLimit() {
    _limitSubject.add(sessionsFetchLimit);
  }

  Stream<List<Session>> get _friendsSessionsStream {
    return Rx.combineLatest2(
      userController.currentUserStream,
      _limitSubject,
      (currentUser, limit) => (currentUser: currentUser, limit: limit),
    ).switchMap((data) {
      final currentUser = data.currentUser;
      final limit = data.limit;

      final allIds = {
        ...currentUser.friends,
        authService.authenticatedUser.uid,
      };
      return sessionController.sessionsForMemberIdsStream(allIds, limit: limit);
    });
  }

  // TODO(metju-ac): Add other activity types (e.g. friend requests, badges earned, etc.)
  Stream<({List<SessionWithMembers> sessions, bool hasMore})>
  get activityFeedStream {
    return Rx.combineLatest2(
      _friendsSessionsStream,
      _limitSubject,
      (sessions, limit) => (sessions: sessions, limit: limit),
    ).switchMap((data) {
      final sessions = data.sessions;
      final limit = data.limit;

      if (sessions.isEmpty) {
        return Stream.value((sessions: <SessionWithMembers>[], hasMore: false));
      }

      final sessionsWithMembers = sessions.map((session) {
        final memberStreams = session.memberIds
            .map(userController.streamById)
            .toList();

        return Rx.combineLatestList(memberStreams).map((users) {
          final userMap = <String, UserModel>{
            for (final user in users) user.id: user,
          };
          return SessionWithMembers(session: session, members: userMap);
        });
      }).toList();

      return Rx.combineLatestList(
        sessionsWithMembers,
      ).map((list) => (sessions: list, hasMore: list.length >= limit));
    });
  }
}
