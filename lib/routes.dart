import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/activity/page/activity_page.dart';
import 'package:remembeer/activity/page/session_detail_page.dart';
import 'package:remembeer/activity/widget/session_photo_viewer.dart';
import 'package:remembeer/auth/page/change_password_page.dart';
import 'package:remembeer/auth/page/login_page.dart';
import 'package:remembeer/auth/page/register_page.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/avatar/page/change_avatar_page.dart';
import 'package:remembeer/common/widget/nav_bar.dart';
import 'package:remembeer/drink/page/add_drink_page.dart';
import 'package:remembeer/drink/page/drink_page.dart';
import 'package:remembeer/drink/page/update_drink_page.dart';
import 'package:remembeer/drink_type/page/add_drink_type_page.dart';
import 'package:remembeer/drink_type/page/custom_drink_types_page.dart';
import 'package:remembeer/drink_type/page/update_drink_type_page.dart';
import 'package:remembeer/friend_request/page/friend_requests_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/page/create_leaderboard_page.dart';
import 'package:remembeer/leaderboard/page/join_leaderboard_page.dart';
import 'package:remembeer/leaderboard/page/leaderboard_detail_page.dart';
import 'package:remembeer/leaderboard/page/leaderboards_page.dart';
import 'package:remembeer/leaderboard/page/manage_leaderboard_page.dart';
import 'package:remembeer/leaderboard/page/update_leaderboard_name_page.dart';
import 'package:remembeer/location/page/location_page.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/page/beerpong_page.dart';
import 'package:remembeer/party/page/challenge_detail_page.dart';
import 'package:remembeer/party/page/party_management_page.dart';
import 'package:remembeer/party/page/party_page.dart';
import 'package:remembeer/party/page/quest_detail_page.dart';
import 'package:remembeer/session/page/add_friends_to_session_page.dart';
import 'package:remembeer/session/page/create_session_page.dart';
import 'package:remembeer/session/page/edit_session_page.dart';
import 'package:remembeer/session/page/manage_admins_page.dart';
import 'package:remembeer/session/page/session_management_page.dart';
import 'package:remembeer/session/page/summary_page.dart';
import 'package:remembeer/user/page/friends_list_page.dart';
import 'package:remembeer/user/page/profile_page.dart';
import 'package:remembeer/user/page/search_user_page.dart';
import 'package:remembeer/user_settings/page/badge_visibility_page.dart';
import 'package:remembeer/user_settings/page/default_drink_page.dart';
import 'package:remembeer/user_settings/page/drink_list_sort_page.dart';
import 'package:remembeer/user_settings/page/end_of_day_page.dart';
import 'package:remembeer/user_settings/page/profile_details_page.dart';
import 'package:remembeer/user_settings/page/settings_page.dart';
import 'package:remembeer/user_settings/page/username_page.dart';

part 'routes.g.dart';

final _authService = get<AuthService>();

