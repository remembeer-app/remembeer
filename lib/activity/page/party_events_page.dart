import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/party/widget/party_activity_tab.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyEventsPage extends StatelessWidget {
  final String sessionId;

  PartyEventsPage({super.key, required this.sessionId});

  final _partyService = get<PartyService>();
  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Party Activity'),
      child: AsyncBuilder<Session>(
        stream: _sessionService.sessionStream(sessionId),
        builder: (context, session) => AsyncBuilder<List<UserModel>>(
          stream: _sessionService.sessionMembersStream(sessionId),
          builder: (context, members) => PartyActivityTab(
            sessionId: sessionId,
            members: members,
            drinks: session.drinks,
            currentUserId: _partyService.currentUserId,
            isPartyActive: false,
          ),
        ),
      ),
    );
  }
}
