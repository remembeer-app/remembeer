import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';

class SessionManagementPage extends StatelessWidget {
  SessionManagementPage({super.key});

  final _sessionController = get<SessionController>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Session Management'),
      child: AsyncBuilder<List<Session>>(
        stream: _sessionController.sessionsStreamWhereCurrentUserIsMember,
        builder: (context, sessions) {
          if (sessions.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return _buildSessionCard(context, session);
            },
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

  Widget _buildSessionCard(BuildContext context, Session session) {
    final theme = Theme.of(context);
    final memberCount = session.memberIds.length;
    final isOngoing = session.endedAt == null;
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
        trailing: isOngoing
            ? Chip(
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
              )
            : null,
      ),
    );
  }
}
