import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:rxdart/rxdart.dart';

class ActivityService {
  final AuthService authService;
  final SessionController sessionController;
  final UserService userService;

  const ActivityService({
    required this.authService,
    required this.sessionController,
    required this.userService,
  });

  Stream<List<Session>> get activityFeedStream {
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
}
