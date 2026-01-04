import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/constants.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/page/add_friends_to_session_page.dart';
import 'package:remembeer/session/page/edit_session_page.dart';
import 'package:remembeer/session/service/session_service.dart';

class SessionDivider extends StatelessWidget {
  final Session session;

  SessionDivider({super.key, required this.session});

  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('H:mm');
    final isOwner = _sessionService.isSessionOwner(session);
    final iconColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

    final timeText = session.endedAt != null
        ? '${timeFormat.format(session.startedAt)} to ${timeFormat.format(session.endedAt!)}'
        : '${timeFormat.format(session.startedAt)} - still going';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.table_bar,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          hGap6,
          Text(
            session.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
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
          Text(
            timeText,
            style: theme.textTheme.bodySmall?.copyWith(color: iconColor),
          ),
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
}
