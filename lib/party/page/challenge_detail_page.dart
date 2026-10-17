import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/partyChallenge.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/widget/party_creation_forms.dart';
import 'package:remembeer/party/widget/party_games.dart';
import 'package:remembeer/party/widget/party_scope.dart';

class ChallengeDetailPage extends StatelessWidget {
  const ChallengeDetailPage({
    super.key,
    required this.sessionId,
    required this.challengeId,
  });
  final String sessionId;
  final String challengeId;

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Challenge'),
    child: PartyScope(
      sessionId: sessionId,
      builder: (context, party, userId, members, isAdmin) => PartyChallengeGetTypeQuery(
        id: PartyChallengeId(challengeId),
        builder: (context, challenge) {
          if (challenge.sessionId != party.id) {
            return const Center(
              child: Text('Challenge not found in this party.'),
            );
          }
          final canManage =
              isAdmin &&
              party.endedAt == null &&
              party.modules.partyChallengesEnabled;
          final active =
              challenge.status == PartyChallengeDocumentStatus.activeValue;
          return ListView(
            children: [
              Text(
                challenge.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Gap(12),
              Text(challenge.instructions),
              const Gap(12),
              Text(
                '${formatPartyScore(challenge.pointsUnits.toInt())} points per winner · ${challenge.status.value}',
              ),
              Text('Ends ${partyTime(challenge.endsAt)}'),
              const Gap(24),
              Text('Winners', style: Theme.of(context).textTheme.titleLarge),
              if (challenge.winners.isEmpty)
                const ListTile(title: Text('No winners yet.')),
              PartyChallengeRemoveWinnerMutation(
                builder: (context, remove, state) => Column(
                  children: [
                    if (state.error case final error?)
                      ErrorMessageBox(message: error.toString()),
                    for (final winner in challenge.winners)
                      ListTile(
                        title: Text(
                          members
                                  .where(
                                    (entry) =>
                                        entry.member.userId == winner.userId,
                                  )
                                  .firstOrNull
                                  ?.username ??
                              'Unavailable user',
                        ),
                        trailing: canManage
                            ? IconButton(
                                tooltip: 'Remove winner',
                                icon: const Icon(Icons.undo),
                                onPressed: state.isLoading
                                    ? null
                                    : () => showConfirmationDialog(
                                        context: context,
                                        title: 'Remove winner?',
                                        text:
                                            'Their challenge points will be removed.',
                                        submitButtonText: 'Remove',
                                        isDestructive: true,
                                        onPressed: () async {
                                          await remove(
                                            id: challenge.id,
                                            userId: winner.userId,
                                          );
                                        },
                                      ),
                              )
                            : null,
                      ),
                  ],
                ),
              ),
              if (canManage) ...[
                ExpansionTile(
                  title: const Text('Edit challenge'),
                  children: [
                    PartyChallengeForm(
                      key: ValueKey(challenge.updatedAt),
                      sessionId: party.id,
                      challenge: challenge,
                    ),
                  ],
                ),
                const Gap(16),
                Text(
                  'Award a winner',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                PartyChallengeAddWinnerMutation(
                  builder: (context, add, state) => Column(
                    children: [
                      if (state.error case final error?)
                        ErrorMessageBox(message: error.toString()),
                      for (final entry in members.where(
                        (entry) =>
                            entry.member.sessionMemberStatus.isJoined &&
                            !challenge.winners.any(
                              (winner) => winner.userId == entry.member.userId,
                            ),
                      ))
                        ListTile(
                          title: Text(entry.username),
                          trailing: TextButton(
                            onPressed: state.isLoading
                                ? null
                                : () => add.run(
                                    id: challenge.id,
                                    userId: entry.member.userId,
                                  ),
                            child: const Text('Award'),
                          ),
                        ),
                    ],
                  ),
                ),
                if (active) ...[
                  const Gap(24),
                  PartyChallengeCompleteMutation(
                    builder: (context, complete, state) => Column(
                      children: [
                        FilledButton(
                          onPressed: state.isLoading
                              ? null
                              : () => complete.run(id: challenge.id),
                          child: const Text('Complete challenge'),
                        ),
                        if (state.error case final error?)
                          ErrorMessageBox(message: error.toString()),
                      ],
                    ),
                  ),
                  PartyChallengeCancelMutation(
                    builder: (context, cancel, state) => Column(
                      children: [
                        TextButton(
                          onPressed: state.isLoading
                              ? null
                              : () => showConfirmationDialog(
                                  context: context,
                                  title: 'Cancel challenge?',
                                  text:
                                      'The challenge will stop. Recorded winners keep their points.',
                                  submitButtonText: 'Cancel challenge',
                                  isDestructive: true,
                                  onPressed: () async {
                                    await cancel(id: challenge.id);
                                  },
                                ),
                          child: const Text('Cancel challenge'),
                        ),
                        if (state.error case final error?)
                          ErrorMessageBox(message: error.toString()),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          );
        },
      ),
    ),
  );
}
