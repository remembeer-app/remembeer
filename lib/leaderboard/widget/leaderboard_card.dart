import 'package:flutter/material.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';
import 'package:remembeer/leaderboard/page/leaderboard_detail_page.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';

class LeaderboardCard extends StatelessWidget {
  final Leaderboard leaderboard;

  LeaderboardCard({super.key, required this.leaderboard});

  final _leaderboardService = get<LeaderboardService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final memberCount = leaderboard.memberIds.length;
    final icon = LeaderboardIcon.fromName(leaderboard.iconName);

    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) =>
                  LeaderboardDetailPage(leaderboard: leaderboard),
            ),
          );
        },
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(icon.icon, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(leaderboard.name, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '$memberCount ${memberCount == 1 ? 'member' : 'members'}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: _buildStandingInfo(context, theme),
      ),
    );
  }

  Widget _buildStandingInfo(BuildContext context, ThemeData theme) {
    return AsyncBuilder(
      stream: _leaderboardService.currentUserStandingStreamFor(leaderboard),
      waitingBuilder: (_) => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      builder: (context, leaderboardEntry) {
        if (leaderboardEntry == null) {
          return const Icon(Icons.chevron_right);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRankChip(
              theme,
              Icons.sports_bar,
              leaderboardEntry.rankByBeers,
            ),
            hGap4,
            _buildRankChip(
              theme,
              Icons.local_bar,
              leaderboardEntry.rankByAlcohol,
            ),
            hGap4,
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
          hGap2,
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
