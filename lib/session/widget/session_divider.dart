import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/constants.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/page/add_friends_to_session_page.dart';
import 'package:remembeer/session/page/edit_session_page.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/service/user_service.dart';

class SessionDivider extends StatelessWidget {
  final Session session;

  SessionDivider({super.key, required this.session});

  final _sessionService = get<SessionService>();
  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOwner = _sessionService.isSessionOwner(session);
    final iconColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.table_bar,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const Gap(6),
          Text(
            session.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(6),
          Text(
            '${session.drinksCount} / $maxSessionDrinks',
            style: theme.textTheme.bodySmall?.copyWith(
              color: session.drinksCount >= maxSessionDrinks
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          IconButton(
            icon: Icon(Icons.group_add, size: 16, color: iconColor),
            tooltip: 'Add friends',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => AddFriendsToSessionPage(session: session),
              ),
            ),
          ),
          const Spacer(),
          _buildTime(theme, iconColor),
          if (isOwner)
            IconButton(
              icon: Icon(Icons.edit_outlined, size: 16, color: iconColor),
              tooltip: 'Edit session',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => EditSessionPage(session: session),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTime(ThemeData theme, Color iconColor) {
    return AsyncBuilder(
      stream: _userService.currentUserStream,
      builder: (builder, user) {
        final timeText = formatSessionTimeRange(
          session.startedAt,
          session.endedAt,
          user.endOfDayBoundary,
        );

        return Text(
          timeText,
          style: theme.textTheme.bodySmall?.copyWith(color: iconColor),
        );
      },
    );
  }
}
