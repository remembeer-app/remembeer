import 'package:flutter/material.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/user/model/user_model.dart';

class MemberCard extends StatelessWidget {
  final UserModel user;
  final bool isOwner;
  final VoidCallback onRemove;
  final VoidCallback onBan;

  const MemberCard({
    super.key,
    required this.user,
    required this.isOwner,
    required this.onRemove,
    required this.onBan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: UserAvatar(user: user),
        title: Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: isOwner
            ? _buildOwnerLabel(context)
            : _buildMemberActions(context),
      ),
    );
  }

  Widget _buildOwnerLabel(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Owner',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildMemberActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: onRemove, icon: const Icon(Icons.person_remove)),
        IconButton(
          onPressed: onBan,
          icon: const Icon(Icons.block),
          color: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }
}
