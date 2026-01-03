import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/badge/service/badge_service.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/service/date_service.dart';
import 'package:remembeer/drink/service/drink_list_service.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/friend_request/controller/friend_request_controller.dart';
import 'package:remembeer/leaderboard/controller/leaderboard_controller.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';
import 'package:remembeer/leaderboard/service/month_service.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';
import 'package:remembeer/user_stats/service/user_stats_service.dart';

final get = GetIt.instance;

class IoCContainer {
  IoCContainer._();

  static void initialize() {
    get
      ..registerSingleton(FirebaseAuth.instance)
      ..registerSingleton(AuthService(firebaseAuth: get<FirebaseAuth>()))
      ..registerSingleton(DateService())
      ..registerSingleton(MonthService())
      ..registerSingleton(LocationService())
      ..registerSingleton(BadgeService());

    _registerControllers();
    _registerServices();
  }

  static void _registerControllers() {
    get
      ..registerSingleton(DrinkController(authService: get<AuthService>()))
      ..registerSingleton(DrinkTypeController(authService: get<AuthService>()))
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
      ..registerSingleton(SessionController(authService: get<AuthService>()));
  }

  static void _registerServices() {
    get
      ..registerSingleton(
        UserStatsService(userController: get<UserController>()),
      )
      ..registerSingleton(
        DrinkService(
          drinkController: get<DrinkController>(),
          userController: get<UserController>(),
          userSettingsController: get<UserSettingsController>(),
          dateService: get<DateService>(),
          locationService: get<LocationService>(),
          userStatsService: get<UserStatsService>(),
          badgeService: get<BadgeService>(),
        ),
      )
      ..registerSingleton(
        UserService(
          authService: get<AuthService>(),
          friendRequestController: get<FriendRequestController>(),
          userController: get<UserController>(),
        ),
      )
      ..registerSingleton(
        UserSettingsService(
          authService: get<AuthService>(),
          userSettingsController: get<UserSettingsController>(),
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
        ),
      )
      ..registerSingleton(
        DrinkListService(
          drinkService: get<DrinkService>(),
          sessionService: get<SessionService>(),
        ),
      );
  }
}
