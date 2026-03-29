import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/activity/constants.dart';
import 'package:remembeer/activity/type/session_with_members.dart';
import 'package:remembeer/avatar/widget/user_avatar.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

class SessionCard extends StatelessWidget {
  final SessionWithMembers sessionWithMembers;
  final TimeOfDay endOfDayBoundary;

  const SessionCard({
    super.key,
    required this.sessionWithMembers,
    required this.endOfDayBoundary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = sessionWithMembers.session;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme, session.name, session.endedAt!),
              const Gap(12),
              _buildMembersRow(theme),
              const Gap(12),
              _buildStatsRow(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String sessionName, DateTime endedAt) {
    return Row(
      children: [
        Icon(Icons.table_bar, size: 20, color: theme.colorScheme.primary),
        const Gap(8),
        Expanded(
          child: Text(
            sessionName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            timeAgo(endedAt, endOfDayBoundary),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersRow(ThemeData theme) {
    final members = sessionWithMembers.membersList;

    return Row(
      children: [
        ...members.take(avatarsOnSessionPreview).map((member) {
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: UserAvatar(user: member, size: 16),
          );
        }),

        // Show "+X more" if there are more members
        if (members.length > avatarsOnSessionPreview)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+${members.length - avatarsOnSessionPreview}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    const iconSize = 30.0;

    final session = sessionWithMembers.session;
    final duration = formatDuration(session.startedAt, session.endedAt);
    final drinkCount = session.drinksCount;
    final totalAlcoholMl = session.totalAlcoholMl;

    return Row(
      children: [
        DrinkIcon(
          category: DrinkCategory.beer,
          size: iconSize,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const Gap(4),
        Text(
          '$drinkCount ${drinkCount == 1 ? 'drink' : 'drinks'}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Gap(12),
        // TODO(metju-ac): Better icon for alcohol volume
        DrinkIcon(
          category: DrinkCategory.wine,
          size: iconSize,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const Gap(4),
        Text(
          '${totalAlcoholMl.toStringAsFixed(0)} ml',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Gap(12),
        Icon(
          Icons.access_time,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const Gap(4),
        Text(
          duration,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
