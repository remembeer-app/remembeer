import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/partyQuest.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/widget/party_games.dart';
import 'package:remembeer/party/widget/party_scope.dart';

class QuestDetailPage extends StatelessWidget {
  const QuestDetailPage({
    super.key,
    required this.sessionId,
    required this.questId,
  });
  final String sessionId;
  final String questId;

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Social quest'),
    child: PartyScope(
      sessionId: sessionId,
      builder: (context, party, userId, members, isAdmin) => PartyQuestGetTypeQuery(
        id: PartyQuestId(questId),
        builder: (context, quest) {
          if (quest.sessionId != party.id) {
            return const Center(child: Text('Quest not found in this party.'));
          }
          final result = quest.results
              .where(
                (result) =>
                    result.firstUserId == userId ||
                    result.secondUserId == userId,
              )
              .firstOrNull;
          final partnerId = result == null
              ? null
              : result.firstUserId == userId
              ? result.secondUserId
              : result.firstUserId;
          final selection = quest.selections
              .where((selection) => selection.userId == userId)
              .firstOrNull;
          String name(UserId id) =>
              members
                  .where((entry) => entry.member.userId == id)
                  .firstOrNull
                  ?.username ??
              'Unavailable user';
          return ListView(
            children: [
              Text(
                quest.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Gap(12),
              Text(quest.instructions),
              const Gap(12),
              Text(
                '${formatPartyScore(quest.pointsUnits.toInt())} points each · ${quest.status.value}',
              ),
              Text('Ends ${partyTime(quest.endsAt)}'),
              const Gap(16),
              if (partnerId != null)
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text('Completed with ${name(partnerId)}'),
                )
              else if (party.endedAt != null ||
                  !party.modules.socialQuestsEnabled ||
                  quest.status != PartyQuestDocumentStatus.activeValue)
                const ListTile(title: Text('This quest is read-only.'))
              else ...[
                if (selection != null)
                  ListTile(
                    title: Text(
                      'Waiting for ${name(selection.selectedUserId)}',
                    ),
                    subtitle: const Text(
                      'You can change your choice until the pair is confirmed.',
                    ),
                  ),
                PartyQuestPartnersQuery(
                  questId: quest.id,
                  builder: (context, partners) => PartyQuestSelectPartnerMutation(
                    builder: (context, select, state) => Column(
                      children: [
                        if (state.error case final error?)
                          ErrorMessageBox(message: error.toString()),
                        if (partners.isEmpty)
                          const ListTile(
                            title: Text('No eligible partners right now.'),
                          ),
                        for (final partner in partners)
                          ListTile(
                            title: Text(partner.username),
                            trailing: FilledButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () => select.run(
                                      questId: quest.id,
                                      selectedUserId: partner.id,
                                      onSuccess: (matched) =>
                                          showSuccessNotification(
                                            matched
                                                ? 'Quest completed!'
                                                : 'Partner selected. Waiting for confirmation.',
                                          ),
                                    ),
                              child: Text(
                                selection?.selectedUserId == partner.id
                                    ? 'Selected'
                                    : 'Choose',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
              const Gap(24),
              Text(
                'Completed pairs',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              for (final result in quest.results)
                ListTile(
                  title: Text(
                    '${name(result.firstUserId)} & ${name(result.secondUserId)}',
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}
