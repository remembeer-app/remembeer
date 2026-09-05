import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/model/party_quest.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/party/widget/quest_card.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';

class QuestDetailPage extends StatefulWidget {
  QuestDetailPage({
    super.key,
    required this.sessionId,
    required this.questId,
    PartyService? partyService,
    SessionService? sessionService,
    PartyQuestService? questService,
  }) : partyService = partyService ?? get<PartyService>(),
       sessionService = sessionService ?? get<SessionService>(),
       questService = questService ?? get<PartyQuestService>();

  final String sessionId;
  final String questId;
  final PartyService partyService;
  final SessionService sessionService;
  final PartyQuestService questService;

  @override
  State<QuestDetailPage> createState() => _QuestDetailPageState();
}

class _QuestDetailPageState extends State<QuestDetailPage> {
  Timer? _timer;
  String? _pendingUserId;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Social quest'),
    child: AsyncBuilder<PartyState>(
      stream: widget.partyService.stateStream(widget.sessionId),
      builder: (context, partyState) => AsyncBuilder<PartyQuestDetailState>(
        stream: widget.questService.questStateStream(
          widget.sessionId,
          widget.questId,
        ),
        builder: (context, questState) {
          final quest = questState.quest;
          if (quest == null) {
            return const Center(child: Text('Quest not found.'));
          }
          return AsyncBuilder<List<UserModel>>(
            stream: widget.sessionService.sessionMembersStream(
              widget.sessionId,
            ),
            builder: (context, members) =>
                _buildContent(context, partyState, questState, quest, members),
          );
        },
      ),
    ),
  );

  Widget _buildContent(
    BuildContext context,
    PartyState partyState,
    PartyQuestDetailState questState,
    PartyQuest quest,
    List<UserModel> members,
  ) {
    final currentUserId = widget.partyService.currentUserId;
    final usersById = {for (final member in members) member.id: member};
    final selection = questState.selectionFor(currentUserId);
    final completedPartnerId = questState.completedPartnerId(currentUserId);
    final isBeforeDeadline = DateTime.now().isBefore(quest.endsAt);
    final canSelect =
        partyState.isActive &&
        partyState.party.moduleSettings.socialQuestsEnabled &&
        quest.status == PartyQuestStatus.active &&
        isBeforeDeadline &&
        quest.eligibleMemberIds.contains(currentUserId) &&
        completedPartnerId == null;
    final eligiblePartners = members
        .where(
          (member) =>
              member.id != currentUserId &&
              quest.eligibleMemberIds.contains(member.id) &&
              (quest.eligiblePairKeys.isEmpty ||
                  quest.eligiblePairKeys.contains(
                    partyQuestPairKey(currentUserId, member.id),
                  )),
        )
        .toList();

    return ListView(
      children: [
        QuestCard(quest: quest),
        const Gap(20),
        if (completedPartnerId != null)
          _StateCard(
            icon: Icons.handshake_outlined,
            title: 'Quest completed',
            text:
                'You and ${usersById[completedPartnerId]?.username ?? 'your partner'} chose each other. This pair is final.',
          )
        else if (selection != null)
          _StateCard(
            icon: Icons.hourglass_top_outlined,
            title: 'Waiting for mutual confirmation',
            text:
                'You chose ${usersById[selection.selectedUserId]?.username ?? 'a member'}. You can change your choice until they choose you too.',
          ),
        if (partyState.isArchived) ...[
          const Gap(12),
          const _StateCard(
            icon: Icons.archive_outlined,
            title: 'Archived Party',
            text: 'Quest details and completed pairs are read-only.',
          ),
        ] else if (!partyState.party.moduleSettings.socialQuestsEnabled) ...[
          const Gap(12),
          const _StateCard(
            icon: Icons.extension_off_outlined,
            title: 'Social quests disabled',
            text: 'This quest remains readable, but selections are disabled.',
          ),
        ] else if (quest.status != PartyQuestStatus.active ||
            !isBeforeDeadline) ...[
          const Gap(12),
          const _StateCard(
            icon: Icons.timer_off_outlined,
            title: 'Quest expired',
            text: 'The selection window has closed.',
          ),
        ] else if (!quest.eligibleMemberIds.contains(currentUserId)) ...[
          const Gap(12),
          const _StateCard(
            icon: Icons.person_off_outlined,
            title: 'Not eligible for this quest',
            text: 'Eligibility was fixed when this quest started.',
          ),
        ],
        if (canSelect) ...[
          const Gap(20),
          Text(
            'Choose a partner',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Gap(4),
          Text(
            'Only partners eligible when the quest started are shown.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(8),
          if (eligiblePartners.isEmpty)
            const _StateCard(
              icon: Icons.group_off_outlined,
              title: 'No eligible partners',
              text: 'There is currently nobody you can select.',
            )
          else
            for (final partner in eligiblePartners)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(partner.username),
                  subtitle: selection?.selectedUserId == partner.id
                      ? const Text('Selected · waiting for their choice')
                      : null,
                  trailing: _pendingUserId == partner.id
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : FilledButton.tonal(
                          onPressed: _pendingUserId == null
                              ? () => _selectPartner(quest, partner)
                              : null,
                          child: Text(
                            selection?.selectedUserId == partner.id
                                ? 'Selected'
                                : 'Choose',
                          ),
                        ),
                ),
              ),
        ],
      ],
    );
  }

  Future<void> _selectPartner(PartyQuest quest, UserModel partner) async {
    setState(() => _pendingUserId = partner.id);
    try {
      final matched = await widget.questService.selectPartner(
        sessionId: widget.sessionId,
        questId: quest.id,
        selectedUserId: partner.id,
      );
      showSuccessNotification(
        matched
            ? 'Mutual match! Both members earned points.'
            : 'Selection saved. Waiting for mutual confirmation.',
      );
    } on Exception catch (error) {
      showErrorNotification(error.toString());
    } finally {
      if (mounted) {
        setState(() => _pendingUserId = null);
      }
    }
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({
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
