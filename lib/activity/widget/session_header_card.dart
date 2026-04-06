import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/formatter/time_formatter.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/service/user_service.dart';

class SessionHeaderCard extends StatelessWidget {
  final Session session;

  SessionHeaderCard({super.key, required this.session});

  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = formatDuration(session.startedAt, session.endedAt);

    return AsyncBuilder(
      stream: _userService.currentUserStream,
      builder: (context, user) {
        final timeRange = formatSessionTimeRange(
          session.startedAt,
          session.endedAt,
          user.endOfDayBoundary,
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const Gap(4),
                    Expanded(
                      child: Text(
                        timeRange,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const Gap(4),
                    Text(
                      'Duration: $duration',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
