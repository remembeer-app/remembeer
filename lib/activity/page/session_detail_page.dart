import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/activity/model/session_with_members.dart';
import 'package:remembeer/activity/widget/session_drinks_section.dart';
import 'package:remembeer/activity/widget/session_header_card.dart';
import 'package:remembeer/activity/widget/session_participants_section.dart';
import 'package:remembeer/activity/widget/session_statistics_card.dart';
import 'package:remembeer/common/widget/page_template.dart';

class SessionDetailPage extends StatelessWidget {
  final SessionWithMembers sessionWithMembers;

  const SessionDetailPage({super.key, required this.sessionWithMembers});

  @override
  Widget build(BuildContext context) {
    final session = sessionWithMembers.session;

    return PageTemplate(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.table_bar, size: 24),
          const Gap(8),
          Flexible(child: Text(session.name, overflow: TextOverflow.ellipsis)),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SessionHeaderCard(session: session),
            const Gap(16),
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
