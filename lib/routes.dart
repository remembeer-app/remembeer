import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/activity/page/activity_page.dart';
import 'package:remembeer/auth/page/login_page.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/widget/rem_navigation_bar.dart';
import 'package:remembeer/drink/page/drink_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/page/leaderboards_page.dart';
import 'package:remembeer/user/page/profile_page.dart';
import 'package:remembeer/user_settings/page/settings_page.dart';

part 'routes.g.dart';

final shellNavigatorKey = GlobalKey<NavigatorState>();
final rootNavigatorKey = GlobalKey<NavigatorState>();

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

@TypedShellRoute<NavbarShellRouteData>(
  routes: [
    TypedGoRoute<ProfileRoute>(path: '/profile/:userId'),
    TypedGoRoute<LeaderboardsRoute>(path: '/leaderboards'),
    TypedGoRoute<DrinkRoute>(path: '/drink'),
    TypedGoRoute<ActivityRoute>(path: '/activity'),
    TypedGoRoute<SettingsRoute>(path: '/settings'),
  ],
)
class NavbarShellRouteData extends ShellRouteData {
  const NavbarShellRouteData();

  static final GlobalKey<NavigatorState> navigatorKey = shellNavigatorKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return Scaffold(
      body: navigator,
      bottomNavigationBar: RemNavigationBar(currentIndex: 2),
    );
  }
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  final String userId;

  const ProfileRoute({required this.userId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfilePage(userId: userId);
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
    return const DrinkPage();
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
