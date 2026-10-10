import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/widgets/leaderboard.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_card.dart';
import 'package:remembeer/routes.dart';

class LeaderboardsPage extends StatelessWidget {
  const LeaderboardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Leaderboards'),
      child: Column(
        children: [
          _buildActionButtons(context),
          const Gap(16),
          Expanded(child: _buildLeaderboardList()),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => const JoinLeaderboardRoute().push<void>(context),
            icon: const Icon(Icons.group_add),
            label: const Text('Join'),
          ),
        ),
        const Gap(12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => const CreateLeaderboardRoute().push<void>(context),
            icon: const Icon(Icons.add),
            label: const Text('Create'),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    return UserCurrentQuery(
      builder: (context, user) => LeaderboardListCurrentQuery(
        builder: (context, leaderboards) {
          if (leaderboards.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            itemCount: leaderboards.length,
            itemBuilder: (context, index) {
              final leaderboard = leaderboards[index];
              return LeaderboardCard(
                leaderboard: leaderboard,
                currentUserId: user.id,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const Gap(16),
            Text(
              'No leaderboards yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(8),
            Text(
              'Create a new leaderboard or join one with an invite code',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
