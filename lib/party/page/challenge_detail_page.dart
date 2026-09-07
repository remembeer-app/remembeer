import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/service/party_challenge_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/party/widget/challenge_card.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';

class ChallengeDetailPage extends StatefulWidget {
  ChallengeDetailPage({
    super.key,
    required this.sessionId,
    required this.challengeId,
    PartyService? partyService,
    SessionService? sessionService,
    PartyChallengeService? challengeService,
  }) : partyService = partyService ?? get<PartyService>(),
       sessionService = sessionService ?? get<SessionService>(),
       challengeService = challengeService ?? get<PartyChallengeService>();

  final String sessionId;
  final String challengeId;
  final PartyService partyService;
  final SessionService sessionService;
  final PartyChallengeService challengeService;

  @override
  State<ChallengeDetailPage> createState() => _ChallengeDetailPageState();
}

class _ChallengeDetailPageState extends State<ChallengeDetailPage> {
  late final Timer _timer;
  String? _pendingAction;

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
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Challenge'),
      child: AsyncBuilder<PartyState>(
        stream: widget.partyService.stateStream(widget.sessionId),
        builder: (context, partyState) =>
            AsyncBuilder<PartyChallengeDetailState>(
              stream: widget.challengeService.challengeStateStream(
                widget.sessionId,
                widget.challengeId,
              ),
              builder: (context, challengeState) {
                final challenge = challengeState.challenge;
                if (challenge == null) {
                  return const Center(child: Text('Challenge not found.'));
                }
                return AsyncBuilder<List<UserModel>>(
                  stream: widget.sessionService.sessionMembersStream(
                    widget.sessionId,
                  ),
                  builder: (context, members) => _buildContent(
                    context,
                    partyState,
                    challengeState,
                    challenge,
                    members,
                  ),
                );
              },
            ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PartyState partyState,
    PartyChallengeDetailState challengeState,
    PartyChallenge challenge,
    List<UserModel> members,
  ) {
    final activeBeforeDeadline =
        challenge.status == PartyChallengeStatus.active &&
        DateTime.now().isBefore(challenge.endsAt);
    final canAdminister =
        partyState.isAdmin && partyState.isActive && activeBeforeDeadline;
    final usersById = {for (final user in members) user.id: user};

    return ListView(
      children: [
        ChallengeCard(challenge: challenge),
        const Gap(20),
        Text('Winners', style: Theme.of(context).textTheme.titleLarge),
        const Gap(8),
        if (challenge.winnerIds.isEmpty)
          const Card(
            child: ListTile(
              leading: Icon(Icons.emoji_events_outlined),
              title: Text('No winners yet'),
            ),
          )
        else
          for (final winnerId in challenge.winnerIds)
            _WinnerTile(
              name: usersById[winnerId]?.username ?? 'Unknown member',
              isReversed: challengeState.reversedWinnerIds.contains(winnerId),
              isPending: _pendingAction == 'reverse:$winnerId',
              onReverse:
                  (_pendingAction == null ||
                          _pendingAction == 'reverse:$winnerId') &&
                      partyState.isAdmin &&
                      partyState.isActive &&
                      challenge.status != PartyChallengeStatus.cancelled &&
                      challenge.status != PartyChallengeStatus.expired &&
                      !challengeState.reversedWinnerIds.contains(winnerId)
                  ? () => _confirmReversal(context, challenge, winnerId)
                  : null,
            ),
        if (canAdminister) ...[
          const Gap(20),
          Text('Award a winner', style: Theme.of(context).textTheme.titleLarge),
          const Gap(8),
          for (final member in members)
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(member.username),
                subtitle: challenge.winnerIds.contains(member.id)
                    ? const Text('Already awarded')
                    : null,
                trailing: _pendingAction == 'award:${member.id}'
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : FilledButton.tonal(
                        onPressed:
                            _pendingAction != null ||
                                challenge.winnerIds.contains(member.id)
                            ? null
                            : () => _runAction(
                                'award:${member.id}',
                                () => widget.challengeService.awardWinner(
                                  widget.sessionId,
                                  challenge.id,
                                  member.id,
                                ),
                                'Winner awarded.',
                              ),
                        child: const Text('Award'),
                      ),
              ),
            ),
          const Gap(20),
          FilledButton.icon(
            onPressed: _pendingAction == null
                ? () => _confirmComplete(context, challenge)
                : null,
            icon: const Icon(Icons.check),
            label: const Text('Complete challenge'),
          ),
          const Gap(8),
          OutlinedButton.icon(
            onPressed: _pendingAction == null
                ? () => _confirmCancel(context, challenge)
                : null,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancel challenge'),
          ),
        ] else if (partyState.isArchived) ...[
          const Gap(20),
          const Card(
            child: ListTile(
              leading: Icon(Icons.archive_outlined),
              title: Text('Archived Party'),
              subtitle: Text('Challenge results are read-only.'),
            ),
          ),
        ] else if (challenge.status == PartyChallengeStatus.active &&
            !activeBeforeDeadline) ...[
          const Gap(20),
          const Card(
            child: ListTile(
              leading: Icon(Icons.timer_off_outlined),
              title: Text('Time is up'),
              subtitle: Text('This challenge can no longer be changed.'),
            ),
          ),
        ],
      ],
    );
  }

  void _confirmReversal(
    BuildContext context,
    PartyChallenge challenge,
    String winnerId,
  ) {
    showConfirmationDialog(
      context: context,
      title: 'Correct this winner?',
      text:
          'Their challenge points will be reversed. The audit history remains visible.',
      submitButtonText: 'Reverse award',
      isDestructive: true,
      onPressed: () => _runAction(
        'reverse:$winnerId',
        () => widget.challengeService.reverseWinner(
          widget.sessionId,
          challenge.id,
          winnerId,
        ),
        'Challenge award reversed.',
      ),
    );
  }

  void _confirmComplete(BuildContext context, PartyChallenge challenge) {
    showConfirmationDialog(
      context: context,
      title: 'Complete challenge?',
      text: 'No more winners can be added after completion.',
      submitButtonText: 'Complete',
      onPressed: () => _runAction(
        'complete',
        () => widget.challengeService.completeChallenge(
          widget.sessionId,
          challenge.id,
        ),
        'Challenge completed.',
      ),
    );
  }

  void _confirmCancel(BuildContext context, PartyChallenge challenge) {
    showConfirmationDialog(
      context: context,
      title: 'Cancel challenge?',
      text: 'The challenge will end immediately. Existing awards are retained.',
      submitButtonText: 'Cancel challenge',
      isDestructive: true,
      onPressed: () => _runAction(
        'cancel',
        () => widget.challengeService.cancelChallenge(
          widget.sessionId,
          challenge.id,
        ),
        'Challenge cancelled.',
      ),
    );
  }

  Future<void> _runAction(
    String key,
    Future<void> Function() action,
    String successMessage,
  ) async {
    setState(() => _pendingAction = key);
    try {
      await action();
      showSuccessNotification(successMessage);
    } on Exception catch (error) {
      showErrorNotification(error.toString());
    } finally {
      if (mounted) {
        setState(() => _pendingAction = null);
      }
    }
  }
}

class _WinnerTile extends StatelessWidget {
  const _WinnerTile({
    required this.name,
    required this.isReversed,
    required this.isPending,
    required this.onReverse,
  });

  final String name;
  final bool isReversed;
  final bool isPending;
  final VoidCallback? onReverse;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(
        isReversed ? Icons.undo : Icons.emoji_events,
        color: isReversed ? Theme.of(context).colorScheme.outline : null,
      ),
      title: Text(
        name,
        style: TextStyle(
          decoration: isReversed ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(isReversed ? 'Award reversed' : 'Challenge winner'),
      trailing: onReverse == null
          ? null
          : TextButton(
              onPressed: isPending ? null : onReverse,
              child: Text(isPending ? 'Reversing...' : 'Correct'),
            ),
    ),
  );
}
