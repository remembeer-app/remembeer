// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $loginRoute,
  $navbarShellRouteData,
  $userProfileRoute,
];

RouteBase get $loginRoute =>
    GoRouteData.$route(path: '/login', factory: $LoginRoute._fromState);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $navbarShellRouteData => StatefulShellRouteData.$route(
  factory: $NavbarShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/profile',
          factory: $ProfileRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'friend_requests',
              factory: $FriendRequestsRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/leaderboards',
          factory: $LeaderboardsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(path: '/drink', factory: $DrinkRoute._fromState),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/activity',
          factory: $ActivityRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/settings',
          factory: $SettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $NavbarShellRouteDataExtension on NavbarShellRouteData {
  static NavbarShellRouteData _fromState(GoRouterState state) =>
      const NavbarShellRouteData();
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FriendRequestsRoute on GoRouteData {
  static FriendRequestsRoute _fromState(GoRouterState state) =>
      const FriendRequestsRoute();

  @override
  String get location => GoRouteData.$location('/profile/friend_requests');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LeaderboardsRoute on GoRouteData {
  static LeaderboardsRoute _fromState(GoRouterState state) =>
      const LeaderboardsRoute();

  @override
  String get location => GoRouteData.$location('/leaderboards');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DrinkRoute on GoRouteData {
  static DrinkRoute _fromState(GoRouterState state) => const DrinkRoute();

  @override
  String get location => GoRouteData.$location('/drink');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ActivityRoute on GoRouteData {
  static ActivityRoute _fromState(GoRouterState state) => const ActivityRoute();

  @override
  String get location => GoRouteData.$location('/activity');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $userProfileRoute => GoRouteData.$route(
  path: '/user/:userId',
  factory: $UserProfileRoute._fromState,
);

mixin $UserProfileRoute on GoRouteData {
  static UserProfileRoute _fromState(GoRouterState state) =>
      UserProfileRoute(userId: state.pathParameters['userId']!);

  UserProfileRoute get _self => this as UserProfileRoute;

  @override
  String get location =>
      GoRouteData.$location('/user/${Uri.encodeComponent(_self.userId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
