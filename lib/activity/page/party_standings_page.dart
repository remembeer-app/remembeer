import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/party/widget/party_ranking_tab.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyStandingsPage extends StatelessWidget {
  final String sessionId;

  PartyStandingsPage({super.key, required this.sessionId});

  final _partyService = get<PartyService>();
  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Ranking'),
      child: AsyncBuilder<List<UserModel>>(
        stream: _sessionService.sessionMembersStream(sessionId),
        builder: (context, members) => PartyRankingTab(
          sessionId: sessionId,
          members: members,
          currentUserId: _partyService.currentUserId,
          partyService: _partyService,
        ),
      ),
    );
  }
}
