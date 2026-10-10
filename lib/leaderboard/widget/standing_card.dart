import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/convex_api/modules/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_type.dart';
import 'package:remembeer/routes.dart';

class StandingCard extends StatelessWidget {
  final StandingsResultEntriesItem entry;
  final bool isCurrentUser;
  final LeaderboardType sortType;

  const StandingCard({
    super.key,
    required this.entry,
    required this.sortType,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rank = sortType == LeaderboardType.beers
        ? entry.rankByBeers.toInt()
        : entry.rankByAlcohol.toInt();
    final value = sortType == LeaderboardType.beers
        ? entry.beersConsumed
        : entry.alcoholConsumedMl;
    final unit = sortType == LeaderboardType.beers ? 'beers' : 'ml';

    final (cardColor, borderColor) = _getCardColors(context, rank);

    return Card(
      color: cardColor,
      shape: borderColor != null
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor, width: 2),
            )
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _navigateToUserPage(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Text(
                  '#$rank',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(8),
              UserAvatar(avatarUrl: entry.user.avatarUrl),
              const Gap(12),
              Expanded(
                child: Text(
                  entry.user.username,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${value.toStringAsFixed(1)} $unit',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color?, Color?) _getCardColors(BuildContext context, int rank) =>
      switch (rank) {
        1 => (const Color(0xFFE8B41E), const Color(0xFFA68900)),
        2 => (const Color(0xFFAEAEAE), const Color(0xFF757575)),
        3 => (const Color(0xFFC36A1D), const Color(0xFF7C4006)),
        _ => (null, null),
      };

  VoidCallback? _navigateToUserPage(BuildContext context) {
    if (isCurrentUser) return null;

    return () =>
        UserProfileRoute(userId: entry.user.id.value).push<void>(context);
  }
}
