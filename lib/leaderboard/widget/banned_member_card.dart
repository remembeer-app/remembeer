import 'package:flutter/material.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/user/model/user_model.dart';

class BannedMemberCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onUnban;

  const BannedMemberCard({
    super.key,
    required this.user,
    required this.onUnban,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: UserAvatar(user: user),
        title: Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          onPressed: onUnban,
          icon: const Icon(Icons.undo),
          color: theme.colorScheme.primary,
          tooltip: 'Unban',
        ),
      ),
    );
  }
}
