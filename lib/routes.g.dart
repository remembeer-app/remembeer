// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $loginRoute,
  $registerRoute,
  $profileCompletionRoute,
  $navbarShellRouteData,
  $userProfileRoute,
];

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  hasOverriddenOnExit: false,
  factory: $LoginRoute._fromState,
);

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

RouteBase get $registerRoute => GoRouteData.$route(
  path: '/register',
  hasOverriddenOnExit: false,
  factory: $RegisterRoute._fromState,
);

mixin $RegisterRoute on GoRouteData {
  static RegisterRoute _fromState(GoRouterState state) => const RegisterRoute();

  @override
  String get location => GoRouteData.$location('/register');

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

RouteBase get $profileCompletionRoute => GoRouteData.$route(
  path: '/complete-profile',
  hasOverriddenOnExit: false,
  factory: $ProfileCompletionRoute._fromState,
);

mixin $ProfileCompletionRoute on GoRouteData {
  static ProfileCompletionRoute _fromState(GoRouterState state) =>
      const ProfileCompletionRoute();

  @override
  String get location => GoRouteData.$location('/complete-profile');

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
          hasOverriddenOnExit: false,
          factory: $ProfileRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'friend_requests',
              hasOverriddenOnExit: false,
              factory: $FriendRequestsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'search',
              hasOverriddenOnExit: false,
              factory: $UserSearchRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'avatar',
              hasOverriddenOnExit: false,
              factory: $ProfileChangeAvatarRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'username',
              hasOverriddenOnExit: false,
              factory: $ProfileUsernameRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/leaderboards',
          hasOverriddenOnExit: false,
          factory: $LeaderboardsRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'join',
              hasOverriddenOnExit: false,
              factory: $JoinLeaderboardRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'new',
              hasOverriddenOnExit: false,
              factory: $CreateLeaderboardRoute._fromState,
            ),
            GoRouteData.$route(
              path: ':leaderboardId',
              hasOverriddenOnExit: false,
              factory: $LeaderboardDetailRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'manage',
                  hasOverriddenOnExit: false,
                  factory: $ManageLeaderboardRoute._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'name',
                      hasOverriddenOnExit: false,
                      factory: $UpdateLeaderboardNameRoute._fromState,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/drink',
          hasOverriddenOnExit: false,
          factory: $DrinkRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'new',
              hasOverriddenOnExit: false,
              factory: $AddDrinkRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'parties/:sessionId',
              hasOverriddenOnExit: false,
              factory: $PartyRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'location-picker',
              hasOverriddenOnExit: false,
              factory: $LocationPickerRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'sessions/new',
              hasOverriddenOnExit: false,
              factory: $CreateSessionRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'sessions/summary',
              hasOverriddenOnExit: false,
              factory: $SessionSummaryRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'sessions/manage',
              hasOverriddenOnExit: false,
              factory: $SessionManagementRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'sessions/:sessionId/edit',
              hasOverriddenOnExit: false,
              factory: $EditSessionRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'sessions/:sessionId/admins',
              hasOverriddenOnExit: false,
              factory: $ManageSessionAdminsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'sessions/:sessionId/friends/add',
              hasOverriddenOnExit: false,
              factory: $AddSessionFriendsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'sessions/:sessionId/drinks/:drinkId/edit',
              hasOverriddenOnExit: false,
              factory: $UpdateDrinkRoute._fromState,
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/activity',
          hasOverriddenOnExit: false,
          factory: $ActivityRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'sessions/:sessionId',
              hasOverriddenOnExit: false,
              factory: $ActivitySessionRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'photos/:initialIndex',
                  hasOverriddenOnExit: false,
                  factory: $SessionPhotoRoute._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/settings',
          hasOverriddenOnExit: false,
          factory: $SettingsRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'drink-types',
              hasOverriddenOnExit: false,
              factory: $CustomDrinkTypesRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'new',
                  hasOverriddenOnExit: false,
                  factory: $AddDrinkTypeRoute._fromState,
                ),
                GoRouteData.$route(
                  path: ':drinkTypeId/edit',
                  hasOverriddenOnExit: false,
                  factory: $UpdateDrinkTypeRoute._fromState,
                ),
              ],
            ),
            GoRouteData.$route(
              path: 'default-drink',
              hasOverriddenOnExit: false,
              factory: $DefaultDrinkSettingsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'drink-sort',
              hasOverriddenOnExit: false,
              factory: $DrinkSortSettingsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'username',
              hasOverriddenOnExit: false,
              factory: $UsernameSettingsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'profile-details',
              hasOverriddenOnExit: false,
              factory: $ProfileDetailsSettingsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'avatar',
              hasOverriddenOnExit: false,
              factory: $ChangeAvatarSettingsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'badge-visibility',
              hasOverriddenOnExit: false,
              factory: $BadgeVisibilityRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'password',
              hasOverriddenOnExit: false,
              factory: $ChangePasswordRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'end-of-day',
              hasOverriddenOnExit: false,
              factory: $EndOfDaySettingsRoute._fromState,
            ),
          ],
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

