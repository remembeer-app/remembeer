import 'package:dartvex/dartvex.dart';
import 'package:dartvex_auth_better/dartvex_auth_better.dart';
import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:remembeer/account_deletion/service/account_deletion_service.dart';
import 'package:remembeer/activity/service/activity_service.dart';
import 'package:remembeer/app_icon/service/app_icon_service.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/avatar/service/avatar_service.dart';
import 'package:remembeer/badge/service/badge_service.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/friend_request/controller/friend_request_controller.dart';
import 'package:remembeer/leaderboard/controller/leaderboard_controller.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';
import 'package:remembeer/leaderboard/service/month_service.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:remembeer/notification/service/notification_service.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/party/controller/party_event_controller.dart';
import 'package:remembeer/party/controller/party_game_controller.dart';
import 'package:remembeer/party/service/beerpong_service.dart';
import 'package:remembeer/party/service/party_challenge_service.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/service/session_picture_service.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user/service/user_stats_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';

final get = GetIt.instance;

class IoCContainer {
  IoCContainer._();

  static void initialize() {
    _registerConvex();

    get
      ..registerSingleton(FirebaseAuth.instance)
      ..registerSingleton(AuthService(firebaseAuth: get<FirebaseAuth>()))
      ..registerSingleton(NotificationService())
      ..registerSingleton(MonthService())
      ..registerSingleton(LocationService())
      ..registerSingleton(UserStatsService())
      ..registerSingleton(BadgeService());

    _registerControllers();
    _registerServices();
  }

  static void _registerConvex() {
    get
      ..registerSingleton(
        BetterAuthClient(baseUrl: dotenv.get('CONVEX_SITE_URL')),
      )
      ..registerSingleton(
        ConvexClient(
          dotenv.get('CONVEX_URL'),
          config: ConvexClientConfig(
            connectivitySignal: ConnectivityPlusSignal(),
          ),
        ),
      )
      ..registerSingleton(
        ConvexBetterAuthProvider(client: get<BetterAuthClient>()),
      )
      ..registerSingleton(
        get<ConvexClient>().withAuth(get<ConvexBetterAuthProvider>()),
      )
      ..registerSingleton(
        ConvexApi(get<ConvexClientWithAuth<BetterAuthSession>>()),
      )
      ..registerSingleton(
        ConvexAuthService(
          authProvider: get<ConvexBetterAuthProvider>(),
          client: get<ConvexClientWithAuth<BetterAuthSession>>(),
          api: get<ConvexApi>(),
        ),
      );
  }

  static void _registerControllers() {
    get
      ..registerSingleton(DrinkController(authService: get<AuthService>()))
      ..registerSingleton(
        FriendRequestController(authService: get<AuthService>()),
      )
      ..registerSingleton(UserController(authService: get<AuthService>()))
      ..registerSingleton(
        UserSettingsController(authService: get<AuthService>()),
      )
      ..registerSingleton(
        LeaderboardController(authService: get<AuthService>()),
      )
      ..registerSingleton(SessionController(authService: get<AuthService>()))
      ..registerSingleton(PartyController())
      ..registerSingleton(PartyEventController())
      ..registerSingleton(PartyGameController());
  }

  static void _registerServices() {
    get
      ..registerSingleton(DrinkService(api: get<ConvexApi>()))
      ..registerSingleton(DateService(userController: get<UserController>()))
      ..registerSingleton(
        AppIconService(
          authService: get<AuthService>(),
          userController: get<UserController>(),
        ),
      )
      ..registerSingleton(
        DrinkLogService(
          authService: get<AuthService>(),
          userController: get<UserController>(),
          userSettingsController: get<UserSettingsController>(),
          sessionController: get<SessionController>(),
          dateService: get<DateService>(),
          locationService: get<LocationService>(),
          userStatsService: get<UserStatsService>(),
          badgeService: get<BadgeService>(),
          drinkController: get<DrinkController>(),
          partyController: get<PartyController>(),
        ),
      )
      ..registerSingleton(
        UserService(
          authService: get<AuthService>(),
          notificationService: get<NotificationService>(),
          friendRequestController: get<FriendRequestController>(),
          userController: get<UserController>(),
        ),
      )
      ..registerSingleton(
        UserSettingsService(
          authService: get<AuthService>(),
          userSettingsController: get<UserSettingsController>(),
          notificationService: get<NotificationService>(),
        ),
      )
      ..registerSingleton(
        LeaderboardService(
          authService: get<AuthService>(),
          leaderboardController: get<LeaderboardController>(),
          userController: get<UserController>(),
          monthService: get<MonthService>(),
        ),
      )
      ..registerSingleton(
        SessionService(
          authService: get<AuthService>(),
          sessionController: get<SessionController>(),
          userSettingsController: get<UserSettingsController>(),
          dateService: get<DateService>(),
          userService: get<UserService>(),
          notificationService: get<NotificationService>(),
          partyController: get<PartyController>(),
        ),
      )
      ..registerSingleton(
        PartyService(
          authService: get<AuthService>(),
          sessionController: get<SessionController>(),
          partyController: get<PartyController>(),
        ),
      )
      ..registerSingleton(
        PartyChallengeService(
          partyController: get<PartyController>(),
          gameController: get<PartyGameController>(),
          eventController: get<PartyEventController>(),
        ),
      )
      ..registerSingleton(
        PartyQuestService(
          partyController: get<PartyController>(),
          gameController: get<PartyGameController>(),
        ),
      )
      ..registerSingleton(
        BeerpongService(
          partyController: get<PartyController>(),
          gameController: get<PartyGameController>(),
        ),
      )
      ..registerSingleton(
        AvatarService(
          authService: get<AuthService>(),
          userController: get<UserController>(),
        ),
      )
      ..registerSingleton(
        ActivityService(
          authService: get<AuthService>(),
          sessionController: get<SessionController>(),
          userController: get<UserController>(),
        ),
      )
      ..registerSingleton(
        SessionPictureService(
          authService: get<AuthService>(),
          sessionController: get<SessionController>(),
        ),
      )
      ..registerSingleton(
        AccountDeletionService(
          authService: get<AuthService>(),
          drinkController: get<DrinkController>(),
          sessionController: get<SessionController>(),
          leaderboardController: get<LeaderboardController>(),
          friendRequestController: get<FriendRequestController>(),
          userController: get<UserController>(),
          userSettingsController: get<UserSettingsController>(),
          avatarService: get<AvatarService>(),
          sessionPictureService: get<SessionPictureService>(),
          partyController: get<PartyController>(),
        ),
      );
  }
}
