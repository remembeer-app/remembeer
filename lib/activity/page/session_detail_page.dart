import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/activity/model/session_with_members.dart';
import 'package:remembeer/activity/service/activity_service.dart';
import 'package:remembeer/activity/widget/session_drinks_section.dart';
import 'package:remembeer/activity/widget/session_header_card.dart';
import 'package:remembeer/activity/widget/session_participants_section.dart';
import 'package:remembeer/activity/widget/session_photos_section.dart';
import 'package:remembeer/activity/widget/session_statistics_card.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class SessionDetailPage extends StatelessWidget {
  final String sessionId;

  SessionDetailPage({super.key, required this.sessionId});

  final _activityService = get<ActivityService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<SessionWithMembers>(
      stream: _activityService.sessionWithMembersStream(sessionId),
      builder: _buildPage,
    );
  }

  Widget _buildPage(
    BuildContext context,
    SessionWithMembers sessionWithMembers,
  ) {
    final session = sessionWithMembers.session;
    final colorScheme = Theme.of(context).colorScheme;

    return PageTemplate(
      appBarBackgroundColor: session.isParty
          ? colorScheme.errorContainer
          : null,
      appBarForegroundColor: session.isParty
          ? colorScheme.onErrorContainer
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(session.isParty ? Icons.celebration : Icons.table_bar, size: 24),
          const Gap(8),
          Flexible(
            child: Text(
              session.isParty ? 'Party · ${session.name}' : session.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SessionHeaderCard(session: session),
            const Gap(16),
            SessionPhotosSection(sessionId: session.id),
            SessionParticipantsSection(members: sessionWithMembers.membersList),
            const Gap(16),
            SessionDrinksSection(sessionWithMembers: sessionWithMembers),
            const Gap(16),
            SessionStatisticsCard(sessionWithMembers: sessionWithMembers),
          ],
        ),
      ),
    );
  }
}
