import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/activity/page/activity_page.dart';
import 'package:remembeer/auth/page/login_page.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/widget/nav_bar.dart';
import 'package:remembeer/drink/page/drink_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/page/leaderboards_page.dart';
import 'package:remembeer/user/page/profile_page.dart';
import 'package:remembeer/user_settings/page/settings_page.dart';

part 'routes.g.dart';

final _authService = get<AuthService>();

final router = GoRouter(
  initialLocation: '/drink',
  redirect: (context, state) {
    final isOnLogin = state.matchedLocation == '/login';
    return switch ((_authService.isAuthenticated, isOnLogin)) {
      (true, true) => '/drink',
      (false, false) => '/login',
      _ => null,
    };
  },
  routes: $appRoutes,
);

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

@TypedStatefulShellRoute<NavbarShellRouteData>(
  branches: [
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [
        TypedGoRoute<ProfileRedirectRoute>(
          path: '/profile',
          routes: [TypedGoRoute<ProfileRoute>(path: ':userId')],
        ),
      ],
    ),
    TypedStatefulShellBranch<LeaderboardsBranch>(
      routes: [TypedGoRoute<LeaderboardsRoute>(path: '/leaderboards')],
    ),
    TypedStatefulShellBranch<DrinkBranch>(
      routes: [TypedGoRoute<DrinkRoute>(path: '/drink')],
    ),
    TypedStatefulShellBranch<ActivityBranch>(
      routes: [TypedGoRoute<ActivityRoute>(path: '/activity')],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [TypedGoRoute<SettingsRoute>(path: '/settings')],
    ),
  ],
)
class NavbarShellRouteData extends StatefulShellRouteData {
  const NavbarShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return NavBar(navigationShell: navigationShell);
  }
}

class ProfileBranch extends StatefulShellBranchData {
  const ProfileBranch();
}

class LeaderboardsBranch extends StatefulShellBranchData {
  const LeaderboardsBranch();
}

class DrinkBranch extends StatefulShellBranchData {
  const DrinkBranch();
}

class ActivityBranch extends StatefulShellBranchData {
  const ActivityBranch();
}

class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  final String userId;

  const ProfileRoute({required this.userId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfilePage(userId: userId);
  }
}

class ProfileRedirectRoute extends GoRouteData with $ProfileRedirectRoute {
  const ProfileRedirectRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return '/profile/${_authService.authenticatedUser.uid}';
  }
}

class LeaderboardsRoute extends GoRouteData with $LeaderboardsRoute {
  const LeaderboardsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LeaderboardsPage();
  }
}

class DrinkRoute extends GoRouteData with $DrinkRoute {
  const DrinkRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DrinkPage();
  }
}

class ActivityRoute extends GoRouteData with $ActivityRoute {
  const ActivityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ActivityPage();
  }
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SettingsPage();
  }
}
