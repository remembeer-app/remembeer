import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_standings.dart';
import 'package:remembeer/routes.dart';

class LeaderboardCard extends StatelessWidget {
  final ListCurrentResultItem leaderboard;
  final UserId currentUserId;

  const LeaderboardCard({
    super.key,
    required this.leaderboard,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final memberCount = leaderboard.memberCount.toInt();
    final icon = LeaderboardIcon.fromName(leaderboard.leaderboard.iconName);

    return Card(
      child: ListTile(
        onTap: () => LeaderboardDetailRoute(
          leaderboardId: leaderboard.leaderboard.id.value,
        ).push<void>(context),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(icon.icon, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(
          leaderboard.leaderboard.name,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          '$memberCount ${memberCount == 1 ? 'member' : 'members'}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: _buildStandingInfo(context, theme),
      ),
    );
  }

  Widget _buildStandingInfo(BuildContext context, ThemeData theme) {
    return LeaderboardStandings(
      id: leaderboard.leaderboard.id,
      waitingBuilder: (_) => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      errorBuilder: (context, error) => Tooltip(
        message: error.toString(),
        child: const Icon(Icons.error_outline),
      ),
      builder: (context, standings) {
        final leaderboardEntry = standings.entries
            .where((entry) => entry.user.id == currentUserId)
            .firstOrNull;
        if (leaderboardEntry == null) {
          return const Icon(Icons.chevron_right);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRankChip(
              theme,
              Icons.sports_bar,
              leaderboardEntry.rankByBeers.toInt(),
            ),
            const Gap(4),
            _buildRankChip(
              theme,
              Icons.local_bar,
              leaderboardEntry.rankByAlcohol.toInt(),
            ),
            const Gap(4),
            const Icon(Icons.chevron_right),
          ],
        );
      },
    );
  }

  Widget _buildRankChip(ThemeData theme, IconData icon, int rank) {
    final isHighlighted = rank <= 3;
    final backgroundColor = _getRankColor(rank, theme);
    final foregroundColor = isHighlighted
        ? Colors.white
        : theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const Gap(2),
          Text(
            '#$rank',
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank, ThemeData theme) => switch (rank) {
    1 => const Color(0xFFE8B41E),
    2 => const Color(0xFF9C9B9B),
    3 => const Color(0xFFC36A1D),
    _ => theme.colorScheme.surfaceContainerHighest,
  };
}
