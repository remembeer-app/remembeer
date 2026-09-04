import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/party_quest.dart';

class QuestCard extends StatefulWidget {
  const QuestCard({super.key, required this.quest, this.onTap, this.now});

  final PartyQuest quest;
  final VoidCallback? onTap;
  final DateTime? now;

  @override
  State<QuestCard> createState() => _QuestCardState();
}

class _QuestCardState extends State<QuestCard> {
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = widget.now ?? DateTime.now();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant QuestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quest != widget.quest || oldWidget.now != widget.now) {
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

  @override
  Widget build(BuildContext context) {
    final status = _displayStatus;
    final isActive = status == PartyQuestStatus.active;
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
                    isActive ? Icons.group_work : _statusIcon(status),
                    color: isActive ? colorScheme.primary : colorScheme.outline,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      widget.quest.titleSnapshot,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(status.name.toUpperCase()),
                ],
              ),
              const Gap(10),
              Text(widget.quest.instructionsSnapshot),
              const Gap(12),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _Metadata(
                    icon: Icons.stars_outlined,
                    text:
                        '${formatPartyScore(widget.quest.pointsUnits)} points',
                  ),
                  _Metadata(
                    icon: Icons.people_outline,
                    text: '${widget.quest.completedPairKeys.length} pairs',
                  ),
                  _Metadata(
                    icon: isActive ? Icons.timer_outlined : Icons.schedule,
                    text: isActive
                        ? _formatRemaining(widget.quest.endsAt.difference(_now))
                        : DateFormat.MMMd().add_jm().format(
                            widget.quest.endsAt,
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

  PartyQuestStatus get _displayStatus =>
      widget.quest.status == PartyQuestStatus.active &&
          !_now.isBefore(widget.quest.endsAt)
      ? PartyQuestStatus.expired
      : widget.quest.status;

  void _startTimer() {
    if (widget.now != null || _displayStatus != PartyQuestStatus.active) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() => _now = DateTime.now());
      if (_displayStatus != PartyQuestStatus.active) {
        _timer?.cancel();
      }
    });
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

IconData _statusIcon(PartyQuestStatus status) => switch (status) {
  PartyQuestStatus.active => Icons.group_work,
  PartyQuestStatus.expired => Icons.timer_off_outlined,
  PartyQuestStatus.cancelled => Icons.cancel_outlined,
};

String _formatRemaining(Duration duration) {
  final seconds = duration.inSeconds.clamp(0, Duration.secondsPerDay);
  final hours = seconds ~/ Duration.secondsPerHour;
  final minutes =
      (seconds % Duration.secondsPerHour) ~/ Duration.secondsPerMinute;
  final remainingSeconds = seconds % Duration.secondsPerMinute;
  if (hours > 0) {
    return '${hours}h ${minutes}m left';
  }
  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')} left';
}
