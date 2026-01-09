import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/page/edit_session_page.dart';
import 'package:remembeer/session/service/session_service.dart';

class SessionManagementPage extends StatelessWidget {
  SessionManagementPage({super.key});

  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Session Management'),
      child: AsyncBuilder<List<Session>>(
        stream: _sessionService.sessionsWhereCurrentUserIsMemberStream,
        builder: (context, sessions) {
          if (sessions.isEmpty) {
            return _buildEmptyState(context);
          }

          final now = DateTime.now();
          final sevenDaysAgo = now.subtract(const Duration(days: 7));
          final thirtyDaysAgo = now.subtract(const Duration(days: 30));

          final thisWeek = sessions
              .where((s) => s.startedAt.isAfter(sevenDaysAgo))
              .toList();
          final last30Days = sessions
              .where(
                (s) =>
                    s.startedAt.isAfter(thirtyDaysAgo) &&
                    !s.startedAt.isAfter(sevenDaysAgo),
              )
              .toList();
          final older = sessions
              .where((s) => !s.startedAt.isAfter(thirtyDaysAgo))
              .toList();

          return ListView(
            children: [
              if (thisWeek.isNotEmpty) ...[
                _buildSectionHeader(context, 'This Week'),
                ...thisWeek.map((s) => _buildSessionCard(context, s)),
              ],
              if (last30Days.isNotEmpty) ...[
                _buildSectionHeader(context, 'Last 30 Days'),
                ...last30Days.map((s) => _buildSessionCard(context, s)),
              ],
              if (older.isNotEmpty) ...[
                _buildSectionHeader(context, 'Older'),
                ...older.map((s) => _buildSessionCard(context, s)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: theme.colorScheme.outline),
          gap16,
          Text(
            "You're not part of any sessions yet",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, Session session) {
    final theme = Theme.of(context);
    final memberCount = session.memberIds.length;
    final isOngoing = session.endedAt == null;
    final isOwner = _sessionService.isSessionOwner(session);
    final dateFormat = DateFormat.yMMMd();

    // TODO(ohtenkay): somehow display the session color once custom colors are implemented
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          // TODO(ohtenkay): Replace with session signature drink icon
          child: Icon(
            Icons.sports_bar,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(session.name, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '${dateFormat.format(session.startedAt)} · $memberCount ${memberCount == 1 ? 'member' : 'members'}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOngoing)
              Chip(
                label: Text(
                  'Ongoing',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                backgroundColor: theme.colorScheme.primaryContainer,
                side: BorderSide.none,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            if (isOwner)
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Edit session',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => EditSessionPage(session: session),
                  ),
                ),
              )
            else
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Leave session',
                onPressed: () {
                  // TODO(ohtenkay): Implement leave session
                },
              ),
          ],
        ),
      ),
    );
  }
}