mixin $UserSearchRoute on GoRouteData {
  static UserSearchRoute _fromState(GoRouterState state) =>
      const UserSearchRoute();

  @override
  String get location => GoRouteData.$location('/profile/search');

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

mixin $ProfileChangeAvatarRoute on GoRouteData {
  static ProfileChangeAvatarRoute _fromState(GoRouterState state) =>
      const ProfileChangeAvatarRoute();

  @override
  String get location => GoRouteData.$location('/profile/avatar');

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

mixin $ProfileUsernameRoute on GoRouteData {
  static ProfileUsernameRoute _fromState(GoRouterState state) =>
      const ProfileUsernameRoute();

  @override
  String get location => GoRouteData.$location('/profile/username');

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

mixin $JoinLeaderboardRoute on GoRouteData {
  static JoinLeaderboardRoute _fromState(GoRouterState state) =>
      const JoinLeaderboardRoute();

  @override
  String get location => GoRouteData.$location('/leaderboards/join');

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

mixin $CreateLeaderboardRoute on GoRouteData {
  static CreateLeaderboardRoute _fromState(GoRouterState state) =>
      const CreateLeaderboardRoute();

  @override
  String get location => GoRouteData.$location('/leaderboards/new');

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

mixin $LeaderboardDetailRoute on GoRouteData {
  static LeaderboardDetailRoute _fromState(GoRouterState state) =>
      LeaderboardDetailRoute(
        leaderboardId: state.pathParameters['leaderboardId']!,
      );

  LeaderboardDetailRoute get _self => this as LeaderboardDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/leaderboards/${Uri.encodeComponent(_self.leaderboardId)}',
  );

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

mixin $ManageLeaderboardRoute on GoRouteData {
  static ManageLeaderboardRoute _fromState(GoRouterState state) =>
      ManageLeaderboardRoute(
        leaderboardId: state.pathParameters['leaderboardId']!,
      );

  ManageLeaderboardRoute get _self => this as ManageLeaderboardRoute;

  @override
  String get location => GoRouteData.$location(
    '/leaderboards/${Uri.encodeComponent(_self.leaderboardId)}/manage',
  );

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

mixin $UpdateLeaderboardNameRoute on GoRouteData {
  static UpdateLeaderboardNameRoute _fromState(GoRouterState state) =>
      UpdateLeaderboardNameRoute(
        leaderboardId: state.pathParameters['leaderboardId']!,
      );

  UpdateLeaderboardNameRoute get _self => this as UpdateLeaderboardNameRoute;

  @override
  String get location => GoRouteData.$location(
    '/leaderboards/${Uri.encodeComponent(_self.leaderboardId)}/manage/name',
  );

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

mixin $AddDrinkRoute on GoRouteData {
  static AddDrinkRoute _fromState(GoRouterState state) => AddDrinkRoute(
    targetSessionId: state.uri.queryParameters['target-session-id'],
  );

  AddDrinkRoute get _self => this as AddDrinkRoute;

  @override
  String get location => GoRouteData.$location(
    '/drink/new',
    queryParams: {
      if (_self.targetSessionId != null)
        'target-session-id': _self.targetSessionId,
    },
  );

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

mixin $PartyRoute on GoRouteData {
  static PartyRoute _fromState(GoRouterState state) =>
      PartyRoute(sessionId: state.pathParameters['sessionId']!);

  PartyRoute get _self => this as PartyRoute;

  @override
  String get location => GoRouteData.$location(
    '/drink/parties/${Uri.encodeComponent(_self.sessionId)}',
  );

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

mixin $LocationPickerRoute on GoRouteData {
  static LocationPickerRoute _fromState(GoRouterState state) =>
      LocationPickerRoute(
        latitude: double.parse(state.uri.queryParameters['latitude']!),
        longitude: double.parse(state.uri.queryParameters['longitude']!),
      );

  LocationPickerRoute get _self => this as LocationPickerRoute;

  @override
  String get location => GoRouteData.$location(
    '/drink/location-picker',
    queryParams: {
      'latitude': _self.latitude.toString(),
      'longitude': _self.longitude.toString(),
    },
  );

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

mixin $CreateSessionRoute on GoRouteData {
  static CreateSessionRoute _fromState(GoRouterState state) =>
      const CreateSessionRoute();

  @override
  String get location => GoRouteData.$location('/drink/sessions/new');

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

mixin $SessionSummaryRoute on GoRouteData {
  static SessionSummaryRoute _fromState(GoRouterState state) =>
      const SessionSummaryRoute();

  @override
  String get location => GoRouteData.$location('/drink/sessions/summary');

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

mixin $SessionManagementRoute on GoRouteData {
  static SessionManagementRoute _fromState(GoRouterState state) =>
      const SessionManagementRoute();

  @override
  String get location => GoRouteData.$location('/drink/sessions/manage');

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

mixin $EditSessionRoute on GoRouteData {
  static EditSessionRoute _fromState(GoRouterState state) =>
      EditSessionRoute(sessionId: state.pathParameters['sessionId']!);

  EditSessionRoute get _self => this as EditSessionRoute;

  @override
  String get location => GoRouteData.$location(
    '/drink/sessions/${Uri.encodeComponent(_self.sessionId)}/edit',
  );

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

mixin $ManageSessionAdminsRoute on GoRouteData {
  static ManageSessionAdminsRoute _fromState(GoRouterState state) =>
      ManageSessionAdminsRoute(sessionId: state.pathParameters['sessionId']!);

  ManageSessionAdminsRoute get _self => this as ManageSessionAdminsRoute;

  @override
  String get location => GoRouteData.$location(
    '/drink/sessions/${Uri.encodeComponent(_self.sessionId)}/admins',
  );

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

mixin $AddSessionFriendsRoute on GoRouteData {
  static AddSessionFriendsRoute _fromState(GoRouterState state) =>
      AddSessionFriendsRoute(sessionId: state.pathParameters['sessionId']!);

  AddSessionFriendsRoute get _self => this as AddSessionFriendsRoute;

  @override
  String get location => GoRouteData.$location(
    '/drink/sessions/${Uri.encodeComponent(_self.sessionId)}/friends/add',
  );

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

mixin $UpdateDrinkRoute on GoRouteData {
  static UpdateDrinkRoute _fromState(GoRouterState state) => UpdateDrinkRoute(
    sessionId: state.pathParameters['sessionId']!,
    drinkId: state.pathParameters['drinkId']!,
  );

  UpdateDrinkRoute get _self => this as UpdateDrinkRoute;

  @override
  String get location => GoRouteData.$location(
    '/drink/sessions/${Uri.encodeComponent(_self.sessionId)}/drinks/${Uri.encodeComponent(_self.drinkId)}/edit',
  );

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

mixin $ActivitySessionRoute on GoRouteData {
  static ActivitySessionRoute _fromState(GoRouterState state) =>
      ActivitySessionRoute(sessionId: state.pathParameters['sessionId']!);

  ActivitySessionRoute get _self => this as ActivitySessionRoute;

  @override
  String get location => GoRouteData.$location(
    '/activity/sessions/${Uri.encodeComponent(_self.sessionId)}',
  );

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

mixin $SessionPhotoRoute on GoRouteData {
  static SessionPhotoRoute _fromState(GoRouterState state) => SessionPhotoRoute(
    sessionId: state.pathParameters['sessionId']!,
    initialIndex: int.parse(state.pathParameters['initialIndex']!),
  );

  SessionPhotoRoute get _self => this as SessionPhotoRoute;

  @override
  String get location => GoRouteData.$location(
    '/activity/sessions/${Uri.encodeComponent(_self.sessionId)}/photos/${Uri.encodeComponent(_self.initialIndex.toString())}',
  );

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

mixin $CustomDrinkTypesRoute on GoRouteData {
  static CustomDrinkTypesRoute _fromState(GoRouterState state) =>
      const CustomDrinkTypesRoute();

  @override
  String get location => GoRouteData.$location('/settings/drink-types');

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

mixin $AddDrinkTypeRoute on GoRouteData {
  static AddDrinkTypeRoute _fromState(GoRouterState state) =>
      const AddDrinkTypeRoute();

  @override
  String get location => GoRouteData.$location('/settings/drink-types/new');

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

mixin $UpdateDrinkTypeRoute on GoRouteData {
  static UpdateDrinkTypeRoute _fromState(GoRouterState state) =>
      UpdateDrinkTypeRoute(drinkTypeId: state.pathParameters['drinkTypeId']!);

  UpdateDrinkTypeRoute get _self => this as UpdateDrinkTypeRoute;

  @override
  String get location => GoRouteData.$location(
    '/settings/drink-types/${Uri.encodeComponent(_self.drinkTypeId)}/edit',
  );

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

mixin $DefaultDrinkSettingsRoute on GoRouteData {
  static DefaultDrinkSettingsRoute _fromState(GoRouterState state) =>
      const DefaultDrinkSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/default-drink');

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

mixin $DrinkSortSettingsRoute on GoRouteData {
  static DrinkSortSettingsRoute _fromState(GoRouterState state) =>
      const DrinkSortSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/drink-sort');

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

mixin $UsernameSettingsRoute on GoRouteData {
  static UsernameSettingsRoute _fromState(GoRouterState state) =>
      const UsernameSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/username');

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

mixin $ProfileDetailsSettingsRoute on GoRouteData {
  static ProfileDetailsSettingsRoute _fromState(GoRouterState state) =>
      const ProfileDetailsSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/profile-details');

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

mixin $ChangeAvatarSettingsRoute on GoRouteData {
  static ChangeAvatarSettingsRoute _fromState(GoRouterState state) =>
      const ChangeAvatarSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/avatar');

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

mixin $BadgeVisibilityRoute on GoRouteData {
  static BadgeVisibilityRoute _fromState(GoRouterState state) =>
      const BadgeVisibilityRoute();

  @override
  String get location => GoRouteData.$location('/settings/badge-visibility');

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

mixin $ChangePasswordRoute on GoRouteData {
  static ChangePasswordRoute _fromState(GoRouterState state) =>
      const ChangePasswordRoute();

  @override
  String get location => GoRouteData.$location('/settings/password');

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

mixin $EndOfDaySettingsRoute on GoRouteData {
  static EndOfDaySettingsRoute _fromState(GoRouterState state) =>
      const EndOfDaySettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/end-of-day');

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
  hasOverriddenOnExit: false,
  factory: $UserProfileRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'friends',
      hasOverriddenOnExit: false,
      factory: $UserFriendsRoute._fromState,
    ),
  ],
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

mixin $UserFriendsRoute on GoRouteData {
  static UserFriendsRoute _fromState(GoRouterState state) =>
      UserFriendsRoute(userId: state.pathParameters['userId']!);

  UserFriendsRoute get _self => this as UserFriendsRoute;

  @override
  String get location => GoRouteData.$location(
    '/user/${Uri.encodeComponent(_self.userId)}/friends',
  );

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
