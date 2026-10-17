import 'package:flutter/material.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/routes.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.userId,
    required this.username,
    required this.avatarUrl,
    this.replaceRoute = false,
  });

  final UserId userId;
  final String username;
  final String? avatarUrl;
  final bool replaceRoute;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        leading: UserAvatar(avatarUrl: avatarUrl),
        title: Text(
          username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          final route = UserProfileRoute(userId: userId.value);
          if (replaceRoute) {
            route.pushReplacement(context);
          } else {
            route.push<void>(context);
          }
        },
      ),
    ),
  );
}
