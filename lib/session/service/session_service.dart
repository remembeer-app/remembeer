import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/notification/service/notification_service.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/model/session_create.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';
import 'package:rxdart/rxdart.dart';

class SessionService {
  final AuthService authService;
  final SessionController sessionController;
  final DateService dateService;
  final UserSettingsController userSettingsController;
  final UserService userService;
  final NotificationService notificationService;

  SessionService({
    required this.authService,
    required this.sessionController,
    required this.dateService,
    required this.userSettingsController,
    required this.userService,
    required this.notificationService,
  });

  String get currentUserId => authService.authenticatedUser.uid;

  Stream<List<Session>> get sessionsWhereCurrentUserIsMemberStream =>
      sessionController.sessionsStreamWhereCurrentUserIsMember;

  Stream<List<Session>> get mySessionsForSelectedDateStream {
    return Rx.combineLatest4(
      sessionController.sessionsStreamWhereCurrentUserIsMember,
      dateService.selectedDateStateStream,
      userSettingsController.currentUserSettingsStream,
      userService.currentUserStream,
      (sessions, _, userSettings, user) {
        final drinkListSort = userSettings.drinkListSortOrder;
        final (startTime, endTime) = dateService.selectedDateBoundaries(
          user.endOfDayBoundary,
        );

        final filtered = sessions.where((session) {
          final startsBeforeDayEnds = session.startedAt.isBefore(endTime);
          final endsAfterDayStarts =
              session.endedAt == null || session.endedAt!.isAfter(startTime);
          return startsBeforeDayEnds && endsAfterDayStarts;
        }).toList();

        switch (drinkListSort) {
          case DrinkListSortOrder.descending:
            filtered.sort((a, b) => b.startedAt.compareTo(a.startedAt));
          case DrinkListSortOrder.ascending:
            filtered.sort((a, b) => a.startedAt.compareTo(b.startedAt));
        }

        return filtered;
      },
    );
  }

  Future<void> createSession({
    required String name,
    required DateTime startedAt,
  }) async {
    await sessionController.createSingle(
      SessionCreate(
        name: name,
        startedAt: startedAt,
        memberIds: {currentUserId},
      ),
    );
  }

  Future<void> updateSession({
    required Session session,
    String? name,
    DateTime? startedAt,
    DateTime? endedAt,
  }) async {
    final updatedSession = session.copyWith(
      name: name ?? session.name,
      startedAt: startedAt ?? session.startedAt,
      endedAt: endedAt ?? session.endedAt,
    );
    await sessionController.updateSingle(updatedSession);
  }

  Future<void> markSessionAsDone({
    required Session session,
    required DateTime endedAt,
  }) async {
    await updateSession(session: session, endedAt: endedAt);
  }

  bool isSessionOwner(Session session) {
    return session.userId == currentUserId;
  }

  Future<void> deleteSession(Session session) async {
    invariant(
      isSessionOwner(session),
      'Only the session owner can delete the session.',
    );

    await sessionController.deleteSingle(session);
  }

  Stream<List<UserModel>> sessionMembersStream(String sessionId) {
    return sessionController.streamById(sessionId).switchMap((session) {
      if (session.memberIds.isEmpty) {
        return Stream.value(<UserModel>[]);
      }

      final memberStreams = session.memberIds
          .map(userService.userStreamFor)
          .toList();
      return Rx.combineLatestList(memberStreams);
    });
  }

  Stream<List<UserModel>> availableFriendsForSessionStream(String sessionId) {
    return Rx.combineLatest2(
      sessionController.streamById(sessionId),
      userService.friendsFor(currentUserId),
      (session, friends) {
        return friends
            .where((friend) => !session.memberIds.contains(friend.id))
            .toList();
      },
    );
  }

  Future<void> addMemberToSession({
    required String sessionId,
    required String memberId,
  }) async {
    final currentUser = await userService.currentUser;
    final session = await sessionController.streamById(sessionId).first;

    final updatedMemberIds = Set<String>.from(session.memberIds)..add(memberId);
    final updatedSession = session.copyWith(memberIds: updatedMemberIds);

    await sessionController.updateSingle(updatedSession);
    await notificationService.notifyAddedToSession(
      memberId,
      currentUser.username,
      session.name,
    );
  }
}
