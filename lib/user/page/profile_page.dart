import 'package:flutter/material.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/friend_request/model/friend_request.dart';
import 'package:remembeer/friend_request/model/friendship_status.dart';
import 'package:remembeer/friend_request/page/friend_requests_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/page/search_user_page.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user/widget/badges_section.dart';
import 'package:remembeer/user/widget/consumption_section.dart';
import 'package:remembeer/user/widget/social_section.dart';
import 'package:remembeer/user_settings/page/username_page.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  final bool showTitle;

  ProfilePage({super.key, required this.userId, this.showTitle = true});

  final _userService = get<UserService>();
  final _authService = get<AuthService>();

  @override
  Widget build(BuildContext context) {
    final currentUserId = _authService.authenticatedUser.uid;

    final isCurrentUser = userId == currentUserId;
    final userStream = _userService.userStreamFor(userId);

    return PageTemplate(
      title: showTitle ? const Text('Profile') : null,
      child: AsyncBuilder(
        stream: userStream,
        builder: (context, user) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileHeader(
                  context: context,
                  user: user,
                  isCurrentUser: isCurrentUser,
                ),
                gap16,
                SocialSection(user: user, isCurrentUser: isCurrentUser),
                gap12,
                BadgesSection(user: user),
                gap12,
                ConsumptionSection(user: user),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader({
    required BuildContext context,
    required UserModel user,
    required bool isCurrentUser,
  }) {
    return Column(
      children: [
        UserAvatar(user: user, size: 60),
        gap8,
        InkWell(
          onTap: isCurrentUser
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const UserNamePage(),
                    ),
                  );
                }
              : null,
          child: _buildUsernameLabel(user),
        ),
        gap12,
        if (isCurrentUser)
          _buildCurrentUserActions(context)
        else
          _buildOtherUserActions(context, user),
      ],
    );
  }

  Widget _buildCurrentUserActions(BuildContext context) {
    return Column(
      children: [
        AsyncBuilder<List<FriendRequest>>(
          stream: _userService.pendingFriendRequests(),
          builder: (context, requests) {
            if (requests.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => FriendRequestsPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1),
                label: Text('View ${requests.length} friend request(s)'),
              ),
            );
          },
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const SearchUserPage(),
              ),
            );
          },
          icon: const Icon(Icons.search),
          label: const Text('Search for friends'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOtherUserActions(BuildContext context, UserModel user) {
    return AsyncBuilder(
      stream: _userService.friendshipStatus(user.id),
      builder: (context, status) {
        final VoidCallback onPressed;
        final IconData icon;
        final String label;

        switch (status) {
          case FriendshipStatus.friends:
            onPressed = () => _showRemoveFriendDialog(context, user);
            icon = Icons.person_remove;
            label = 'Remove friend';
          case FriendshipStatus.requestSent:
            onPressed = () => _userService.revokeFriendRequest(user.id);
            icon = Icons.cancel_schedule_send;
            label = 'Revoke sent request';
          case FriendshipStatus.requestReceived:
            onPressed = () => _userService.acceptFriendRequest(user.id);
            icon = Icons.check_circle;
            label = 'Accept request';
          case FriendshipStatus.notFriends:
            onPressed = () => _userService.sendFriendRequest(user.id);
            icon = Icons.person_add;
            label = 'Add as friend';
        }

        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }

  void _showRemoveFriendDialog(BuildContext context, UserModel user) {
    showConfirmationDialog(
      context: context,
      title: 'Remove Friend',
      text:
          'Are you sure you want to remove "${user.username}" from your friends?',
      submitButtonText: 'Remove',
      isDestructive: true,
      onPressed: () => _userService.removeFriend(user.id),
    );
  }

  Widget _buildUsernameLabel(UserModel user) {
    return Text(
      user.username,
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
    );
  }
}
