import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/party_challenge.dart';

class ChallengeCard extends StatefulWidget {
  const ChallengeCard({
    super.key,
    required this.challenge,
    this.onTap,
    this.compact = false,
  });

  final PartyChallenge challenge;
  final VoidCallback? onTap;
  final bool compact;

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant ChallengeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.challenge.endsAt != widget.challenge.endsAt ||
        oldWidget.challenge.status != widget.challenge.status) {
      _timer?.cancel();
      _startTimerIfNeeded();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = _displayStatus;
    final isLive = status == PartyChallengeStatus.active;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isLive ? Icons.bolt : _statusIcon(status),
                    color: isLive ? colorScheme.error : colorScheme.outline,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      widget.challenge.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _StatusLabel(status: status),
                ],
              ),
              if (!widget.compact) ...[
                const Gap(10),
                Text(widget.challenge.instructions),
              ],
              const Gap(12),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _Metadata(
                    icon: Icons.stars_outlined,
                    text:
                        '${formatPartyScore(widget.challenge.pointsUnits)} points',
                  ),
                  _Metadata(
                    icon: Icons.people_outline,
                    text: '${widget.challenge.winnerIds.length} winners',
                  ),
                  _Metadata(
                    icon: isLive ? Icons.timer_outlined : Icons.schedule,
                    text: isLive
                        ? _formatRemaining(
                            widget.challenge.endsAt.difference(_now),
                          )
                        : DateFormat.MMMd().add_jm().format(
                            widget.challenge.endsAt,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PartyChallengeStatus get _displayStatus =>
      widget.challenge.status == PartyChallengeStatus.active &&
          !_now.isBefore(widget.challenge.endsAt)
      ? PartyChallengeStatus.expired
      : widget.challenge.status;

  void _startTimerIfNeeded() {
    if (widget.challenge.status != PartyChallengeStatus.active) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() => _now = DateTime.now());
      if (!_now.isBefore(widget.challenge.endsAt)) {
        _timer?.cancel();
      }
    });
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.status});

  final PartyChallengeStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = status == PartyChallengeStatus.active;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.errorContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          status.name.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isActive
                ? colorScheme.onErrorContainer
                : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
      const Gap(4),
      Text(text, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

IconData _statusIcon(PartyChallengeStatus status) => switch (status) {
  PartyChallengeStatus.active => Icons.bolt,
  PartyChallengeStatus.completed => Icons.check_circle_outline,
  PartyChallengeStatus.expired => Icons.timer_off_outlined,
  PartyChallengeStatus.cancelled => Icons.cancel_outlined,
};

String _formatRemaining(Duration duration) {
  final seconds = duration.inSeconds.clamp(0, 86400);
  final hours = seconds ~/ Duration.secondsPerHour;
  final minutes =
      (seconds % Duration.secondsPerHour) ~/ Duration.secondsPerMinute;
  final remainingSeconds = seconds % Duration.secondsPerMinute;
  if (hours > 0) {
    return '${hours}h ${minutes}m left';
  }
  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')} left';
}
