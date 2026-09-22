import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_quest.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/service/party_challenge_service.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/routes.dart';

class PartyLiveBanner extends StatelessWidget {
  const PartyLiveBanner({
    super.key,
    required this.state,
    required this.backgroundColor,
    required this.foregroundColor,
    this.accentColor,
    this.questService,
    this.challengeService,
    this.now,
  });

  final PartyState state;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? accentColor;
  final PartyQuestService? questService;
  final PartyChallengeService? challengeService;

  /// Fixed clock for tests; a live ticking clock is used when null.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    if (state.isArchived) {
      return _Strip(
        backgroundColor: backgroundColor,
        child: Row(
          children: [
            Icon(Icons.archive, color: accentColor ?? foregroundColor),
            const Gap(12),
            Expanded(
              child: Text(
                'Archived Party',
                style: TextStyle(color: foregroundColor),
              ),
            ),
          ],
        ),
      );
    }

    final settings = state.party.moduleSettings;
    final questId = settings.socialQuestsEnabled
        ? state.party.activeQuestId
        : null;
    final challengeId = settings.adminChallengesEnabled
        ? state.party.activeChallengeId
        : null;
    if (questId == null && challengeId == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (questId != null)
          AsyncBuilder<List<PartyQuest>>(
            stream: _questService.questsStream(state.session.id),
            waitingBuilder: _empty,
            errorBuilder: _emptyError,
            builder: (context, quests) {
              final quest = quests
                  .where((quest) => quest.id == questId)
                  .firstOrNull;
              if (quest == null || quest.status != PartyQuestStatus.active) {
                return const SizedBox.shrink();
              }
              return _LiveItem(
                icon: Icons.group_work,
                kind: 'Social quest',
                title: quest.titleSnapshot,
                endsAt: quest.endsAt,
                now: now,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                accentColor: accentColor,
                onTap: () => PartyQuestRoute(
                  sessionId: state.session.id,
                  questId: quest.id,
                  tab: PartyTab.games,
                ).push<void>(context),
              );
            },
          ),
        if (challengeId != null)
          AsyncBuilder<List<PartyChallenge>>(
            stream: _challengeService.challengesStream(state.session.id),
            waitingBuilder: _empty,
            errorBuilder: _emptyError,
            builder: (context, challenges) {
              final challenge = challenges
                  .where((challenge) => challenge.id == challengeId)
                  .firstOrNull;
              if (challenge == null ||
                  challenge.status != PartyChallengeStatus.active) {
                return const SizedBox.shrink();
              }
              return _LiveItem(
                icon: Icons.bolt,
                kind: 'Admin challenge',
                title: challenge.title,
                endsAt: challenge.endsAt,
                now: now,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                accentColor: accentColor,
                onTap: () => PartyChallengeRoute(
                  sessionId: state.session.id,
                  challengeId: challenge.id,
                  tab: PartyTab.games,
                ).push<void>(context),
              );
            },
          ),
      ],
    );
  }

  static Widget _empty(BuildContext context) => const SizedBox.shrink();

  static Widget _emptyError(BuildContext context, Object error) =>
      const SizedBox.shrink();

  PartyQuestService get _questService =>
      questService ?? get<PartyQuestService>();

  PartyChallengeService get _challengeService =>
      challengeService ?? get<PartyChallengeService>();
}

class _Strip extends StatelessWidget {
  const _Strip({required this.backgroundColor, required this.child});

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    color: backgroundColor,
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
    child: child,
  );
}

class _LiveItem extends StatefulWidget {
  const _LiveItem({
    required this.icon,
    required this.kind,
    required this.title,
    required this.endsAt,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    this.accentColor,
    this.now,
  });

  final IconData icon;
  final String kind;
  final String title;
  final DateTime endsAt;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? accentColor;
  final VoidCallback onTap;
  final DateTime? now;

  @override
  State<_LiveItem> createState() => _LiveItemState();
}

class _LiveItemState extends State<_LiveItem> {
  Timer? _timer;
  late DateTime _now;

  bool get _isLive => _now.isBefore(widget.endsAt);

  @override
  void initState() {
    super.initState();
    _now = widget.now ?? DateTime.now();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant _LiveItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endsAt != widget.endsAt || oldWidget.now != widget.now) {
      _timer?.cancel();
      _now = widget.now ?? DateTime.now();
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (widget.now != null || !_isLive) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() => _now = DateTime.now());
      if (!_isLive) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLive) {
      return const SizedBox.shrink();
    }
    final textTheme = Theme.of(context).textTheme;
    final highlight = widget.accentColor ?? widget.foregroundColor;
    final mutedForeground = widget.foregroundColor.withValues(alpha: 0.75);
    return Material(
      color: widget.backgroundColor,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: highlight.withValues(alpha: 0.18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(widget.icon, color: highlight),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: highlight,
                          ),
                          child: const SizedBox.square(dimension: 8),
                        ),
                        const Gap(6),
                        Text(
                          widget.kind.toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                            color: mutedForeground,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const Gap(2),
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: widget.foregroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, size: 18, color: mutedForeground),
                  const Gap(4),
                  Text(
                    formatPartyRemaining(widget.endsAt.difference(_now)),
                    style: textTheme.labelLarge?.copyWith(
                      color: widget.foregroundColor,
                      fontWeight: FontWeight.bold,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              Icon(Icons.chevron_right, color: mutedForeground),
            ],
          ),
        ),
      ),
    );
  }
}
