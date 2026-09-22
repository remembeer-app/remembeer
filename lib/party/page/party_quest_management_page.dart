import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/party/widget/party_quest_management_section.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class PartyQuestManagementPage extends StatelessWidget {
  PartyQuestManagementPage({
    super.key,
    required this.sessionId,
    PartyService? partyService,
    PartyQuestService? questService,
  }) : _partyService = partyService ?? get<PartyService>(),
       _questService = questService ?? get<PartyQuestService>();

  final String sessionId;
  final PartyService _partyService;
  final PartyQuestService _questService;

  @override
  Widget build(BuildContext context) => SettingsPageTemplate(
    title: const Text('Quest catalog'),
    hint: 'Enable the built-in quests available to this Party.',
    padding: const EdgeInsets.all(16),
    child: AsyncBuilder<PartyState>(
      stream: _partyService.stateStream(sessionId),
      builder: (context, state) {
        if (state.isArchived) {
          return const Center(
            child: Text('This Party is archived and read-only.'),
          );
        }
        if (!state.isAdmin) {
          return const Center(
            child: Text('Only Party admins can manage this Party.'),
          );
        }
        return ListView(
          children: [
            PartyQuestManagementSection(
              sessionId: sessionId,
              service: _questService,
              defaultDurationMinutes:
                  state.party.questSchedule.defaultDurationMinutes,
            ),
          ],
        );
      },
    ),
  );
}
