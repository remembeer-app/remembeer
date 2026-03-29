import 'package:remembeer/activity/type/session_with_members.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:rxdart/rxdart.dart';

class ActivityService {
  final AuthService authService;
  final SessionController sessionController;
  final UserService userService;
  final UserController userController;

  const ActivityService({
    required this.authService,
    required this.sessionController,
    required this.userService,
    required this.userController,
  });

  Stream<List<Session>> get _friendsSessionsStream {
    return userService.currentUserStream.switchMap((currentUser) {
      final allIds = {
        ...currentUser.friends,
        authService.authenticatedUser.uid,
      };
      return sessionController
          .sessionsForMemberIdsStream(allIds)
          .map(
            (sessions) =>
                sessions.where((s) => s.endedAt != null).toList()
                  ..sort((a, b) => b.endedAt!.compareTo(a.endedAt!)),
          );
    });
  }

  // TODO(metju-ac): Add other activity types (e.g. friend requests, badges earned, etc.)
  Stream<List<SessionWithMembers>> get activityFeedStream {
    return _friendsSessionsStream.switchMap((sessions) {
      if (sessions.isEmpty) {
        return Stream.value([]);
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

      return Rx.combineLatestList(sessionsWithMembers);
    });
  }
}
