import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/badge/data/badge_definitions.dart';
import 'package:remembeer/badge/model/unlocked_badge.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/badge.dart';
import 'package:remembeer/convex_api/widgets/friendship.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user/model/accent_color.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/widget/badges_section.dart';
import 'package:remembeer/user/widget/consumption_section.dart';
import 'package:remembeer/user/widget/friendship_actions.dart';
import 'package:remembeer/user/widget/social_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.userId, this.showTitle = true});

  final String? userId;
  final bool showTitle;

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: showTitle ? const Text('Profile') : null,
    child: UserCurrentQuery(
      builder: (context, current) {
        if (userId == null || userId == current.id.value) {
          return _content(
            context,
            current.id,
            current.username,
            current.avatarUrl,
            AccentColorKey.values.byName(current.accentColor.value! as String),
            isCurrentUser: true,
          );
        }
        return UserGetTypeQuery(
          userId: UserId(userId!),
          builder: (context, user) => _content(
            context,
            user.id,
            user.username,
            user.avatarUrl,
            AccentColorKey.values.byName(user.accentColor.value! as String),
            isCurrentUser: false,
          ),
        );
      },
    ),
  );

  Widget _content(
    BuildContext context,
    UserId id,
    String username,
    String? avatarUrl,
    AccentColorKey accentColor, {
    required bool isCurrentUser,
  }) {
    // TODO(ohtenkay): Replace display-only empty email, search data, and monthly stats with Convex profile data.
    final user = UserModel(
      id: id.value,
      username: username,
      avatarUrl: avatarUrl,
      accentColorKey: accentColor,
      email: '',
      searchableUsername: '',
      // TODO(ohtenkay): Replace default empty badges/friends for other users when public Convex queries exist.
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileHeader(
            context: context,
            user: user,
            isCurrentUser: isCurrentUser,
          ),
          const Gap(16),
          if (isCurrentUser)
            FriendshipListCurrentQuery(
              builder: (context, friends) => SocialSection(
                user: user.copyWith(
                  friends: friends.map((friend) => friend.id.value).toSet(),
                ),
                isCurrentUser: true,
              ),
            )
          else
            SocialSection(user: user, isCurrentUser: false),
          const Gap(12),
          if (isCurrentUser)
            BadgeListCurrentQuery(
              builder: (context, badges) => BadgesSection(
                user: user.copyWith(
                  unlockedBadges: {
                    for (final badge in badges)
                      if (getBadgeByIdOrNull(badge.badgeKey) != null)
                        badge.badgeKey: UnlockedBadge(
                          badgeId: badge.badgeKey,
                          unlockedAt: DateTime.fromMillisecondsSinceEpoch(
                            badge.unlockedAt.toInt(),
                          ),
                          isShown: badge.isShown,
                        ),
                  },
                ),
              ),
            )
          else
            BadgesSection(user: user),
          const Gap(12),
          ConsumptionSection(user: user),
        ],
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
        _buildAvatar(context, isCurrentUser, user),
        const Gap(8),
        _buildUserName(isCurrentUser, context, user),
        const Gap(12),
        if (isCurrentUser)
          _buildCurrentUserActions(context, user.id)
        else
          FriendshipActions(userId: UserId(user.id), username: user.username),
      ],
    );
  }

  Widget _buildAvatar(
    BuildContext context,
    bool isCurrentUser,
    UserModel user,
  ) {
    return InkWell(
      onTap: isCurrentUser
          ? () => const ProfileChangeAvatarRoute().push<void>(context)
          : null,
      child: Stack(
        children: [
          UserAvatar(avatarUrl: user.avatarUrl, size: 60),
          if (isCurrentUser)
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserActions(BuildContext context, String currentUserId) {
    return Column(
      children: [
        FriendshipListRequestsQuery(
          builder: (context, requests) {
            final incoming = requests
                .where(
                  (request) =>
                      request.friendship.requestedById.value != currentUserId,
                )
                .length;
            if (incoming == 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton.icon(
                onPressed: () => const FriendRequestsRoute().go(context),
                icon: const Icon(Icons.person_add_alt_1),
                label: Text('View $incoming friend request(s)'),
              ),
            );
          },
        ),
        ElevatedButton.icon(
          onPressed: () => const UserSearchRoute().push<void>(context),
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

  Widget _buildUserName(
    bool isCurrentUser,
    BuildContext context,
    UserModel user,
  ) {
    return InkWell(
      onTap: isCurrentUser
          ? () => const ProfileUsernameRoute().push<void>(context)
          : null,
      child: Text(
        user.username,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
      ),
    );
  }
}
