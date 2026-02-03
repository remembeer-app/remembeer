import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/leaderboard_type.dart';
import 'package:remembeer/leaderboard/type/leaderboard_entry.dart';
import 'package:remembeer/user/page/profile_page.dart';

class StandingCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final LeaderboardType sortType;

  StandingCard({super.key, required this.entry, required this.sortType});

  final _authService = get<AuthService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rank = sortType == LeaderboardType.beers
        ? entry.rankByBeers
        : entry.rankByAlcohol;
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
              UserAvatar(user: entry.user),
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
    final isCurrentUser = entry.user.id == _authService.authenticatedUser.uid;
    if (isCurrentUser) return null;

    return () => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProfilePage(userId: entry.user.id),
      ),
    );
  }
}
