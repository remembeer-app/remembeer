import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/leaderboard/constants.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';

class FoundLeaderboardCard extends StatelessWidget {
  final Leaderboard leaderboard;
  final VoidCallback onJoin;

  const FoundLeaderboardCard({
    super.key,
    required this.leaderboard,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final memberCount = leaderboard.memberIds.length;
    final isFull = memberCount >= maxLeaderboardMembers;
    final icon = LeaderboardIcon.fromName(leaderboard.iconName);

    return Column(
      children: [
        SizedBox(
          width: 300,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      icon.icon,
                      size: 32,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  gap12,
                  Text(leaderboard.name, style: theme.textTheme.headlineSmall),
                  gap4,
                  Text(
                    '$memberCount ${memberCount == 1 ? 'member' : 'members'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isFull
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (isFull) ...[
                    gap4,
                    Text(
                      'Leaderboard is full',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        gap16,
        SizedBox(
          width: 200,
          child: FilledButton.icon(
            onPressed: isFull ? null : onJoin,
            icon: const Icon(Icons.group_add),
            label: const Text('Join Leaderboard'),
          ),
        ),
      ],
    );
  }
}
