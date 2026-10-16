import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/beerpongTournament.dart';
import 'package:remembeer/convex_api/widgets/partyChallenge.dart';
import 'package:remembeer/convex_api/widgets/partyQuest.dart';
import 'package:remembeer/convex_api/widgets/session.dart';
import 'package:remembeer/convex_api/widgets/sessionMember.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/widget/party_class_selector.dart';
import 'package:remembeer/party/widget/party_creation_forms.dart';
import 'package:remembeer/party/widget/party_scope.dart';
import 'package:remembeer/party/widget/quest_schedule_form.dart';
import 'package:remembeer/routes.dart';

class PartyManagementPage extends StatelessWidget {
  const PartyManagementPage({
    super.key,
    required this.sessionId,
    this.tab = PartyTab.activity,
  });
  final String sessionId;
  final PartyTab tab;

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Manage party'),
    child: PartyScope(
      sessionId: sessionId,
      builder: (context, party, userId, members, isAdmin) {
        if (!isAdmin || party.endedAt != null) {
          return const Center(
            child: Text('Only admins can manage an ongoing party.'),
          );
        }
        return ListView(
          children: [
            PartyQuestSetEnabledMutation(
              builder: (context, setEnabled, state) => Column(
                children: [
                  SwitchListTile(
                    title: const Text('Social quests'),
                    value: party.modules.socialQuestsEnabled,
                    onChanged: state.isLoading
                        ? null
                        : (value) => setEnabled.run(
                            sessionId: party.id,
                            enabled: value,
                          ),
                  ),
                  if (state.error case final error?)
                    ErrorMessageBox(message: error.toString()),
                ],
              ),
            ),
            PartyChallengeSetEnabledMutation(
              builder: (context, setEnabled, state) => Column(
                children: [
                  SwitchListTile(
                    title: const Text('Challenges'),
                    value: party.modules.partyChallengesEnabled,
                    onChanged: state.isLoading
                        ? null
                        : (value) => setEnabled.run(
                            sessionId: party.id,
                            enabled: value,
                          ),
                  ),
                  if (state.error case final error?)
                    ErrorMessageBox(message: error.toString()),
                ],
              ),
            ),
            BeerpongTournamentSetEnabledMutation(
              builder: (context, setEnabled, state) => Column(
                children: [
                  SwitchListTile(
                    title: const Text('Beerpong'),
                    value: party.modules.beerpongEnabled,
                    onChanged: state.isLoading
                        ? null
                        : (value) => setEnabled.run(
                            sessionId: party.id,
                            enabled: value,
                          ),
                  ),
                  if (state.error case final error?)
                    ErrorMessageBox(message: error.toString()),
                ],
              ),
            ),
            const Gap(16),
            QuestScheduleForm(
              key: ValueKey((
                party.questSchedule.minIntervalMinutes,
                party.questSchedule.maxIntervalMinutes,
                party.questSchedule.defaultDurationMinutes,
              )),
              party: party,
            ),
            if (party.modules.socialQuestsEnabled)
              PartyQuestStartNextMutation(
                builder: (context, start, state) => Column(
                  children: [
                    OutlinedButton(
                      onPressed: state.isLoading
                          ? null
                          : () => start.run(
                              sessionId: party.id,
                              onSuccess: (id) {
                                if (context.mounted) {
                                  PartyQuestRoute(
                                    sessionId: sessionId,
                                    questId: id.value,
                                  ).push<void>(context);
                                }
                              },
                            ),
                      child: const Text('Start or open current quest'),
                    ),
                    if (state.error case final error?)
                      ErrorMessageBox(message: error.toString()),
                  ],
                ),
              ),
            if (party.modules.partyChallengesEnabled) ...[
              const Gap(24),
              Text(
                'Create challenge',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              PartyChallengeForm(sessionId: party.id),
            ],
            if (party.modules.beerpongEnabled) ...[
              const Gap(24),
              Text(
                'Create tournament',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              PartyTournamentForm(sessionId: party.id),
            ],
            const Gap(24),
            Text(
              'Member classes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            for (final entry in members.where(
              (entry) => entry.member.sessionMemberStatus.isJoined,
            ))
              if (entry.member case final PartyMember member)
                ExpansionTile(
                  title: Text(entry.username),
                  children: [
                    SessionMemberSetClassMutation(
                      builder: (context, setClass, state) => Column(
                        children: [
                          PartyClassSelector(
                            selectedClass: member.selectedClass,
                            onSubmit: (category) => setClass(
                              sessionId: party.id,
                              userId: member.userId,
                              selectedClass: category,
                            ),
                          ),
                          if (state.error case final error?)
                            ErrorMessageBox(message: error.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
            const Gap(24),
            SessionUpdateMutation(
              builder: (context, update, state) => Column(
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.archive_outlined),
                    label: const Text('End party'),
                    onPressed: state.isLoading
                        ? null
                        : () => showConfirmationDialog(
                            context: context,
                            title: 'End party?',
                            text: 'Gameplay will become read-only.',
                            submitButtonText: 'End party',
                            isDestructive: true,
                            onPressed: () async {
                              await update(
                                id: party.id,
                                endedAt: Optional.of(
                                  DateTime.now().millisecondsSinceEpoch
                                      .toDouble(),
                                ),
                              );
                            },
                          ),
                  ),
                  if (state.error case final error?)
                    ErrorMessageBox(message: error.toString()),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}
