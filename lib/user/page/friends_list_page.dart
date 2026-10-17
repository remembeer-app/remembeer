import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/widgets/friendship.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/user/widget/user_card.dart';

class FriendsListPage extends StatelessWidget {
  const FriendsListPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Friends'),
    child: UserCurrentQuery(
      builder: (context, current) {
        if (userId != current.id.value) {
          // TODO(ohtenkay): Replace this empty list when a public Convex friends query exists.
          return const Center(child: Text('This user has no friends yet.'));
        }
        return FriendshipListCurrentQuery(
          builder: (context, friends) => friends.isEmpty
              ? const Center(child: Text('This user has no friends yet.'))
              : ListView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  children: [
                    for (final user in friends)
                      UserCard(
                        userId: user.id,
                        username: user.username,
                        avatarUrl: user.avatarUrl,
                        replaceRoute: true,
                      ),
                  ],
                ),
        );
      },
    ),
  );
}
