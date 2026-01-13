import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/controller/leaderboard_controller.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/page/create_leaderboard_page.dart';
import 'package:remembeer/leaderboard/page/join_leaderboard_page.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_card.dart';

class LeaderboardsPage extends StatelessWidget {
  LeaderboardsPage({super.key});

  final _leaderboardController = get<LeaderboardController>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Leaderboards'),
      child: Column(
        children: [
          _buildActionButtons(context),
          gap16,
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const JoinLeaderboardPage(),
                ),
              );
            },
            icon: const Icon(Icons.group_add),
            label: const Text('Join'),
          ),
        ),
        hGap12,
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => CreateLeaderboardPage(),
                ),
              ),
            },
            icon: const Icon(Icons.add),
            label: const Text('Create'),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    return AsyncBuilder<List<Leaderboard>>(
      stream: _leaderboardController.entitiesStreamWhereCurrentUserIsMember,
      builder: (context, leaderboards) {
        if (leaderboards.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          itemCount: leaderboards.length,
          itemBuilder: (context, index) {
            final leaderboard = leaderboards[index];
            return LeaderboardCard(leaderboard: leaderboard);
          },
        );
      },
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
            gap16,
            Text(
              'No leaderboards yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            gap8,
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
