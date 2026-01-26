import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/activity/page/activity_page.dart';
import 'package:remembeer/common/widget/app_navigation_bar.dart';
import 'package:remembeer/drink/page/drink_page.dart';
import 'package:remembeer/leaderboard/page/leaderboards_page.dart';
import 'package:remembeer/user/page/profile_page.dart';
import 'package:remembeer/user_settings/page/settings_page.dart';

part 'routes.g.dart';

final shellNavigatorKey = GlobalKey<NavigatorState>();
final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(initialLocation: '/drink', routes: $appRoutes);

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
      bottomNavigationBar: RemNavigationBar(currentIndex: 2, onTap: (_) {}),
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
