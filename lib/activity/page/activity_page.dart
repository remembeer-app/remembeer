import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/activity/service/activity_service.dart';
import 'package:remembeer/activity/widget/session_card.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:rxdart/rxdart.dart';

class ActivityPage extends StatelessWidget {
  ActivityPage({super.key});

  final _activityService = get<ActivityService>();
  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      child: AsyncBuilder(
        stream: Rx.combineLatest2(
          _activityService.activityFeedStream,
          _userService.currentUserStream,
          (sessions, user) =>
              (sessions: sessions, endOfDayBoundary: user.endOfDayBoundary),
        ),
        builder: (context, data) {
          final sessions = data.sessions;
          final endOfDayBoundary = data.endOfDayBoundary;

          if (sessions.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            separatorBuilder: (context, index) => const Gap(8),
            itemBuilder: (context, index) {
              final sessionWithMembers = sessions[index];
              return SessionCard(
                sessionWithMembers: sessionWithMembers,
                endOfDayBoundary: endOfDayBoundary,
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
              Icons.table_bar_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const Gap(16),
            Text(
              'No activity yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(8),
            Text(
              'Sessions with friends will appear here',
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
