import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/party/model/party_quest.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/widget/quest_card.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyQuestGamesSection extends StatelessWidget {
  const PartyQuestGamesSection({
    super.key,
    required this.state,
    required this.members,
    required this.service,
  });

  final PartyState state;
  final List<UserModel> members;
  final PartyQuestService service;

  @override
  Widget build(BuildContext context) => AsyncBuilder<List<PartyQuest>>(
    stream: service.questsStream(state.session.id),
    builder: (context, quests) {
      final active = quests
          .where((quest) => quest.id == state.party.activeQuestId)
          .firstOrNull;
      final visibleQuest =
          active ?? (state.isArchived ? quests.firstOrNull : null);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Social quests', style: Theme.of(context).textTheme.titleLarge),
          const Gap(8),
          if (visibleQuest != null)
            QuestCard(
              quest: visibleQuest,
              onTap: () => PartyQuestRoute(
                sessionId: state.session.id,
                questId: visibleQuest.id,
                tab: PartyTab.games,
              ).push<void>(context),
            )
          else if (state.isArchived)
            const _QuestStateCard(
              icon: Icons.archive_outlined,
              title: 'No archived quests',
              text: 'No social quest ran during this Party.',
            )
          else if (members.length < 2)
            const _QuestStateCard(
              icon: Icons.group_off_outlined,
              title: 'Not enough participants',
              text: 'At least two eligible members are needed for a quest.',
            )
          else
            const _QuestStateCard(
              icon: Icons.schedule_outlined,
              title: 'Waiting for the next quest',
              text: 'A quest will appear when the random schedule is due.',
            ),
        ],
      );
    },
  );
}

class _QuestStateCard extends StatelessWidget {
  const _QuestStateCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(text),
    ),
  );
}