final router = GoRouter(
  initialLocation: const DrinkRoute().location,
  redirect: (context, state) {
    final isOnAuthPage = {
      const LoginRoute().location,
      const RegisterRoute().location,
    }.contains(state.matchedLocation);
    return switch ((_authService.isAuthenticated, isOnAuthPage)) {
      (true, true) => const DrinkRoute().location,
      (false, false) => const LoginRoute().location,
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

@TypedGoRoute<RegisterRoute>(path: '/register')
class RegisterRoute extends GoRouteData with $RegisterRoute {
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RegisterPage();
  }
}

@TypedStatefulShellRoute<NavbarShellRouteData>(
  branches: [
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [
        TypedGoRoute<ProfileRoute>(
          path: '/profile',
          routes: [
            TypedGoRoute<FriendRequestsRoute>(path: 'friend_requests'),
            TypedGoRoute<UserSearchRoute>(path: 'search'),
            TypedGoRoute<ProfileChangeAvatarRoute>(path: 'avatar'),
            TypedGoRoute<ProfileUsernameRoute>(path: 'username'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<LeaderboardsBranch>(
      routes: [
        TypedGoRoute<LeaderboardsRoute>(
          path: '/leaderboards',
          routes: [
            TypedGoRoute<JoinLeaderboardRoute>(path: 'join'),
            TypedGoRoute<CreateLeaderboardRoute>(path: 'new'),
            TypedGoRoute<LeaderboardDetailRoute>(
              path: ':leaderboardId',
              routes: [
                TypedGoRoute<ManageLeaderboardRoute>(
                  path: 'manage',
                  routes: [
                    TypedGoRoute<UpdateLeaderboardNameRoute>(path: 'name'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<DrinkBranch>(
      routes: [
        TypedGoRoute<DrinkRoute>(
          path: '/drink',
          routes: [
            TypedGoRoute<AddDrinkRoute>(path: 'new'),
            TypedGoRoute<PartyRoute>(
              path: 'parties/:sessionId',
              routes: [
                TypedGoRoute<PartyManagementRoute>(path: 'manage'),
                TypedGoRoute<PartyQuestRoute>(path: 'quests/:questId'),
                TypedGoRoute<PartyChallengeRoute>(
                  path: 'challenges/:challengeId',
                ),
                TypedGoRoute<PartyTournamentRoute>(
                  path: 'tournaments/:tournamentId',
                ),
              ],
            ),
            TypedGoRoute<LocationPickerRoute>(path: 'location-picker'),
            TypedGoRoute<CreateSessionRoute>(path: 'sessions/new'),
            TypedGoRoute<SessionSummaryRoute>(path: 'sessions/summary'),
            TypedGoRoute<SessionManagementRoute>(path: 'sessions/manage'),
            TypedGoRoute<EditSessionRoute>(path: 'sessions/:sessionId/edit'),
            TypedGoRoute<ManageSessionAdminsRoute>(
              path: 'sessions/:sessionId/admins',
            ),
            TypedGoRoute<AddSessionFriendsRoute>(
              path: 'sessions/:sessionId/friends/add',
            ),
            TypedGoRoute<UpdateDrinkRoute>(
              path: 'sessions/:sessionId/drinks/:drinkId/edit',
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ActivityBranch>(
      routes: [
        TypedGoRoute<ActivityRoute>(
          path: '/activity',
          routes: [
            TypedGoRoute<ActivitySessionRoute>(
              path: 'sessions/:sessionId',
              routes: [
                TypedGoRoute<SessionPhotoRoute>(path: 'photos/:initialIndex'),
              ],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [
        TypedGoRoute<SettingsRoute>(
          path: '/settings',
          routes: [
            TypedGoRoute<CustomDrinkTypesRoute>(
              path: 'drink-types',
              routes: [
                TypedGoRoute<AddDrinkTypeRoute>(path: 'new'),
                TypedGoRoute<UpdateDrinkTypeRoute>(path: ':drinkTypeId/edit'),
              ],
            ),
            TypedGoRoute<DefaultDrinkSettingsRoute>(path: 'default-drink'),
            TypedGoRoute<DrinkSortSettingsRoute>(path: 'drink-sort'),
            TypedGoRoute<UsernameSettingsRoute>(path: 'username'),
            TypedGoRoute<ProfileDetailsSettingsRoute>(path: 'profile-details'),
            TypedGoRoute<ChangeAvatarSettingsRoute>(path: 'avatar'),
            TypedGoRoute<BadgeVisibilityRoute>(path: 'badge-visibility'),
            TypedGoRoute<ChangePasswordRoute>(path: 'password'),
            TypedGoRoute<EndOfDaySettingsRoute>(path: 'end-of-day'),
          ],
        ),
      ],
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
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfilePage(
      userId: _authService.authenticatedUser.uid,
      showTitle: false,
    );
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

class FriendRequestsRoute extends GoRouteData with $FriendRequestsRoute {
  const FriendRequestsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FriendRequestsPage();
  }
}

class UserSearchRoute extends GoRouteData with $UserSearchRoute {
  const UserSearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchUserPage();
  }
}

class ProfileChangeAvatarRoute extends GoRouteData
    with $ProfileChangeAvatarRoute {
  const ProfileChangeAvatarRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChangeAvatarPage();
  }
}

class ProfileUsernameRoute extends GoRouteData with $ProfileUsernameRoute {
  const ProfileUsernameRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserNamePage();
  }
}

class JoinLeaderboardRoute extends GoRouteData with $JoinLeaderboardRoute {
  const JoinLeaderboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const JoinLeaderboardPage();
  }
}

class CreateLeaderboardRoute extends GoRouteData with $CreateLeaderboardRoute {
  const CreateLeaderboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateLeaderboardPage();
  }
}

class LeaderboardDetailRoute extends GoRouteData with $LeaderboardDetailRoute {
  final String leaderboardId;

  const LeaderboardDetailRoute({required this.leaderboardId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LeaderboardDetailPage(leaderboardId: leaderboardId);
  }
}

class ManageLeaderboardRoute extends GoRouteData with $ManageLeaderboardRoute {
  final String leaderboardId;

  const ManageLeaderboardRoute({required this.leaderboardId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ManageLeaderboardPage(leaderboardId: leaderboardId);
  }
}

class UpdateLeaderboardNameRoute extends GoRouteData
    with $UpdateLeaderboardNameRoute {
  final String leaderboardId;

  const UpdateLeaderboardNameRoute({required this.leaderboardId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UpdateLeaderboardNamePage(leaderboardId: leaderboardId);
  }
}

class AddDrinkRoute extends GoRouteData with $AddDrinkRoute {
  final String? targetSessionId;

  const AddDrinkRoute({this.targetSessionId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddDrinkPage(targetSessionId: targetSessionId);
  }
}

class PartyRoute extends GoRouteData with $PartyRoute {
  final String sessionId;
  final PartyTab tab;

  const PartyRoute({required this.sessionId, this.tab = PartyTab.activity});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PartyPage(sessionId: sessionId, tab: tab);
  }
}

class PartyManagementRoute extends GoRouteData with $PartyManagementRoute {
  const PartyManagementRoute({
    required this.sessionId,
    this.tab = PartyTab.activity,
  });

  final String sessionId;
  final PartyTab tab;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PartyManagementPage(sessionId: sessionId);
  }
}

class PartyQuestRoute extends GoRouteData with $PartyQuestRoute {
  const PartyQuestRoute({
    required this.sessionId,
    required this.questId,
    this.tab = PartyTab.activity,
  });

  final String sessionId;
  final String questId;
  final PartyTab tab;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return QuestDetailPage(sessionId: sessionId, questId: questId);
  }
}

class PartyChallengeRoute extends GoRouteData with $PartyChallengeRoute {
  const PartyChallengeRoute({
    required this.sessionId,
    required this.challengeId,
    this.tab = PartyTab.activity,
  });

  final String sessionId;
  final String challengeId;
  final PartyTab tab;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChallengeDetailPage(sessionId: sessionId, challengeId: challengeId);
  }
}

class PartyTournamentRoute extends GoRouteData with $PartyTournamentRoute {
  const PartyTournamentRoute({
    required this.sessionId,
    required this.tournamentId,
    this.tab = PartyTab.activity,
  });

  final String sessionId;
  final String tournamentId;
  final PartyTab tab;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BeerpongPage(tournamentId: tournamentId);
  }
}

class LocationPickerRoute extends GoRouteData with $LocationPickerRoute {
  final double latitude;
  final double longitude;

  const LocationPickerRoute({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LocationPage(location: GeoPoint(latitude, longitude));
  }
}

class CreateSessionRoute extends GoRouteData with $CreateSessionRoute {
  const CreateSessionRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateSessionPage();
  }
}

class SessionSummaryRoute extends GoRouteData with $SessionSummaryRoute {
  const SessionSummaryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SummaryPage();
  }
}

class SessionManagementRoute extends GoRouteData with $SessionManagementRoute {
  const SessionManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SessionManagementPage();
  }
}

class EditSessionRoute extends GoRouteData with $EditSessionRoute {
  final String sessionId;

  const EditSessionRoute({required this.sessionId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditSessionPage(sessionId: sessionId);
  }
}

class ManageSessionAdminsRoute extends GoRouteData
    with $ManageSessionAdminsRoute {
  final String sessionId;

  const ManageSessionAdminsRoute({required this.sessionId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ManageAdminsPage(sessionId: sessionId);
  }
}

class AddSessionFriendsRoute extends GoRouteData with $AddSessionFriendsRoute {
  final String sessionId;

  const AddSessionFriendsRoute({required this.sessionId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddFriendsToSessionPage(sessionId: sessionId);
  }
}

class UpdateDrinkRoute extends GoRouteData with $UpdateDrinkRoute {
  final String sessionId;
  final String drinkId;

  const UpdateDrinkRoute({required this.sessionId, required this.drinkId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UpdateDrinkPage(sessionId: sessionId, drinkId: drinkId);
  }
}

class ActivitySessionRoute extends GoRouteData with $ActivitySessionRoute {
  final String sessionId;

  const ActivitySessionRoute({required this.sessionId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SessionDetailPage(sessionId: sessionId);
  }
}

class SessionPhotoRoute extends GoRouteData with $SessionPhotoRoute {
  final String sessionId;
  final int initialIndex;

  const SessionPhotoRoute({
    required this.sessionId,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SessionPhotoViewer(sessionId: sessionId, initialIndex: initialIndex);
  }
}

class CustomDrinkTypesRoute extends GoRouteData with $CustomDrinkTypesRoute {
  const CustomDrinkTypesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomDrinkTypesPage();
  }
}

class AddDrinkTypeRoute extends GoRouteData with $AddDrinkTypeRoute {
  const AddDrinkTypeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddDrinkTypePage();
  }
}

class UpdateDrinkTypeRoute extends GoRouteData with $UpdateDrinkTypeRoute {
  final String drinkTypeId;

  const UpdateDrinkTypeRoute({required this.drinkTypeId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UpdateDrinkTypePage(drinkTypeId: drinkTypeId);
  }
}

class DefaultDrinkSettingsRoute extends GoRouteData
    with $DefaultDrinkSettingsRoute {
  const DefaultDrinkSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DefaultDrinkPage();
  }
}

class DrinkSortSettingsRoute extends GoRouteData with $DrinkSortSettingsRoute {
  const DrinkSortSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DrinkListSortPage();
  }
}

class UsernameSettingsRoute extends GoRouteData with $UsernameSettingsRoute {
  const UsernameSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserNamePage();
  }
}

class ProfileDetailsSettingsRoute extends GoRouteData
    with $ProfileDetailsSettingsRoute {
  const ProfileDetailsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfileDetailsPage();
  }
}

class ChangeAvatarSettingsRoute extends GoRouteData
    with $ChangeAvatarSettingsRoute {
  const ChangeAvatarSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChangeAvatarPage();
  }
}

class BadgeVisibilityRoute extends GoRouteData with $BadgeVisibilityRoute {
  const BadgeVisibilityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BadgeVisibilityPage();
  }
}

class ChangePasswordRoute extends GoRouteData with $ChangePasswordRoute {
  const ChangePasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChangePasswordPage();
  }
}

class EndOfDaySettingsRoute extends GoRouteData with $EndOfDaySettingsRoute {
  const EndOfDaySettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EndOfDayPage();
  }
}

@TypedGoRoute<UserProfileRoute>(
  path: '/user/:userId',
  routes: [TypedGoRoute<UserFriendsRoute>(path: 'friends')],
)
class UserProfileRoute extends GoRouteData with $UserProfileRoute {
  final String userId;

  const UserProfileRoute({required this.userId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfilePage(userId: userId);
  }
}

class UserFriendsRoute extends GoRouteData with $UserFriendsRoute {
  final String userId;

  const UserFriendsRoute({required this.userId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FriendsListPage(userId: userId);
  }
}
