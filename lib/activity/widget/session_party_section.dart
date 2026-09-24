import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/activity/model/session_with_members.dart';
import 'package:remembeer/activity/widget/party_ranking_preview.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/service/party_ranking_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/routes.dart';

class SessionPartySection extends StatelessWidget {
  final SessionWithMembers sessionWithMembers;

  SessionPartySection({super.key, required this.sessionWithMembers});

  final _partyService = get<PartyService>();
  final _rankingService = const PartyRankingService();

  @override
  Widget build(BuildContext context) {
    final session = sessionWithMembers.session;

    return AsyncBuilder<List<PartyMember>>(
      stream: _partyService.membersStream(session.id),
      builder: (context, partyMembers) {
        final standings = _rankingService.rank(
          members: partyMembers,
          users: sessionWithMembers.membersList,
          currentUserId: _partyService.currentUserId,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PartyRankingPreview(
              standings: standings,
              isFinal: session.endedAt != null,
              onTap: () => ActivityPartyRankingRoute(
                sessionId: session.id,
              ).push<void>(context),
            ),
            OutlinedButton.icon(
              onPressed: () => ActivityPartyEventsRoute(
                sessionId: session.id,
              ).push<void>(context),
              icon: const Icon(Icons.bolt),
              label: const Text('View events'),
            ),
            const Gap(16),
          ],
        );
      },
    );
  }
}
